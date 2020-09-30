//
//  UserHelper.swift
//  WePeiYang
//
//  Created by 于隆祎 on 2020/9/20.
//  Copyright © 2020 twtstudio. All rights reserved.
//

import Foundation
import Alamofire

class UserHelper {
     static func userIdGet(studentId: String = TwTUser.shared.schoolID ?? "0", realname: String = TwTUser.shared.realname ?? "0", completion: @escaping (Result<Int>) -> Void) {
          let UserIdGet: DataRequest = Alamofire.request("http://47.93.253.240:10805/api/user/userId?", parameters: ["student_id": studentId, "name": realname] )
          UserIdGet.validate().responseJSON() {response in
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
