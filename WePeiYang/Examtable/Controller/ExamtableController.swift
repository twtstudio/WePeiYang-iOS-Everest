//
//  ExamtableController.swift
//  WePeiYang
//
//  Created by Halcao on 2018/12/30.
//  Copyright © 2018 twtstudio. All rights reserved.
//

import UIKit
import MJRefresh

class ExamtableController: UIViewController {
    private var tableView = UITableView(frame: .zero, style: .grouped)
    private var data: [(String?, ExamModel?)] = []
    private var currentTime = ""

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "考表"
        tableView.frame = self.view.bounds
        tableView.separatorStyle = .none
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 24, right: 0)
        self.view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .white
        tableView.register(UINib(nibName: "ExamTableViewCell", bundle: nil), forCellReuseIdentifier: "ExamTableViewCell")
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "TITLE_CELL")
        tableView.mj_header = MJRefreshNormalHeader(refreshingTarget: self, refreshingAction: #selector(refresh))

        navigationController?.navigationBar.setBackgroundImage(UIImage(color: .white)!, for: .default)
        if isModal {
            let image = UIImage(named: "ic_back")!
            self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(close))
        }

        tableView.mj_header.beginRefreshing()
        ExamAssistant.loadCache(success: {
            self.load()
        }, failure: { msg in
            SwiftMessages.showErrorMessage(body: msg)
        })
    }

    @objc private func close() {
        self.dismiss(animated: true, completion: nil)
    }

    @objc private func refresh() {
        ExamAssistant.getTable(success: {
            self.tableView.mj_header.endRefreshing()
            self.load()
        }, failure: { err in
            self.tableView.mj_header.endRefreshing()
            SwiftMessages.showErrorMessage(body: err.localizedDescription)
            showSpiderLoginView {
                self.refresh()
            }
        })
    }

    private func load() {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-ddHH:mm"
        currentTime = formatter.string(from: Date())

        data.removeAll()

        var dict: [String: Bool] = [:]

        for exam in ExamAssistant.exams {
            if dict[exam.date] == nil {
                dict[exam.date] = true
                data.append((exam.date, nil))
            }
            data.append((nil, exam))
        }

        if ExamAssistant.isFinish {
            SwiftMessages.showSuccessMessage(body: "哈哈哈哈哈哈放假啦！✨")
        }
        tableView.reloadData()
    }

    private func getCell(indexPath: IndexPath) -> UITableViewCell {
        let item = data[indexPath.row]
        var cell: UITableViewCell
        if let title = item.0 {
            cell = tableView.dequeueReusableCell(withIdentifier: "TITLE_CELL", for: indexPath)
            if let label = cell.contentView.viewWithTag(-2) as? UILabel {
                label.text = title
            } else {
                let label = UILabel()
                label.tag = -2
                label.text = title
                label.font = UIFont.systemFont(ofSize: 14)
                label.textColor = .lightGray
                label.sizeToFit()
                cell.contentView.addSubview(label)
                label.snp.makeConstraints { make in
                    make.center.equalToSuperview()
                }
            }
        } else if let model = item.1 {
            cell = tableView.dequeueReusableCell(withIdentifier: "ExamTableViewCell", for: indexPath)
            (cell as? ExamTableViewCell)?.setData(model, displayDate: false)

            if currentTime > model.date + model.arrange {
                cell.contentView.alpha = 0.5
            }
        } else {
            cell = UITableViewCell()
        }

        return cell
    }
}

extension ExamtableController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: self.view.width, height: 60))
        label.textAlignment = .center
        label.text = "数据来自教育教学信息管理系统，仅供参考\n具体安排以学院和学校通知为准"
        label.numberOfLines = 0
        label.textColor = UIColor.lightGray
        return label
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 60
    }

    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
}

extension ExamtableController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return getCell(indexPath: indexPath)
    }
}
