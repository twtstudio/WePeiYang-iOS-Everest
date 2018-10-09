//
//  ParkingSpots.swift
//  WePeiYang
//
//  Created by Tigris on 20/08/2017.
//  Copyright © 2017 twtstudio. All rights reserved.
//

import MapKit
//import SwiftyJSON
import Alamofire

class ParkingSpot: NSObject, MKAnnotation {
    let id: Int
    let title: String?
    let coordinate: CLLocationCoordinate2D
    var numberOfBikes: Int
    var currentNumberOfBikes: Int?
    var status: Status?

    enum Status: String {
        case online = "该点运行良好"
        case offline = "该停车位已掉线，数据可能不是最新"
        case dunno = "该点运行状态未知"
    }

    static var parkingSpots: [ParkingSpot]? {

        var foo: [ParkingSpot]? = []

        guard let jsonPath = Bundle.main.path(forResource: "ParkingSpotsLocs", ofType: "json") else {
            //Do fetch JSON file from the server
            return nil
        }

        guard let jsonData = NSData(contentsOfFile: jsonPath) else {
            return nil
        }

        guard let jsonObj = (try? JSONSerialization.jsonObject(with: jsonData as Data, options: .mutableContainers))! as? NSDictionary else {
            return nil
        }

        guard let arr = jsonObj["data"] as? [NSDictionary] else {
            return nil
        }

//        // MARK: 此 flatMap 方法有问题
//         return arr.flatMap({ (dict: NSDictionary) -> ParkingSpots? in
//         //let id = dict["id"] as? String,
//         guard let title = dict["name"] as? String
//         let campus = dict["campus"] as? Int,
//         let latitude_c = dict["lat_c"] as? Double,
//         let longtitude_c = dict["lng_c"] as? Double
//         else {
//         return nil
//         }
//         let coordinate = CLLocationCoordinate2D(latitude: latitude_c, longitude: longtitude_c)
//         return ParkingSpots(title: title, coordinate: coordinate, numberOfBikes: 0)
//         })*/

        for dict in arr {
            guard let id = dict["id"] as? Int,
                let title = dict["name"] as? String,
                // FIXME: 这是个啥玩意儿
//                let campus = dict["campus"] as? Int,
                let latitude_c = dict["lat_c"] as? Double,
                let longitude_c = dict["lng_c"] as? Double
                else {
                    return nil
            }
            let coordinate = CLLocationCoordinate2D(latitude: latitude_c, longitude: longitude_c)
            let newSpot = ParkingSpot(id: id, title: title, coordinate: coordinate, numberOfBikes: 0)
            foo?.append(newSpot)
        }
        return foo
    }

    init(id: Int, title: String?, coordinate: CLLocationCoordinate2D, numberOfBikes: Int) {
        self.id = id
        self.title = title!
        self.coordinate = coordinate
        self.numberOfBikes = numberOfBikes
    }

}

//Calculate Distance
extension ParkingSpot {

    func calculateDistance(userLocation: MKUserLocation) -> CLLocationDistance {

        let spotLoc = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
        let userLoc = CLLocation(latitude: userLocation.coordinate.latitude, longitude: userLocation.coordinate.longitude)
        return spotLoc.distance(from: userLoc)

    }
}

//网络请求获得实时状况
extension ParkingSpot {

    //单个点获得状态，用于点击后获取
    func getCurrentStatus(and completion: @escaping () -> Void) {

        //        let manager = Alamofire.SessionManager()

        let parameters = ["station": String(id)]

        SolaSessionManager.solaSession(type: .get, baseURL: BicycleAPIs.rootURL, url: BicycleAPIs.statusURL, token: nil, parameters: parameters, success: { dic in

            guard dic["errno"] as? Int == 0 else {
                guard let msg = dic["errmsg"] as? String else {
                    SwiftMessages.showErrorMessage(body: "解析错误")
                    return
                }
                SwiftMessages.showErrorMessage(body: msg)
                return
            }

            guard let fooStatus = dic["data"] as? [NSDictionary] else {
                SwiftMessages.showErrorMessage(body: "解析错误")
                return
            }

            guard fooStatus.count == 1 else {
                SwiftMessages.showErrorMessage(body: "状态获取失败")
                return
            }

            guard let foo = fooStatus[0]["status"] as? String else {
                self.status = Status.dunno
                return
            }

            if foo == "0" {
                self.status = Status.offline
            } else {
                self.status = Status.online
            }

            guard let numberOfBikes = fooStatus[0]["total"] as? String,
                let currentNumberOfBikes = fooStatus[0]["used"] as? String
                else {
                    SwiftMessages.showErrorMessage(body: "获取状态失败")
                    return
            }

            self.numberOfBikes = Int(numberOfBikes)!
            self.currentNumberOfBikes = Int(currentNumberOfBikes)
            completion()
        }, failure: { err in
            SwiftMessages.showErrorMessage(body: err.localizedDescription)
        })
    }

    //用于对一个 [ParkingSpot] 获取状态，智能对一定区域内点预加载 (放进 userdefaults)
    static func getCurrentStatusForList(list: [ParkingSpot], and completion: @escaping () -> Void) {

        var parameters: [String: String] {
            var foo = ""
            for spot in list {
                foo += "\(spot.id), "
            }
            return ["station": foo.removeCharsFromEnd(count: 2)]
        }

        SolaSessionManager.solaSession(type: .get, baseURL: BicycleAPIs.rootURL, url: BicycleAPIs.statusURL, parameters: parameters, success: { dic in

            guard dic["errno"] as! Int == 0 else {
                guard let msg = dic["ermsg"] as? String else {
                    SwiftMessages.showErrorMessage(body: "解析错误")
                    return
                }
                SwiftMessages.showErrorMessage(body: msg)
                return
            }

            guard let fooStatus = dic["data"] as? [NSDictionary] else {
                SwiftMessages.showErrorMessage(body: "解析错误")
                return
            }

            for i in 0..<list.count {
                guard let numberOfBikes = fooStatus[i]["total"] as? String,
                    let currentNumberOfBikes = fooStatus[i]["used"] as? String
                    else {
                        SwiftMessages.showErrorMessage(body: "数据解析错误")
                        return
                }
                list[i].numberOfBikes = Int(numberOfBikes)!
                list[i].currentNumberOfBikes = Int(currentNumberOfBikes)
            }

            completion()

        }, failure: { error in
            SwiftMessages.showErrorMessage(body: error.localizedDescription)
        })
    }
}

fileprivate extension String {

    func removeCharsFromEnd(count: Int) -> String {
        let stringLength = self.count
        let substringCount = (stringLength < count) ? 0 : stringLength - count
        let index: String.Index = self.index(self.startIndex, offsetBy: substringCount)
        return String(self[...index])
    }
}
