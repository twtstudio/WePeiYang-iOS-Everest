//
//  APIHelper.swift
//  WePeiYang
//
//  Created by 安宇 on 2020/3/23.
//  Copyright © 2020 twtstudio. All rights reserved.
//

import Foundation
import Alamofire
import UIKit

struct SelfStudyAPI {
    
    static let base = "https://selfstudy.twt.edu.cn"
    
    static let getBuildingList = "/api/getBuildingList.php"
    
    static let getDayData = "/api/getDayData.php?"
    
    static let getCourseData = "/api/getCourseData.php?"
    
    static let getCollectionList = "/api/getCollectionList.php"
//
    static let addCollection = "/api/addCollection.php"
    
    static let cancelCollection = "/api/deleteCollection.php"
    
    static let getClassroomInfo = "/api/getClassroomWeekInfo.php?classroom_ID=xj202&week=5&term=18191"
    
    static let login = "/api/login.php"
}
struct DetailHelper {
    static func dataManager(url: String, success: (([String: Any])->())? = nil, failure: ((Error)->())? = nil) {
        Alamofire.request(url).responseJSON { response in
            switch response.result {
            case .success:
                if let data = response.result.value  {
                    if let dict = data as? [String: Any] {
                        success?(dict)
                    }
                }
            case .failure(let error):
                failure?(error)
                if let data = response.result.value  {
                    if let dict = data as? [String: Any],
                        let errmsg = dict["message"] as? String {
                        print(errmsg)
                    }
                } else {
                    print(error)
                }
            }
        }
    }
}
//
struct BuildingListHelper {
    static func getBuildingList(success: @escaping (BuildingList)->(), failure: @escaping (Error)->()) {
        var url = ""
        if RoomHelper.fit == 0 {
            url = SelfStudyAPI.base + SelfStudyAPI.getBuildingList
        } else if RoomHelper.fit == 1 {
            url = SelfStudyAPI.base + SelfStudyAPI.getDayData + "term=\(ClassHelper.term)" + "&week=\(ClassHelper.week)" + "&day=\(ClassHelper.day)"
        } else {
            url = SelfStudyAPI.base + SelfStudyAPI.getCourseData + "term=\(ClassHelper.term)" + "&week=\(ClassHelper.week)" + "&day=4" + "&course=\(ClassHelper.courseList[ClassHelper.course])"
            
        }
        DetailHelper.dataManager(url: url, success: { dic in
            if let data = try? JSONSerialization.data(withJSONObject: dic, options: JSONSerialization.WritingOptions.init(rawValue: 0)), let tmp = try? BuildingList(data: data) {
                success(tmp)
            }
        }, failure: { _ in

        })
        
        
        
    }
}

struct AddCollectionHelper {
    static func addCollection(success: @escaping (AddCollectionData)->(), failure: @escaping (Error)->()) {
        SolaSessionManager.solaSession(type: .post, baseURL: SelfStudyAPI.base, url: SelfStudyAPI.addCollection, parameters: ["token": TwTUser.shared.token!, "classroom_ID": ClassroomHelper.classroomId], success: { dict in
            if let data = try? JSONSerialization.data(withJSONObject: dict, options: JSONSerialization.WritingOptions.init(rawValue: 0)), let model = try? AddCollectionData(data: data) {
                success(model)
                SwiftMessages.showSuccessMessage(body: "添加成功")
            } else {
                failure("解析失败" as! Error)
            }
        }, failure: { error in
            failure(error.localizedDescription as! Error)
            
        })
    }
}

struct ClassroomWeekInfoHelper {
    let url = SelfStudyAPI.base + SelfStudyAPI.getCollectionList + "classroom_ID=\(ClassroomHelper.classroomId)&week=\(ClassHelper.week)&term=\(ClassHelper.term)"
    static func getClassroomWeekInfoList(success: @escaping (ClassroomWeekInfo)->(), failure: @escaping (Error)->()) {
        DetailHelper.dataManager(url: SelfStudyAPI.base + "/api/getClassroomWeekInfo.php?classroom_ID=\(ClassroomHelper.classroomId)&week=\(ClassHelper.week)&term=\(ClassHelper.term)", success: { dic in
            if let data = try? JSONSerialization.data(withJSONObject: dic, options: JSONSerialization.WritingOptions.init(rawValue: 0)), let tmp = try? ClassroomWeekInfo(data: data) {
                success(tmp)
            }
        }, failure: { _ in

        })
    }
    
}

struct CancelCollectionHelper {
    static func cancelCollection(success: @escaping (CancelCollectionData)->(), failure: @escaping (Error)->()) {
        SolaSessionManager.solaSession(type: .post, baseURL: SelfStudyAPI.base, url: SelfStudyAPI.cancelCollection, parameters: ["token": TwTUser.shared.token!, "classroom_ID": ClassroomHelper.classroomId], success: { dict in
            if let data = try? JSONSerialization.data(withJSONObject: dict, options: JSONSerialization.WritingOptions.init(rawValue: 0)), let model = try? CancelCollectionData(data: data) {
                success(model)
                SwiftMessages.showSuccessMessage(body: "取消成功")
            } else {
                failure("解析失败" as! Error)
            }
        }, failure: { error in
            failure(error.localizedDescription as! Error)
            
        })
    }
    
}

struct CollectionListHelper {
    static func getCollectionList(success: @escaping ([Collection])->(), failure: @escaping (Error)->()) {
        SolaSessionManager.solaSession(type: .post, baseURL: SelfStudyAPI.base, url: SelfStudyAPI.getCollectionList, parameters: ["token": TwTUser.shared.token!], success: { dict in
            if let listLata = dict["data"] as? [[String: Any]] {
                var data = [Collection]()
                for list in listLata {
                    
                    let classroom_ID = list["classroom_ID"] as? String ?? ""
                    let classroom = list["classroom"] as? String ?? ""
                    let capacity = list["capacity"] as? Int ?? 0
                    let building = list["building"] as? String ?? ""
                    let collection = Collection(classroomID: classroom_ID, classroom: classroom, capacity: capacity, building: building)
                    data.append(collection)
                }
                success(data)
            } else {
                print("mi")
            }
            
        }, failure: { error in
            failure(error.localizedDescription as! Error)
        })
    }
    
}


struct PageHelper {
    static var pageNum = 0
}
struct CampusHelper {
//    起始是卫津路
    static var campusId = "1"
}
struct DateHelper {
    static var year = 0
    static var month = 0
    static var day = 0
}
struct ClassHelper {
    static var term = 20212
    static var week = 0
    static var day = 0
    static var courseList = [Int]()
    static var course = 0
    static var flag = 0
}
struct RoomHelper {
    static var fit = 0
}
struct BOTHelper {
    static let month = 2
    static let day = 17
}
struct ClassroomHelper {
    static var buildingId = ""
    static var classroomId = ""
    static var classroomName = ""
    static var size = ""
}
struct DataHelper {
    static var buildingList: BuildingList!
    static var collectionList: [Collection]!
}
