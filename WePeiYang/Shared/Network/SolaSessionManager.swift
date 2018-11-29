//
//  SolaSessionManager.swift
//  WePeiYang
//
//  Created by Halcao on 2017/3/12.
//  Copyright © 2017年 twtstudio. All rights reserved.
//

import Foundation
import Alamofire

enum SessionType {
    case get
    case post
    case duo
}

let TWT_ROOT_URL = "https://open.twtstudio.com/api/v1"
let DEV_RECORD_SESSION_INFO = "DEV_RECORD_SESSION_INFO"

struct SolaSessionManager {

    /// A primary package of Alamofire, the foundation of network module of WePeiyang
    ///
    /// - Parameters:
    ///   - type: http method: get/post/duo, default value is get
    ///   - baseURL: base url of your request, default value is TWT_ROOT_URL
    ///   - url: url of your request
    ///   - token: default value is twt token
    ///   - parameters: http parameters
    ///   - success: callback if request succeeds
    ///   - failure: callback if request fails
    static func solaSession(type: SessionType = .get, baseURL: String = TWT_ROOT_URL, url: String, token: String? = nil, parameters: [String: String]? = nil, success: (([String: Any]) -> Void)? = nil, failure: ((Error) -> Void)? = nil) {

        let fullurl = baseURL + url
        let timeStamp = String(Int64(Date().timeIntervalSince1970))
        var para = parameters ?? [String: String]()
        para["t"] = timeStamp
        var fooPara = para

        if type == .duo, let token = token {
            fooPara["token"] = token
        }

        let keys = fooPara.keys.sorted()
        // encrypt with sha1
        var tmpSign = ""
        for key in keys {
            tmpSign += (key + fooPara[key]!)
        }

        let sign = (TWTKeychain.appKey + tmpSign + TWTKeychain.appSecret).sha1.uppercased()
        para["sign"] = sign
        para["app_key"] = TWTKeychain.appKey

        var headers = HTTPHeaders()
        headers["User-Agent"] = DeviceStatus.userAgent

        if let twtToken = TwTUser.shared.token {
            headers["Authorization"] = "Bearer \(twtToken)"
        } else {
            log("can't load twtToken")
        }

        var method: HTTPMethod!
        switch type {
        case .get:
            method = .get
        case .post:
            method = .post
        case .duo:
            method = .post
        }

        Alamofire.request(fullurl, method: method, parameters: para, headers: headers).responseJSON { response in
            switch response.result {
            case .success:
                if let data = response.result.value {
                    if let dict = data as? [String: Any] {
                        success?(dict)
                        return
                    }
                }
                let error = response.error ?? WPYCustomError.errorCode(-2, "数据解析错误")
                failure?(error)
            case .failure(let error):
                if let data = response.result.value {
                    if let dict = data as? [String: Any],
                    let errmsg = dict["message"] as? String {
                        failure?(WPYCustomError.custom(errmsg))
                        return
                    }
                }
                failure?(error)
            }
        }
    }

    static func upload(dictionay: [String: Any], url: String, method: HTTPMethod = .post, progressBlock: ((Progress) -> Void)? = nil, success: (([String: Any]) -> Void)?, failure: ((Error) -> Void)? = nil) {

        var dataDict = [String: Data]()
        var paraDict = [String: String]()
        for item in dictionay {
            if let value = item.value as? UIImage {
                let data = UIImageJPEGRepresentation(value, 1.0)!
                dataDict[item.key] = data
            } else if let value = item.value as? String {
                paraDict[item.key] = value
            }
        }

        let timeStamp = String(Int64(Date().timeIntervalSince1970))
        paraDict["t"] = timeStamp
        var fooPara = paraDict

        let keys = fooPara.keys.sorted()
        // encrypt with sha1
        var tmpSign = ""
        for key in keys {
            tmpSign += (key + fooPara[key]!)
        }

        let sign = (TWTKeychain.appKey + tmpSign + TWTKeychain.appSecret).sha1.uppercased()
        paraDict["sign"] = sign
        paraDict["app_key"] = TWTKeychain.appKey

        var headers = HTTPHeaders()
        headers["User-Agent"] = DeviceStatus.userAgent

        if let twtToken = TwTUser.shared.token {
            headers["Authorization"] = "Bearer \(twtToken)"
        } else {
            log("can't load twtToken")
        }
        let fullURL = TWT_ROOT_URL + url
        
        if method == .post {
            Alamofire.upload(multipartFormData: { formdata in
                for item in dataDict {
                    // TODO: file name
                    formdata.append(item.value, withName: item.key, fileName: "avatar.jpg", mimeType: "image/jpeg")
                }
                for item in paraDict {
                    formdata.append(item.value.data(using: .utf8)!, withName: item.key)
                }
            }, to: fullURL, method: method, headers: headers, encodingCompletion: { response in
                switch response {
                case .success(let upload, _, _):
                    upload.responseJSON { response in
                        if let data = response.result.value {
                            if let dict = data as? [String: Any], dict["error_code"] as? Int == -1 {
                                success?(dict)
                            } else {
                            }
                        }
                    }
                    upload.uploadProgress { progress in
                        progressBlock?(progress)
                    }
                case .failure(let error):
                    failure?(error)
                }
            })
            return
        }
        
        if method == .delete {
            Alamofire.request(fullURL, method: .delete, parameters: paraDict, headers: headers).responseJSON { response in
                switch response.result {
                case .success(let data):
                    if let dict = data as? [String: Any], dict["error_code"] as? Int == -1 {
                        success?(dict)
                    } else {
                        
                    }
                case .failure(let error):
                    failure?(error)
                }
            }
            return
        }
    }
}
