//
//  FBCommentHelper.swift
//  WePeiYang
//
//  Created by 于隆祎 on 2020/9/20.
//  Copyright © 2020 twtstudio. All rights reserved.
//

import Foundation
import Alamofire

// MARK: - FBCommentGet
struct FBCommentGet: Codable {
     var errorCode: Int?
     var msg: String?
     var data: [FBCommentModel]?
     
     enum CodingKeys: String, CodingKey {
          case errorCode = "ErrorCode"
          case msg, data
     }
}

// MARK: - FBCommentModel
// 这个是问题回复和评论的杂合体
struct FBCommentModel: Codable {
     var id: Int?
     var contain: String?
     var adminID: Int?
     var score: Float?
     var commit: String?
     var userID, likes: Int?
     var createdAt, updatedAt, username: String?
     var isLiked: Bool?
     var adminName: String?
     
     enum CodingKeys: String, CodingKey {
          case id, contain
          case userID = "user_id"
          case likes, adminID = "admin_id"
          case score, commit
          case createdAt = "created_at"
          case updatedAt = "updated_at"
          case username, adminName = "admin_name"
          case isLiked = "is_liked"
     }
}


class FBCommentHelper {
     enum type {
          case comment, answer
     }
     
     static func commentGet(type: type = .comment, id: Int, completion: @escaping (Result<[FBCommentModel]>) -> Void) {
          let url = FB_BASE_USER_URL + (type == .comment ?
               "question/get/commit?question_id=\(id)&user_id=\(FB_USER_ID)" :
               "question/get/answer?question_id=\(id)&user_id=\(FB_USER_ID)")
          let commentRequest: DataRequest = Alamofire.request(url)
          commentRequest.validate().responseJSON { response in
               if let data = response.data {
                    do {
                         let commentGet = try JSONDecoder().decode(FBCommentGet.self, from: data)
                         completion(.success(commentGet.data ?? []))
                    } catch {
                         completion(.failure(error))
                    }
               } else {
                    print("comment get error")
               }
          }
     }
     
     static func addComment(questionId: Int, contain: String, completion: @escaping (Result<String>) -> Void) {
          let paras = ["question_id": questionId, "user_id": FB_USER_ID, "contain": contain] as [String : Any]
          Alamofire.request(FB_BASE_USER_URL + "commit/add/question", method: .post, parameters: paras, encoding: JSONEncoding.default)
               .validate().responseJSON { response in
                    if let data = response.data {
                         do {
                              let plain = try JSONDecoder().decode(FBPlainModel.self, from: data)
                              if plain.errorCode == 0 {
                                   completion(.success("评论成功"))
                              }
                         } catch {
                              completion(.failure(error))
                         }
                    } else {
                         print("likeComment error")
                    }
               }
     }
     
     static func commentAnswer (answerId: Int, score: Int, commit: String, completion: @escaping (Result<String>) -> Void) {
          let paras = ["user_id": FB_USER_ID, "answer_id": answerId, "score": score, "commit": commit] as [String: Any]
          Alamofire.request(FB_BASE_USER_URL + "answer/commit", method: .post, parameters: paras, encoding: JSONEncoding.default)
               .validate().responseJSON{(response) in
                    if let data = response.data {
                         do {
                              let plain = try JSONDecoder().decode(FBPlainModel.self, from: data)
                              if plain.errorCode == 0 {
                                   completion(.success("评论回复成功"))
                              }
                         } catch {
                              completion(.failure(error))
                         }
                    } else {
                         print("post commit error")
                    }
               }
     }
     
     static func likeComment(type: type = .comment, commentId: Int, completion: @escaping (Result<String>) -> Void) {
          let paras = ["id": commentId, "user_id": FB_USER_ID]
          Alamofire.request(FB_BASE_USER_URL + (type == .comment ? "commit/like" : "answer/like") , method: .post, parameters: paras, encoding: JSONEncoding.default)
               .validate().responseJSON { (response) in
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
                         print("likeComment error")
                    }
               }
     }
     
     static func dislikeComment(type: type = .comment, commentId: Int, completion: @escaping (Result<String>) -> Void) {
          let paras = ["id": commentId, "user_id": FB_USER_ID]
          Alamofire.request(FB_BASE_USER_URL + (type == .comment ? "commit/dislike" : "answer/dislike"), method: .post, parameters: paras, encoding: JSONEncoding.default)
               .validate().responseJSON { (response) in
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
                         print("likeComment error")
                    }
               }
     }
}

