//
//  LostFoundAPI.swift
//  WePeiYang
//
//  Created by Hado on 2017/7/6.
//  Copyright © 2017年 twtstudio. All rights reserved.
//

import Foundation
import Alamofire

class GetLostAPI {
    static func getLost(page: Int, success: @escaping ([LostFoundModel]) -> Void, failure: @escaping (Error) -> Void) {
        SolaSessionManager.solaSession(url: "/lostfound/lost?page=\(page)", success: {
            dic in

            if let lostData = dic["data"] as? [[String: Any]] {
                var losts = [LostFoundModel]()
                for lost in lostData {

                    let detail_type = lost["detail_type"] as? String ?? ""
                    let time = lost["time"] as? String ?? ""
                    let title = lost["title"] as? String ?? ""
                    let picture = lost["picture"] as? String ?? ""
                    let place = lost["place"] as? String ?? ""
                    let id = lost["id"] as? Int ?? 0
                    let isback = lost["isback"] as? String ?? ""
                    let name = lost["name"] as? String ?? ""
                    let phone = lost["phone"] as? String ?? ""

                    let lostModel = LostFoundModel(id: id, title: title, detail_type: detail_type, time: time, picture: picture, place: place, phone: phone, isback: isback, name: name)
                    losts.append(lostModel)

                }
                success(losts)
            }

        }, failure: { err in
            // TODO: error
            failure(err)
        })
    }
}

class GetFoundAPI {

    static func getFound(page: Int, success: @escaping ([LostFoundModel]) -> Void, failure: @escaping (Error) -> Void) {
        SolaSessionManager.solaSession(url: "/lostfound/found?page=\(page)", success: {
            dic in
            print(page)
            if let foundData = dic["data"] as? [[String: Any]] {
                var founds = [LostFoundModel]()
                for found in foundData {

                    let detail_type = found["detail_type"] as? String ?? ""
                    let time = found["time"] as? String ?? ""
                    let title = found["title"] as? String ?? ""
                    let picture = found["picture"] as? String ?? ""
                    let place = found["place"] as? String ?? ""
                    let id = found["id"] as? Int ?? 0
                    let isback = found["isback"] as? String ?? ""
                    let name = found["name"] as? String ?? ""
                    let phone = found["phone"] as? String ?? ""

                    let foundModel = LostFoundModel(id: id, title: title, detail_type: detail_type, time: time, picture: picture, place: place, phone: phone, isback: isback, name: name)
                    founds.append(foundModel)

                }
                success(founds)
            }

        }, failure: { err in
            // TODO: error
            failure(err)
        })
    }

}

class GetMyLostAPI {

    static func getMyLost(page: Int, success: @escaping ([MyLostFoundModel]) -> Void, failure: @escaping (Error) -> Void) {

        SolaSessionManager.solaSession(url: "/lostfound/user/lost?page=\(page)", success: { dic in
            if let myLostData = dic["data"] as? [[String: Any]] {
                var myLosts = [MyLostFoundModel]()
                for lost in myLostData {

                    let detail_type = lost["detail_type"] as? Int ?? 0
                    let time = lost["time"] as? String ?? ""
                    let title = lost["title"] as? String ?? ""
                    let picture = lost["picture"] as? String ?? ""
                    let place = lost["place"] as? String ?? ""
                    let id = lost["id"] as? Int ?? 0
                    let isback = lost["isback"] as? String ?? ""
                    let name = lost["name"] as? String ?? ""
                    let phone = lost["phone"] as? String ?? ""

                    let myLostModel = MyLostFoundModel(isBack: isback, title: title, detail_type: detail_type, time: time, place: place, picture: picture, id: id, name: name, phone: phone)
                    myLosts.append(myLostModel)
                }
                success(myLosts)
            }

        }, failure: { err in
            // TODO: error
            failure(err)
        })
    }
}

class GetMyFoundAPI {

    static func getMyFound(page: Int, success: @escaping ([MyLostFoundModel]) -> Void, failure: @escaping (Error) -> Void) {

        SolaSessionManager.solaSession(url: "/lostfound/user/found?page=\(page)", success: { dic in
            if let myFoundData = dic["data"] as? [[String: Any]] {
                var myFounds = [MyLostFoundModel]()
                for found in myFoundData {

                    let detail_type = found["detail_type"] as? Int ?? 0
                    let time = found["time"] as? String ?? ""
                    let title = found["title"] as? String ?? ""
                    let picture = found["picture"] as? String ?? ""
                    let place = found["place"] as? String ?? ""
                    let id = found["id"] as? Int ?? 0
                    let isback = found["isback"] as? String ?? ""
                    let name = found["name"] as? String ?? ""
                    let phone = found["phone"] as? String ?? ""

                    let myFoundModel = MyLostFoundModel(isBack: isback, title: title, detail_type: detail_type, time: time, place: place, picture: picture, id: id, name: name, phone: phone)
                    myFounds.append(myFoundModel)
                }
                success(myFounds)
            }

        }, failure: { err in
            // TODO: error
            failure(err)
        })
    }
}

