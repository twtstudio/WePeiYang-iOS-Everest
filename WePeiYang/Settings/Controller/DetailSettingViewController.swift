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
import WebKit
import PopupDialog

class DetailSettingViewController: UIViewController {
    enum SettingTitle: String {
        case classtable = "课表提醒设置"
        case modules = "模块设置"
        case accounts = "关联账号设置"
        case shakeWiFi = "摇一摇登录校园网"
        case armode = "AR模式"

        case join = "加入我们"
        case EULA = "用户协议"
        case feedback = "建议与反馈"
        case qqGroup = "加入QQ反馈群"

        case share = "推荐给朋友"
        case rate = "给微北洋评分"
        case quit = "退出登录"
    }

    var tableView: UITableView!
    var titles: [(String, [SettingTitle])] = [
        //        ("设置", [.notification, .modules, .accounts]),
        ("设置", [.classtable, .shakeWiFi, .modules, .armode]),
        ("关于", [.join, .EULA, .feedback, .qqGroup]),
        ("其他", [.share, .rate, .quit])]

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(color: .white)!, for: .default)
        self.navigationController?.navigationBar.isHidden = false
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
//        // 因为这个方法不会取消左滑back手势
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationController?.navigationBar.isTranslucent = true
        tableView = UITableView(frame: self.view.bounds, style: .grouped)
        tableView.contentInset.bottom = 100
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = deviceWidth == .iPhoneSEWidth ? 35 : 44

        self.view.addSubview(tableView)
//        tableView.backgroundColor = .white
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.black]
        title = "设置"

        // 据说可以移除转场阴影
//        navigationController?.navigationBar.isTranslucent = false
        if TwTUser.shared.token == nil {
            titles[2].1.removeLast()
        }
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
        cell.textLabel?.text = titles[indexPath.section].1[indexPath.row].rawValue
        cell.textLabel?.font = UIFont.flexibleSystemFont(ofSize: 15)
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
        case (0, .classtable):
            let notificationVC = ClassTableSettingViewController()
            self.navigationController?.pushViewController(notificationVC, animated: true)
            return
        case (0, .shakeWiFi):
            let status = UserDefaults.standard.bool(forKey: "shakeWiFiEnabled")
            let popup: PopupDialog
            if status {
                // 开启状态
                popup = PopupDialog(title: "摇一摇上网", message: "要关闭摇一摇联网吗？", buttonAlignment: .horizontal, transitionStyle: .zoomIn)

                let cancelButton = DefaultButton(title: "取消", action: nil)

                let defaultButton = DestructiveButton(title: "关闭", dismissOnTap: true) {
                    UserDefaults.standard.set(false, forKey: "shakeWiFiEnabled")
                }
                popup.addButtons([cancelButton, defaultButton])
            } else {
                // 开启状态
                popup = PopupDialog(title: "摇一摇上网", message: "要开启摇一摇联网吗？", buttonAlignment: .horizontal, transitionStyle: .zoomIn)

                let cancelButton = CancelButton(title: "取消", action: nil)

                let defaultButton = DefaultButton(title: "开启", dismissOnTap: true) {
                    UserDefaults.standard.set(true, forKey: "shakeWiFiEnabled")
                }
                popup.addButtons([cancelButton, defaultButton])
            }
            self.present(popup, animated: true, completion: nil)
            return
        case (0, .armode):
            guard let version = Double(UIDevice.current.systemVersion.split(separator: ".")[0]),
            version > 11 else {
                SwiftMessages.showErrorMessage(body: "由于版本限制，暂不支持iOS 11以下x的系统")
                return
            }

            let ARModeEnabledKey = "ARModeEnabledKey"
            let status = UserDefaults.standard.bool(forKey: ARModeEnabledKey)
            let action = status ? "关闭" : "开启"
            let message = "要" + action + "AR模式吗？"
            let popup: PopupDialog = PopupDialog(title: "ARMode", message: message, buttonAlignment: .horizontal, transitionStyle: .zoomIn)

            let cancelButton = DefaultButton(title: "取消", action: nil)

            let defaultButton = DestructiveButton(title: action, dismissOnTap: true) {
                UserDefaults.standard.set(!status, forKey: ARModeEnabledKey)
                if (!status) {
                    if #available(iOS 11.0, *) {
                        let arWindow = ARKeyWindow()
                        (UIApplication.shared.delegate as? AppDelegate)?.arWindow = arWindow
                        arWindow.makeKeyAndVisible()
                    }
                } else {
                    SwiftMessages.showSuccessMessage(body: action + "成功，请手动重启应用")
                    return
                }
                SwiftMessages.showSuccessMessage(body: action + "成功")
            }
            popup.addButtons([cancelButton, defaultButton])
            self.present(popup, animated: true, completion: nil)
            return
        case (0, .modules):
            let settingsVC = ModulesSettingsViewController()
            self.navigationController?.pushViewController(settingsVC, animated: true)
        case (0, .accounts):
            return

        case (1, .join):
            let webVC = SupportWebViewController(url: URL(string: "https://coder.twtstudio.com/")!)
            self.navigationController?.pushViewController(webVC, animated: true)
        case (1, .EULA):
            let webVC = SupportWebViewController(url: URL(string: "https://support.twtstudio.com/category/1/%E5%85%AC%E5%91%8A")!)
            self.navigationController?.pushViewController(webVC, animated: true)
        case (1, .feedback):
            let webVC = SupportWebViewController(url: URL(string: "https://support.twtstudio.com/category/6/%E7%A7%BB%E5%8A%A8%E5%AE%A2%E6%88%B7%E7%AB%AF")!)
            self.navigationController?.pushViewController(webVC, animated: true)
        case (1, .qqGroup):
            let urlString = "mqqapi://card/show_pslcard?src_type=internal&version=1&uin=738068756&card_type=group&source=qrcode&jump_from=&auth="
            if UIApplication.shared.openURL(URL(string: urlString)!) == false {
                SwiftMessages.showWarningMessage(body: "没有找到QQ")
            }
            //break
        case (2, .share):
            let shareVC = UIActivityViewController(activityItems: [UIImage(named: "AppIcon40x40")!, "我发现「微北洋」超好用！一起来吧！", URL(string: "https://mobile.twt.edu.cn/wpy/index.html")!], applicationActivities: [])
            // TODO: iPad
