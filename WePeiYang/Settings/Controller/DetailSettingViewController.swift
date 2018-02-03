//
//  DetailSettingViewController.swift
//  WePeiYang
//
//  Created by Halcao on 2018/1/27.
//  Copyright © 2018年 twtstudio. All rights reserved.
//

import UIKit

class DetailSettingViewController: UIViewController {
    var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView = UITableView(frame: self.view.bounds, style: .grouped)
        
    }

}