class DetailAPI {
    //    var id = 0
    var detailDisplay: [Any] = []
    func getDetail(id: String, success: @escaping ([LostFoundDetailModel]) -> Void, failure: @escaping (Error) -> Void) {
        SolaSessionManager.solaSession(url: ("/lostfound/"+"\(id)"), success: {
            dic in
            print(dic)
            if let detailData = dic["data"] as? [String: Any] {

                var details = [LostFoundDetailModel]()
//                for (key, value) in detailData {

                    let detail_type = detailData["detail_type"] as? Int ?? 0
                    let time = detailData["time"] as? String ?? ""
                    let title = detailData["title"] as? String ?? ""
                    let picture =  detailData["picture"] as? String ?? ""
                    let place = detailData["place"] as? String ?? ""
                    let id = detailData["id"] as? Int ?? 0
                    let name = detailData["name"] as? String ?? ""
                    let phone = detailData["phone"] as? String ?? ""
                    let item_description = detailData["item_description"] as? String ?? ""
                    let card_name = detailData["card_name"] as? String ?? ""
                    let card_number = detailData["card_number"] as? Int ?? 0
                    let publish_start = detailData["publish_start"] as? String ?? ""
                    let publish_end = detailData["publish_end"] as? String ?? ""
                    let other_tag = detailData["other_tag"] as? String ?? ""
                    let type = detailData["type"] as? Int ?? 0

                    let lostFoundDetailModel = LostFoundDetailModel(id: id, name: name, title: title, place: place, phone: phone, time: time, picture: picture, item_description: item_description, card_name: card_name, card_number: card_number, publish_start: publish_start, publish_end: publish_end, other_tag: other_tag, type: type, detail_type: detail_type)
                    self.detailDisplay = [time, place, detail_type, name, phone, item_description ]
                    print(self.detailDisplay)
                    details.append(lostFoundDetailModel)
//                }
                success(details)
            }

        }, failure: { err in
            // TODO: error
            failure(err)
        })
    }
}

class GetSearchAPI {

    static func getSearch(inputText: String, page: Int, success: @escaping ([LostFoundModel]) -> Void, failure: @escaping (Error) -> Void) {

        let utf8Text = "/lostfound/search?keyword=\(inputText)&page=\(page)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        print(utf8Text)
        SolaSessionManager.solaSession(type: .get, url: utf8Text, success: { dic in
            print(dic)
            if let error_code = dic["error_code"] as? Int, error_code == 0 {
                if let searchData = dic["data"] as? [[String: Any]] {

                    var searchs = [LostFoundModel]()
                    for search in searchData {

                        let detail_type = search["detail_type"] as? String ?? ""
                        let time = search["time"] as? String ?? ""
                        let title = search["title"] as? String ?? ""
                        let picture = search["picture"] as? String ?? ""
                        let place = search["place"] as? String ?? ""
                        let id = search["id"] as? Int ?? 0
                        let isback = search["isback"] as? String ?? ""
                        let name = search["name"] as? String ?? ""
                        let phone = search["phone"] as? String ?? ""

                        let searchModel = LostFoundModel(id: id, title: title, detail_type: detail_type, time: time, picture: picture, place: place, phone: phone, isback: isback, name: name)
                        searchs.append(searchModel)
                    }
                    success(searchs)
                }
            }
        }, failure: { err in
            // TODO: error
            failure(err)
        })
    }

}

class PostLostAPI {

    static func postLost(markDic: [String: Any], tag: String, success: @escaping ([String: Any]) -> Void, failure: @escaping (Error) -> Void) {
        SolaSessionManager.upload(dictionay: markDic, url: "/lostfound/"+tag, method: .post, progressBlock: nil, failure: { err in
            // TODO: error
            failure(err)
        }, success: success)
    }
}

class GetInverseAPI {

    static func getInverse(id: String, success: @escaping (Int) -> Void, failure: @escaping (Error) -> Void) {
        SolaSessionManager.solaSession(type: .get, url: "/lostfound/inverse/" + "\(id)", success: { dic in
            if let error_code = dic["error_code"] as? Int {
                success(error_code)
            }
        }, failure: { err in
            // TODO: error
            failure(err)
        })
    }
}
