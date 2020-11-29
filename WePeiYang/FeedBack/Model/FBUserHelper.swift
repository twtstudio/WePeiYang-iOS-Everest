//
//  FBUserHelper.swift
//  WePeiYang
//
//  Created by 于隆祎 on 2020/9/20.
//  Copyright © 2020 twtstudio. All rights reserved.
//

import Foundation
import Alamofire


// MARK: - UserGet
struct FBUserGet: Codable {
    var errorCode: Int?
    var msg: String?
    var data: FBUserModel?

    enum CodingKeys: String, CodingKey {
        case errorCode = "ErrorCode"
        case msg, data
    }
}

// MARK: - Users
struct FBUserModel: Codable {
    var id: Int?
    var name, studentID: String?
    var myQuestionNum, mySolvedQuestionNum, myLikedQuestionNum, myCommitNum: Int?

    enum CodingKeys: String, CodingKey {
        case id, name
        case studentID = "student_id"
        case myQuestionNum = "my_question_num"
        case mySolvedQuestionNum = "my_solved_question_num"
        case myLikedQuestionNum = "my_liked_question_num"
        case myCommitNum = "my_commit_num"
    }
}

class FBUserHelper {
     static func getDetail(completion: @escaping (Result<FBUserModel>) -> Void) {
          Alamofire.request(FB_BASE_USER_URL + "userData?user_id=\(TwTUser.shared.feedbackID ?? 1)")
               .validate().responseJSON { (response) in
                    if let data = response.data {
                         do {
                              let user = try JSONDecoder().decode(FBUserGet.self, from: data)
                              completion(.success(user.data ?? FBUserModel()))
                         } catch {
                              completion(.failure(error))
                         }
                    } else {
                         print("detail get error")
                    }
               }
     }
     
     static func userIdGet(completion: @escaping (Result<Int>) -> Void) {
          let url = (FB_BASE_USER_URL + "userId?student_id=\(TwTUser.shared.username ?? "")&name=\(TwTUser.shared.realname ?? "")").addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
          Alamofire.request(url)
               .validate().responseJSON() {response in
                    if let data = response.data {
                         do {
                              let jsonData = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as AnyObject
                              let data: AnyObject = jsonData["data"] as AnyObject
                              if let incurData = try? JSONSerialization.data(withJSONObject: data, options: []) {
                                   let data = try JSONSerialization.jsonObject(with: incurData, options: .mutableContainers) as AnyObject
                                   completion(.success((data["user_id"]! as! Int?) ?? 0))
                              }
                         } catch {
                              completion(.failure(error))
                         }
                    } else {
                         print("userid get error")
                    }
               }
     }
}
