//
//  BicycleUserBindViewController.swift
//  WePeiYang
//
//  Created by JinHongxu on 16/8/9.
//  Copyright © 2016年 Qin Yubo. All rights reserved.
//

import Foundation
import UIKit

class BicycleUserBindViewController: UIViewController, UIAlertViewDelegate {

    @IBOutlet var hintLabel: UILabel!
    @IBOutlet var IDTextField: UITextField!

    override func viewDidLoad() {
        self.navigationController?.navigationBar.tintColor = nil
        super.viewDidLoad()
        // FIXME: 不知道还要不要
//        let alert = UIAlertView(title: "请绑定自行车卡", message: "提示：\n在您进行新办卡、修改卡信息、换卡等操作后，第二天才能正常使用本系统", delegate: self, cancelButtonTitle: "知道了")

//        alert.show()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        UIView.animate(withDuration: 0.4, animations: {
            self.hintLabel.alpha = 1
        })
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //self.navigationController!.jz_navigationBarBackgroundAlpha = 0
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillAppear(animated)
        BicycleUser.sharedInstance.bindCancel = true

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    @IBAction func confirmButton(sender: UIButton) {

        guard !(IDTextField.text?.isEmpty)! else {
            //MsgDisplay.showErrorMsg("身份证号不能为空")
            return
        }

        BicycleUser.sharedInstance.getCardlist(idnum: IDTextField.text!, doSomething: {
            let cardListVC = BicycleCardListViewController(style: .grouped)
            self.navigationController?.pushViewController(cardListVC, animated: true)
        })
    }
}