//            if let popoverPresentationController = shareVC.popoverPresentationController {
//                popoverPresentationController.barButtonItem
//                popoverPresentationController.permittedArrowDirections = .up
//            }
            self.present(shareVC, animated: true, completion: nil)
        case (2, .rate):
            UIApplication.shared.openURL(URL(string: "itms-apps://itunes.apple.com/cn/app/%E5%BE%AE%E5%8C%97%E6%B4%8B/id785509141?mt=8")!)
//            let appid = "785509141"
//            let storeVC = SKStoreProductViewController()
//            storeVC.delegate = self
//            SwiftMessages.showLoading()
//
//            storeVC.loadProduct(withParameters: [SKStoreProductParameterITunesItemIdentifier: appid], completionBlock: { (result, error) in
//                if let error = error {
//                    SwiftMessages.showErrorMessage(body: error.localizedDescription)
//                } else {
//                    SwiftMessages.hide()
//                    self.present(storeVC, animated: true, completion: nil)
//                }
//            })
        case (2, .quit):
            let popup = PopupDialog(title: "退出", message: "确定要退出吗？", buttonAlignment: .horizontal, transitionStyle: .zoomIn)

            let cancelButton = CancelButton(title: "不了", action: nil)

            let defaultButton = DestructiveButton(title: "退出", dismissOnTap: true) {
                UserDefaults.standard.set(true, forKey: "shakeWiFiEnabled")
                UserDefaults.standard.set(false, forKey: "isOnline")
                TwTUser.shared.delete()
                tableView.reloadData()
                ClassTableNotificationHelper.removeNotification()
                NotificationCenter.default.post(name: NotificationName.NotificationUserDidLogout.name, object: nil)
                self.navigationController?.popViewController(animated: true)
            }
            popup.addButtons([cancelButton, defaultButton])
            self.present(popup, animated: true, completion: nil)

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

class SupportWebViewController: ProgressWebViewController {
    let url: URL

    init(url: URL) {
        self.url = url
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        webView.frame.origin.y = 0
        webView.load(URLRequest(url: url))
    }

    override func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        super.webView(webView, didFinish: navigation)
        webView.evaluateJavaScript("document.title", completionHandler: { (title, _) in
            self.navigationItem.title = title as? String
        })
    }
}
