//
//  SettingsViewController.swift
//  WePeiYang
//
//  Created by Allen X on 5/11/17.
//  Copyright © 2017 twtstudio. All rights reserved.
//

import UIKit

enum ServiceBindingState: String {
    case bind = "已绑定"
    case notBind = "未绑定"
}

typealias ItemData = (title: String, class: AnyClass, iconName: String, status: () -> Bool)

class SettingsViewController: UIViewController {
    
    // The below override will not be called if current viewcontroller is controlled by a UINavigationController
    // We should do self.navigationController.navigationBar.barStyle = UIBarStyleBlack
    //    override var preferredStatusBarStyle: UIStatusBarStyle {
    //        return .lightContent
    //    }
    
    var tableView: UITableView!
    var headerView: UIView!
    var signatureLabel: UILabel!
    let avatarView = UIImageView(frame: .zero)
    let loginButton = UIButton()

    // FIXME: image name
    public var services: [ItemData] = [
        ("图书馆", LibraryBindingViewController.self, "", {
            return TwTUser.shared.libBindingState}),
        ("自行车", BicycleBindingViewController.self, "", {
            return TwTUser.shared.bicycleBindingState}),
        ("办公网", TJUBindingViewController.self, "", {
            return TwTUser.shared.tjuBindingState}),
        ("校园网", WLANBindingViewController.self, "", {
            return TwTUser.shared.WLANBindingState})
    ]
    fileprivate let settingTitles: [(title: String, iconName: String)] = [("设置", "")]
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
        tableView.reloadData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
//        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
//        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        navigationController?.navigationBar.barStyle = .black
//        navigationController?.navigationBar.barTintColor = Metadata.Color.WPYAccentColor
        //Changing NavigationBar Title color
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: Metadata.Color.naviTextColor]
        // This is for removing the dark shadows when transitioning
//        navigationController?.navigationBar.isTranslucent = false

        navigationItem.title = "设置"
        
        view.backgroundColor = Metadata.Color.GlobalViewBackgroundColor
        
        tableView = UITableView(frame: self.view.bounds, style: .grouped)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 50
        tableView.backgroundColor = .white
        tableView.separatorStyle = .none

        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)

        NotificationCenter.default.addObserver(self, selector: #selector(bindingStatusDidChange), name: NotificationName.NotificationBindingStatusDidChange.name, object: nil)
        
        self.view.addSubview(tableView)
        
        headerView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 165))

        headerView.addSubview(avatarView)
        //        avatarView.image = UIImage(named: "ic_account_circle")!.with(color: .gray)
        avatarView.sd_setImage(with: URL(string: TwTUser.shared.avatarURL ?? ""), placeholderImage: UIImage(named: "ic_account_circle")!.with(color: .gray))
        
        avatarView.layer.cornerRadius = 80.0/2
        avatarView.layer.masksToBounds = true
        avatarView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(20)
            make.height.width.equalTo(80)
        }
        
        if TwTUser.shared.token != nil {
            loginButton.setTitle(TwTUser.shared.username, for: .normal)
        } else {
            loginButton.setTitle("登录", for: .normal)
            // FIXME: better way to set it
            loginButton.addTarget(self, action: #selector(login), for: .touchUpInside)
        }
        
        loginButton.setTitleColor(.black, for: .normal)
        loginButton.titleLabel?.font = UIFont.systemFont(ofSize: 31, weight: UIFont.Weight.regular)
        loginButton.titleLabel?.sizeToFit()
        loginButton.sizeToFit()
        //        loginButton.sizeToFit()
        headerView.addSubview(loginButton)
        loginButton.snp.makeConstraints { make in
            make.left.equalTo(avatarView.snp.right).offset(15)
            make.top.equalTo(avatarView.snp.top).offset(5)
        }
        
        signatureLabel = UILabel(text: "登录以查看更多信息", color: .lightGray, fontSize: 15)
        headerView.addSubview(signatureLabel)
        signatureLabel.snp.makeConstraints { make in
            make.left.equalTo(avatarView.snp.right).offset(15)
            make.bottom.equalTo(avatarView.snp.bottom).offset(-5)
        }
    }

    @objc func login() {
        guard TwTUser.shared.token == nil else {
            return
        }
        showLoginView()

//        let loginVC = LoginViewController()
//        self.present(loginVC, animated: true, completion: nil)
    }
    
    func unbind(indexPathAtRow: Int) {
        
        var unbindURL: String
        
        switch indexPathAtRow {
        case 0:
            unbindURL = BindingAPIs.unbindLIBAccount
        case 1:
            return
        case 2:
            unbindURL = BindingAPIs.unbindTJUAccount
        case 3:
            return
        default:
            return
        }
        
        SolaSessionManager.solaSession(type: .get, url: unbindURL, token: TwTUser.shared.token, success: { dictionary in
            print(dictionary)
            print("Succeeded")
            guard let errorCode: Int = dictionary["error_code"] as? Int else {
                return
            }
            
            if errorCode == -1 {
                TwTUser.shared.tjuBindingState = false
                TwTUser.shared.save()
                // services[].status can't get renewed data each time user unbinds
                // self.services[indexPathAtRow].status = false
                self.tableView.reloadData()
            } else {
                let alert = UIAlertController(title: "未知错误", message: nil, preferredStyle: .alert)
                let okAction = UIAlertAction(title: "好的", style: .default, handler: { (result) in
                    print("OK.")
                })
                alert.addAction(okAction)
                self.present(alert, animated: true, completion: nil)
            }
        }, failure: { error in
            debugLog(error)
            print("Failed")
            self.dismiss(animated: true, completion: nil)
        })
    }
    
    @objc func bindingStatusDidChange(notification: Notification) {
            tableView.reloadData()
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

// MARK: UITableViewDataSource
extension SettingsViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return services.count
        case 1:
            return settingTitles.count
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = UITableViewCell(style: .value1, reuseIdentifier: "Cell")
            cell.textLabel?.text = (indexPath.section == 0) ? services[indexPath.row].title : settingTitles[indexPath.row].title
            cell.textLabel?.font = UIFont.systemFont(ofSize: 15, weight: UIFont.Weight.regular)
            cell.accessoryType = .disclosureIndicator
            let x: CGFloat = 15
            let separator = UIView(frame: CGRect(x: x, y: tableView.rowHeight - 1, width: self.view.width - x, height: 1))
            separator.backgroundColor = .gray
            separator.alpha = 0.25
            cell.addSubview(separator)
            cell.detailTextLabel?.font = UIFont.systemFont(ofSize: 14, weight: UIFont.Weight.regular)
            //            cell.detailTextLabel?.text = services[indexPath.row].status.rawValue
            if services[indexPath.row].status() {
                cell.detailTextLabel?.text = "已绑定"
            } else {
                cell.detailTextLabel?.text = "未绑定"
            }
            return cell
        } else {
            let cell = UITableViewCell()
            cell.textLabel?.text = (indexPath.section == 0) ? services[indexPath.row].title : settingTitles[indexPath.row].title
            cell.textLabel?.font = UIFont.systemFont(ofSize: 15, weight: UIFont.Weight.regular)
            cell.accessoryType = .disclosureIndicator
            let x: CGFloat = 15
            let separator = UIView(frame: CGRect(x: x, y: tableView.rowHeight - 1, width: self.view.width - x, height: 1))
            separator.backgroundColor = .gray
            separator.alpha = 0.25
            cell.addSubview(separator)
            return cell
        }
    }
}

