//
//  FBConsts.swift
//  WePeiYang
//
//  Created by 于隆祎 on 2020/9/20.
//  Copyright © 2020 twtstudio. All rights reserved.
//

import Foundation

import Foundation
// MARK: - 用户端基础URL
let FB_BASE_USER_URL: String = "https://areas.twt.edu.cn/api/user/"
let FB_USER_ID: Int = TwTUser.shared.feedbackID ?? 0
let FB_NOTIFICATIONFLAG_NEED_RELOAD: String = "FB_NOTIFICATIONFLAG_NEED_RELOAD"
let FB_SHOULD_RELOAD_NEWQUESTIONVC: String = "FB_SHOULD_RELOAD_NEWQUESTIONVC"

extension UIColor {
    static var feedBackBlue: UIColor = UIColor(hex6: 0x3f54af)
}
