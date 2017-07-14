//
//  GPASessionManager.swift
//  WePeiYang
//
//  Created by Halcao on 2017/7/14.
//  Copyright © 2017年 twtstudio. All rights reserved.
//

import ObjectMapper

struct GPASessionManager {
    static func getGPA(success: @escaping ([GPATermModel])->(), failure: (Error)->()) {
        SolaSessionManager.solaSession(withType: .get, url: "/gpa", success: { dic in
            if let data = dic["data"] as? [String : Any], let termsData = data["data"] as? [[String : Any]] {
                // stat of a year is used
                var terms = [GPATermModel]()
                for term in termsData {
                    if let classData = term["data"] as? [[String : Any]], let statData = term["stat"] as? [String : Any] {
                        let classes = Mapper<GPAClassModel>().mapArray(JSONArray: classData)
                        let name = term["name"] as? String ?? ""
                        let termName = term["term"] as? String ?? ""
                        let stat = GPAStatModel(JSON: statData)
                        let termModel = GPATermModel(term: termName, classes: classes, name: name, stat: stat!)
                        terms.append(termModel)
                    }
                }
                success(terms)
            }
        }, failure: { err in
            
        })
    }
}
