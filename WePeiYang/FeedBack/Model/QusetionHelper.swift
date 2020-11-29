//
//  QusetionHelper.swift
//  WePeiYang
//
//  Created by 于隆祎 on 2020/9/20.
//  Copyright © 2020 twtstudio. All rights reserved.
//

import Foundation
import Alamofire


import Foundation

// MARK: - PlainModel
struct FBPlainModel: Codable {
     var errorCode: Int?
     var msg: String?
     
     enum CodingKeys: String, CodingKey {
          case errorCode = "ErrorCode"
          case msg
     }
}

// MARK: - QuestionGet
struct FBQuestionGet: Codable {
     var errorCode: Int?
     var msg: String?
     var questionData: FBQuestionData?
     
     enum CodingKeys: String, CodingKey {
          case errorCode = "ErrorCode"
          case msg, questionData = "data"
     }
}

// MARK: - DataClass
struct FBQuestionData: Codable {
     var currentPage: Int?
     var data: [FBQuestionModel]?
     var firstPageURL: String?
     var from, lastPage: Int?
     var lastPageURL, nextPageURL, path: String?
     var perPage: Int?
     var prevPageURL: String?
     var to, total: Int?
     
     enum CodingKeys: String, CodingKey {
          case currentPage = "current_page"
          case data
          case firstPageURL = "first_page_url"
          case from
          case lastPage = "last_page"
          case lastPageURL = "last_page_url"
          case nextPageURL = "next_page_url"
          case path
          case perPage = "per_page"
          case prevPageURL = "prev_page_url"
          case to, total
     }
}

// MARK: - Datum
struct FBQuestionModel: Codable {
     var id: Int?
     var name, datumDescription: String?
     var userID, solved, noCommit, likes: Int?
     var createdAt, updatedAt, username: String?
     var msgCount: Int?
     var urlList: [String]?
     var thumbImg: String?
     var tags: [FBTagModel]?
     var thumbUrlList: [String]?
     var isLiked: Bool?
     
     enum CodingKeys: String, CodingKey {
          case id, name
          case datumDescription = "description"
          case userID = "user_id"
          case solved
          case noCommit = "no_commit"
          case likes, tags
          case createdAt = "created_at"
          case updatedAt = "updated_at"
          case username, msgCount
          case urlList = "url_list"
          case thumbImg, isLiked = "is_liked"
          case thumbUrlList = "thumb_url_list"
     }
}


//  stupid quicktype QAQ

