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

let ClassTableKey = "ClassTableKey"

class TodayViewController: UIViewController, NCWidgetProviding {
    var tableView: UITableView!
    var imgView: UIImageView!
    var hintLabel: UILabel!
    var messageLabel: UILabel!

    var classes: [ClassModel] = [] {
        willSet {
            if newValue.count == 0 {
                messageLabel.isHidden = false
            } else {
                messageLabel.isHidden = true
            }
        }
    }
    let timeArray = [(start: "8:30", end: "9:15"),
                     (start: "9:20", end: "10:05"),
                     (start: "10:25", end: "11:10"),
                     (start: "11:15", end: "12:00"),
                     (start: "13:30", end: "14:15"),
                     (start: "14:20", end: "15:05"),
                     (start: "15:25", end: "16:10"),
                     (start: "16:15", end: "17:00"),
                     (start: "18:30", end: "19:15"),
                     (start: "19:20", end: "20:05"),
                     (start: "20:10", end: "20:55"),
                     (start: "21:00", end: "21:45")]

    override func viewDidLoad() {
        super.viewDidLoad()

        if #available(iOSApplicationExtension 10.0, *) {
            extensionContext?.widgetLargestAvailableDisplayMode = .expanded
        }

        let width = UIScreen.main.bounds.width

        let dayLabel = UILabel(frame: CGRect(x: 70, y: 20, width: width - 70 - 20, height: 20))
        dayLabel.textAlignment = .center
        dayLabel.font = UIFont.preferredFont(forTextStyle: .title3)
        dayLabel.text = "周二 2月21日 第17周"
        dayLabel.textColor = .gray
        self.view.addSubview(dayLabel)

        let tableViewHeight = 50 as CGFloat
        self.preferredContentSize = CGSize(width: width, height: tableViewHeight + 20)

        tableView = UITableView(frame: CGRect(x: 70, y: 50, width: width - 70, height: 50))
        tableView.rowHeight = tableViewHeight
        imgView = UIImageView(frame: CGRect(x: 20, y: 20, width: 40, height: 40))
        imgView.image = #imageLiteral(resourceName: "ic_wifi-1")
        // imgView.image = #imageLiteral(resourceName: "bicycleBtn")

        hintLabel = UILabel(frame: CGRect(x: 20, y: 65, width: 40, height: 15))
        hintLabel.textColor = .gray
        hintLabel.textAlignment = .center
        hintLabel.font = UIFont.systemFont(ofSize: 10)
        hintLabel.text = "请稍候"

        messageLabel = UILabel(frame: CGRect(x: 70, y: 50, width: width - 70, height: 50))
        messageLabel.font = UIFont.preferredFont(forTextStyle: .title3)
        messageLabel.textAlignment = .center
        messageLabel.textColor = .gray
        messageLabel.text = "今天没有课，做点有趣的事情吧！"
        self.view.addSubview(messageLabel)
        messageLabel.isHidden = true

        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none

        self.view.addSubview(tableView)
        self.view.addSubview(imgView)
        self.view.addSubview(hintLabel)
        layout()
    }

    @available(iOSApplicationExtension 10.0, *)
    func widgetActiveDisplayModeDidChange(_ activeDisplayMode: NCWidgetDisplayMode, withMaximumSize maxSize: CGSize) {
        switch activeDisplayMode {
        case .compact:
            tableView.frame.size.height = tableView.rowHeight
            self.preferredContentSize.height =  tableView.rowHeight + 20 + 20
        case .expanded:
            tableView.frame.size.height = CGFloat(classes.count) * tableView.rowHeight
            self.preferredContentSize.height = CGFloat(classes.count) * tableView.rowHeight + 20 + 20
        }
        layout()
    }

    func layout() {

    }

    func widgetPerformUpdate(completionHandler: (@escaping (NCUpdateResult) -> Void)) {
//        if let dic = CacheManager.loadGroupCache(withKey: ClassTableKey) as? [String: Any], let table = Mapper<ClassTableModel>().map(JSON: dic) {
//            self.classes = table.classes.filter { model in
//                return model.arrange.count > 0
//            }
//            tableView.reloadData()
//            completionHandler(NCUpdateResult.newData)
//        }
        TwTUser.shared.load(success: {
            CacheManager.retreive("classtable/classtable.json", from: .group, as: String.self, success: { string in
                if let table = Mapper<ClassTableModel>().map(JSONString: string) {
                    self.classes = ClassTableHelper.getTodayCourse(table: table).filter { course in
                        return course.courseName != "" && course.arrange.count > 0
                    }
                    self.tableView.reloadData()
                    completionHandler(NCUpdateResult.newData)
                }
            }, failure: {
                completionHandler(NCUpdateResult.failed)
            })
        }, failure: {
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
        cell.coursenameLabel.text = model.courseName + " (当前课程)"
        let rangeText = "\(arrange.start)-\(arrange.end)节"
        var timeText = ""
        if arrange.start <= timeArray.count && arrange.end <= timeArray.count {
            timeText = "\(timeArray[arrange.start].start)-\(timeArray[arrange.end].end)"
        }
        cell.infoLabel.text = rangeText + " " + timeText

        if arrange.room != "" && arrange.room != "无" {
            let text = cell.infoLabel.text!
            cell.infoLabel.text = text + " @" + arrange.room
        }
        return cell
    }
}

extension TodayViewController: UITableViewDelegate {

}
