 //
//  ClientItem.swift
//  WePeiYang
//
//  Created by Halcao on 2017/2/22.
//  Copyright © 2017年 Halcao. All rights reserved.
//

import Foundation

class ClientItem1: NSObject, NSCoding {
    var name: String
    var phone: String
    var isFavorite = false
    var owner: String
    
    init(name: String, phone: String, owner: String) {
        self.name = name
        self.phone = phone
        self.owner = owner
    }
    
    required init?(coder aDecoder: NSCoder) {
        name = aDecoder.decodeObject(forKey: "yp_name") as! String
        phone = aDecoder.decodeObject(forKey: "yp_phone") as! String
//        isFavorite = aDecoder.decodeObject(forKey: "yp_isFavorite") as! Bool
        isFavorite = aDecoder.decodeBool(forKey: "yp_isFavorite")
        owner = aDecoder.decodeObject(forKey: "yp_owner") as! String
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(name, forKey: "yp_name")
        aCoder.encode(phone, forKey: "yp_phone")
        aCoder.encode(isFavorite, forKey: "yp_isFavorite")
        aCoder.encode(owner, forKey: "yp_owner")
    }

}

struct ClientItem: Codable {
    var name: String
    var phone: String
    var isFavorite = false
    var owner: String
}
