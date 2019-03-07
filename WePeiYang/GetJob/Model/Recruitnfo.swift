//
//  RecruitmentInfo.swift
//  WePeiYang
//
//  Created by 王春杉 on 2019/2/19.
//  Copyright © 2019 twtstudio. All rights reserved.
//

import Foundation
import SwiftyJSON

struct didSelectCell {
    static var id: String = ""
}

struct RecruitInfo {
    var type: String
    static var pageCountOfType0: Int = 0
    static var pageCountOfType1: Int = 0
    var page: Int
    var imporant: [Imporant]
    var common: [Common]
    var rotation: [Rotation]
    init() {
        self.type = ""
        self.page = 0
        self.imporant = [Imporant]()
        self.common = [Common]()
        self.rotation = [Rotation]()
    }
}

struct Imporant {
    var id: String
    var title: String
    var date: String
    var click: String
    var heldDate: String
    var heldTime: String
    var place: String
    
    init() {
        self.id = ""
        self.title = ""
        self.date = ""
        self.click = ""
        self.heldDate = ""
        self.heldTime = ""
        self.place = ""
    }
}

struct Common {
    var id: String
    var title: String
    var date: String
    var click: String
    var heldDate: String
    var heldTime: String
    var place: String
    
    init() {
        self.id = ""
        self.title = ""
        self.date = ""
        self.click = ""
        self.heldDate = ""
        self.heldTime = ""
        self.place = ""
    }
}

struct Rotation {
    var id: String
    var title: String
    var date: String
    var click: String
    
    init() {
        self.id = ""
        self.title = ""
        self.date = ""
        self.click = ""
    }
}
