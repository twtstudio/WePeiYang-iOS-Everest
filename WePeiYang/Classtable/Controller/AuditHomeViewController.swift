//
//  AuditHomeViewController.swift
//  WePeiYang
//
//  Created by JasonEWNL on 2018/11/14.
//  Copyright © 2018年 twtstudio. All rights reserved.
//

import UIKit

class AuditHomeViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.navigationBar.tintColor = UIColor(red: 0.14, green: 0.69, blue: 0.93, alpha: 1.00)
        navigationController?.navigationBar.setBackgroundImage(UIImage(color: .white), for: UIBarMetrics.default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.setNavigationBarHidden(false, animated: animated)
        self.navigationController?.navigationBar.barStyle = .default
        self.navigationController?.navigationBar.isTranslucent = false
        
        navigationItem.title = "蹭课"
        
        let auditBack = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
        navigationItem.backBarButtonItem = auditBack
    }
    
}
