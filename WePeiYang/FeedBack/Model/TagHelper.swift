//
//  TagHelper.swift
//  WePeiYang
//
//  Created by 于隆祎 on 2020/9/20.
//  Copyright © 2020 twtstudio. All rights reserved.
//

import Foundation
import Alamofire

// MARK: - TagsGet
struct TagsGet: Codable {
    var errorCode: Int?
    var msg: String?
    var data: [TagModel]?
}

// MARK: - TagModel
struct TagModel: Codable {
    var id: Int?
    var name: String?
    var children: [TagModel]?
}

class TagsHelper {
    
    static func tagGet(completion: @escaping (Result<[TagModel]>) -> Void) {
        let tagRequest: DataRequest = Alamofire.request(FB_BASE_USER_URL + "tag/get/all")
        tagRequest.validate().responseJSON{ response in
            do {
//                var contentArray: [[String]] = [[], []]
                
                if let data = response.data {
                    let tagsGet = try JSONDecoder().decode(TagsGet.self, from: data)
                    completion(.success(tagsGet.data ?? []))
////                    contentArray[0].removeAll()

                }

            } catch {
               completion(.failure(error))
            }
        }
    }
}
