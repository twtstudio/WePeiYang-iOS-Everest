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
    
    func auth(presentViewController: @escaping () -> ()) {
        
        // FIXME: token
        let parameters = ["wpy_tk": "\(TwTUser.shared.token ?? "")}"]
        
        
        
        SolaSessionManager.solaSession(type: .post, baseURL: BicycleAPIs.rootURL, url: BicycleAPIs.authURL, parameters: parameters, success: { dic in
            
            //log.obj(dic!)/
            guard dic["errno"] as? NSNumber == 0 else {
                //                MsgDisplay.showErrorMsg(dic?.objectForKey("errmsg") as? String)
                return
            }
            
            let dict = dic["data"] as? NSDictionary
            //print(dict)
            guard let fooStatus = dict?["status"] as? Int,
                let fooVersion = dict?["version"] as? Int,
                let fooBikeToken = dict?["token"] as? String,
                let fooExpire = dict?["expire"] as? Int
                else {
                    //                    MsgDisplay.showErrorMsg("用户认证失败，请重新登陆试试")
                    return
            }
            
            //            MsgDisplay.dismiss()
            self.status = fooStatus
            self.version = fooVersion
            self.bikeToken = fooBikeToken
            self.expire = fooExpire
            
            presentViewController()
            
        }, failure: { error in
            //            MsgDisplay.showErrorMsg("网络错误，请稍后再试")
            print("error: \(error)")
        })
        
        //        manager.request(BicycleAPIs.authURL, parameters: parameters, progress: { (progress: Progress) in
        //
        //            //MsgDisplay.showLoading()
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
        //            let dict = dic?.objectForKey("data") as? NSDictionary
        //            //print(dict)
        //            guard let fooStatus = dict?.objectForKey("status") as? NSNumber,
        //                let fooVersion = dict?.objectForKey("version") as? NSNumber,
        //                let fooBikeToken = dict?.objectForKey("token") as? String,
        //                let fooExpire = dict?.objectForKey("expire") as? Int
        //                else {
        //                    MsgDisplay.showErrorMsg("用户认证失败，请重新登陆试试")
        //                    return
        //            }
        //
        //            MsgDisplay.dismiss()
        //            self.status = fooStatus
        //            self.version = fooVersion
        //            self.bikeToken = fooBikeToken
        //            self.expire = fooExpire
        //
        //            presentViewController()
        //
        //        }, failure: { (task: URLSessionDataTask?, error: NSError) in
        //            MsgDisplay.showErrorMsg("网络错误，请稍后再试")
        //            print("error: \(error)")
        //        })
        
    }
    
    func getCardlist(idnum: String, doSomething: @escaping () -> ()) {
        
        let parameters = ["auth_token": bikeToken!, "idnum": idnum]
        
        SolaSessionManager.solaSession(type: .get, baseURL: BicycleAPIs.rootURL, url: BicycleAPIs.cardURL, parameters: parameters, success: { dic in
            
            guard dic["errno"] as? Int == 0 else {
                print(dic["errmsg"]!)
                return
            }
            
            if let data = dic["data"] as? [[String:Any]] {
                self.cardList.removeAll()
                for dict in data {
                    let cardInfo = dict as Dictionary
                    self.cardList.append(Card(dict: cardInfo))
                }
            }
            
            doSomething()
            
        }, failure: { error in
            print("error: \(error)")
        })
        
        //        manager.request(BicycleAPIs.cardURL, parameters: parameters, progress: { (progress: Progress) in
        //
        ////            MsgDisplay.showLoading()
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
        //            MsgDisplay.dismiss()
        //            let list = dic?.objectForKey("data") as? NSArray
        //
        //            self.cardList.removeAll()
        //            for dict in list! {
        //                let cardInfo = dict as? NSDictionary
        //                self.cardList.append(Card(dict: cardInfo!))
        //            }
        //            doSomething()
        //
        //        }, failure: { (task: URLSessionDataTask?, error: NSError) in
        //            MsgDisplay.showErrorMsg("网络错误，请稍后再试")
        //            print("error: \(error)")
        //        })
    }
    
    func bindCard(id: String, sign: String, doSomething: @escaping () -> ()) {
        
        let parameters = ["auth_token": bikeToken!, "id": id, "sign": sign]
        
        SolaSessionManager.solaSession(type: .post, baseURL: BicycleAPIs.rootURL, url: BicycleAPIs.bindURL, parameters: parameters, success: { dic in
            
            guard dic["errno"] as? Int == 0 else {
                return
            }
            
            doSomething()
            
        }, failure: { error in
            print("error: \(error)")
        })
        
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

