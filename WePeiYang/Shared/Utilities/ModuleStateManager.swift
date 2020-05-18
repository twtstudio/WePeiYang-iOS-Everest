//
//  ModuleStateManager.swift
//  WePeiYang
//
//  Created by Halcao on 2018/12/8.
//  Copyright © 2018 twtstudio. All rights reserved.
//

import Foundation

enum Module: String, CaseIterable {
    case classtable = "课程表"
    case gpa = "GPA"
    case library = "图书馆"
    case ecard = "校园卡"
    case exam = "考表"
    case code = "活动"
}

let ModuleArrangementKey = "ModuleArrangementKey"
struct ModuleStateManager {
    static func getAllModule() -> [Module: Int] {
        var index = 0
        var modules: [Module: Int] = [:]
        Module.allCases.forEach { module in
            index += 1
            modules[module] = index
        }

        if let dict = UserDefaults.standard.dictionary(forKey: ModuleArrangementKey) as? [String: Int] {
            for item in dict {
                let module = Module(rawValue: item.key)!
                modules[module] = item.value
            }
        } else if let dict = UserDefaults.standard.dictionary(forKey: ModuleArrangementKey) as? [String: [String: String]] {
            for item in dict {
                if let module = Module(rawValue: item.key) {
                    let isOn = Bool(item.value["isOn"]!)!
                    let order = Int(item.value["order"]!)! + 1
                    modules[module] = isOn ? order : -order
                }
            }
        }

        return modules
    }

    static func getModules() -> [Module] {
        let modules = getAllModule()
        return Array(modules).filter { item in
            return item.value > 0
            }.sorted { a, b in
                return a.value < b.value
            }.map { item in
                return item.key
        }
    }

    static func setModules(dict: [String: Int]) {
//        var dict: [Module: Int] = [:]
//        var index = 0
//        Module.allCases.forEach { module in
//            index -= 1
//            dict[module] = index
//        }
//
//        for (idx, module) in modules.enumerated() {
//            dict[module] = idx
//        }

        UserDefaults.standard.set(dict, forKey: ModuleArrangementKey)
    }
}
