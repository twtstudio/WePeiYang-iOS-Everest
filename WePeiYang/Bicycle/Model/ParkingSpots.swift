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
            //log.word("fuck1")/
            return nil
        }
        
        guard let jsonData = NSData(contentsOfFile: jsonPath) else {
            //log.word("fuck2")/
            return nil
        }
        
        guard let jsonObj = (try? JSONSerialization.jsonObject(with: jsonData as Data, options: .mutableContainers))! as? NSDictionary else {
            //log.word("fuck3")/
            return nil
        }
        
        guard let arr = jsonObj["data"] as? Array<NSDictionary> else {
            //log.word("fuck4")/
            return nil
        }
        
        /*
         //MARK: 此 flatMap 方法有问题
         return arr.flatMap({ (dict: NSDictionary) -> ParkingSpots? in
         //let id = dict["id"] as? String,
         guard let title = dict["name"] as? String
         let campus = dict["campus"] as? Int,
         let latitude_c = dict["lat_c"] as? Double,
         let longtitude_c = dict["lng_c"] as? Double
         else {
         //log.word("fuck5")/
         return nil
         }
         let coordinate = CLLocationCoordinate2D(latitude: latitude_c, longitude: longtitude_c)
         return ParkingSpots(title: title, coordinate: coordinate, numberOfBikes: 0)
         })*/
        
        for dict in arr {
            guard let id = dict["id"] as? Int,
                let title = dict["name"] as? String,
                let campus = dict["campus"] as? Int,
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
    func getCurrentStatus(and completion: @escaping () -> ()) {
        
        //        let manager = Alamofire.SessionManager()
        
        let parameters = ["station": String(id)]
        
        SolaSessionManager.solaSession(type: .get, baseURL: BicycleAPIs.rootURL, url: BicycleAPIs.statusURL, token: nil, parameters: parameters, success: { dic in
            
            guard dic["errno"] as? Int == 0 else {
                guard let msg = dic["errmsg"] as? String else {
                    // Display err.
                    return
                }
                // Display err.
                return
            }
            
            guard let fooStatus = dic["data"] as? Array<NSDictionary> else {
                // Display err.
                return
            }
            
            guard fooStatus.count == 1 else {
                // Display err.
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
                    // MsgDisplay.showErrorMsg("哎呀，未知错误3")
                    return
            }
            
            self.numberOfBikes = Int(numberOfBikes)!
            self.currentNumberOfBikes = Int(currentNumberOfBikes)
            completion()
        }, failure: { err in
             //MsgDisplay.showErrorMsg("网络不好，请重试")
        })
        
        //        manager.request(BicycleAPIs.statusURL, parameters: parameters, success: { (task: URLSessionDataTask, responseObject: AnyObject?) in
        //            guard responseObject != nil else {
        //                MsgDisplay.showErrorMsg("网络不好，请稍候再试")
        //                return
        //            }
        //
        //            guard responseObject?.objectForKey("errno") as? Int == 0 else {
        //                guard let msg = responseObject?.objectForKey("errmsg") as? String else {
        //                    MsgDisplay.showErrorMsg("哎呀，未知错误")
        //                    return
        //                }
        //                MsgDisplay.showErrorMsg("服务器出错啦，错误信息：" + msg)
        //                return
        //            }
        //
        //            guard let fooStatus = responseObject?.objectForKey("data") as? Array<NSDictionary> else {
        //                MsgDisplay.showErrorMsg("哎呀，未知错误1")
        //                return
        //            }
        //
        //            guard fooStatus.count == 1 else {
        //                MsgDisplay.showErrorMsg("哎呀，未知错误2")
        //                return
        //            }
        //
        //            guard let foo = fooStatus[0]["status"] as? String else {
        //                //self.statusMsg = "该点运行状态未知"
        //                self.status = Status.dunno
        //                return
        //            }
        //
        //            if foo == "0" {
        //                //self.statusMsg = Status.offline.rawValue
        //                self.status = Status.offline
        //            } else {
        //                //self.statusMsg = Status.online.rawValue
        //                self.status = Status.online
        //            }
        //
        //            guard let numberOfBikes = fooStatus[0]["total"] as? String,
        //                let currentNumberOfBikes = fooStatus[0]["used"] as? String
        //                else {
        //                    MsgDisplay.showErrorMsg("哎呀，未知错误3")
        //                    return
        //            }
        //
        //            self.numberOfBikes = Int(numberOfBikes)!
        //            self.currentNumberOfBikes = Int(currentNumberOfBikes)
        //
        //            completion()
        //        }) { (task: URLSessionDataTask?, err: NSError) in
        //            //MsgDisplay.showErrorMsg("网络不好，请重试")
        //        }
    }
    
    //用于对一个 [ParkingSpot] 获取状态，智能对一定区域内点预加载 (放进 userdefaults)
    static func getCurrentStatusForList(list: [ParkingSpot], and completion: @escaping () -> ()) {
        
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
                    // display errmsg
                    return
                }
                // display errmsg
                return
            }
            
            guard let fooStatus = dic["data"] as? Array<NSDictionary> else {
                // display errmsg
                return
            }
            
            for i in 0..<list.count {
                guard let numberOfBikes = fooStatus[i]["total"] as? String,
                    let currentNumberOfBikes = fooStatus[i]["used"] as? String
                    else {
                        //MsgDisplay.showErrorMsg("哎呀，未知错误3")
                        return
                }
                list[i].numberOfBikes = Int(numberOfBikes)!
                list[i].currentNumberOfBikes = Int(currentNumberOfBikes)
            }
            
            completion()
            
        }, failure: nil)
    }
    //        manager.request(BicycleAPIs.statusURL, parameters: parameters, success: { (task: URLSessionDataTask, responseObject: AnyObject?) in
    //
    //            var fooStatusArr: [[String: String]]
    //
    //            guard responseObject != nil else {
    //                MsgDisplay.showErrorMsg("网络不好，请稍候再试")
    //                return
    //            }
    //
    //            guard responseObject?.objectForKey("errno") as? Int == 0 else {
    //                guard let msg = responseObject?.objectForKey("errmsg") as? String else {
    //                    MsgDisplay.showErrorMsg("哎呀，未知错误")
    //                    return
    //                }
    //                MsgDisplay.showErrorMsg("服务器出错啦，错误信息：" + msg)
    //                return
    //            }
    //
    //            guard let fooStatus = responseObject?.objectForKey("data") as? Array<NSDictionary> else {
    //                MsgDisplay.showErrorMsg("哎呀，未知错误")
    //                return
    //            }
    //
    //            for i in 0..<list.count {
    //                guard let numberOfBikes = fooStatus[i]["total"] as? String,
    //                    let currentNumberOfBikes = fooStatus[i]["used"] as? String
    //                    else {
    //                        MsgDisplay.showErrorMsg("哎呀，未知错误3")
    //                        return
    //                }
    //                list[i].numberOfBikes = Int(numberOfBikes)!
    //                list[i].currentNumberOfBikes = Int(currentNumberOfBikes)
    //            }
    //
    //            //以下的 for in 有问题（会导致几个一样）
    //            /*
    //             for spot in list {
    //             for status in fooStatus {
    //             guard let numberOfBikes = status["total"] as? String,
    //             let currentNumberOfBikes = status["used"] as? String
    //             else {
    //             MsgDisplay.showErrorMsg("哎呀，未知错误3")
    //             return
    //             }
    //             spot.numberOfBikes = Int(numberOfBikes)!
    //             spot.currentNumberOfBikes = Int(currentNumberOfBikes)
    //             }
    //             }*/
    //
    //            completion()
    //
    //        }) { (task: URLSessionDataTask?, err:NSError) in
    //        }
    //    }
}


fileprivate extension String {
    
    func removeCharsFromEnd(count:Int) -> String{
        let stringLength = self.characters.count
        let substringCount = (stringLength < count) ? 0 : stringLength - count
        let index: String.Index = self.index(self.startIndex, offsetBy: substringCount)
        return self.substring(to: index)
    }
}

