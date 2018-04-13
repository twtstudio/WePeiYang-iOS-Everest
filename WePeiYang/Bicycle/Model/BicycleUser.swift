//
//  BicycleUser.swift
//  WePeiYang
//
//  Created by Tigris on 16/8/7.
//  Copyright © 2016年 Qin Yubo. All rights reserved.
//

import Foundation
import Alamofire

class BicycleUser {
    
    //auth
    var uid: String?
    var status: Int?
    var version: Int?
    var bikeToken: String?
    var cardList = [Card]()
    var expire: Int?
    
    //info
    var name: String?
    var balance: String?
    var duration: String?
    var recent: [[Any]] = []
    var record: [String: Any]?
    
    //取消绑定时不重复要求绑定
    var bindCancel = false
    
    static let sharedInstance = BicycleUser()
    private init() {}
    
    func auth(success: @escaping () -> (), failure: ((String)->())? = nil) {
        let parameters = ["wpy_tk": "\(TwTUser.shared.token!)"]

        SolaSessionManager.solaSession(type: .post, baseURL: BicycleAPIs.rootURL, url: BicycleAPIs.authURL, parameters: parameters, success: { dict in
            if let errno = dict["errno"] as? Int,
                errno == 0,
                let data = dict["data"] as? [String: Any],
                let status = data["status"] as? Int,
                let version = data["version"] as? Int,
                let token = data["token"] as? String,
                let expire = data["expire"] as? Int {
                self.status = status
                self.version = version
                self.bikeToken = token
                self.expire = expire

                if status == 1 {
                    TwTUser.shared.bicycleBindingState = true
                } else {
                    TwTUser.shared.bicycleBindingState = false
                }
                success()
            } else {
                failure?((dict["errmsg"] as? String) ?? "解析失败")
            }
        }, failure: { error in
            failure?(error.localizedDescription)
        })
    }
    
    func getCardlist(idnum: String, doSomething: @escaping () -> (), failure: ((String)->())? = nil) {
        
        let parameters = ["auth_token": bikeToken!, "idnum": idnum]

        SolaSessionManager.solaSession(type: .post, baseURL: BicycleAPIs.rootURL, url: BicycleAPIs.cardURL, parameters: parameters, success: { dict in
            guard dict["errno"] as? Int == 0 else {
                failure?((dict["errmsg"] as? String) ?? "解析失败")
                return
            }

            if let data = dict["data"] as? [[String:Any]] {
                self.cardList.removeAll()
                for dic in data {
                    let cardInfo = dic as Dictionary
                    self.cardList.append(Card(dict: cardInfo))
                }
                doSomething()
            }
        }, failure: { error in
            failure?(error.localizedDescription)
        })
    }
    
    func bindCard(id: String, sign: String, doSomething: @escaping () -> (), failure: ((String)->())? = nil) {
        
        let parameters = ["auth_token": bikeToken!, "id": id, "sign": sign]

        Alamofire.request(BicycleAPIs.rootURL+BicycleAPIs.bindURL, method: .post, parameters: parameters, headers: nil).responseJSON { response in
            switch response.result {
            case .success:
                if let data = response.result.value,
                    let dict = data as? [String: Any] {
                    guard dict["errno"] as? Int == 0 else {
                        failure?((dict["errmsg"] as? String) ?? "解析失败")
                        return
                    }
                    doSomething()
                    return
                }
                failure?("解析失败")
            case .failure(let error):
                failure?(error.localizedDescription)
            }
        }
//        SolaSessionManager.solaSession(type: .post, baseURL: BicycleAPIs.rootURL, url: BicycleAPIs.bindURL, token: nil, parameters: parameters, success: { dic in
//            guard dic["errno"] as? Int == 0 else {
//                failure?((dic["errmsg"] as? String) ?? "解析失败")
//                return
//            }
//            doSomething()
//        }, failure: { error in
//            failure?(error.localizedDescription)
//        })
    }
    
    func getUserInfo(doSomething: @escaping () -> ()) {
        
        let parameters = ["auth_token": bikeToken!]
        
        SolaSessionManager.solaSession(type: .post, baseURL: BicycleAPIs.rootURL, url: BicycleAPIs.infoURL, parameters: parameters, success: { dict in
            
            guard dict["errno"] as? Int == 0 else {
                print(dict["errmsg"]!)
                return
            }
            let dic = dict["data"] as! NSDictionary
            
            guard let fooName = dic["name"] as? String,
                let fooBalance = dic["balance"] as? String,
                let fooDuration = dic["duration"] as? String,
                let fooRecent = dic["recent"] as? [[Any]],
            let fooRecord = dic["record"] as? [String: Any]
                else {
                    print("error.")
                    return
            }
            
            self.name = fooName
            self.balance = fooBalance
            self.duration = fooDuration
            self.recent = fooRecent
            self.record = fooRecord
            
            doSomething()
            
        }, failure: { error in
            print("error: \(error)")
        })
    }

    func unbind(success: @escaping () -> (), failure: ((String)->())? = nil) {

        auth(success: {
            let parameters = ["auth_token": self.bikeToken!]

            SolaSessionManager.solaSession(type: .post, baseURL: BicycleAPIs.rootURL, url: BicycleAPIs.unBindURL, parameters: parameters, success: { dict in
                guard dict["errno"] as? Int == 0 else {
                    failure?((dict["errmsg"] as? String) ?? "解析失败")
                    return
                }
                TwTUser.shared.bicycleBindingState = false
                success()
            }, failure: { error in
                failure?(error.localizedDescription)
            })
        }, failure: { msg in
            SwiftMessages.showErrorMessage(body: msg)
        })
    }
}

