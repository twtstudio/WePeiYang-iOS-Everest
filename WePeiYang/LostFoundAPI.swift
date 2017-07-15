//
//  LostFoundAPI.swift
//  WePeiYang
//
//  Created by Hado on 2017/7/6.
//  Copyright © 2017年 twtstudio. All rights reserved.
//

import Foundation
import Alamofire

class LostAPI{
    var lostList: [LostFoundModel] = []
    
    static func fabu(markdic: [String: String] , success: @escaping ([String: AnyObject]) -> ()) {
        SolaSessionManager.solaSession(withType: .post , url: "/lostfound/lost", token: AccountManager.token, parameters: markdic, success: success, failure: nil)
    
    }
}
