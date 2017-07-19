

//
//  GPATermModel.swift
//  WePeiYang
//
//  Created by Halcao on 2017/7/14.
//  Copyright © 2017年 twtstudio. All rights reserved.
//

struct GPATermModel {
    var term: String = ""
    var classes: [GPAClassModel] = []
    var name: String = ""
    var stat: GPAStatModel!
    init(term: String, classes: [GPAClassModel], name: String, stat: GPAStatModel) {
        self.term = term
        self.classes = classes
        self.name = name
        self.stat = stat
    }
}