// MARK: UITableViewDelegate
extension SettingsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 {
            if TwTUser.shared.token != nil {
                loginButton.setTitle(TwTUser.shared.username, for: .normal)
                signatureLabel.text = TwTUser.shared.realname
            } else {
                loginButton.setTitle("登录", for: .normal)
                loginButton.addTarget(self, action: #selector(login), for: .touchUpInside)
                signatureLabel.text = "登录以查看更多信息"
            }

            avatarView.sd_setImage(with: URL(string: TwTUser.shared.avatarURL ?? ""), placeholderImage: UIImage(named: "account_circle")!.with(color: .gray))

            return headerView
        }
        return nil
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return section == 0 ? 165 : 0
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        switch (indexPath.section, indexPath.row) {
        case (1, 1):
            // delete user info and request for unbind after click logout button
            tableView.deselectRow(at: indexPath, animated: true)
            for index in 0...(services.count - 1) {
                self.unbind(indexPathAtRow: index)
            }
            TwTUser.shared.delete()
            tableView.reloadData()
            print("log out")

        case (1, 0):
            let detailVC = DetailSettingViewController()
            detailVC.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(detailVC, animated: true)
            return
        case (0, _):
            guard let _ = TwTUser.shared.token else {
                let alert = UIAlertController(title: "先去登录！", message: nil, preferredStyle: .alert)
                let okAction = UIAlertAction(title: "好的", style: .default, handler: { (result) in
                    print("OK")
                })
                alert.addAction(okAction)
                self.present(alert, animated: true, completion: nil)
                return
            }
        default:
            break
        }
        
        if !services[indexPath.row].status() {
            if let vc = (services[indexPath.row].class as? UIViewController.Type)?.init() {
                vc.hidesBottomBarWhenPushed = true
                self.present(vc, animated: true)
            }
        } else {
            let alert = UIAlertController(title: "要解绑吗？", message: nil, preferredStyle: .alert)
            let okAction = UIAlertAction(title: "好的", style: .destructive, handler: { (result) in
                print("OK")
                self.unbind(indexPathAtRow: indexPath.row)
            })
            let cancelAction = UIAlertAction(title: "算啦", style: .cancel, handler: { (result) in
                print("Canceled")
            })
            alert.addAction(okAction)
            alert.addAction(cancelAction)
            self.present(alert, animated: true, completion: nil)
        }
    }
}

func showLoginView(success: (()->())? = nil) {
    let loginView = LoginView()
    loginView.successHandler = success
    var config = SwiftMessages.defaultConfig
    config.presentationStyle = .center
    config.duration = .forever
    config.dimMode = .blur(style: .dark, alpha: 1, interactive: true)
    config.presentationContext  = .window(windowLevel: UIWindowLevelAlert)
    SwiftMessages.show(config: config, view: loginView)
}
