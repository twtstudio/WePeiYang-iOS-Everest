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

            guard dic["errno"] as? NSNumber == 0 else {
                SwiftMessages.showErrorMessage(body: (dic["errmsg"] as? String) ?? "解析错误")
                return
            }

            guard let foo = dic["data"] as? [AnyObject] else {
                SwiftMessages.showErrorMessage(body: "获取信息失败")
                return
            }

            if !foo.isEmpty {
                let fooTimeStamp = Int((foo[0] as AnyObject)["timestamp"] as! String)!
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
            SwiftMessages.showErrorMessage(body: error.localizedDescription)
        })
    }

}
