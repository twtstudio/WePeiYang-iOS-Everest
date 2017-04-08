
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
class PhoneBook: NSObject {
    static let shared = PhoneBook()
    private override init() {}
    
    static let url = "http://open.twtstudio.com/api/v1/yellowpage/data3"
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
//        if section == "校级部门" {
//            return ["计算机学院团委办公室", "信息学院团委办公室", "软件学院团委办公室"]
//        }
//        return []
        guard let dict = members[section] else {
            return []
        }
        return dict
    }
    
    // get sections
    func getSections() -> [String] {
        return sections
    }
    
    // get favorite
    func getFavorite() -> [ClientItem] {
        let models: [ClientItem] = []
//        
//        models.append(ClientItem(with: "学工部本科生教育科", phone: "27407083", isFavorite: true))
//        models.append(ClientItem(with: "学工部宿舍管理科", phone: "27407032", isFavorite: true))
//        models.append(ClientItem(with: "学工部研究生教育管理科", phone: "27407011", isFavorite: true))
//        models.append(ClientItem(with: "学工部学生档案室", phone: "27407023", isFavorite: true))
        // return favorite
        return models
    }
    
    func addToFavorite(with model: ClientItem, success: ()->()) {
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
    
    func removeFromFavorite(with model: ClientItem, success: ()->()) {
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
    
    func saveToLocal() {
        UserDefaults.standard.set(self.favorite, forKey: "YellowPageFavorite")
    }
    
    func readFromLocal() {
        self.favorite = UserDefaults.standard.object(forKey: "YellowPageFavorite") as! [ClientItem]
    }
    
    static func checkVersion(success:@escaping ()->()) {
        Alamofire.request(PhoneBook.url).responseJSON { response in
            switch response.result {
            case .success:
                // the data sucks!
                if let data = response.result.value  {
                    if let dict = data as? Dictionary<String, Any>,
                        let categories = dict["category_list"] as? Array<Dictionary<String, AnyObject>> {
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
                                        PhoneBook.shared.items.append(ClientItem(name: item_name!, phone: item_phone!, owner: department_name))
                                    }
                                }
                            }
                        }
                    }
                }
            case .failure(let error):
                log.error(error)/
                if let data = response.result.value  {
                    if let dict = data as? Dictionary<String, AnyObject> {
                        log.errorMessage("网络开小差啦...")/
                        log.any(dict)/
                    }
                }
            }
        }
    }
        
}

extension PhoneBook {
    func save() {
        let path = self.dataFilePath()
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
        //编码结束
        archiver.finishEncoding()
        //数据写入
        data.write(toFile: dataFilePath(), atomically: true)
    }
    
    //读取数据
    func load(success: ()->(), failure: ()->()) {
        //获取本地数据文件地址
        let path = self.dataFilePath()
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
            if let array = unarchiver.decodeObject(forKey: YELLOWPAGE_SAVE_KEY) as? Array<ClientItem>,
                let members = unarchiver.decodeObject(forKey: "yp_member_key") as? [String: [String]],
                let sections = unarchiver.decodeObject(forKey: "yp_section_key") as? [String] {
                guard array.count > 0 else {
                    failure()
                    return
                }
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
    func dataFilePath() -> String{
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let documentsDirectory = paths.first!
        return documentsDirectory.appendingFormat("/YellowPage.plist")
    }
}
