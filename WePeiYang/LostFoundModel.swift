//
//  File.swift
//  WePeiYang
//
//  Created by Hado on 2017/7/3.
//  Copyright © 2017年 twtstudio. All rights reserved.
//

import UIKit

class LostFoundModel {
    
    var mark = ""
    var time = ""
    var picture = ""
    var place = ""
    var title = ""
    
    init(title: String, mark: String, time: String, picture: String, place: String) {
        
        self.title = title
        self.mark = mark
        self.time = time
        self.picture = picture
        self.place = place
    }
    
}
