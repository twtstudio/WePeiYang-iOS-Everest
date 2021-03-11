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
    // 0 为本科生 1 为研究生
    private static var type: Int = 0
    static let termNameList: [String] = ["一年级上", "一年级下", "二年级上", "二年级下", "三年级上", "三年级下", "四年级上", "四年级下", "五年级上", "五年级下"]
    
    
    private static func parseGPA(_ html: String) -> GPAModel {
        var courseList = [GPAClassModel]()
        var termList = [GPATermModel]()
        let tables = html.replacingOccurrences(of: "\r", with: "").findArray("class=\"gridtable\">(.+?)</table>")
        
        let totalThs = tables[0].findArray("<th>(.+?)</th>")
        var totalCredits: Double = 0
        var totalGpa: Double = 0
        var totalScore: Double = 0
        // 这里真的不太好弄
        if totalThs[0] == "学年度" {
            totalCredits = Double(totalThs[7]) ?? 0
            totalGpa = Double(totalThs[8]) ?? 0
            totalScore = Double(totalThs[9]) ?? 0
        } else {
            totalCredits = Double(totalThs[5]) ?? 0
            totalGpa = Double(totalThs[6]) ?? 0
            totalScore = Double(totalThs[7]) ?? 0
        }
        
        let totalGPAStat = GPAStatModel(year: "", score: totalScore, gpa: totalGpa, credit: totalCredits)
        
        let courseTrs = tables[1].findArray("<tr class(.+?)</tr>")
        let courseAttri = tables[1].findArray("<th .*?>(.+?)</th>")
        var attributesDict: [String: Int] = [:]
        for (i, name) in courseAttri.enumerated() {
            var keyName = ""
            switch name {
                case "学年学期":
                    keyName = "term"
                    case "课程名称":
                    keyName = "name"
                case "学分":
                    keyName = "credit"
                case "课程类别":
                    keyName = "type"
                case "最终", "成绩":
                    keyName = "score"
                case "绩点":
                    keyName = "gpa"
                default: break
            }
            attributesDict[keyName] = i
        }
        
        var currentTermStr = ""
        
        for (index, courseTr) in courseTrs.enumerated() {
            let tds = courseTr.findArray("<td(.+?)</td>")
            let term = tds[0]
            if (currentTermStr == "") {
                currentTermStr = term
            }
            
            if (currentTermStr == term) {
                parseCourses(tds, attributesDict: attributesDict, courseList: &courseList)
            } else {
                //计算上学期的数据
                calculateScore(currentTermStr, courseList: &courseList, termList: &termList)
                //更新当前学期
                currentTermStr = term
                parseCourses(tds, attributesDict: attributesDict, courseList: &courseList)
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
    
    private static func calculateScore(_ currentTermStr: String, courseList: inout [GPAClassModel], termList: inout [GPATermModel]) {
        var currentTermScore = 0.0
        var currentTermGpa = 0.0
        var currentTermTotalCredits = 0.0
        currentTermTotalCredits = courseList.reduce(0, { $0 + $1.credit })
        currentTermGpa = courseList.reduce(0, { $0 + $1.credit * $1.gpa })
        currentTermGpa /= currentTermTotalCredits
        currentTermScore = courseList.reduce(0, { $0 + $1.credit * $1.score })
        currentTermScore /= currentTermTotalCredits
        
        let currentTermStat = GPAStatModel(year: "", score: currentTermScore, gpa: currentTermGpa, credit: currentTermTotalCredits)
        
        let currentTerm = GPATermModel(term: currentTermStr.trimmingCharacters(in: CharacterSet([">"])), classes: courseList, name: "", stat: currentTermStat)
        
        termList.append(currentTerm)
        courseList.removeAll()
    }
    
    private static func parseCourses(_ tds: [String], attributesDict: [String: Int], courseList: inout [GPAClassModel]) {
        // 直接用Dict来获取值
        func getAttribute(_ key: String) -> String {
            if let idx = attributesDict[key] {
                return tds[idx]
            } else {
                return ""
            }
        }
        let course = GPAClassModel(no: 0,
                                   name: {
                                    let ret = getAttribute("name").trimmingCharacters(in: CharacterSet(["\r", "\n", "\t", ">"]))
                                    if ret.contains("\t") {
                                        return ret.find("(.+?)\t") + " " + ret.find(">(.+?)<")
                                    } else {
                                        return ret
                                    }
                                   }(),
                                   type: getAttribute("type").contains("必修") ? 1 : 0,
                                   credit: Double(getAttribute("credit").find("([0-9]*\\.?[0-9]+)")) ?? 0,
                                   score: {
                                    //                                        let score = tds[6].find("([0-9]*\\.?[0-9]+)")
                                    let score = getAttribute("score").find("\t\t\t(.+?)\n")
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
                                   gpa: Double(getAttribute("gpa").find("([0-9]*\\.?[0-9]+)")) ?? 0,
                                   reset: 0,
                                   lessonID: "",
                                   unionID: "",
                                   courseID: "",
                                   term: getAttribute("term")
                                    .trimmingCharacters(in: CharacterSet(["\r", "\n", "\t", ">"]))
                                    .components(separatedBy: CharacterSet(["-", " "]))
                                    .joined(separator: " "))// term sub
        if course.score != 999 {
            courseList.append(course)
        }
    }
    
    
    static func getGPA(success: @escaping (GPAModel) -> Void, failure: @escaping (WPYCustomError) -> Void) {
        // 搜索类别
        SolaSessionManager.fetch(.post, urlString: "http://classes.tju.edu.cn/eams/stdDetail.action") { (result) in
            switch result {
                case.success(let s):
                    if s.contains("本科") {
                        type = 0
                    }
                    if s.contains("研究") {
                        type = 1
                    }
                    sleep(UInt32(1))
                    // 获取课表
                    SolaSessionManager.fetch(.post, urlString: "http://classes.tju.edu.cn/eams/teach/grade/course/person!historyCourseGrade.action?projectType=MAJOR") { (result) in
                        switch result {
                            case .success(let html):
                                if html.contains("过快") {
                                    failure(WPYCustomError.custom("点击过快"))
                                    return
                                }
                                success(parseGPA(html))
                            case .failure(let error):
                                let cuserror = (error as! WPYCustomError)
                                failure(cuserror)
                        }
                    }
                case .failure(let err):
                    failure(err as! WPYCustomError)
            }
        }
    }
}
