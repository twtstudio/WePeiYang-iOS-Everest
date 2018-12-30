//
//  ExamCard.swift
//  WePeiYang
//
//  Created by Halcao on 2018/12/30.
//  Copyright © 2018 twtstudio. All rights reserved.
//

import UIKit

class ExamCard: CardView {
    private let titleLabel = UILabel()
    private let tableView = UITableView()

    override func initialize() {
        super.initialize()
        let padding: CGFloat = 20
        titleLabel.text = "最近的考试"
        titleLabel.font = UIFont.systemFont(ofSize: 25, weight: UIFont.Weight.semibold)
        titleLabel.textColor = .black
        titleLabel.sizeToFit()
        self.addSubview(titleLabel)

        titleLabel.snp.makeConstraints { make in
            make.left.top.equalToSuperview().offset(padding)
            make.width.equalTo(200)
            make.height.equalTo(30)
        }

        self.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(padding)
            make.left.equalToSuperview().offset(padding)
            make.right.equalToSuperview().offset(padding)
            make.bottom.equalToSuperview().offset(-padding)
        }
    }

    override func layout(rect: CGRect) {
        let padding: CGFloat = 20

        let layerWidth = rect.width - 2*padding
        let layerHeight = rect.height - 2*padding - 40

        blankView.frame = CGRect(x: padding, y: padding + 30 + 15, width: layerWidth, height: layerHeight)

        super.layout(rect: rect)
    }

    func load() {
        tableView.reloadData()
    }

    override func refresh() {
        super.refresh()

        guard TwTUser.shared.token != nil else {
            self.setState(.failed("请先登录", .gray))
            return
        }

        guard TwTUser.shared.tjuBindingState else {
            self.setState(.failed("请绑定办公网", .gray))
            return
        }

        setState(.loading("加载中...", .gray))

        ExamAssistant.getTable(success: {
            self.setState(.data)
            load()
        }, failure: { err in
            self.setState(.failed(err.localizedDescription, .gray))
        })
    }
}

extension ExamCard: UITableViewDelegate {

}

extension ExamCard: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? ExamAssistant.exams.count : 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 1 {
            let cell = UITableViewCell()
            cell.textLabel?.text = "查看更多"
            cell.textLabel?.textColor = UIColor.readRed
            return cell
        }

        let data = ExamAssistant.exams[indexPath.row]
        let cell = ExamTableViewCell(style: .default, reuseIdentifier: "ExamTableViewCell")
        cell.setData(data)
        return cell
    }

}
