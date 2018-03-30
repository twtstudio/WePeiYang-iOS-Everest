
//
//  PhoneBook.swift
//  WePeiYang
//
//  Created by Halcao on 2017/4/8.
//  Copyright © 2017年 twtstudio. All rights reserved.
//

import UIKit
import Alamofire

let YELLOWPAGE_SAVE_KEY = "YellowPageItems"
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
    
    func addFavorite(with model: ClientItem, success: ()->()) {
        for m in favorite {
            if m.phone == model.phone && m.name == model.name {
                return
            }
        }
        let m = model
        // help? right?
        m.isFavorite = true
        favorite.append(m)
        success()
    }
    
    func removeFavorite(with model: ClientItem, success: ()->()) {
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
    
    func saveFavorite() {
        UserDefaults.standard.set(self.favorite, forKey: "YellowPageFavorite")
    }
    
    func loadFavorite() {
        self.favorite = (UserDefaults.standard.object(forKey: "YellowPageFavorite") as? [ClientItem]) ?? []
    }
    
    static func checkVersion(success: @escaping ()->(), failure: @escaping ()->()) {
        SolaSessionManager.solaSession(url: PhoneBook.url, success: { dict in
            if let categories = dict["category_list"] as? Array<Dictionary<String, AnyObject>> {
                var newItems = [ClientItem]()
                for category in categories {
                    let category_name = category["category_name"] as! String
                    PhoneBook.shared.sections.append(category_name)
                    if let departments = category["department_list"] as? Array<Dictionary<String, AnyObject>>{
                        for department in departments {
                            let department_name = department["department_name"] as! String
                            if PhoneBook.shared.members[category_name] != nil {
                                PhoneBook.shared.members[category_name]!.append(department_name)
                            } else {
                                PhoneBook.shared.members[category_name] = [department_name]
                            }
                            let items = department["unit_list"] as! Array<Dictionary<String, String>>
                            for item in items {
                                let item_name = item["item_name"]
                                let item_phone = item["item_phone"]
                                newItems.append(ClientItem(name: item_name!, phone: item_phone!, owner: department_name))
                            }
                        }
                    } else {
                    }
                }
                PhoneBook.shared.items = newItems
                PhoneBook.shared.save()
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
            let path = self.dataFilePath
            //声明文件管理器
            let defaultManager = FileManager()
            if defaultManager.fileExists(atPath: path) {
                try! defaultManager.removeItem(atPath: path)
            }

            let data = NSMutableData()
            //申明一个归档处理对象
            let archiver = NSKeyedArchiver(forWritingWith: data)
            //将lists以对应Checklist关键字进行编码

            archiver.encode(PhoneBook.shared.items, forKey: YELLOWPAGE_SAVE_KEY)
            archiver.encode(PhoneBook.shared.favorite, forKey: "yp_favorite_key")
            archiver.encode(PhoneBook.shared.members, forKey: "yp_member_key")
            archiver.encode(PhoneBook.shared.sections, forKey: "yp_section_key")

            //编码结束
            archiver.finishEncoding()
            //数据写入
            data.write(toFile: self.dataFilePath, atomically: true)
        }
    }
    
    //读取数据
    func load(success: ()->(), failure: ()->()) {
        //获取本地数据文件地址
        let path = self.dataFilePath
        //声明文件管理器
        let defaultManager = FileManager()
        //通过文件地址判断数据文件是否存在
        if defaultManager.fileExists(atPath: path) {
            //读取文件数据
            let url = URL(fileURLWithPath: path)
            let data = try! Data(contentsOf: url)
            //解码器
            let unarchiver = NSKeyedUnarchiver(forReadingWith: data)
            //通过归档时设置的关键字Checklist还原lists
            if let array = unarchiver.decodeObject(forKey: YELLOWPAGE_SAVE_KEY) as? [ClientItem],
                let favorite = unarchiver.decodeObject(forKey: "yp_favorite_key") as? [ClientItem],
                let members = unarchiver.decodeObject(forKey: "yp_member_key") as? [String: [String]],
                let sections = unarchiver.decodeObject(forKey: "yp_section_key") as? [String] {
                guard array.count > 0 else {
                    failure()
                    return
                }
                PhoneBook.shared.favorite = favorite
                PhoneBook.shared.members = members
                PhoneBook.shared.sections = sections
                PhoneBook.shared.items = array
                unarchiver.finishDecoding()
                success()
                return
            }
            //结束解码
            failure()
        }
        failure()
    }
    
    //获取数据文件地址
    var dataFilePath: String {
        get {
            let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
            let documentsDirectory = paths.first!
            return documentsDirectory.appendingFormat("/YellowPage.plist")
        }
    }
}
