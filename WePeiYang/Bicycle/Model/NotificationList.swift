//
//  NotificationList.swift
//  WePeiYang
//
//  Created by Tigris on 19/08/2017.
//  Copyright © 2017 twtstudio. All rights reserved.
//

import Foundation
import Alamofire

class NotificationList: NSObject {

    var list: [NotificationItem] = []
    var newestTimeStamp: Int = 0
    var didGetNewNotification: Bool = false

    static let sharedInstance = NotificationList()
    private override init() {}

    func getList(doSomething: @escaping () -> Void) {

        SolaSessionManager.solaSession(type: .get, baseURL: BicycleAPIs.rootURL, url: BicycleAPIs.notificationURL, parameters: nil, success: { dic in

            //log.obj(dic!)/

            guard dic["errno"] as? NSNumber == 0 else {
                //            MsgDisplay.showErrorMsg(dic?.objectForKey("errmsg") as? String)
                return
            }

            guard let foo = dic["data"] as? [AnyObject] else {
                //            MsgDisplay.showErrorMsg("获取信息失败")
                return
            }

            if !foo.isEmpty {
                let fooTimeStamp = Int((foo[0])["timestamp"] as! String)!
                if fooTimeStamp > self.newestTimeStamp {
                    self.didGetNewNotification = true
                    self.newestTimeStamp = fooTimeStamp
                }
            }
            self.list.removeAll()

            for dict in foo {
                self.list.append(NotificationItem(dict: dict as! NSDictionary))
            }

            doSomething()

        }, failure: { error in
            //                MsgDisplay.showErrorMsg("网络错误，请稍后再试")
            print("error: \(error)")
        })
    }

}
