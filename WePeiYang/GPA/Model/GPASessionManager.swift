//
//  GPASessionManager.swift
//  WePeiYang
//
//  Created by Halcao on 2017/7/14.
//  Copyright © 2017年 twtstudio. All rights reserved.
//

import ObjectMapper
import Alamofire

struct GPASessionManager {
     static let termNameList: [String] = ["大一上", "大一下", "大二上", "大二下", "大三上", "大三下", "大四上", "大四下", "大五上", "大五下"]
     
     static func parseGPA(_ html: String) -> GPAModel {
          var courseList = [GPAClassModel]()
          var termList = [GPATermModel]()
          let tables = html.replacingOccurrences(of: "\r", with: "").findArray("class=\"gridtable\">(.+?)</table>")
          
          let totalThs = tables[0].findArray("<th>(.+?)</th>")
          let totalCredits = Double(totalThs[5]) ?? 0
          let totalGpa = Double(totalThs[6]) ?? 0
          let totalScore = Double(totalThs[7]) ?? 0
          
          let totalGPAStat = GPAStatModel(year: "", score: totalScore, gpa: totalGpa, credit: totalCredits)
          
          let courseTrs = tables[1].findArray("<tr class(.+?)</tr>")
          
          var currentTermStr = ""
          
          for (index, courseTr) in courseTrs.enumerated() {
               let tds = courseTr.findArray("<td(.+?)</td>")
               let term = tds[0]
               if (currentTermStr == "") {
                    currentTermStr = term
               }
               
               if (currentTermStr == term) {
                    parseCourses(tds, courseList: &courseList)
               } else {
                    //计算上学期的数据
                    calculateScore(currentTermStr, courseList: &courseList, termList: &termList)
                    //更新当前学期
                    currentTermStr = term
                    parseCourses(tds, courseList: &courseList)
               }
               
               //计算最后一学期的数据
               if (index == courseTrs.count - 1) {
                    calculateScore(currentTermStr, courseList: &courseList, termList: &termList)
               }
          }
          
          for index in 0..<termList.count {
               termList[index].name = termNameList[index]
          }
          
          return GPAModel(terms: termList, stat: totalGPAStat, session: "")
     }
     
     static func calculateScore(_ currentTermStr: String, courseList: inout [GPAClassModel], termList: inout [GPATermModel]) {
          var currentTermScore = 0.0
          var currentTermGpa = 0.0
          var currentTermTotalCredits = 0.0
          currentTermTotalCredits = courseList.reduce(0, { $0 + $1.credit })
          currentTermGpa = courseList.reduce(0, { $0 + $1.gpa })
          currentTermGpa /= currentTermTotalCredits
          currentTermScore = courseList.reduce(0, { $0 + $1.score })
          currentTermScore /= currentTermTotalCredits
          
          
          let currentTermStat = GPAStatModel(year: "", score: currentTermScore, gpa: currentTermGpa, credit: currentTermTotalCredits)
          
          let currentTerm = GPATermModel(term: currentTermStr.trimmingCharacters(in: CharacterSet([">"])), classes: courseList, name: "", stat: currentTermStat)
          
          termList.append(currentTerm)
          courseList.removeAll()
     }
     
     static func parseCourses(_ tds: [String], courseList: inout [GPAClassModel]) {
          let course = GPAClassModel(no: Int(tds[1]) ?? 0,
                                     name: {
                                        let ret = tds[2].trimmingCharacters(in: CharacterSet(["\r", "\n", "\t", ">"]))
                                        if ret.contains("\t") {
                                             return ret.find("(.+?)\t") + " " + ret.find(">(.+?)<")
                                        } else {
                                             return ret
                                        }
                                     }(),
                                     type: tds[4] == ">必修" ? 1 : 0,
                                     credit: Double(tds[5].find("([\\d]+)")) ?? 0,
                                     score: {
                                        let score = tds[6].find("([\\d]+)")
                                        //                                print(score)
                                        switch score {
                                        case "P":
                                             return 100
                                        case "--", "F", "A", "B", "C", "D", "E":
                                             return 999
                                        default:
                                             return Double(score) ?? 0
                                        }
                                     }(),
                                     gpa: Double(tds[8].find("([\\d]+)")) ?? 0,
                                     reset: 0,
                                     lessonID: "",
                                     unionID: "",
                                     courseID: "",
                                     term: tds[0])// term sub
          if course.score != 999 {
               courseList.append(course)
          }
     }

     
     static func getGPA(success: @escaping (GPAModel) -> Void, failure: @escaping (Error) -> Void) {
          SolaSessionManager.fetch(.post, urlString: "http://classes.tju.edu.cn/eams/teach/grade/course/person!historyCourseGrade.action?projectType=MAJOR") { (result) in
               switch result {
               case .success(let html):
                    success(parseGPA(html))
               case .failure(let error):
                    failure(error)
               }
          }
          //          SolaSessionManager.solaSession(url: "/gpa", success: { dic in
          //               guard let errorCode = dic["error_code"] as? Int,
          //                     let message = dic["message"] as? String else {
          //                    failure(WPYCustomError.custom("GPA 响应解析错误"))
          //                    return
          //               }
          //               guard errorCode == -1 else {
          //                    failure(WPYCustomError.errorCode(errorCode, message))
          //                    return
          //               }
          //
          //
          //               if let data = dic["data"] as? [String: Any], let model = Mapper<GPAModel>().map(JSON: data) {
          //                    success(model)
          //               } else {
          //                    failure(WPYCustomError.custom("GPA 数据解析错误"))
          //               }
          //          }, failure: { err in
          //               failure(err)
          //          })
     }
}
