//
//  BicycleUser.swift
//  WePeiYang
//
//  Created by Tigris on 16/8/7.
//  Modified by JasonEWNL on 2018/9/13.
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
        
        // let parameters = ["wpy_tk": "\(TwTUser.shared.token!)"]
        // Modified by JasonEWNL
        var parameters: [String: String]
        if let token = TwTUser.shared.token { parameters = ["wpy_tk": "\(token)"] } else { return }

        // FIXME: sola 为啥不能用
        Alamofire.request(BicycleAPIs.rootURL+BicycleAPIs.authURL, method: .post, parameters: parameters, headers: nil).responseJSON { response in
            switch response.result {
            case .success:
                if let data = response.result.value,
                    let dict = data as? [String: Any] {
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
                        success()
                    } else {
                        failure?((dict["errmsg"] as? String) ?? "解析失败")
                    }
                }
            case .failure(let error):
                failure?(error.localizedDescription)
            }
        }
    }
    
    func getCardlist(idnum: String, doSomething: @escaping () -> (), failure: ((String)->())? = nil) {
        
        let parameters = ["auth_token": bikeToken!, "idnum": idnum]




//        Alamofire.request(BicycleAPIs.rootURL+BicycleAPIs.cardURL, method: .get, parameters: parameters, headers: nil)
        Alamofire.request(BicycleAPIs.rootURL+BicycleAPIs.cardURL, method: .post, parameters: parameters, encoding: URLEncoding.default, headers: ["Accept": "application/json"]).responseJSON { response in
            switch response.result {
            case .success:
                if let data = response.result.value,
                    let dict = data as? [String: Any] {
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
                }
            case .failure(let error):
                failure?(error.localizedDescription)
            }
        }

//        SolaSessionManager.solaSession(type: .get, baseURL: BicycleAPIs.rootURL, url: BicycleAPIs.cardURL, parameters: parameters, success: { dic in
//
//            guard dic["errno"] as? Int == 0 else {
//                print(dic["errmsg"]!)
//                return
//            }
//
//            if let data = dic["data"] as? [[String:Any]] {
//                self.cardList.removeAll()
//                for dict in data {
//                    let cardInfo = dict as Dictionary
//                    self.cardList.append(Card(dict: cardInfo))
//                }
//            }
//
//            doSomething()
//
//        }, failure: { error in
//            print("error: \(error)")
//        })
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
                }
            case .failure(let error):
                failure?(error.localizedDescription)
            }
        }

//        SolaSessionManager.solaSession(type: .post, baseURL: BicycleAPIs.rootURL, url: BicycleAPIs.bindURL, parameters: parameters, success: { dic in
//
//            guard dic["errno"] as? Int == 0 else {
//                return
//            }
//
//            doSomething()
//
//        }, failure: { error in
//            print("error: \(error)")
//        })

        //        let manager = Alamofire.SessionManager()
        //
        //        manager.request(BicycleAPIs.bindURL, parameters: parameters, progress: { (progress: Progress) in
        //
        //            MsgDisplay.showLoading()
        //
        //            }, success: { (task: URLSessionDataTask, responseObject: AnyObject?) in
        //
        //            let dic = responseObject as? NSDictionary
        //            //log.obj(dic!)/
        //            guard dic?.objectForKey("errno") as? NSNumber == 0 else {
        //                MsgDisplay.showErrorMsg(dic?.objectForKey("errmsg") as? String)
        //                return
        //            }
        //
        //            MsgDisplay.showSuccessMsg("绑定成功！")
        //            doSomething()
        //
        //        }, failure: { (task: URLSessionDataTask?, error: NSError) in
        //            MsgDisplay.showErrorMsg("网络错误，请稍后再试")
        //            print("error: \(error)")
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
        
        //        let manager = Alamofire.SessionManager()
        //
        //        manager.POST(BicycleAPIs.infoURL, parameters: parameters, progress: { (progress: Progress) in
        //
        ////            MsgDisplay.showLoading()
        //
        //        }, success: { (task: URLSessionDataTask, responseObject: AnyObject?) in
        //
        //            let dic = responseObject as? NSDictionary
        //            //log.obj(dic!)/
        //            guard dic?.objectForKey("errno") as? NSNumber == 0 else {
        //                MsgDisplay.showErrorMsg(dic?.objectForKey("errmsg") as? String)
        //                return
        //            }
        //
        //            let dict = dic?.objectForKey("data") as? NSDictionary
        //            print(dict)
        //
        //
        //            guard let fooName = dict?.objectForKey("name") as? String,
        //                let fooBalance = dict?.objectForKey("balance") as? String,
        //                let fooDuration = dict?.objectForKey("duration") as? String,
        //                let fooRecent = dict?.objectForKey("recent") as? Array<Array<AnyObject>>,
        //                let fooRecord = dict?.objectForKey("record") as? NSDictionary
        //                else {
        //                    MsgDisplay.showErrorMsg("获取用户数据失败，请重新登陆试试")
        //                    return
        //            }
        //
        //            MsgDisplay.dismiss()
        //
        //            self.name = fooName
        //            self.balance = fooBalance
        //            self.duration = fooDuration
        //            self.recent = fooRecent
        //            self.record = fooRecord
        //
        //            doSomething()
        //
        //        }, failure: { (task: URLSessionDataTask?, error: NSError) in
        //            MsgDisplay.showErrorMsg("网络错误，请稍后再试")
        //            print("error: \(error)")
        //        })
    }
    
}

