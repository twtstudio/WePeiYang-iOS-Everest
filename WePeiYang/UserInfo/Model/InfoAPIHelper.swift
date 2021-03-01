//
//  APIHelper.swift
//  WePeiYang
//
//  Created by 安宇 on 2021/1/13.
//  Copyright © 2021 twtstudio. All rights reserved.
//

import Foundation
import Alamofire
import UIKit

struct InfoAPI {
    
    static let base = "https://api.twt.edu.cn"
    
    static let getRegisterCode = "/api/register/phone/msg"//POST
    
    static let getLoginCode = "/api/auth/phone/msg"
    
    static let register = "/api/register"//POST
    
    static let login = "/api/auth/common"
    
    static let loginByPhone = "/api/auth/phone"
    
    static let getUserInfo = "/api/user/single"
    
    static let changeInfo = "/api/user/single" //PUT

}
struct InfoHelper {
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
//
struct GetCodeHelper {

    static func getRegisterCode(success: @escaping (CodeModel)->(), failure: @escaping (Error)->()) {
        Alamofire.request(InfoAPI.base + InfoAPI.getRegisterCode, method: .post, parameters: ["phone": PhoneInfo.num], headers: ["ticket": "YmFuYW5hLjM3YjU5MDA2M2Q1OTM3MTY0MDVhMmM1YTM4MmIxMTMwYjI4YmY4YTc=", "domain": "weipeiyang.twt.edu.cn"]).responseJSON { (response) in
            do {
                if let data = response.data {
                    let code = try JSONDecoder().decode(CodeModel.self, from: data)
                    success(code)
                }
            } catch {
                failure(error)
            }
        }
    }
    static func getLoginCode(phone: String, success: @escaping (CodeModel)->(), failure: @escaping (Error)->()) {
        Alamofire.request(InfoAPI.base + InfoAPI.getLoginCode, method: .post, parameters: ["phone": phone], headers: ["ticket": "YmFuYW5hLjM3YjU5MDA2M2Q1OTM3MTY0MDVhMmM1YTM4MmIxMTMwYjI4YmY4YTc=", "domain": "weipeiyang.twt.edu.cn"]).responseJSON { (response) in
            do {
                if let data = response.data {
                    let code = try JSONDecoder().decode(CodeModel.self, from: data)
                    success(code)
                }
            } catch {
                failure(error)
            }
        }
    }
}

struct GetUserInfoHelper {
    static func login(username: String, password: String, success: @escaping (UserInfo)->(), failure: @escaping (Error)->()) {
        Alamofire.request(InfoAPI.base + InfoAPI.login, method: .post, parameters: ["account": username, "password": password], headers: ["ticket": "YmFuYW5hLjM3YjU5MDA2M2Q1OTM3MTY0MDVhMmM1YTM4MmIxMTMwYjI4YmY4YTc=", "domain": "weipeiyang.twt.edu.cn"]).responseJSON { (response) in
            switch response.result {
            case .success:
                if let data = response.result.value  {
                    if let dict = data as? [String: Any] {
                        if let dic = dict["result"] as? [String: Any] {
                            let telephone = dic["telephone"] as? String ?? ""
                            let gender = dic["gender"] as? String ?? ""
                            let realname = dic["realname"] as? String ?? ""
                            let major = dic["major"] as? String ?? ""
                            let userNumber = dic["userNumber"] as? String ?? ""
                            let avatar = dic["avatar"] as? String ?? ""
                            let stuType = dic["stuType"] as? String ?? ""
                            let role = dic["role"] as? String ?? ""
                            let token = dic["token"] as? String ?? ""
                            let nickname = dic["nickname"] as? String ?? ""
                            let email = dic["email"] as? String ?? ""
                            let department = dic["department"] as? String ?? ""
                            CurToken.token = token
                            let userInfo = UserInfo(userNumber: userNumber, nickname: nickname, telephone: telephone, email: email, token: token, role: role, realname: realname, gender: gender, department: department, major: major, stuType: stuType, avatar: avatar)
                            success(userInfo)
                        }
                       
                    }
                }
            case .failure(let error):
                failure(error)
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
    static func loginByPhone(phone: String, code: String, success: @escaping (UserInfo)->(), failure: @escaping (Error)->()) {
        Alamofire.request(InfoAPI.base + InfoAPI.loginByPhone, method: .post, parameters: ["phone": phone, "code": code], headers: ["ticket": "YmFuYW5hLjM3YjU5MDA2M2Q1OTM3MTY0MDVhMmM1YTM4MmIxMTMwYjI4YmY4YTc=", "domain": "weipeiyang.twt.edu.cn"]).responseJSON { (response) in
            switch response.result {
            case .success:
                if let data = response.result.value  {
                    if let dict = data as? [String: Any] {
                        if let dic = dict["result"] as? [String: Any] {
                            let telephone = dic["telephone"] as? String ?? ""
                            let gender = dic["gender"] as? String ?? ""
                            let realname = dic["realname"] as? String ?? ""
                            let major = dic["major"] as? String ?? ""
                            let userNumber = dic["userNumber"] as? String ?? ""
                            let avatar = dic["avatar"] as? String ?? ""
                            let stuType = dic["stuType"] as? String ?? ""
                            let role = dic["role"] as? String ?? ""
                            let token = dic["token"] as? String ?? ""
                            let nickname = dic["nickname"] as? String ?? ""
                            let email = dic["email"] as? String ?? ""
                            let department = dic["department"] as? String ?? ""
                            CurToken.token = token
                            let userInfo = UserInfo(userNumber: userNumber, nickname: nickname, telephone: telephone, email: email, token: token, role: role, realname: realname, gender: gender, department: department, major: major, stuType: stuType, avatar: avatar)
                            success(userInfo)
                        }
                       
                    }
                }
            case .failure(let error):
                failure(error)
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

struct ChangeUserInfoHelper {
    static func changeUserInfo(success: @escaping (CodeModel)->(), failure: @escaping (Error)->()) {
        Alamofire.request(InfoAPI.base + InfoAPI.getUserInfo, method: .put, parameters: ["telephone": PhoneInfo.num, "email": PhoneInfo.email, "verifyCode": PhoneInfo.code], headers: ["ticket": "YmFuYW5hLjM3YjU5MDA2M2Q1OTM3MTY0MDVhMmM1YTM4MmIxMTMwYjI4YmY4YTc=", "domain": "weipeiyang.twt.edu.cn", "token": TwTUser.shared.newToken!]).responseJSON { (response) in
            switch response.result {
            case .success:
                if let data = response.result.value  {
                    if let dict = data as? [String: Any] {
                        if let finalData = try? JSONSerialization.data(withJSONObject: dict, options: JSONSerialization.WritingOptions.init(rawValue: 0)), let tmp = try? CodeModel(data:finalData) {
                            success(tmp)
                        }
                    }
                }
                
            case .failure(let error):
                failure(error)
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

struct CurToken {
    static var token = ""
    static var flag = 0
}
