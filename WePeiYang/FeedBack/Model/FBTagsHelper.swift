//
//  FBTagsHelper.swift
//  WePeiYang
//
//  Created by 于隆祎 on 2020/9/20.
//  Copyright © 2020 twtstudio. All rights reserved.
//

import Foundation
import Alamofire

// MARK: - FBTagsGet
struct FBTagsGet: Codable {
    var errorCode: Int?
    var msg: String?
    var data: [FBTagModel]?
}

// MARK: - FBTagModel
struct FBTagModel: Codable {
    var id: Int?
    var name: String?
    var description: String?
    var children: [FBTagModel]?
    
    enum CodingKeys: String, CodingKey {
        case id, name, children
        case description = "tag_description"
    }
}

class FBTagsHelper {
    
    static func tagGet(completion: @escaping (Result<[FBTagModel]>) -> Void) {
        let tagRequest: DataRequest = Alamofire.request(FB_BASE_USER_URL + "tag/get/all")
        tagRequest.validate().responseJSON{ response in
            do {
//                var contentArray: [[String]] = [[], []]
                
                if let data = response.data {
                    let tagsGet = try JSONDecoder().decode(FBTagsGet.self, from: data)
                    completion(.success(tagsGet.data ?? []))
////                    contentArray[0].removeAll()

                }

            } catch {
               completion(.failure(error))
            }
        }
    }
}
