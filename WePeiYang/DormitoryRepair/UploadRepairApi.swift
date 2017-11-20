//
//  UploadRepairApi.swift
//  WePeiYang
//
//  Created by 赵家琛 on 2017/10/20.
//  Copyright © 2017年 twtstudio. All rights reserved.
//

import UIKit

class UploadRepairApi {
    
    static func deleteRepair(id: String, success: @escaping() -> (), failure: (Error) -> ()) {
        
        var diction: [String : String] = [String : String]()
        diction["order_id"] = id
        
        SolaSessionManager.upload1(dictionay: diction, url: "/repairs/order/delete", method: .post, progressBlock: nil, failure: { error in
            print(error)
        }, success: { dic in
            success()
        })
        
    }
    
    static func submitRepair(diction: [String : Any], success: @escaping(Bool) -> (), failure: (Error) -> ()) {

        SolaSessionManager.upload1(dictionay: diction, url: "/repairs/order/add", method: .post, progressBlock: nil, failure: { error in
            print(error)
            
        }, success: { dic in
            
            var victory = false
            if let error_code = dic["error_code"] as? Int {
                if error_code == -1 {
                    victory = true
                }
            }
            success(victory)
        })
        
    }
    
    static func submitComplain(diction: [String : Any], success: @escaping(Bool) -> (), failure: (Error) -> ()) {
        
        SolaSessionManager.upload1(dictionay: diction, url: "/repairs/complain/add", method: .post, progressBlock: nil, failure: { error in
            print(error)
        }, success: { dic in
            //print(dic)
            var victory = false
            if let error_code = dic["error_code"] as? Int {
                if error_code == -1 {
                    victory = true
                }
            }
            success(victory)
        })
    }
    
    static func submitEvaluation(diction: [String : Any], success: @escaping(Bool) -> (), failure: (Error) -> ()) {
        
        SolaSessionManager.upload1(dictionay: diction, url: "/repairs/grade/add", method: .post, progressBlock: nil, failure: { error in
            print(error)
        }, success: { dic in
            var victory = false
            if let error_code = dic["error_code"] as? Int {
                if error_code == -1 {
                    victory = true
                }
            }
            success(victory)
        })
    }
    
       
    
}
