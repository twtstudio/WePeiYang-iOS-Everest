//
//  PhoneBook.swift
//  WePeiYang
//
//  Created by Halcao on 2017/4/8.
//  Copyright © 2017年 twtstudio. All rights reserved.
//

import UIKit

class PhoneBook {
    static let shared = PhoneBook()
    private init() {}
    
    static let url = "/yellowpage/data3"
    var favorite: [UnitItem] = []
    //var phonebook: [String: [String: [UnitItem]]] = [:]
    var sections: [String] = []
    var members: [String: [String]] = [:]
    var items: [UnitItem] = []
    var departments: [String: Int] = [:]
    
    // given a name, return its phone number
    func getPhoneNumber(with string: String) -> String? {
        for item in items {
            if item.itemName.contains(string) {
                return item.itemPhone
            }
        }
        return nil
    }
    
    // get members with section
    func getMembers(with section: String) -> [String] {
        guard let array = members[section] else {
            return []
        }
        return array
        
    }
    
    func addFavorite(with model: UnitItem, success: () -> Void) {
        for m in favorite {
            if m.itemPhone == model.itemPhone && m.itemName == model.itemName {
                return
            }
        }
        var m = model
        m.isFavorite = true
        favorite.append(m)
        success()
    }
    
    func removeFavorite(with model: UnitItem, success: () -> Void) {
        for (index, m) in favorite.enumerated() {
            if m.itemPhone == model.itemPhone && m.itemName == model.itemName {
                favorite.remove(at: index)
            }
        }
        success()
    }
    
    // get models with member name
    func getModels(with member: String) -> [UnitItem] {
        return items.filter { item in
            let departID = departments[member]
            return item.itemAttach == departID
        }
    }
    
    // seach result
    func getResult(with string: String) -> [UnitItem] {
        return items.filter { item in
            return item.itemName.contains(string)
        }
    }
    
    static func checkVersion(success: @escaping () -> Void, failure: @escaping () -> Void) {
     SolaSessionManager.solaSession(url: PhoneBook.url, token: TwTUser.shared.token, success: { dict in
            let data = try? JSONSerialization.data(withJSONObject: dict, options: [])
            
            if let welcome = try? JSONDecoder().decode(Welcome.self, from: data!) {
                var newItems = [UnitItem]()
                for category in welcome.categoryList {
                    let category_name = category.categoryName
                    PhoneBook.shared.sections.append(category_name)
                    for department in category.departmentList {
                        PhoneBook.shared.departments[department.departmentName] = department.id
                        if PhoneBook.shared.members[category_name] != nil {
                            PhoneBook.shared.members[category_name]!.append(department.departmentName)
                        } else {
                            PhoneBook.shared.members[category_name] = [department.departmentName]
                        }
                        let items = department.unitList
                        for item in items {
                            newItems.append(item)
                        }
                        
                    }
                }
                PhoneBook.shared.items = newItems
                PhoneBook.shared.save()
                success()
            } else {
                failure()
            }
            
            // FIXME: should be optimized
            //            if let categories = dict["category_list"] as? [[String: Any]] {
            //                var newItems = [UnitList]()
            //                for category in categories {
            //                    let category_name = category["category_name"] as! String
            //                    PhoneBook.shared.sections.append(category_name)
            //                    if let departments = category["department_list"] as? [[String: Any]] {
            //                        for department in departments {
            //                            let department_name = department["department_name"] as! String
            //                            if PhoneBook.shared.members[category_name] != nil {
            //                                PhoneBook.shared.members[category_name]!.append(department_name)
            //                            } else {
            //                                PhoneBook.shared.members[category_name] = [department_name]
            //                            }
            //                            if let items = department["unit_list"] as? [AnyObject] {
            //                                for item in items {
            //                                    if let item_name = item["item_name"] as? String,
            //                                        let item_phone = item["item_phone"] as? String {
            //                                        newItems.append(UnitList(name: item_name, itemPhone: item_phone, isFavorite: false, owner: department_name))
            //                                    }
            //                                }
            //                            }
            //                        }
            //                    }
            //                }
            //                PhoneBook.shared.items = newItems
            //                PhoneBook.shared.save()
            //                success()
            //            } else {
            //                failure()
            //            }
        })
    }
}

extension PhoneBook {
    func save() {
        let queue = DispatchQueue.global()
        queue.async {
            Storage.store(PhoneBook.shared.items, in: .documents, as: "yellowpage/items.json")
            Storage.store(PhoneBook.shared.members, in: .documents, as: "yellowpage/members.json")
            Storage.store(PhoneBook.shared.sections, in: .documents, as: "yellowpage/sections.json")
            Storage.store(PhoneBook.shared.favorite, in: .documents, as: "yellowpage/favorite.json")
            Storage.store(PhoneBook.shared.departments, in: .documents, as: "yellowpage/departments.json")
        }
    }
    
    //读取数据
    func load(success: @escaping () -> Void, failure: @escaping () -> Void) {
        DispatchQueue.global().sync {
            if let items = Storage.retreive("yellowpage/items.json", from: .documents, as: [UnitItem].self),
                let members = Storage.retreive("yellowpage/members.json", from: .documents, as: [String: [String]].self),
                let sections = Storage.retreive("yellowpage/sections.json", from: .documents, as: [String].self),
                let favorite = Storage.retreive("yellowpage/favorite.json", from: .documents, as: [UnitItem].self),
                let departments = Storage.retreive("yellowpage/departments.json", from: .documents, as: [String: Int].self) {
               if items.isEmpty {
                    failure()
                    return
               }
                PhoneBook.shared.items = items
                PhoneBook.shared.members = members
                PhoneBook.shared.sections = sections
                PhoneBook.shared.favorite = favorite
                PhoneBook.shared.departments = departments
                DispatchQueue.main.async {
                    success()
                }
            } else {
                DispatchQueue.main.async {
                    failure()
                }
            }
        }
    }
}

extension KeyedDecodingContainer {
    fileprivate func decodeIfPresent(_ type: String.Type, forKey key: K) throws -> String? {
        if let str = try? decode(type, forKey: key) {
            return str
        } else if let int = try? decode(Int.self, forKey: key) {
            return "\(int)"
        } else {
            return nil
        }
    }
}
