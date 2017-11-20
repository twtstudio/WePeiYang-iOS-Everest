//
//  GetRepairApi.swift
//  WePeiYang
//
//  Created by 赵家琛 on 2017/9/23.
//  Copyright © 2017年 twtstudio. All rights reserved.
//

import UIKit

struct GetRepairApi {
    
    static func getItemType(type: String, success: @escaping([String]) -> (), failure: (Error) -> ()) {
        SolaSessionManager.solaSession(baseURL: "https://open.twtstudio.com", url: "/api/v1/repairs/order/item?type=\(type)", token: (TwTUser.shared.token)!, parameters: nil, success: { dic in
            var items: [String] = [String]()
            if let articlesFromJson = dic["data"] as? [[String : AnyObject]] {
                
                for articleFromJson in articlesFromJson {
                    if let item = articleFromJson["item"] as? String {
                        items.append(item)
                    }
                }
            }
            success(items)
        }, failure: { error in
            print(error)
        })
    }
    
    
    
    
    static func getApartmenBuilding(success: @escaping([Apartment]) -> (), failure: (Error) -> ()) {
        SolaSessionManager.solaSession(baseURL: "https://open.twtstudio.com", url: "/api/v1/repairs/order/area", token: (TwTUser.shared.token)!, parameters: nil, success: { dic in
            var apartments = [Apartment]()
            
            if let articlesFromJson = dic["data"] as? [[String : AnyObject]] {
                
                for articleFromJson in articlesFromJson {
                    var apartment = Apartment()
                    
                    if
                        let id = articleFromJson["id"] as? String,
                        let area_name = articleFromJson["area_name"] as? String {
                        apartment.id = id
                        apartment.name = area_name
                    }
                    apartments.append(apartment)
                }
            }
            success(apartments)
        }, failure: { error in
            print("sadasd")
        })
    }
    
    static func getApartmenRoom(id: String, success: @escaping([Room]) -> (), failure: (Error) -> ()) {
        SolaSessionManager.solaSession(baseURL: "https://open.twtstudio.com", url: "/api/v1/repairs/order/room?area_id=\(id)", token: (TwTUser.shared.token)!, parameters: nil, success: { dic in
            var rooms = [Room]()
            
            if let articlesFromJson = dic["data"] as? [[String : AnyObject]] {
                for articleFromJson in articlesFromJson {
                    var room = Room()
                    
                    if
                        let type = articleFromJson["type"] as? String,
                        let name = articleFromJson["room"] as? String {
                        room.name = name
                        room.type = type
                    }
                    rooms.append(room)
                }
                
            }
            success(rooms)
        }, failure: { error in
            print(error)
        })
    }
    
    
    
    static func getRepair(success: @escaping([Article]) -> (), failure: (Error) -> ()) {
        
        SolaSessionManager.solaSession(type: .get, baseURL: "https://open.twtstudio.com", url: "/api/v1/repairs/order/show", token: (TwTUser.shared.token)!, parameters: nil, success: { dic in
            
            var articles = [Article]()
            
            if let articlesFromJson = dic["data"] as? [[String : AnyObject]] {
                
                for articleFromJson in articlesFromJson {
                    
                    var article = Article()
                    
                    if
                        let id = articleFromJson["id"] as? String,
                        let detail = articleFromJson["detail"] as? String,
                        let deleted = articleFromJson["deleted"] as? String,
                        let items = articleFromJson["items"] as? String ,
                        let time = articleFromJson["created_at"] as? String,
                        let state = articleFromJson["state"] as? String,
                        let complained = articleFromJson["complained"] as? String,
                        let places = articleFromJson["place"] as? [String : AnyObject]
                    {
                        
                        if
                            let area = places["area"] as? [String : AnyObject],
                            let room = places["room"] as? String {
                            if let area_name = area["area_name"] as? String {
                                if room.characters.count == 3 {
                                    article.locationRepair = area_name + room + "寝室"
                                } else {
                                    article.locationRepair = area_name + room
                                }
                                
                            }
                        }
                        
                        if complained == "1" {
                            article.situationRepair = "已投诉"
                        } else {
                            if state == "1" {
                                article.situationRepair = "已接收"
                            } else if state == "4" {
                                article.situationRepair = "已完成"
                            } else if state == "0" {
                                article.situationRepair = "已上报"
                            } else {
                                article.situationRepair = "已维修"
                            }
                        }
                        
                        article.idRepair = id
                        article.detailRepair = detail
                        article.itemsRepair = items
                        article.submitTimeRepair = time
                        article.state = Int(state)
                        
                        if deleted == "0" {
                            articles.append(article)
                        }
                    }
                    
                }
                success(articles)
            }
        }, failure: { error in
            print("sadasd")
        })
    }
    
    static func getDormitory(state: String, id: String, success: @escaping([String]) -> (), failure: (Error) -> ()) {
        
        
        SolaSessionManager.solaSession(type: .get, baseURL: "https://open.twtstudio.com", url: "/api/v1/repairs/order/detail?order_id=\(id)", token: (TwTUser.shared.token)!, parameters: nil, success: { dic in
            
            var list: [String] = [String]()
            list.append("")
            
            if let articleFromJson = dic["data"] as? [String : AnyObject] {
                
                if let grade = articleFromJson["grade"] as? [String : AnyObject] {
                    if let created_at = grade["created_at"] as? String {
                        list[0].append("已评价，维修已完成\n" + created_at + "\n")
                    }
                }
                if let complain = articleFromJson["complain"] as? [String : AnyObject] {
                    if let created_at = complain["created_at"] as? String {
                        list[0].append("已投诉" + created_at + "\n")
                    }
                }
                if let repaired_at = articleFromJson["repaired_at"] as? String {
                    list[0].append("维修方已确认维修完成（48h内可投诉）\n" + repaired_at + "\n")
                }
                if let reacted_at = articleFromJson["reacted_at"] as? String {
                    list[0].append("维修方已接收报修信息\n" + reacted_at + "\n")
                }
                if let created_at = articleFromJson["created_at"] as? String {
                    print("AllenX")
                    list[0].append("报修信息已提交至维修方，请耐心等候\n" + created_at)
                }
                
                if let id = articleFromJson["id"] as? String {
                    list.append(id)
                }
                
                if let stuff = articleFromJson["stuff"] as? [String : AnyObject] {
                    if
                        let username = stuff["name"] as? String,
                        let phone = stuff["phone"] as? String {
                        list.append(username)
                        list.append(phone)
                    }
                }
                
                if let predicted_at = articleFromJson["predicted_at"] as? String {
                    list.append(predicted_at)
                }
                
            }
            success(list)
        }, failure: { error in
            print(error)
        })
    }
    
}

