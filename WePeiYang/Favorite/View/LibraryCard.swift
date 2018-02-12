
//
//  LibraryCard.swift
//  WePeiYang
//
//  Created by Halcao on 2017/12/12.
//  Copyright © 2017年 twtstudio. All rights reserved.
//

import UIKit

class LibraryCard: CardView {
    let titleLabel = UILabel()
    let tableView = UITableView()
    let refreshButton = CardButton()
    let renewButton = CardButton()
    let toggleButton = CardButton()

    override func initialize() {
        super.initialize()
        
        self.backgroundColor = .white
        let padding: CGFloat = 20
        
        titleLabel.text = "图书馆"
        titleLabel.font = UIFont.systemFont(ofSize: 25, weight: UIFontWeightSemibold)
        titleLabel.textColor = .black
        contentView.addSubview(titleLabel)
        titleLabel.sizeToFit()
//        titleLabel.snp.makeConstraints { make in
//            make.left.equalToSuperview().offset(padding)
//            make.top.equalToSuperview().offset(padding)
//            make.width.equalTo(200)
//            make.height.equalTo(30)
//        }

        tableView.rowHeight = 50
        tableView.delegate = self
        tableView.dataSource = self
        tableView.isScrollEnabled = false
//        (tableView as UIScrollView).isScrollEnabled = false
        contentView.addSubview(tableView)
//        tableView.snp.makeConstraints { make in
//            make.centerX.equalToSuperview()
//            make.top.equalTo(titleLabel.snp.bottom).offset(20)
//            make.width.equalToSuperview().multipliedBy(0.9)
//            make.height.equalTo(132)
////            make.height.equalToSuperview().offset(-30)
////            make.bottom.equalToSuperview().offset(-padding)
//        }
        contentView.addSubview(renewButton)
        renewButton.setTitle("一键续借")
        renewButton.layer.cornerRadius = renewButton.height/2
//        renewButton.snp.makeConstraints { make in
//            make.centerX.equalToSuperview()
//            make.width.equalTo(renewButton.width)
//            make.height.equalTo(renewButton.height)
//            make.top.equalTo(tableView.snp.bottom).offset(10)
//            make.bottom.equalToSuperview().offset(-10)
//        }
        renewButton.tapAction = renew

        contentView.addSubview(refreshButton)
        refreshButton.setTitle("刷新")
        refreshButton.layer.cornerRadius = refreshButton.height/2
//        refreshButton.snp.makeConstraints { make in
//            make.right.equalTo(renewButton.snp.left).offset(-30)
//            make.width.equalTo(refreshButton.width)
//            make.height.equalTo(refreshButton.height)
//            make.top.equalTo(tableView.snp.bottom).offset(10)
//            make.bottom.equalToSuperview().offset(-10)
//        }
        refreshButton.tapAction = refresh

        contentView.addSubview(toggleButton)
        toggleButton.setTitle("展开")
        toggleButton.tag = 0
        toggleButton.layer.cornerRadius = toggleButton.height/2
//        toggleButton.snp.makeConstraints { make in
//            make.left.equalTo(renewButton.snp.right).offset(30)
//            make.width.equalTo(toggleButton.width)
//            make.height.equalTo(toggleButton.height)
//            make.top.equalTo(tableView.snp.bottom).offset(10)
//            make.bottom.equalToSuperview().offset(-10)
//        }

        toggleButton.tapAction = toggle

//        self.height = 162
        self.height = 240
        remakeConstraints()
        // 其实是高度
//        let info: [String : Any] = ["name": "Library", "height": 260 as CGFloat]
//        NotificationCenter.default.post(name: NotificationName.NotificationCardWillRefresh.name, object: nil, userInfo: info)
//        self.tag = 260
    }

    override func layout(rect: CGRect) {
        super.layout(rect: rect)
    }

    func remakeConstraints() {
        let padding: CGFloat = 20

        titleLabel.snp.remakeConstraints { make in
            make.left.equalToSuperview().offset(padding)
            make.top.equalToSuperview().offset(padding)
            make.width.equalTo(200)
            make.height.equalTo(30)
        }

        let height = self.height - 125
        tableView.snp.remakeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(titleLabel.snp.bottom).offset(20)
            make.width.equalToSuperview().multipliedBy(0.9)
            make.height.equalTo(height)
        }

