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
    private var exams: [ExamModel] {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-ddHH:mm"
        let currentTime = formatter.string(from: Date())

        let exams = ExamAssistant.exams.filter { exam in
            return (exam.date + exam.arrange) > currentTime
        }

        return exams
    }

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
        tableView.register(UINib(nibName: "ExamTableViewCell", bundle: nil), forCellReuseIdentifier: "ExamTableViewCell")
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.isUserInteractionEnabled = false
        tableView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(padding)
            make.right.equalToSuperview().offset(-padding)
            make.top.equalTo(titleLabel.snp.bottom).offset(padding)
            make.width.equalToSuperview().offset(-2 * padding)
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
        if (exams.count > 0) {
            self.setState(.data)
            tableView.reloadData()
        } else {
            self.setState(.empty("竟然没有考试！？", .lightGray))
        }
    }

    override func refresh() {
        super.refresh()

        guard TwTUser.shared.token != nil else {
            self.setState(.failed("请先登录", .gray))
            return
        }

        setState(.loading("加载中...", .gray))

        ExamAssistant.loadCache(success: {
            self.load()
        }, failure: { err in
            self.setState(.failed(err, .gray))
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
        return section == 0 ? min(exams.count, 1) : 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 1 {
            let cell = UITableViewCell()
            cell.textLabel?.text = "More"
            cell.textLabel?.textColor = UIColor.darkGray
            return cell
        }

        let cell = tableView.dequeueReusableCell(withIdentifier: "ExamTableViewCell", for: indexPath) as! ExamTableViewCell

        let data = exams[indexPath.row]
        cell.setData(data, displayDate: true)
        return cell
    }

}
