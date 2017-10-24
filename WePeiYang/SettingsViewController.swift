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
        ("办公网", LoginViewController.self, "",.notBind)
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
        
        headerView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 100))
    }
}

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
        let cell = UITableViewCell()
        cell.textLabel?.text = (indexPath.section == 0) ? services[indexPath.row].title : settingTitles[indexPath.row].title
        cell.textLabel?.font = UIFont.systemFont(ofSize: 18, weight: UIFontWeightRegular)
        cell.accessoryType = .disclosureIndicator
        return cell
    }
}

// MARK: 
extension SettingsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return section == 0 ? 100 : 0
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0
    }
}
