//
//  LostFoundAPI.swift
//  WePeiYang
//
//  Created by Hado on 2017/7/6.
//  Copyright © 2017年 twtstudio. All rights reserved.
//

import Foundation
import Alamofire

class GetLostAPI{
    
//    static func fabu(markdic: [String: String] , success: @escaping ([String: AnyObject]) -> ()) {

//       SolaSessionManager.solaSession(type: .post , url: "/lostfound/lost", token: AccountManager.token, parameters: markdic, success: success, failure: nil)
//
//        if let array = dic 
//
//    }
//
//    
//} 
   static func getLost(success: @escaping ([LostFoundModel])->(), failure: (Error)->()) {
    SolaSessionManager.solaSession(url: "/lostfound/lost",success: {
        dic in
        if let lostData = dic["data"] as? [[String : Any]]
        {
            var losts = [LostFoundModel]()
            for lost in lostData {
                
                let detail_type = lost["detail_type"] as? Int ?? 0
                let time = lost["time"] as? String ?? ""
                let title = lost["title"] as? String ?? ""
                let picture = lost["picture"] as? String ?? ""
                let place = lost["place"] as? String ?? ""
                let id = lost["id"] as? Int ?? 0
                let isback = lost["isback"] as? Int ?? 0
                let name = lost["name"] as? String ?? ""
                let phone = lost["phone"] as? String ?? ""
                

            let lostModel = LostFoundModel(id: id, title: title, detail_type: detail_type, time: time, picture: picture, place: place, phone: phone, isback: isback, name: name)
            losts.append(lostModel)
                
                }
            success(losts)
            }

        } ,failure: { err in
    
        })
    }
}



class GetFoundAPI {
    
    static func getFound(success: @escaping ([LostFoundModel])->(), failure: (Error)->()) {
        SolaSessionManager.solaSession(url: "/lostfound/found",success: {
            dic in
            if let foundData = dic["data"] as? [[String : Any]]
            {
                var founds = [LostFoundModel]()
                for found in foundData {
                    
                    let detail_type = found["detail_type"] as? Int ?? 0
                    let time = found["time"] as? String ?? ""
                    let title = found["title"] as? String ?? ""
                    let picture = found["picture"] as? String ?? ""
                    let place = found["place"] as? String ?? ""
                    let id = found["id"] as? Int ?? 0
                    let isback = found["isback"] as? Int ?? 0
                    let name = found["name"] as? String ?? ""
                    let phone = found["phone"] as? String ?? ""
                    
                    
                    let foundModel = LostFoundModel(id: id, title: title, detail_type: detail_type, time: time, picture: picture, place: place, phone: phone, isback: isback, name: name)
                    founds.append(foundModel)
                    
                }
                success(founds)
            }
            
        } ,failure: { err in
            print(err)
        })
    }

}

class GetMyLostAPI {

    static func getMyLostAPI(success: @escaping ([MyLostFoundModel])->(), failure: (Error)->()) {
        
        SolaSessionManager.solaSession(url: "/lostfound/user/lost", success: { dic in
            if let myLostData = dic["data"] as? [[String : Any]]
            {
                var myLosts = [MyLostFoundModel]()
                for lost in myLostData {
                    
                    let detail_type = lost["detail_type"] as? Int ?? 0
                    let time = lost["time"] as? String ?? ""
                    let title = lost["title"] as? String ?? ""
                    let picture = lost["picture"] as? String ?? ""
                    let place = lost["place"] as? String ?? ""
                    let id = lost["id"] as? Int ?? 0
                    let isback = lost["isback"] as? Int ?? 0
                    let name = lost["name"] as? String ?? ""
                    let phone = lost["phone"] as? String ?? ""
                    
                    
                    let myLostModel = MyLostFoundModel(isBack: isback, title: title, detail_type: detail_type, time: time, place: place, picture: picture, id: id, name: name, phone: phone)
                    myLosts.append(myLostModel)
                }
                success(myLosts)
            }
        
        }, failure: { err in
            print(err)
        
        })
    }
}


class PostLostAPI {

    static func postLost(markDic: [String : String] , success: @escaping (Dictionary<String, AnyObject>)->(),failure: (Error)->()) {
    SolaSessionManager.solaSession(type: .post, url: "/lostfound/lost", parameters: markDic, success: success, failure: { err in
    print(err)
    
    
    })
    
    }

}
