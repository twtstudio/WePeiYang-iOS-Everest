
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
        self.addSubview(titleLabel)
        titleLabel.sizeToFit()
        titleLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(padding)
            make.top.equalToSuperview().offset(padding)
            make.width.equalTo(200)
            make.height.equalTo(30)
        }
        
        tableView.delegate = self
        tableView.dataSource = self
//        (tableView as UIScrollView).isScrollEnabled = false
        self.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(titleLabel.snp.bottom).offset(20)
            make.width.equalToSuperview().multipliedBy(0.9)
            make.height.equalTo(132)
//            make.bottom.equalToSuperview().offset(-padding)
        }

        self.addSubview(refreshButton)
        refreshButton.setTitle("刷新", for: .normal)
        refreshButton.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(100)
            make.top.equalTo(tableView.snp.bottom).offset(10)
            make.bottom.equalToSuperview().offset(-padding)
        }
        
//        let button
    }
}

extension LibraryCard {
    func getBooks() {
        SolaSessionManager.solaSession(type: .get, url: "/library/user/info", token: "", parameters: nil, success: { dict in
            if let data = try? JSONSerialization.data(withJSONObject: dict, options: .init(rawValue: 0)),
                let response = try? LibraryResponse(data: data) {
                LibraryDataContainer.shared.response = response
                self.tableView.reloadData()
            } else {
                // TODO: 解析错误
            }
        }, failure: { err in

        })
    }
}

extension LibraryCard: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return LibraryDataContainer.shared.books.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        let book = LibraryDataContainer.shared.books[indexPath.row]
        cell.textLabel?.text = book.title
        cell.detailTextLabel?.text = book.author
        return cell
    }
}

extension LibraryCard: UITableViewDelegate {
}
