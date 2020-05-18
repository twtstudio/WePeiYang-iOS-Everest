//
//  ScanCodeAPI.swift
//  WePeiYang
//
//  Created by 安宇 on 24/08/2019.
//  Copyright © 2019 twtstudio. All rights reserved.
//

import Foundation
import Alamofire

struct ScanCodeAPI {
    
    static let root = "https://activity.twt.edu.cn"
    
    static let getActivityDetail = "/api/activity/index"
    
    static let getUID = "/api/user/info"
//    ?method=0&page=0&limit=0&user_id=3018216126
//    method传入0表示正在进行的活动，传入1表示已完成活动，传入2如果是管理员返回我管理的活动
//    page页数，从1开始
//    limit每页最大活动数
//    static let found = "/found"
//
//    static let search = "/search"
//
//    static let user = "/user"
    static let getId = "/api/user/getNameByNumber"
//    student_number获取学号
    static let getAuother = "/api/user/register/checkManager"
//    user_id是否为管理员
    static let codeLogin = "/api/QrCode/scan"
//    activity_id
//    student_number学号
//    time时间
//    post
//    static let
}
struct CodeDetailHelper {
    static func dataManager(url: String, success: (([String: Any])->())? = nil, failure: ((Error)->())? = nil) {
        Alamofire.request(url).responseJSON { response in
            switch response.result {
            case .success:
                if let data = response.result.value  {
                    if let dict = data as? [String: Any] {
                        success?(dict)
                    }
                }
            case .failure(let error):
                failure?(error)
                if let data = response.result.value  {
                    if let dict = data as? [String: Any],
                        let errmsg = dict["message"] as? String {
                        print(errmsg)
                    }
                } else {
                    print(error)
                }
            }
        }
    }
}

struct UIDHelper {
    static func getUID(success: @escaping (Uid)->(), failure: @escaping (Error)->()) {
        SolaSessionManager.solaSession(type: .get, baseURL: ScanCodeAPI.root, url: ScanCodeAPI.getUID, token: TwTUser.shared.token!, parameters: nil, success: { (dict) in
            if let data = try? JSONSerialization.data(withJSONObject: dict, options: JSONSerialization.WritingOptions.init(rawValue: 0)), let model = try? Uid(data: data) {
                success(model)
            } else {
                failure("解析失败" as! Error)
            }
        }) { (error) in
            failure(error)
        }
    }
}

struct ActivityDetailHelper {
    static func getActivities(success: @escaping (ActivityDeatilModel)->(), failure: @escaping (Error)->()) {
        SolaSessionManager.solaSession(type: .get, baseURL: ScanCodeAPI.root, url: ScanCodeAPI.getActivityDetail, token: TwTUser.shared.token!, parameters: ["method": ScanHelper.state, "page": "1", "limit": "999", "twtid": ScanHelper.uid], success: { (dict) in
            if let data = try? JSONSerialization.data(withJSONObject: dict, options: JSONSerialization.WritingOptions.init(rawValue: 0)), let model = try? ActivityDeatilModel(data: data) {
                success(model)
            } else {
                failure("解析失败" as! Error)
            }
        }) { (error) in
            failure(error)
        }
        
    }
}

struct AuotherHelper {
    static func getAuother(success: @escaping (AuotherModel)->(), failure: @escaping (Error)->()) {
        CodeDetailHelper.dataManager(url: ScanCodeAPI.root + ScanCodeAPI.getAuother + "?user_id=\(TwTUser.shared.schoolID!)", success: { dic in
            if let data = try? JSONSerialization.data(withJSONObject: dic, options: JSONSerialization.WritingOptions.init(rawValue: 0)), let auDetail = try? AuotherModel(data: data) {
                success(auDetail)
            }
        }, failure: { _ in
            
        })
    }
}
struct NameHelper {
    static func getAuother(success: @escaping (NameModel)->(), failure: @escaping (Error)->()) {
        CodeDetailHelper.dataManager(url: ScanCodeAPI.root + ScanCodeAPI.getAuother + "?student_number=\(TwTUser.shared.schoolID!)", success: { dic in
            if let data = try? JSONSerialization.data(withJSONObject: dic, options: JSONSerialization.WritingOptions.init(rawValue: 0)), let nameDetail = try? NameModel(data: data) {
                success(nameDetail)
            }
        }, failure: { _ in
            
        })
    }
}

struct ScanHelper {
    static var uid = ""
    static var state = ""
//    var 
}