class FBQuestionHelper {     
     static func searchQuestions(tags: [Int] = [], string: String = "", limits: Int = 10, page: Int = 1, completion: @escaping (Result<[FBQuestionModel]>) -> Void) {
          let questionRequest: DataRequest = Alamofire.request(FB_BASE_USER_URL + "question/search?tagList=\(tags)&searchString=\(string)&limits=\(limits)&page=\(page)&user_id=\(FB_USER_ID)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)
          questionRequest.responseJSON { response in
               do {
                    if let data = response.data {
                         let questionGet = try JSONDecoder().decode(FBQuestionGet.self, from: data)
                         completion(.success(questionGet.questionData?.data ?? []))
                    }
               } catch {
                    completion(.failure(error))
               }
          }
     }
     
     static func postQuestion (title: String, content: String, tagList: [Int], campus: Int = 0, completion: @escaping (Result<Int>) -> Void) {
          let paras = ["user_id": FB_USER_ID, "name": title, "description": content, "tagList": tagList.description, "campus": campus] as [String : Any]
          Alamofire.request(FB_BASE_USER_URL + "question/add" , method: .post, parameters: paras, encoding: JSONEncoding.default)
               .validate().responseJSON { (response) in
                    if let data = response.data {
                         do {
                              let jsonData = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as AnyObject
                              let data: AnyObject = jsonData["data"] as AnyObject
                              if let incurData = try? JSONSerialization.data(withJSONObject: data, options: []) {
                                   let data = try JSONSerialization.jsonObject(with: incurData, options: .mutableContainers) as AnyObject
                                   completion(.success((data["question_id"]! as! Int?) ?? 0))
                              }
                         } catch {
                              completion(.failure(error))
                         }
                    } else {
                         print("post question error")
                    }
               }
     }
     
     static func postImg (img: UIImage, question_id: Int, completion: @escaping (Result<String>) -> Void) {
          let imageData = img.jpegData(compressionQuality: 1)!
          let paras =  ["user_id": FB_USER_ID, "question_id": question_id] as [String: Int]
          Alamofire.upload(multipartFormData: { (multi) in
               multi.append(imageData, withName: "newImg", fileName: "1.jpg", mimeType: "image/jpeg")
               for (key, val) in paras {
                    let v: String = val.description
                    let vd: Data = v.data(using: .utf8)!
                    multi.append(vd, withName: key)
               }
          }, to: FB_BASE_USER_URL + "image/add") { (result) in
               switch result {
               case .success(let upload, _, _):
                    upload.uploadProgress { (pro) in
                         
                    }
                    upload.responseJSON { (response) in
                         if let data = response.data {
                              do {
                                   let jsonData = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as AnyObject
                                   let data: AnyObject = jsonData["data"] as AnyObject
                                   if let incurData = try? JSONSerialization.data(withJSONObject: data, options: []) {
                                        let data = try JSONSerialization.jsonObject(with: incurData, options: .mutableContainers) as AnyObject
                                        completion(.success((data["url"]! as! String?) ?? ""))
                                   }
                              } catch {
                                   completion(.failure(error))
                              }
                         } else {
                              print("post img error")
                         }
                    }
               case .failure(let err):
                    print(err)
               }
               
          }
     }
     
     static func likeQuestion(id: Int, completion: @escaping (Result<String>) -> Void) {
          let paras = ["id": id, "user_id": FB_USER_ID] as [String : Any]
          Alamofire.request(FB_BASE_USER_URL + "question/like", method: .post, parameters: paras, encoding: JSONEncoding.default)
               .validate().responseJSON{ (response) in
                    if let data = response.data {
                         do {
                              let plain = try JSONDecoder().decode(FBPlainModel.self, from: data)
                              if plain.errorCode == 0 {
                                   completion(.success("点赞成功"))
                              }
                         } catch {
                              completion(.failure(error))
                         }
                    } else {
                         print("post like error")
                    }
               }
     }
     static func dislikeQuestion(id: Int, completion: @escaping (Result<String>) -> Void) {
          let paras = ["id": id, "user_id": FB_USER_ID] as [String : Any]
          Alamofire.request(FB_BASE_USER_URL + "question/dislike", method: .post, parameters: paras, encoding: JSONEncoding.default)
               .validate().responseJSON{ (response) in
                    if let data = response.data {
                         do {
                              let plain = try JSONDecoder().decode(FBPlainModel.self, from: data)
                              if plain.errorCode == 0 {
                                   completion(.success("取消点赞"))
                              }
                         } catch {
                              completion(.failure(error))
                         }
                    } else {
                         print("post dislike error")
                    }
               }
     }

     enum QuesGetType {
          case liked, my, solved
     }
     
     static func getQuestions(type: QuesGetType, limits: Int = 0, completion: @escaping (Result<[FBQuestionModel]>) -> Void) {
          let url = FB_BASE_USER_URL + (type == .liked ? "likes/get/question?user_id=\(FB_USER_ID)" : "question/get/myQuestion?user_id=\(FB_USER_ID)&limits=\(limits)")
          Alamofire.request(url)
               .validate().responseJSON { (response) in
                    do {
                         if let data = response.data {
                              if type == .liked {
                                   let jsonData = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as AnyObject
                                   let data: AnyObject = jsonData["data"] as AnyObject
                                   if let incurData = try? JSONSerialization.data(withJSONObject: data, options: []) {
                                        let questions = try JSONDecoder().decode([FBQuestionModel].self, from: incurData)
                                        completion(.success(questions))
                                   }
                              } else {
//                                   let questionGet = try JSONDecoder().decode(FBQuestionGet.self, from: data)
//                                   completion(.success(questionGet.questionData?.data ?? []))
                                   let jsonData = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as AnyObject
                                   let data: AnyObject = jsonData["data"] as AnyObject
                                   if let incurData = try? JSONSerialization.data(withJSONObject: data, options: []) {
                                        let questions = try JSONDecoder().decode([FBQuestionModel].self, from: incurData)
                                        completion(.success(questions))
                                   }
                              }
                         }
                    } catch {
                         completion(.failure(error))
                    }
               }
     }
     
     static func deleteMyQuestion(questionId: Int, completion: @escaping (Result<String>) -> Void) {
          let paras = ["user_id": FB_USER_ID, "question_id": questionId]
          Alamofire.request(FB_BASE_USER_URL + "question/delete", method: .post, parameters: paras, encoding: JSONEncoding.default)
               .validate().responseJSON { (response) in
                    if let data = response.data {
                         do {
                              let plain = try JSONDecoder().decode(FBPlainModel.self, from: data)
                              if plain.errorCode == 0 {
                                   completion(.success("问题删除成功"))
                              }
                         } catch {
                              completion(.failure(error))
                         }
                    } else {
                         print("question delete error")
                    }
               }
     }
}
