//
//  CourseList.swift
//  WePeiYang
//
//  Created by 赵家琛 on 2018/11/30.
//  Copyright © 2018 twtstudio. All rights reserved.
//

import Foundation

class CourseList {
     // 1-30 周映射
     var displayCourses: [[Int]]
     var undisplayCourses: [[Int]]
     
     func displayNumber(week: Int) -> Int {
          return self.displayCourses[week].count
     }
     
     func undisplayNumber(week: Int) -> Int {
          return self.undisplayCourses[week].count
     }
     
     init() {
          self.displayCourses = Array(repeating: [], count: 31)
          self.undisplayCourses = Array(repeating: [], count: 31)
     }
     
}
