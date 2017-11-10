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

fileprivate typealias ItemData = (title: String, class: AnyClass, iconName: String, status: ServiceBindingState)
class SettingsViewController: UIViewController {
    
    // The below override will not be called if current viewcontroller is controlled by a UINavigationController
    // We should do self.navigationController.navigationBar.barStyle = UIBarStyleBlack
    //    override var preferredStatusBarStyle: UIStatusBarStyle {
    //        return .lightContent
    //    }
    
    var tableView: UITableView!
    var headerView: UIView!
    // FIXME: image name
    fileprivate let services: [ItemData] = [
        ("图书馆", LoginViewController.self, "", .notBind),
        ("自行车", LoginViewController.self, "", .notBind),
        ("办公网", LoginViewController.self, "", .notBind)
    ]
    fileprivate let settingTitles: [(title: String, iconName: String)] = [("设置", ""), ("退出", "")]
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
//        navigationController?.navigationBar.barStyle = .black
//        navigationController?.navigationBar.barTintColor = Metadata.Color.WPYAccentColor
//        //Changing NavigationBar Title color
//        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: Metadata.Color.naviTextColor]
//        
//        navigationItem.title = "设置"

        
    }
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
        navigationController?.navigationBar.barStyle = .black
        navigationController?.navigationBar.barTintColor = Metadata.Color.WPYAccentColor
        //Changing NavigationBar Title color
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: Metadata.Color.naviTextColor]
        // This is for removing the dark shadows when transitioning
        navigationController?.navigationBar.isTranslucent = false
        
        navigationItem.title = "设置"
        
        
        view.backgroundColor = Metadata.Color.GlobalViewBackgroundColor

        tableView = UITableView(frame: self.view.bounds, style: .grouped)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 60
        tableView.backgroundColor = .white
        tableView.separatorStyle = .singleLineEtched
        
        self.view.addSubview(tableView)
        
        headerView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 165))
        let avatarView = UIImageView(frame: .zero)
        headerView.addSubview(avatarView)
        avatarView.image = UIImage(named: "ic_account_circle")!.with(color: .gray)
        avatarView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(20)
            make.height.width.equalTo(80)
        }
        
        let loginButton = UIButton()
        loginButton.setTitle("登录", for: .normal)
        loginButton.setTitleColor(.black, for: .normal)
        loginButton.titleLabel?.font = UIFont.systemFont(ofSize: 31, weight: UIFontWeightRegular)
        loginButton.titleLabel?.sizeToFit()
        loginButton.sizeToFit()
//        loginButton.sizeToFit()
        headerView.addSubview(loginButton)
        loginButton.snp.makeConstraints { make in
            make.left.equalTo(avatarView.snp.right).offset(5)
            make.top.equalTo(avatarView.snp.top).offset(5)
        }
        loginButton.addTarget(self, action: #selector(login), for: .touchUpInside)
        
        let signatureLabel = UILabel(text: "登录以查看更多信息", color: .lightGray, fontSize: 15)
        headerView.addSubview(signatureLabel)
        signatureLabel.snp.makeConstraints { make in
            make.left.equalTo(avatarView.snp.right).offset(5)
            make.bottom.equalTo(avatarView.snp.bottom).offset(-5)
        }
    }
    
    func login() {
        let loginVC = LoginViewController()
        self.present(loginVC, animated: true, completion: nil)
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
            cell.textLabel?.font = UIFont.systemFont(ofSize: 18, weight: UIFontWeightRegular)
            cell.accessoryType = .disclosureIndicator
            let x: CGFloat = 15
            let separator = UIView(frame: CGRect(x: x, y: tableView.rowHeight - 1, width: self.view.width - x, height: 1))
            separator.backgroundColor = .gray
            separator.alpha = 0.25
            cell.addSubview(separator)
            cell.detailTextLabel?.text = services[indexPath.row].status.rawValue
            return cell
        } else {
            let cell = UITableViewCell()
            cell.textLabel?.text = (indexPath.section == 0) ? services[indexPath.row].title : settingTitles[indexPath.row].title
            cell.textLabel?.font = UIFont.systemFont(ofSize: 18, weight: UIFontWeightRegular)
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
}
