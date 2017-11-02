//
//  ReadBeacon.swift
//  WePeiYang
//
//  Created by Halcao on 2017/4/8.
//  Copyright © 2017年 twtstudio. All rights reserved.
//

import Foundation
import Alamofire

struct ReadBeacon {
    static func request(_ url: String, method: HTTPMethod = HTTPMethod.get, parameters: [String: Any]? = [:], headers: [String: String]? = nil, failureMessage: String?, failure: ((Dictionary<String, AnyObject>)->(Void))? = nil, success: @escaping (Dictionary<String, AnyObject>)->(Void)) {
        User.shared.getToken { token in
            var header = headers ?? HTTPHeaders()
            if headers == nil {
                header["User-Agent"] = DeviceStatus.userAgent
                header["Authorization"] = "Bearer {\(token)}"
            }
            Alamofire.request(url, method: method, parameters: parameters, headers: header).responseJSON { response in
                switch response.result {
                case .success:
                    if let value = response.result.value,
                        let dict = value as? Dictionary<String, AnyObject> {
                        if dict["error_code"] as! Int == -1 {
                            success(dict)
                            return
                        } else if dict["error_code"] as! Int == 10000 {
                            print("removed read token")
                            UserDefaults.standard.removeObject(forKey: READ_TOKEN_KEY)
                            // FIXME: token should be refreshed??
                        }
                        failure?(dict)
                        // FIXME: log failureMessage
                        // log.errorMessage(failureMessage)
                        // log.errorMessage(dict["message"])
                    }
                case .failure(let error):
                log.error(error)/
                if let data = response.result.value as? Dictionary<String, AnyObject> {
                    // FIXME: errorMessage/ MsgDisplay
                    // 网络开小差啦
                    failure?(data)
                    log.errorMessage(data["message"] as! String)/
                }
            }
        }
    }
}

}
