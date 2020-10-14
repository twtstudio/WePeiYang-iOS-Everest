//
//  WPYStorage.swift
//  WePeiYang
//
//  Created by Shawnee on 2020/10/4.
//  Copyright © 2020 twtstudio. All rights reserved.
//

import Foundation

struct WPYStorage {
     static let defaults = UserDefaults(suiteName: "group.com.twtstudio.PeiYang-Lite")!
//     static let courseTable = Store<CourseTable>("courseTable")
//     static let gpa = Store<GPA>("gpa")
//     static let ecard = Store<ECard>("ecard")
}

protocol Storable {
     init()
}

class Store<T: Codable & Storable> {
     var object: T
     
     private let key: String
     
     init(_ key: String) {
          self.object = T()
          self.key = key
          
          load()
     }
     
     func load() {
          guard let data = WPYStorage.defaults.data(forKey: key) else {
               return
          }
          
          guard let object = try? JSONDecoder().decode(T.self, from: data) else {
               return
          }
          
          self.object = object
     }
     
     func save() {
          guard let data = try? JSONEncoder().encode(object) else {
               return
          }
          
          WPYStorage.defaults.setValue(data, forKey: key)
     }
     
     func remove() {
          WPYStorage.defaults.removeObject(forKey: key)
          self.object = T()
     }
}
