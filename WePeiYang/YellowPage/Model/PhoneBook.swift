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
    var favorite: [ClientItem] = []
    //var phonebook: [String: [String: [ClientItem]]] = [:]
    var sections: [String] = []
    var members: [String: [String]] = [:]
    var items: [ClientItem] = []

    // given a name, return its phone number
    func getPhoneNumber(with string: String) -> String? {
        for item in items {
            if item.name.contains(string) {
                return item.phone
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

    func addFavorite(with model: ClientItem, success: () -> Void) {
        for m in favorite {
            if m.phone == model.phone && m.name == model.name {
                return
            }
        }
        var m = model
        m.isFavorite = true
        favorite.append(m)
        success()
    }

    func removeFavorite(with model: ClientItem, success: () -> Void) {
        for (index, m) in favorite.enumerated() {
            if m.phone == model.phone && m.name == model.name {
                favorite.remove(at: index)
            }
        }
        success()
    }

    // get models with member name
    func getModels(with member: String) -> [ClientItem] {
        return items.filter { item in
            return item.owner == member
        }
    }

    // seach result
    func getResult(with string: String) -> [ClientItem] {
        return items.filter { item in
            return item.name.contains(string)
        }
    }

    static func checkVersion(success: @escaping () -> Void, failure: @escaping () -> Void) {
        SolaSessionManager.solaSession(url: PhoneBook.url, success: { dict in
            // FIXME: should be optimized
            if let categories = dict["category_list"] as? [[String: Any]] {
                var newItems = [ClientItem]()
                for category in categories {
                    guard let category_name = category["category_name"] as? String else {
                        continue
                    }
                    PhoneBook.shared.sections.append(category_name)
                    guard let departments = category["department_list"] as? [[String: Any]] else {
                        continue
                    }
                    for department in departments {
                        guard let department_name = department["department_name"] as? String else {
                            continue
                        }
                        if PhoneBook.shared.members[category_name] != nil {
                            PhoneBook.shared.members[category_name]?.append(department_name)
                        } else {
                            PhoneBook.shared.members[category_name] = [department_name]
                        }
                        guard let items = department["unit_list"] as? [AnyObject] else {
                            continue
                        }

                        for item in items {
                            guard let item_name = item["item_name"] as? String,
                                let item_phone = item["item_phone"] as? String else {
                                    continue
                            }
                            newItems.append(ClientItem(name: item_name, phone: item_phone, isFavorite: false, owner: department_name))
                        }
                    }
                }
                PhoneBook.shared.items = newItems
                PhoneBook.shared.save()
                success()
            } else {
                failure()
            }
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
        }
    }

    //读取数据
    func load(success: @escaping () -> Void, failure: @escaping () -> Void) {
        DispatchQueue.global().sync {
            if let items = Storage.retreive("yellowpage/items.json", from: .documents, as: [ClientItem].self),
                let members = Storage.retreive("yellowpage/members.json", from: .documents, as: [String: [String]].self),
                let sections = Storage.retreive("yellowpage/sections.json", from: .documents, as: [String].self),
                let favorite = Storage.retreive("yellowpage/favorite.json", from: .documents, as: [ClientItem].self) {
                PhoneBook.shared.items = items
                PhoneBook.shared.members = members
                PhoneBook.shared.sections = sections
                PhoneBook.shared.favorite = favorite
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
