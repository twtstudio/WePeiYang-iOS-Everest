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

    var classes: [ClassModel] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        if #available(iOSApplicationExtension 10.0, *) {
            extensionContext?.widgetLargestAvailableDisplayMode = .expanded
        }

        

        let width = UIScreen.main.bounds.width
        let tableViewHeight = 50 as CGFloat
        self.preferredContentSize = CGSize(width: width, height: tableViewHeight + 20)

        tableView = UITableView(frame: CGRect(x: 80, y: 20, width: width - 80, height: 50))
        tableView.rowHeight = tableViewHeight
        imgView = UIImageView(frame: CGRect(x: 20, y: 20, width: 50, height: 50))
        imgView.backgroundColor = .white
        // imgView.image = #imageLiteral(resourceName: "bicycleBtn")

        hintLabel = UILabel(frame: CGRect(x: 20, y: 75, width: 50, height: 15))
        hintLabel.textColor = .gray
        hintLabel.textAlignment = .center
        hintLabel.font = UIFont.systemFont(ofSize: 10)
        hintLabel.text = "请稍候"

        tableView.delegate = self
        tableView.dataSource = self

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
            self.preferredContentSize.height =  tableView.rowHeight + 20
        case .expanded:
            tableView.frame.size.height = CGFloat(classes.count) * tableView.rowHeight
            self.preferredContentSize.height = CGFloat(classes.count) * tableView.rowHeight + 20
        }
        layout()
    }

    func layout() {

    }

    func widgetPerformUpdate(completionHandler: (@escaping (NCUpdateResult) -> Void)) {
        if let dic = CacheManager.loadGroupCache(withKey: ClassTableKey) as? [String: Any], let table = Mapper<ClassTableModel>().map(JSON: dic) {
            self.classes = table.classes
            tableView.reloadData()
            completionHandler(NCUpdateResult.newData)
        }
//        self.classes = ClassTableHelper.getTodayCourse().filter { course in
//            return course.courseName != ""
//        }
//        self.tableView.reloadData()
        // Perform any setup necessary in order to update the view.
        
        // If an error is encountered, use NCUpdateResult.Failed
        // If there's no update required, use NCUpdateResult.NoData
        // If there's an update, use NCUpdateResult.NewData
//        completionHandler(NCUpdateResult.newData)
        completionHandler(NCUpdateResult.failed)
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
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "12345")
        let model = classes[indexPath.row]
        cell.textLabel?.text = model.courseName
        cell.detailTextLabel?.text = model.arrange.first?.room ?? ""
        return cell
    }
}

extension TodayViewController: UITableViewDelegate {

}
