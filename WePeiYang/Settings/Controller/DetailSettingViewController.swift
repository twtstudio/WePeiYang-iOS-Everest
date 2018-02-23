//
//  DetailSettingViewController.swift
//  WePeiYang
//
//  Created by Halcao on 2018/1/27.
//  Copyright © 2018年 twtstudio. All rights reserved.
//

import UIKit
import SafariServices

class DetailSettingViewController: UIViewController {
    private enum SettingTitle: String {
        case notification = "推送设置"
        case modules = "模块设置"
        case accounts = "关联账号设置"

        case join = "加入我们"
        case ucma
    }

    var tableView: UITableView!
    let titles = [("设置", ["推送设置", "模块设置", "关联账号设置"]),
                  ("关于", ["加入我们", "用户协议", "建议与反馈"]),
                  ("其他", ["推荐给朋友", "给微北洋评分", "退出登录"])]

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(color: .white)!, for: .default)
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.barStyle = .default
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView = UITableView(frame: self.view.bounds, style: .grouped)
        tableView.delegate = self
        tableView.dataSource = self

        self.view.addSubview(tableView)
//        tableView.backgroundColor = .white
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.black]
        title = "设置"
    }
}

extension DetailSettingViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return titles.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titles[section].1.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = titles[indexPath.section].1[indexPath.row]
        return cell
    }
}

extension DetailSettingViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return titles[section].0
    }

    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        guard section == 2 else {
            return nil
        }

        let footer = UIView(frame: CGRect(x: 0, y: 0, width: self.view.width, height: 100))
        let imgView = UIImageView(image: #imageLiteral(resourceName: "logo"))
        imgView.frame = CGRect(x: (self.view.width-40)/2, y: 20, width: 40, height: 20)
        footer.addSubview(imgView)
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .caption1)
        label.textColor = .gray
        var desc = "Created by twtstudio with ❤️"
        desc += "\n\(DeviceStatus.appName()) v\(DeviceStatus.appVersion())(\(DeviceStatus.appBuild()))"
        label.text = desc
        label.numberOfLines = 0
        label.sizeToFit()
        label.y = 45
        label.x = (self.view.width - label.width)/2
        footer.addSubview(label)
        return footer
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if section == 2 {
            return 120
        } else {
            return 15
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        switch (indexPath.section, indexPath.row) {
        case (0, 0):
            return
        case (0, 1):
            return
        case (0, 2):
            return

        case (1, 0):
            return
        case (1, 1):
            return
        case (1, 2):
            return

        case (2, 0):
            return
        case (2, 1):
            return
        case (2, 2):
            let alert = UIAlertController(title: "确定要退出吗？", message: nil, preferredStyle: .alert)
            let okAction = UIAlertAction(title: "好的", style: .destructive, handler: { (result) in
                TwTUser.shared.delete()
                tableView.reloadData()
                NotificationCenter.default.post(name: NotificationName.NotificationUserDidLogout.name, object: nil)
                print("log out")
            })
            let cancelAction = UIAlertAction(title: "算啦", style: .cancel, handler: { (result) in
                print("Cancled")
            })
            alert.addAction(okAction)
            alert.addAction(cancelAction)
            self.present(alert, animated: true, completion: nil)
        default:
            return
        }
    }
}
