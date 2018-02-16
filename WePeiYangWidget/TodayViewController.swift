//
//  TodayViewController.swift
//  WePeiYangWidget
//
//  Created by Halcao on 2018/2/16.
//  Copyright © 2018年 twtstudio. All rights reserved.
//

import UIKit
import NotificationCenter

class TodayViewController: UIViewController, NCWidgetProviding {
    var tableView: UITableView!
    var imgView: UIImageView!
    var hintLabel: UILabel!

    var classes: [String] = []

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
            self.preferredContentSize.height =  tableView.rowHeight + 20
        case .expanded:
            self.preferredContentSize.height = CGFloat(classes.count) * tableView.rowHeight + 20
        }
        layout()
    }

    func layout() {

    }

    func widgetPerformUpdate(completionHandler: (@escaping (NCUpdateResult) -> Void)) {
        // Perform any setup necessary in order to update the view.
        
        // If an error is encountered, use NCUpdateResult.Failed
        // If there's no update required, use NCUpdateResult.NoData
        // If there's an update, use NCUpdateResult.NewData
        
        completionHandler(NCUpdateResult.newData)
    }

    func widgetMarginInsets(forProposedMarginInsets defaultMarginInsets: UIEdgeInsets) -> UIEdgeInsets {
        return .zero
    }
}

extension TodayViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = "\(indexPath)"
        return cell
    }
}

extension TodayViewController: UITableViewDelegate {

}
