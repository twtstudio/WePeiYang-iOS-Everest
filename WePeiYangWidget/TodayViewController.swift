//
//  TodayViewController.swift
//  WePeiYangWidget
//
//  Created by Halcao on 2018/2/16.
//  Copyright © 2018年 twtstudio. All rights reserved.
//

import UIKit
import NotificationCenter
import ObjectMapper

class TodayViewController: UIViewController, NCWidgetProviding {
    var tableView: UITableView!
    var imgView: UIImageView!
    var hintLabel: UILabel!
    var messageLabel: UILabel!
    var dayLabel: UILabel!
    var isOnline = false
    var displayTomorrowCourse = false

    var classes: [ClassModel] = [] {
        willSet {
            if newValue.count == 0 {
                messageLabel.isHidden = false
            } else {
                messageLabel.isHidden = true
                nextClass = newValue.first(where: { model in
                    let arrange = model.arrange.first!
                    let formatter = DateFormatter()
                    formatter.dateFormat = "HH:mm:ss"
                    let time = formatter.string(from: Date())
                    return time < arrange.startTime
                })
            }
        }
    }

    var nextClass: ClassModel?


    override func viewDidLoad() {
        super.viewDidLoad()

        let width = UIScreen.main.bounds.width
        dayLabel = UILabel(frame: CGRect(x: 90, y: 20, width: width - 90 - 20, height: 20))
        dayLabel.textAlignment = .center
        dayLabel.font = UIFont.preferredFont(forTextStyle: .body)
        self.view.addSubview(dayLabel)

        let tableViewHeight = 50 as CGFloat
        self.preferredContentSize = CGSize(width: width, height: tableViewHeight + 20)

        tableView = UITableView(frame: CGRect(x: 70, y: 55, width: width - 70, height: 50))
        tableView.rowHeight = tableViewHeight
        tableView.allowsSelection = false
        imgView = UIImageView(frame: CGRect(x: 20, y: 20, width: 40, height: 40))
        imgView.image = #imageLiteral(resourceName: "ic_wifi-1")
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(buttonTapped))
        imgView.addGestureRecognizer(gestureRecognizer)
        imgView.isUserInteractionEnabled = true
//        hintLabel.addGestureRecognizer(gestureRecognizer)
//        hintLabel.isUserInteractionEnabled = true

        hintLabel = UILabel(frame: CGRect(x: 20, y: 65, width: 60, height: 15))
        hintLabel.textColor = .gray
        hintLabel.textAlignment = .center
        hintLabel.numberOfLines = 0
        hintLabel.font = UIFont.systemFont(ofSize: 10)

        isOnline = UserDefaults.standard.bool(forKey: "isOnline")
        if isOnline {
            setHint(message: "注销")
        } else {
            setHint(message: "一键上网")
        }

        messageLabel = UILabel(frame: CGRect(x: 70, y: 50, width: width - 70, height: 50))
        if UIScreen.main.bounds.width == 320 {
            messageLabel.font = UIFont.systemFont(ofSize: 14)
        } else {
            messageLabel.font = UIFont.preferredFont(forTextStyle: .body)
        }
        messageLabel.textAlignment = .center
        messageLabel.text = "今天没有课，做点有趣的事情吧！"
        self.view.addSubview(messageLabel)
        messageLabel.isHidden = true

        if DeviceStatus.deviceOSVersion.starts(with: "9") {
            dayLabel.textColor = .white
            messageLabel.textColor = .white
            imgView.image = #imageLiteral(resourceName: "ic_wifi-1").withRenderingMode(.alwaysTemplate)
            imgView.tintColor = .white
            hintLabel.textColor = .white
        } else {
            dayLabel.textColor = .gray
            messageLabel.textColor = .gray
        }

        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none

