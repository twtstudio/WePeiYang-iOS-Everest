////
////  ClassManager.swift
////  WePeiYang
////
////  Created by Shawnee on 2020/10/4.
////  Copyright © 2020 twtstudio. All rights reserved.
////
//
//import Foundation
//
//struct ClassesManager {
//     static let isLoginKey = "classesIsLogin"
//
//     static let usernameKey = "classesUsername"
//     static let passwordKey = "classesPassword"
//
//     static var isLogin: Bool { WPYStorage.defaults.bool(forKey: isLoginKey) }
//
//     static var username: String { WPYStorage.defaults.string(forKey: usernameKey) ?? "" }
//     static var password: String { WPYStorage.defaults.string(forKey: passwordKey) ?? "" }
//
//     static func remove(_ key: String) { WPYStorage.defaults.removeObject(forKey: key) }
//
//     static func removeAll() {
//          remove(isLoginKey)
//          remove(usernameKey)
//          remove(passwordKey)
//          WPYStorage.courseTable.remove()
//          WPYStorage.gpa.remove()
//     }
//
//     // MARK: - SSO
//     static func ssoGet(completion: @escaping (Result<String, WPYNetwork.Failure>) -> Void) {
//          WPYNetwork.fetch("https://sso.tju.edu.cn/cas/login") { result in
//               switch result {
//               case .success(let (data, _)):
//                    guard let html = String(data: data, encoding: .utf8) else {
//                         completion(.failure(.urlError))
//                         return
//                    }
//                    if html.contains("登录成功") {
//                         completion(.failure(WPYNetwork.Failure.alreadyLogin))
//                         return
//                    }
//
//                    let execution = html.find("name=\"execution\" value=\"([^\"]+)\"")
//
//                    completion(.success(execution))
//               case .failure(let error):
//                    completion(.failure(error))
//               }
//          }
//     }
//
//     static func ssoPost(captcha: String, completion: @escaping (Result<String, WPYNetwork.Failure>) -> Void) {
//          ssoGet { result in
//               switch result {
//               case .success(let execution):
//                    WPYNetwork.fetch(
//                         "https://sso.tju.edu.cn/cas/login",
//                         method: .post,
//                         body: [
//                              "username": username,
//                              "password": password,
//                              "captcha": captcha,
//                              "execution": execution,
//                              "_eventId": "submit"
//                         ]
//                    ) { result in
//                         switch result {
//                         case .success(let (data, response)):
//                              guard let html = String(data: data, encoding: .utf8) else {
//                                   completion(.failure(.requestFailed))
//                                   return
//                              }
//
//                              switch response.statusCode {
//                              case 200:
//                                   let message = html.find("<h2>([^<>]+)</h2>")
//                                   completion(.success(message))
//                              case 401:
//                                   completion(.failure(.loginFailed))
//                              default:
//                                   completion(.failure(.unknownError))
//                              }
//                         case .failure(let error):
//                              completion(.failure(error))
//                         }
//                    }
//               case .failure(let error):
//                    completion(.failure(error))
//               }
//          }
//     }
//
//     // MARK: - Service
//     static func fetch(
//          _ method: WPYNetwork.Method = .get,
//          urlString: String,
//          query: [String: String] = [:],
//          body: [String: String] = [:],
//          async: Bool = true,
//          completion: @escaping (Result<String, WPYNetwork.Failure>) -> Void
//     ) {
//          WPYNetwork.fetch(urlString, query: query, method: method, body: body, async: async) { result in
//               switch result {
//               case .success(let (data, response)):
//                    guard let html = String(data: data, encoding: .utf8) else {
//                         completion(.failure(.requestFailed))
//                         return
//                    }
//
//                    if response.statusCode == 200, let url = response.url?.absoluteString {
//                         if url.contains("https://sso.tju.edu.cn/cas/login") {
//                              completion(.failure(.loginFailed))
//                         } else {
//                              completion(.success(html))
//                         }
//                    } else {
//                         completion(.failure(.unknownError))
//                    }
//               case .failure(let error):
//                    completion(.failure(error))
//               }
//          }
//     }
//
//     static func batch(
//          _ method: WPYNetwork.Method = .get,
//          urlString: String,
//          query: [String: String] = [:],
//          body: [String: String] = [:],
//          completion: @escaping (Result<String, WPYNetwork.Failure>) -> Void
//     ) {
//          fetch(method, urlString: urlString, query: query, body: body, async: false, completion: completion)
//     }
//
//     // MARK: - Check
//     static func checkLogin(completion: @escaping (Result<String, WPYNetwork.Failure>) -> Void) {
//          fetch(urlString: "http://classes.tju.edu.cn/eams/homeExt.action", completion: completion)
//     }
//
//     // MARK: - Semester
//     static func semesterPost(completion: @escaping (Result<[Semester], WPYNetwork.Failure>) -> Void) {
//          fetch(.post, urlString: "http://classes.tju.edu.cn/eams/dataQuery.action") { result in
//               switch result {
//               case .success:
//                    fetch(
//                         .post,
//                         urlString: "http://classes.tju.edu.cn/eams/dataQuery.action",
//                         body: ["dataType": "semesterCalendar"]
//                    ) { result in
//                         switch result {
//                         case .success(let html):
//                              let allSemesters = html
//                                   .findArrays("id:([0-9]+),schoolYear:\"([0-9]+)-([0-9]+)\",name:\"(1|2)\"")
//                                   .map { Semester(semester: $0) }
//
//                              var indexPair = [Int]()
//                              for (i, semester) in allSemesters.enumerated() {
//                                   if semester == Semester.origin || semester == Semester.current {
//                                        indexPair.append(i)
//                                   }
//                              }
//
//                              let validSemesters = allSemesters[(indexPair.first ?? 0)...(indexPair.last ?? 0)]
//
//                              completion(.success(Array(validSemesters)))
//                         case .failure(let error):
//                              completion(.failure(error))
//                         }
//                    }
//               case .failure(let error):
//                    completion(.failure(error))
//               }
//          }
//     }
//
//     // MARK: - GPA
//     static func gpaGet(completion: @escaping (Result<GPA, WPYNetwork.Failure>) -> Void) {
//          semesterPost { result in
//               switch result {
//               case .success(let semesterArray):
//                    DispatchQueue.global().async { // `sleep` causes freezing UI if using the main thread
//                         let semaphore = DispatchSemaphore(value: 0)
//
//                         var semesterGPAArray = [SemesterGPA]()
//                         for semester in semesterArray {
//                              batch(
//                                   urlString: "http://classes.tju.edu.cn/eams/teach/grade/course/person!search.action",
//                                   query: ["semesterId": semester.id]
//                              ) { result in
//                                   switch result {
//                                   case .success(let html):
//                                        let gpaArray = html
//                                             .replacingOccurrences(of: "\r", with: "") // only worked after `\r` removed, insane!
//                                             .findArray("<tr .+?\">(.+?)</tr>")
//                                             .map { singleGPAHTML -> SingleGPA in
//                                                  let singleGPA = singleGPAHTML.findArray("<td[^>]*>\\s*([^<\\t\\n]*)")
//                                                  switch singleGPA.count {
//                                                  case 9:
//                                                       return SingleGPA(fullGPA: singleGPA)
//                                                  case 6:
//                                                       return SingleGPA(partialGPA: singleGPA)
//                                                  default:
//                                                       return SingleGPA()
//                                                  }
//                                             }
//
//                                        let semesterGPA = SemesterGPA(semester: semester, gpaArray: gpaArray)
//                                        semesterGPAArray.append(semesterGPA)
//                                        semaphore.signal()
//                                   case .failure(let error):
//                                        completion(.failure(error))
//                                   }
//                              }
//                              sleep(1)
//                              semaphore.wait()
//                         }
//
//                         let gpa = GPA(semesterGPAArray: semesterGPAArray)
//                         DispatchQueue.main.async { // crazy, huh?
//                              completion(.success(gpa))
//                         }
//                    }
//               case .failure(let error):
//                    completion(.failure(error))
//               }
//          }
//     }
//
//     // MARK: - CourseTable
//     static func courseTablePost(completion: @escaping (Result<CourseTable, WPYNetwork.Failure>) -> Void) {
//          semesterPost { result in
//               switch result {
//               case .success(let semesterArray):
//                    let currentSemester = semesterArray.last ?? Semester()
//
//                    fetch(urlString: "http://classes.tju.edu.cn/eams/courseTableForStd.action") { result in
//                         switch result {
//                         case .success(let html):
//                              let ids = html.find("\"ids\",\"([^\"]+)\"")
//
//                              fetch(
//                                   .post,
//                                   urlString: "http://classes.tju.edu.cn/eams/courseTableForStd!courseTable.action",
//                                   body: [
//                                        "ignoreHead": "1",
//                                        "setting.kind": "std",
//                                        "semester.id": currentSemester.id,
//                                        "ids": ids
//                                   ]
//                              ) { result in
//                                   switch result {
//                                   case .success(let html):
//                                        let arrangeHTML = html.find("in TaskActivity(.+)fillTable")
//                                        var arrangePairArray = [(String, Arrange)]()
//                                        for arrangeItem in arrangeHTML.components(separatedBy: "var teachers")[1...] {
//                                             let rawTeachers = arrangeItem.find("var actTeachers = ([^;]+);")
//                                             let teacherArray = rawTeachers.findArray("\"([^\"]+)\"")
//
//                                             let threePair = arrangeItem.findArrays("\"([^\"]+)\",\"[^\"]*\",\"([^\"]*)\",\"([01]+)\"")[0]
//                                             let name = threePair[1]
//                                             let location = threePair[2]
//                                             let rawWeeks = threePair[3]
//                                             var weekArray = [Int]()
//                                             for (i, b) in rawWeeks.enumerated() {
//                                                  if b == "1" {
//                                                       weekArray.append(i)
//                                                  }
//                                             }
//
//                                             let twoPair = arrangeItem.findArrays("([0-9]+)\\*unitCount\\+([0-9]+)")
//                                             let weekday = Int(twoPair[0][1]) ?? 0
//                                             let unitArray = twoPair.map { Int($0[2]) ?? 0 }
//
//                                             arrangePairArray.append(
//                                                  (
//                                                       name,
//                                                       Arrange(
//                                                            teacherArray: teacherArray,
//                                                            weekArray: weekArray,
//                                                            weekday: weekday,
//                                                            unitArray: unitArray,
//                                                            location: location
//                                                       )
//                                                  )
//                                             )
//                                        }
//
//                                        let courseHTML = html.find("<tbody(.+)</tbody>")
//                                        let courseArray = courseHTML.components(separatedBy: "<tr>")[1...]
//                                             .map { courseItem -> Course in
//                                                  Course(
//                                                       fullCourse: courseItem
//                                                            .findArrays("(<td>.*?</td>)")
//                                                            .map { $0[1].find("([^>\\s]+)\\s*<") },
//                                                       arrangePairArray: arrangePairArray
//                                                  )
//                                             }
//
//                                        completion(.success(CourseTable(courseArray: courseArray)))
//                                   case .failure(let error):
//                                        completion(.failure(error))
//                                   }
//                              }
//                         case .failure(let error):
//                              completion(.failure(error))
//                         }
//                    }
////               case .failure(let error):
//                    completion(.failure(error))
//               }
//          }
//     }
//}
