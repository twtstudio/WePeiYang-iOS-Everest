//
//  UIViewController.swift
//  WePeiYang
//
//  Created by Halcao on 2018/2/24.
//  Copyright © 2018年 twtstudio. All rights reserved.
//

import UIKit
import SafariServices

class MallViewController: SFSafariViewController {
    convenience init(_: String = "") {
        self.init(url: URL(string: "https://mall.twt.edu.cn")!)
    }

    required convenience init(_: String = "", coder aDecoder: NSCoder) {
        self.init("")
//        fatalError("init(coder:) has not been implemented")
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
        super.viewWillDisappear(animated)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
    }
}

extension MallViewController: SFSafariViewControllerDelegate {
    func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
        self.navigationController?.popViewController(animated: true)
//        controller.dismiss(animated: true, completion: nil)
    }
}
