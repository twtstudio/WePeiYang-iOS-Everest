//
//  CardTransactionViewController.swift
//  WePeiYang
//
//  Created by Halcao on 2018/11/27.
//  Copyright © 2018 twtstudio. All rights reserved.
//

import UIKit
import MJRefresh

class CardTransactionViewController: UIViewController {
    private var tableView = UITableView(frame: .zero, style: .plain)
    private var page = 1
    var transactions: [Transaction] = []

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
        self.tableView.mj_header.beginRefreshing()
    }

    @objc private func refresh() {
        ECardAPI.getTransaction(callback: { list, err in
            self.tableView.mj_header.endRefreshing()
            if !list.isEmpty {
                self.page = 1
                self.transactions = list
                self.tableView.reloadData()
                return
            }
            if let err = err {
                SwiftMessages.showErrorMessage(body: err.localizedDescription)
            }
        })
    }

    @objc private func load() {
        ECardAPI.getTransaction(page: page+1, callback: { list, err in
            self.tableView.mj_footer.endRefreshing()
            if !list.isEmpty {
                self.page += 1
                self.transactions = list
                self.tableView.reloadData()
                return
            }
            if let err = err {
                SwiftMessages.showErrorMessage(body: err.localizedDescription)
            }
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

extension CardTransactionViewController: UITableViewDelegate {

}

extension CardTransactionViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return transactions.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TransactionCell") ?? UITableViewCell(style: .subtitle, reuseIdentifier: "TransactionCell")
        cell.selectionStyle = .none
        let item = transactions[indexPath.row]

        var image = UIImage(named: "小箭头")!
        var color: UIColor
        if item.type == TransactionType.topup.rawValue {
            color = UIColor(hex6: 0xff5691)
            cell.imageView?.transform = .identity
            cell.textLabel?.text = " 充值: +" + item.amount
        } else {
            color = UIColor(hex6: 0x568fff)
            cell.imageView?.transform = CGAffineTransform(scaleX: 1, y: -1)
            cell.textLabel?.text = " POS机消费: -" + item.amount
        }

        let imageSize = CGSize(width: 15, height: 15)
        image = UIImage.resizedImage(image: image, scaledToSize: imageSize).with(color: color)
        UIGraphicsBeginImageContext(imageSize)
        let imageRect = CGRect(origin: .zero, size: imageSize)
        image.draw(in: imageRect)
        cell.imageView?.contentMode = .scaleAspectFit
        cell.imageView?.image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        cell.imageView?.snp.makeConstraints { make in
            make.top.equalTo(cell.textLabel?.snp.bottom ?? UILabel()).offset(4)
            make.left.equalTo(cell.textLabel ?? UILabel())
        }

        cell.detailTextLabel?.snp.makeConstraints { make in
            make.centerY.equalTo(cell.imageView ?? UIView())
            make.left.equalTo(cell.imageView?.snp.right ?? UIView()).offset(2)
        }

        cell.detailTextLabel?.textColor = .darkGray
        cell.detailTextLabel?.text = item.location + " " + dateFormat(date: item.date, time: item.time)
        return cell
    }
}
