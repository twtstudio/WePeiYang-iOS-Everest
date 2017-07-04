//
//  MyLostFoundModel.swift
//  WePeiYang
//
//  Created by Hado on 2017/7/4.
//  Copyright © 2017年 twtstudio. All rights reserved.
//

import UIKit

class MyLoatFoundModel{

    var isBack = ""
    var title = ""
    var mark = ""
    var time = ""
    var place = ""
    var picture = ""
    
    init(isBack: String,title: String, mark: String, time: String, place: String, picture: String) {
        
        self.isBack = isBack
        self.title = title
        self.mark = mark
        self.time = time
        self.place = place
        self.picture = picture
    }
}
