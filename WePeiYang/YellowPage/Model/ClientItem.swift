//
//  UnitList.swift
//  WePeiYang
//
//  Created by Halcao on 2017/2/22.
//  Copyright © 2017年 Halcao. All rights reserved.
//

import Foundation

struct Welcome: Codable {
    let categoryList: [CategoryList]
    
    enum CodingKeys: String, CodingKey {
        case categoryList = "category_list"
    }
}

struct CategoryList: Codable {
    let categoryName: String
    let departmentList: [DepartmentList]
    
    enum CodingKeys: String, CodingKey {
        case categoryName = "category_name"
        case departmentList = "department_list"
    }
}

struct DepartmentList: Codable {
    let id, departmentAttach: Int
    let departmentName: String
    let unitList: [UnitList]
    
    enum CodingKeys: String, CodingKey {
        case id
        case departmentName = "department_name"
        case departmentAttach = "department_attach"
        case unitList = "unit_list"
    }
}

struct UnitList: Codable {
    let id, itemAttach: Int
    let itemName, itemPhone: String
    var isFavorite = false
    var owner: String = ""
    
    enum CodingKeys: String, CodingKey {
        case id
        case itemName = "item_name"
        case itemPhone = "item_phone"
        case itemAttach = "item_attach"
    }
    
}
