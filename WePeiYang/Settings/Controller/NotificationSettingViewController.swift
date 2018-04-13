//
//  NotificationSettingViewController.swift
//  WePeiYang
//
//  Created by Halcao on 2018/3/8.
//  Copyright © 2018年 twtstudio. All rights reserved.
//

import UIKit
import UserNotifications

class NotificationSettingViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
//        let textField = UITextField(frame: CGRect(x: 15, y: 40, width: 100, height: 50))

        let datePicker = UIDatePicker(frame: CGRect(x: 15, y: 40, width: 375, height: 300))
        //设置地区: zh-中国
        datePicker.locale = Locale(identifier: "zh")
        datePicker.datePickerMode = .time

        // 设置当前显示时间
        datePicker.setDate(Date(), animated: true)

        //设置时间格式

        //监听DataPicker的滚动
        datePicker.addTarget(self, action: #selector(dateChanges(datePicker:)), for: .valueChanged)

//        设置时间输入框的键盘框样式为时间选择器
//        self.timeTextField.inputView = datePicker;
//        textField.inputView = datePicker
        self.view.addSubview(datePicker)
    }

    @objc func dateChanges(datePicker: UIDatePicker) {
        let notification = UILocalNotification()
        notification.fireDate = datePicker.date
        notification.timeZone = NSTimeZone.default
//        notifity.alertBody=@"这是一个通知";
//        //通知触发时播放的声音
//        notifity.soundName=UILocalNotificationDefaultSoundName;
//        //执行通知注册
//        [[UIApplication sharedApplication] scheduleLocalNotification:notifity];
        notification.alertBody = "上课啦!"
        notification.soundName = UILocalNotificationDefaultSoundName
        UIApplication.shared.cancelAllLocalNotifications()
        UIApplication.shared.scheduleLocalNotification(notification)
    }
}
