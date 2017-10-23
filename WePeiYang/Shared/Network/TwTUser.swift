//
//  TwTUser.swift
//  WePeiYang
//
//  Created by Halcao on 2017/7/14.
//  Copyright © 2017年 twtstudio. All rights reserved.
//

import UIKit

class TwTUser {
    static let shared = TwTUser()
    private init() {}
    var token: String?
    var username: String = ""
    var libraryState: Bool = false
    var schoolID: String = ""
    var tjuBindingState: Bool = false
    
    func save() {
    
    }
    
    func delete() {
    
    }
    
    func load() {
    
    }
}