        self.view.addSubview(tableView)
        self.view.addSubview(imgView)
        self.view.addSubview(hintLabel)
        layout()
    }

    func setHint(message: String) {
        hintLabel.text = message
//        hintLabel.sizeToFit()
        let size = hintLabel.sizeThatFits(CGSize(width: 60, height: CGFloat.infinity))
        hintLabel.frame.size = size
        hintLabel.center.x = imgView.center.x
    }

    @objc func buttonTapped() {
        guard let text = hintLabel.text else {
            return
        }

        switch text {
        case "注销":
            setHint(message: "请稍候")
            WLANHelper.logout(success: {
                self.setHint(message: "一键上网")
                self.hintLabel.tag = 0
                UserDefaults.standard.set(false, forKey: "isOnline")
            }, failure: { msg in
                self.hintLabel.tag = -1
                self.setHint(message: msg)
            })
        case "一键上网":
            setHint(message: "请稍候")
            WLANHelper.login(success: {
                self.setHint(message: "注销")
                self.isOnline = true
                UserDefaults.standard.set(true, forKey: "isOnline")
                self.hintLabel.tag = 0
            }, failure: { msg in
                self.hintLabel.tag = -2
                self.setHint(message: msg)
            })
        case "绑定信息":
//            UIApplication.shared.
            return
        case "请稍候":
            return
        default:
            if hintLabel.tag == -1 {
                setHint(message: "注销")
                buttonTapped()
            } else if hintLabel.tag == -2 {
                setHint(message: "一键上网")
                buttonTapped()
            }
        }
    }

    @available(iOSApplicationExtension 10.0, *)
    func widgetActiveDisplayModeDidChange(_ activeDisplayMode: NCWidgetDisplayMode, withMaximumSize maxSize: CGSize) {
        switch activeDisplayMode {
        case .compact:
            tableView.frame.size.height = tableView.rowHeight + 20
            self.preferredContentSize = CGSize(width: 0, height: tableView.frame.size.height)
        case .expanded:
            if classes.count == 0 {
                tableView.frame.size.height = tableView.rowHeight + 20
                self.preferredContentSize = CGSize(width: 0, height: tableView.frame.size.height)
            } else {
                tableView.frame.size.height = CGFloat(classes.count) * tableView.rowHeight + 40
                self.preferredContentSize = CGSize(width: 0, height: tableView.frame.size.height + 20)
            }
        }
        layout()
    }

    func layout() {
        if #available(iOSApplicationExtension 10.0, *) {
            extensionContext?.widgetLargestAvailableDisplayMode = .expanded
        } else {
            tableView.frame.size.height = max(1, CGFloat(classes.count)) * tableView.rowHeight + 40
            self.preferredContentSize = CGSize(width: 0, height: tableView.frame.size.height + 20)
        }
    }

    func widgetPerformUpdate(completionHandler: (@escaping (NCUpdateResult) -> Void)) {
        if #available(iOSApplicationExtension 10.0, *) {
            extensionContext?.widgetLargestAvailableDisplayMode = .expanded
        }

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        let time = dateFormatter.string(from: Date())
        var offset = 0
        if  time > "21:30" && time < "23:59" {
            displayTomorrowCourse = true
            offset = 1
        } else {
            offset = 0
            displayTomorrowCourse = false
        }

        // 如果登出也可以用
        if let termStart = CacheManager.loadGroupCache(withKey: "TermStart") as? Date {
            let now = Date()
            let week = Int(now.timeIntervalSince(termStart)/(7.0*24*60*60) + 1)
            let cal = Calendar.current
            let weekday = DateTool.getChineseWeekDay()
            let formatter = NumberFormatter()
            formatter.locale = Locale(identifier: "zh_CN")
            formatter.numberStyle = .spellOut
            let comps = cal.dateComponents([.month, .day], from: now)

            dayLabel.text = weekday + " \(comps.month!)月\(comps.day!)日 " + "第\(week)周"
            dayLabel.sizeToFit()
        }

        TwTUser.shared.load(success: {
            CacheManager.retreive("classtable/classtable.json", from: .group, as: String.self, success: { string in
                if let table = Mapper<ClassTableModel>().map(JSONString: string) {

                    let termStart = Date(timeIntervalSince1970: TimeInterval(table.termStart))
                    let now = Date()
                    let week = Int(now.timeIntervalSince(termStart)/(7.0*24*60*60) + 1)
                    let cal = Calendar.current
                    let weekday = DateTool.getChineseWeekDay()
                    let formatter = NumberFormatter()
                    formatter.locale = Locale(identifier: "zh_CN")
                    formatter.numberStyle = .spellOut
                    let comps = cal.dateComponents([.month, .day], from: now)

                    self.dayLabel.text = weekday + " \(comps.month!)月\(comps.day!)日 " + "第\(week)周"
                    self.dayLabel.sizeToFit()

//                    self.classes = table.classes
                    self.classes = ClassTableHelper.getTodayCourse(table: table, offset: offset).filter { course in
                        return course.courseName != "" && course.arrange.count > 0
                    }
                    self.tableView.reloadData()
                    self.layout()
                    completionHandler(NCUpdateResult.newData)
                }
            }, failure: {
                self.layout()
                completionHandler(NCUpdateResult.failed)
            })
        }, failure: {
            self.layout()
            completionHandler(NCUpdateResult.failed)
        })
        // Perform any setup necessary in order to update the view.
        
        // If an error is encountered, use NCUpdateResult.Failed
        // If there's no update required, use NCUpdateResult.NoData
        // If there's an update, use NCUpdateResult.NewData
//        completionHandler(NCUpdateResult.newData)
//        completionHandler(NCUpdateResult.failed)
    }

    func widgetMarginInsets(forProposedMarginInsets defaultMarginInsets: UIEdgeInsets) -> UIEdgeInsets {
        return .zero
    }
}

extension TodayViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return classes.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = ClassWidgetCell(style: .default, reuseIdentifier: "ClassWidgetCell")
        let model = classes[indexPath.row]
        let arrange = model.arrange.first!
        cell.coursenameLabel.text = model.courseName
        cell.coursenameLabel.frame.size.width = UIScreen.main.bounds.width - 120
        var rangeText = "\(arrange.start)-\(arrange.end)节"

        if displayTomorrowCourse {
            rangeText = "明天 " + rangeText
        }

        let timeText = arrange.startTime + "-" + arrange.endTime
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        let time = formatter.string(from: Date())
        if time >= arrange.startTime && time <= arrange.endTime && !displayTomorrowCourse {
            cell.coursenameLabel.text = model.courseName + " (当前课程)"
        }
        cell.infoLabel.text = rangeText + " " + timeText

        if arrange.room != "" && arrange.room != "无" {
            let text = cell.infoLabel.text!
            cell.infoLabel.text = text + " @" + arrange.room
        }
        cell.infoLabel.sizeToFit()
        
        return cell
    }
}

extension TodayViewController: UITableViewDelegate {

}
