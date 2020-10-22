//
//  GPAModel.swift
//  WePeiYang
//
//  Created by Halcao on 2017/11/26.
//  Copyright © 2017年 twtstudio. All rights reserved.
//

import UIKit
import ObjectMapper

struct GPAModel: Mappable {
     var terms: [GPATermModel] = []
     var stat: GPAStatModel!
     var session: String = ""
     
     init(terms: [GPATermModel], stat: GPAStatModel, session: String) {
          self.terms = terms
          self.stat = stat
          self.session = session
     }
     
     init?(map: Map) {}
     
     mutating func mapping(map: Map) {
          terms <- map["data"]
          stat <- map["stat.total"]
          session <- map["session"]
     }
}

struct GPATermModel: Mappable {
     var term: String = ""
     var classes: [GPAClassModel] = []
     var name: String = ""
     var stat: GPAStatModel!
     
     init(term: String, classes: [GPAClassModel], name: String, stat: GPAStatModel) {
          self.term = term
          self.classes = classes
          self.name = name
          self.stat = stat
     }
     
     init?(map: Map) {}
     mutating func mapping(map: Map) {
          term <- map["term"]
          classes <- map["data"]
          name <- map["name"]
          stat <- map["stat"]
     }
}

struct GPAClassModel: Mappable {
     var no: Int = 0
     var name: String = ""
     var type: Int = 0
     var credit: Double = 0
     var score: Double = 0
     var gpa: Double = 0
     var reset: Int = 0
     var lessonID: String = ""
     var unionID: String = ""
     var courseID: String = ""
     var term: String = ""
     
     
     init(no: Int, name: String, type: Int, credit: Double, score: Double, gpa: Double, reset: Int, lessonID: String, unionID: String, courseID: String, term: String) {
          self.no = no
          self.name = name
          self.type = type
          self.credit = credit
          self.score = score
          self.gpa = gpa
          self.reset = reset
          self.lessonID = lessonID
          self.unionID = unionID
          self.courseID = courseID
          self.term = term
     }
     
     init?(map: Map) {}
     
     mutating func mapping(map: Map) {
          no <- map["no"]
          name <- map["name"]
          type <- map["type"]
          score <- map["score"]
          reset <- map["reset"]
          credit <- map["credit"]
          
          lessonID <- map["evaluate.lesson_id"]
          unionID <- map["evaluate.union_id"]
          courseID <- map["evaluate.course_id"]
          term <- map["evaluate.term"]
     }
}

struct GPAStatModel: Mappable {
     var year: String =  "" // optional
     var score: Double = 0
     var gpa: Double = 0
     var credit: Double = 0
     
     init(year: String, score: Double, gpa: Double, credit: Double) {
          self.year = year
          self.score = score
          self.gpa = gpa
          self.credit = credit
     }
     
     init?(map: Map) {}
     
     mutating func mapping(map: Map) {
          let transform = TransformOf<Double, String>(fromJSON: { value in
               if let value = value, let num = Double(value) {
                    return num
               } else {
                    return nil
               }
          }, toJSON: { value in
               if let value = value {
                    return "\(value)"
               } else {
                    return nil
               }
          })
          if map["score"].currentValue is String {
               score <- (map["score"], transform)
          } else {
               score <- map["score"]
          }
          
          if map["credit"].currentValue is String {
               credit <- (map["credit"], transform)
          } else {
               credit <- map["credit"]
          }
          
          if map["gpa"].currentValue is String {
               gpa <- (map["gpa"], transform)
          } else {
               gpa <- map["gpa"]
          }
          
          //        credit <- map["credit"]
          //        gpa <- map["gpa"]
          year <- map["year"]
     }
}

