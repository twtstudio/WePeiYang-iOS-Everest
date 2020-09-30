//
//  AnswerHelper.swift
//  WePeiYang
//
//  Created by Zr埋 on 2020/9/27.
//  Copyright © 2020 twtstudio. All rights reserved.
//

import UIKit
import Alamofire

class AnswerHelper {
     static func answerGet(id: Int, completion: @escaping (Result<[CommentModel]>) -> Void) {
          Alamofire.request(FB_BASE_USER_URL + "question/get/answer?question_id=\(id)&user_id=\(FB_USER_ID)")
               .validate().responseJSON { (response) in
                    if let data = response.data {
                         do {
                              let answerGet = try JSONDecoder().decode(CommentGet.self, from: data)
                              completion(.success(answerGet.data ?? []))
                         } catch { 
                              completion(.failure(error))
                         }
                    } else {
                         print("answer get error")
                    }
               }
     }
     
     static func likeAnswer (id: Int, completion: @escaping (Result<String>) -> Void) {
          let paras = ["id": id, "user_id": FB_USER_ID] as [String : Any]
          Alamofire.request(FB_BASE_USER_URL + "answer/like", method: .post, parameters: paras, encoding: JSONEncoding.default)
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
     
     static func disLikeAnswer (id: Int, completion: @escaping (Result<String>) -> Void) {
          let paras = ["id": id, "user_id": FB_USER_ID] as [String : Any]
          Alamofire.request(FB_BASE_USER_URL + "answer/like", method: .post, parameters: paras, encoding: JSONEncoding.default)
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
}
