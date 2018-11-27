//
//  CardTransectionViewController.swift
//  WePeiYang
//
//  Created by Halcao on 2018/11/27.
//  Copyright © 2018 twtstudio. All rights reserved.
//

import UIKit
import MJRefresh

class CardTransectionViewController: UIViewController {
    private var tableView = UITableView(frame: .zero, style: .plain)
    private var page = 1
    var transections: [Transection] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "校园卡流水"
        tableView.delegate = self
        tableView.dataSource = self

        self.view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        if isModal {
            let image = UIImage(named: "ic_back")!
            self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(close))
        }
        let header = MJRefreshNormalHeader(refreshingTarget: self, refreshingAction: #selector(refresh))
        let footer = MJRefreshAutoNormalFooter(refreshingTarget: self, refreshingAction: #selector(load))
        self.tableView.mj_header = header
        self.tableView.mj_footer = footer
        refresh()
    }

    @objc private func refresh() {
        ECardAPI.getTransection(page: 1, type: .expense, success: { transection in
            self.page = 1
            self.tableView.mj_header.endRefreshing()
            self.transections = transection.transection
            self.tableView.reloadData()
        }, failure: { err in
            self.tableView.mj_header.endRefreshing()
            SwiftMessages.showErrorMessage(body: err.localizedDescription)
        })
    }

    @objc private func load() {
        ECardAPI.getTransection(page: page + 1, type: .expense, success: { transection in
            self.tableView.mj_footer.endRefreshing()
            self.page += 1
            self.transections = transection.transection
            self.tableView.reloadData()
        }, failure: { err in
            self.tableView.mj_footer.endRefreshing()
            SwiftMessages.showErrorMessage(body: err.localizedDescription)
        })
    }

    @objc private func close() {
        self.dismiss(animated: true, completion: nil)
    }

    private func dateFormat(date: String, time: String) -> String {
        var date = date
        var time = time
        date.insert("-", at: date.index(date.startIndex, offsetBy: 6))
        date.insert("-", at: date.index(date.startIndex, offsetBy: 4))

        time.insert(":", at: time.index(time.startIndex, offsetBy: 4))
        time.insert(":", at: time.index(time.startIndex, offsetBy: 2))

        return date + " " + time
    }
}

extension CardTransectionViewController: UITableViewDelegate {

}

extension CardTransectionViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return transections.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TransectionCell") ?? UITableViewCell(style: .subtitle, reuseIdentifier: "TransectionCell")
        let item = transections[indexPath.row]
        cell.textLabel?.text = " POS消费: " + item.amount
        cell.detailTextLabel?.textColor = .darkGray
        cell.detailTextLabel?.text = item.location + " " + dateFormat(date: item.date, time: item.time)
        return cell
    }
}
