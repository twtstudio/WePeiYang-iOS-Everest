//
//  YellowPageDetailViewController.swift
//  YellowPage
//
//  Created by Halcao on 2017/2/23.
//  Modified by Halcao on 2017/7/18.
//  Copyright © 2017年 Halcao. All rights reserved.
//

import UIKit
import AddressBook
import PopupDialog

class YellowPageDetailViewController: UIViewController {
    let tableView = UITableView(frame: CGRect(x: 0, y: 0, width: 0, height: 0), style: .plain)

    var models = [ClientItem]()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white

        if let title = self.navigationItem.title {
            let titleLabel = UILabel(text: title)
            titleLabel.backgroundColor = UIColor.clear
            titleLabel.font = UIFont.boldSystemFont(ofSize: 18.0)
            titleLabel.textColor = UIColor.white
            titleLabel.sizeToFit()
            self.navigationItem.titleView = titleLabel
        }

        self.navigationController?.navigationBar.tintColor = UIColor.white

        tableView.delegate = self
        tableView.dataSource = self

        tableView.separatorStyle = UITableViewCellSeparatorStyle.singleLine
        tableView.separatorColor = YellowPageMainViewController.seperateColor
        tableView.showsVerticalScrollIndicator = false

        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableViewAutomaticDimension

        self.view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.top.bottom.left.right.equalToSuperview()
        }
    }

//    override func viewWillAppear(_ animated: Bool) {
//        self.navigationController?.setNavigationBarHidden(false, animated: animated)
//        super.viewWillAppear(animated)
//    }

//    override func viewDidDisappear(_ animated: Bool) {
//        self.navigationController?.setNavigationBarHidden(true, animated: animated)
//        super.viewDidDisappear(animated)
//    }
}

extension YellowPageDetailViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return models.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        // FIXME: reuse
        let cell = YellowPageCell(with: .detailed, model: models[indexPath.row])
//        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(cellTapped(sender:)))
//        cell.phoneLabel.addGestureRecognizer(tapRecognizer)
        return cell
    }
}

extension YellowPageDetailViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }

    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let separator = UIView()
        separator.backgroundColor = UIColor.lightGray
        return separator
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.01
    }

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if let cell = cell as? YellowPageCell {
            cell.phoneLabel.snp.updateConstraints { make in
                make.left.equalTo(cell.separatorInset.left)
            }

            cell.nameLabel.snp.updateConstraints { make in
                make.left.equalTo(cell.separatorInset.left)
            }

            cell.likeView.snp.updateConstraints { make in
                make.right.equalToSuperview().offset(-cell.separatorInset.right-20)
            }

            cell.setNeedsUpdateConstraints()
            cell.updateConstraintsIfNeeded()
        }
    }
}

extension YellowPageDetailViewController {
//    @objc func cellTapped(sender: UILabel) {
//        let popup = PopupDialog(title: "复制到", message: <#T##String?#>)
//        let alertVC = UIAlertController(title: "详情", message: "想要做什么？", preferredStyle: .actionSheet)
//        let copyAction = UIAlertAction(title: "复制到剪切板", style: .default) { action in
//            if let superview = sender.superview as? YellowPageCell {
//                superview.longPressed()
//            }
//        }
//        let cancelAction = UIAlertAction(title: "取消", style: .cancel) { action in
//        }
//        alertVC.addAction(copyAction)
//        alertVC.addAction(cancelAction)
//        self.present(alertVC, animated: true, completion: nil)
//    }
}
