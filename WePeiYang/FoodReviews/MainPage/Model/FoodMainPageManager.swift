//
//  FoodMainPageManager.swift
//  WePeiYang
//
//  Created by 赵家琛 on 2018/5/16.
//  Copyright © 2018年 twtstudio. All rights reserved.
//

import Foundation

struct FoodMainPageManager {
    
    static func getFoodMainPage(success: @escaping (FoodMainPageModel) -> (), failure: @escaping (Error) -> ()) {
        SolaSessionManager.solaSession(type: .get, url: "/food/home", token: nil, parameters: nil, success: { dic in
            if let data = try? JSONSerialization.data(withJSONObject: dic, options: JSONSerialization.WritingOptions.init(rawValue: 0)), let pageModel = try? FoodMainPageModel(data: data) {
                success(pageModel)
            }
        }, failure: { err in
            failure(err)
        })
        
        
        
    }
    
    
    
}
