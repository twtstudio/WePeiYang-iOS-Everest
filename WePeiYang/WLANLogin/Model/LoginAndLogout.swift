//
//  LoginAndLogout.swift
//  WePeiYang
//
//  Created by Tigris on 3/8/18.
//  Copyright © 2018 twtstudio. All rights reserved.
//

import Foundation

func WLANLogin() {
    guard let account: String = TwTUser.shared.WLANAccount, let password: String = TwTUser.shared.password else {
        let infoNotProvidedAlert = UIAlertController(title: "请绑定校园网账号", message: nil, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "好的", style: .default, handler: { (result) in
            print("OK.")
        })
        infoNotProvidedAlert.addAction(okAction)
        // self.present(infoNotProvidedAlert, animated: true, completion: nil)
        return
    }
    
    var loginInfo: [String: String] = [String: String]()
    loginInfo["username"] = account
    loginInfo["password"] = password
    
    SolaSessionManager.solaSession(type: .get, baseURL: baseURL, url: WLANLoginAPIs.loginURL,  parameters: loginInfo, success: { dictionary in
        
        print(dictionary)
        print("Succeeded")
        guard let errorCode: Int = dictionary["error_code"] as? Int,
            let errMsg = dictionary["message"] as? String else {
                return
        }
        
        if errorCode == -1 {
            // SwiftMessages.showSuccessMessage(body: "绑定成功！")
            // NotificationCenter.default.post(name: NotificationName.NotificationBindingStatusDidChange.name, object: ("WLAN", true))
            // self.dismiss(animated: true, completion: nil)
            // print("TJUBindingState:")
            // print(TwTUser.shared.tjuBindingState)
        } else if errorCode == 50002 {
            // SwiftMessages.showErrorMessage(body: "密码错误")
        } else {
            // SwiftMessages.showErrorMessage(body: errMsg)
        }
    }, failure: { error in
        // SwiftMessages.showErrorMessage(body: error.localizedDescription)
    })
}

func WLANLogout() {
    guard let account: String = TwTUser.shared.WLANAccount, let password: String = TwTUser.shared.password else {
        let infoNotProvidedAlert = UIAlertController(title: "请绑定校园网账号", message: nil, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "好的", style: .default, handler: { (result) in
            print("OK.")
        })
        infoNotProvidedAlert.addAction(okAction)
        // self.present(infoNotProvidedAlert, animated: true, completion: nil)
        return
    }
    
    var loginInfo: [String: String] = [String: String]()
    loginInfo["username"] = account
    loginInfo["password"] = password
    
    SolaSessionManager.solaSession(type: .get, baseURL: baseURL, url: WLANLoginAPIs.loginURL, parameters: loginInfo, success: { dictionary in
        
        print(dictionary)
        print("Succeeded")
        guard let errorCode: Int = dictionary["error_code"] as? Int,
            let errMsg = dictionary["message"] as? String else {
                return
        }
        
        if errorCode == -1 {
            // TwTUser.shared.tjuBindingState = false
            // TwTUser.shared.save()
            // SwiftMessages.showSuccessMessage(body: "解绑成功！")
            // self.dismiss(animated: true, completion: nil)
            print("TJUBindingState:")
            print(TwTUser.shared.tjuBindingState)
        } else {
            // SwiftMessages.showErrorMessage(body: errMsg)
        }
    }, failure: { error in
        debugLog(error)
        print("Failed")
        // SwiftMessages.showErrorMessage(body: error.localizedDescription)
    })
}



