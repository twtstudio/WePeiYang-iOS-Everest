//
//  AuditCacheManager.swift
//  WePeiYang
//
//  Created by 赵家琛 on 2018/12/5.
//  Copyright © 2018 twtstudio. All rights reserved.
//

import Foundation

struct AuditCacheManager {

    static func getCourseids(withKey keyNumber: Int) -> [Int] {
        let keyStr = String(keyNumber)
        guard let userDefault = UserDefaults(suiteName: "ClassTableAudit") else {
            return []
        }
        if let originArr = userDefault.array(forKey: keyStr) as? [Int] {
            return originArr
        } else {
            return []
        }
    }

    @discardableResult
    static func saveAudit(withKey keyNumber: Int, ids: [Int]) -> Bool {
        let keyStr = String(keyNumber)
        guard let userDefault = UserDefaults(suiteName: "ClassTableAudit") else {
            return false
        }
        if var originArr = userDefault.array(forKey: keyStr) as? [Int] {
            for i in 0..<ids.count {
                let id = ids[i]
                if !originArr.contains(id) {
                    originArr.append(id)
                }
            }
            userDefault.setValue(originArr, forKey: keyStr)
        } else {
            userDefault.setValue(ids, forKey: keyStr)
        }
        return true
    }

    @discardableResult
    static func deleteAudit(withKey keyNumber: Int, ids: [Int]) -> Bool {
        let keyStr = String(keyNumber)
        guard let userDefault = UserDefaults(suiteName: "ClassTableAudit"), var originArr = userDefault.array(forKey: keyStr) as? [Int] else {
            return false
        }
        originArr = originArr.filter { !ids.contains($0) }
        userDefault.setValue(originArr, forKey: keyStr)
        return true
    }

    static func load(model: AuditPersonalCourseModel) {
        let userDefault = UserDefaults(suiteName: "ClassTableAudit")
        userDefault?.dictionaryRepresentation().keys.forEach { key in
            userDefault?.removeObject(forKey: key)
        }
        model.data.forEach { list in
            let courseID = list.courseID
            userDefault?.removeObject(forKey: String(courseID))
            let ids: [Int] = list.infos.map { item in
                return item.id
            }
            self.saveAudit(withKey: courseID, ids: ids)
        }
    }

}
