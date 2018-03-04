//
//  DetailSettingViewController.swift
//  WePeiYang
//
//  Created by Halcao on 2018/1/27.
//  Copyright © 2018年 twtstudio. All rights reserved.
//

import UIKit
import SafariServices
import StoreKit
import SwiftMessages

class DetailSettingViewController: UIViewController {
    enum SettingTitle: String {
        case notification = "推送设置"
        case modules = "模块设置"
        case accounts = "关联账号设置"

        case join = "加入我们"
        case EULA = "用户协议"
        case feedback = "建议与反馈"

        case share = "推荐给朋友"
        case rate = "给微北洋评分"
        case quit = "退出登录"
    }

    var tableView: UITableView!
//    let titles = [("设置", ["推送设置", "模块设置", "关联账号设置"]),
//                  ("关于", ["加入我们", "用户协议", "建议与反馈"]),
//                  ("其他", ["推荐给朋友", "给微北洋评分", "退出登录"])]
    let titles: [(String, [SettingTitle])] = [
        ("设置", [.notification, .modules, .accounts]),
                  ("关于", [.join, .EULA, .feedback]),
                  ("其他", [.share, .rate, .quit])]

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isTranslucent = true
//        self.navigationController?.setNavigationBarHidden(false, animated: animated)
//        self.navigationController?.navigationBar.shadowImage = UIImage()
//        self.navigationController?.navigationBar.tintColor = .black
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(color: .white)!, for: .default)
        self.navigationController?.navigationBar.isHidden = false
//        self.navigationController?.navigationBar.barStyle = .default
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.navigationBar.isHidden = true
//        self.navigationController?.setNavigationBarHidden(true, animated:animated)
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
//        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationController?.navigationBar.isTranslucent = true
        tableView = UITableView(frame: self.view.bounds, style: .grouped)
        tableView.contentInset.bottom = 100
        tableView.delegate = self
        tableView.dataSource = self

        self.view.addSubview(tableView)
//        tableView.backgroundColor = .white
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.black]
        title = "设置"

        // 据说可以移除转场阴影
//        navigationController?.navigationBar.isTranslucent = false
    }
}

extension DetailSettingViewController: UITableViewDataSource {
    internal func numberOfSections(in tableView: UITableView) -> Int {
        return titles.count
    }

    internal func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titles[section].1.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = titles[indexPath.section].1[indexPath.row].rawValue
        cell.textLabel?.font = UIFont.preferredFont(forTextStyle: .body)
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
        let title = titles[indexPath.section].1[indexPath.row]
        switch (indexPath.section, title) {
        case (0, .notification):
            return
        case (0, .modules):
            let settingsVC = ModulesSettingsViewController()
            self.navigationController?.pushViewController(settingsVC, animated: true)
        case (0, .accounts):
            return

        case (1, .join):
            let safariVC = SFSafariViewController(url: URL(string: "https://coder.twtstudio.com/join")!, entersReaderIfAvailable: false)
            safariVC.delegate = self
            safariVC.modalPresentationStyle = .overFullScreen
            self.navigationController?.pushViewController(safariVC, animated: true)
        case (1, .EULA):
            let safariVC = SFSafariViewController(url: URL(string: "https://support.twtstudio.com/category/1/%E5%85%AC%E5%91%8A")!, entersReaderIfAvailable: false)
            safariVC.delegate = self
            safariVC.modalPresentationStyle = .overFullScreen
            self.navigationController?.pushViewController(safariVC, animated: true)
        case (1, .feedback):
            let safariVC = SFSafariViewController(url: URL(string: "https://support.twtstudio.com/category/6/%E7%A7%BB%E5%8A%A8%E5%AE%A2%E6%88%B7%E7%AB%AF")!, entersReaderIfAvailable: false)
            safariVC.delegate = self
            safariVC.modalPresentationStyle = .overFullScreen
            self.navigationController?.pushViewController(safariVC, animated: true)

        case (2, .share):
            let shareVC = UIActivityViewController(activityItems: [UIImage(named: "AppIcon40x40")!, "我发现「微北洋」超好用！一起来吧！", URL(string: "https://mobile.twt.edu.cn/wpy/index.html")!], applicationActivities: [])
            // TODO: iPad
//            if let popoverPresentationController = shareVC.popoverPresentationController {
//                popoverPresentationController.barButtonItem
//                popoverPresentationController.permittedArrowDirections = .up
//            }
            self.present(shareVC, animated: true, completion: nil)
        case (2, .rate):
            let appid = "785509141"
            let storeVC = SKStoreProductViewController()
            storeVC.delegate = self
            storeVC.loadProduct(withParameters: [SKStoreProductParameterITunesItemIdentifier: appid], completionBlock: { (result, error) in
                if let error = error {
                    SwiftMessages.showErrorMessage(body: error.localizedDescription)
                } else {
                    self.present(storeVC, animated: true, completion: nil)
                }
            })
        case (2, .quit):
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

extension DetailSettingViewController: SFSafariViewControllerDelegate {
    func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
        controller.navigationController?.popViewController(animated: true)
    }
}

extension DetailSettingViewController: SKStoreProductViewControllerDelegate {
    func productViewControllerDidFinish(_ viewController: SKStoreProductViewController) {
        viewController.dismiss(animated: true, completion: nil)
    }
}