        renewButton.snp.remakeConstraints { make in
            make.centerX.equalToSuperview()
            make.width.equalTo(renewButton.width)
            make.height.equalTo(renewButton.height)
            make.top.equalTo(tableView.snp.bottom).offset(10)
            make.bottom.equalToSuperview().offset(-10)
        }

        refreshButton.snp.remakeConstraints { make in
            make.right.equalTo(renewButton.snp.left).offset(-30)
            make.width.equalTo(refreshButton.width)
            make.height.equalTo(refreshButton.height)
            make.top.equalTo(tableView.snp.bottom).offset(10)
            make.bottom.equalToSuperview().offset(-10)
        }

        toggleButton.snp.remakeConstraints { make in
            make.left.equalTo(renewButton.snp.right).offset(30)
            make.width.equalTo(toggleButton.width)
            make.height.equalTo(toggleButton.height)
            make.top.equalTo(tableView.snp.bottom).offset(10)
            make.bottom.equalToSuperview().offset(-10)
        }

        setNeedsDisplay()
//        super.draw(self.frame)
    }

    override func updateConstraints() {
        super.updateConstraints()
    }
}

extension LibraryCard: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return LibraryDataContainer.shared.books.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "\(indexPath)")
        let book = LibraryDataContainer.shared.books[indexPath.row]

        let imageSize = CGSize(width: 30, height: 30)
        UIGraphicsBeginImageContextWithOptions(imageSize, false, 0.0)
        let imageRect = CGRect(center: .zero, size: imageSize)
        #imageLiteral(resourceName: "icon-bike").draw(in: imageRect)
        cell.imageView?.image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        cell.textLabel?.text = book.title
        cell.detailTextLabel?.text = "应还时间: " + book.returnTime
        return cell
    }

}

// MARK: 点击事件
extension LibraryCard {
    func renew(sender: CardButton) {

        let group = DispatchGroup()
//        library/renew/{barcode}
        for book in LibraryDataContainer.shared.books {
            group.enter()
            SolaSessionManager.solaSession(type: .get, url: "/library/renew/\(book.barcode)", token: "", parameters: nil, success: { dict in
                // TODO:
                group.leave()
            }, failure: { err in
                group.leave()
                // TODO: 解析错误
            })
        }
        group.notify(queue: .main, execute: {
            self.updateBookStatus()
        })
    }

    func updateBookStatus() {

    }

    func refresh(sender: CardButton) {
        SolaSessionManager.solaSession(type: .get, url: "/library/user/info", token: "", parameters: nil, success: { dict in
            if let data = try? JSONSerialization.data(withJSONObject: dict, options: .init(rawValue: 0)),
                let response = try? LibraryResponse(data: data) {
                LibraryDataContainer.shared.response = response
                // TODO: 会自己滚到下面
                //                self.toggleButton.tag = 1
                //                self.toggle(sender: self.toggleButton)
                self.tableView.reloadData()
            } else {
                // TODO: 解析错误
            }
        }, failure: { err in

        })
    }

    func toggle(sender: CardButton) {
        // TODO: 没有数据时

        var height: CGFloat = 0
        if sender.tag == 0 {
            // 展开
            height = tableView.rowHeight * CGFloat(LibraryDataContainer.shared.books.count) + 145
            sender.setTitle("收起")
            sender.tag = 1
        } else {
            // 收起
            height = tableView.rowHeight * 2 + 145
            sender.setTitle("展开(\(max(LibraryDataContainer.shared.books.count-2, 0)))")
            sender.tag = 0
        }
        self.height = height
        remakeConstraints()

        let info: [String : Any] = ["name": "Library", "height": height as CGFloat]
        NotificationCenter.default.post(name: NotificationName.NotificationCardWillRefresh.name, object: nil, userInfo: info)
    }
}

extension LibraryCard: UITableViewDelegate {
}
