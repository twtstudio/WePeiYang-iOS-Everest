//
//  HandInDetailViewController.swift
//  WePeiYang
//
//  Created by JinHongxu on 16/8/25.
//  Copyright © 2016年 Qin Yubo. All rights reserved.
//

import UIKit

class HandInDetailViewController: UIViewController {

    @IBOutlet var contentTextView: UITextView!

    @IBOutlet var titleTextField: UITextField!

    var type: Int?
    convenience init(type: Int) {
        self.init(nibName: "HandInDetailViewController", bundle: nil)

        self.type = type

    }

    override func viewDidLoad() {
        super.viewDidLoad()

        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(HandInDetailViewController.submit))

        self.navigationItem.rightBarButtonItem = doneButton

        contentTextView.text = UserDefaults.standard.object(forKey: "PartyHandInContentText") as? String
        titleTextField.text = UserDefaults.standard.object(forKey: "PartyHandInTitleText") as? String
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        self.view.frame.size.width = (UIApplication.shared.keyWindow?.frame.size.width)!

        //NavigationBar 的文字
        self.navigationController!.navigationBar.tintColor = .white

        //NavigationBar 的背景，使用了View
//        self.navigationController!.jz_navigationBarBackgroundAlpha = 0;
        let bgView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.navigationController!.navigationBar.frame.size.height+UIApplication.shared.statusBarFrame.size.height))

        bgView.backgroundColor = .partyRed
        self.view.addSubview(bgView)

        //改变 statusBar 颜色
//        UIApplication.shared.setStatusBarStyle(.lightContent, animated: true)
        navigationController?.navigationBar.barStyle = .black
    }

    @objc func submit() {

        guard !(titleTextField.text?.isEmpty)! else {
//            MsgDisplay.showErrorMsg("标题不能为空")
            return
        }

        guard !(contentTextView.text?.isEmpty)! else {
//            MsgDisplay.showErrorMsg("内容不能为空")
            return
        }

        Applicant.sharedInstance.handIn(titleTextField.text!, content: contentTextView.text!, fileType: type!, doSomething: {
            //print("dooooo!")
            self.navigationController?.popViewController(animated: true)
        })

    }

    override func viewWillDisappear(_ animated: Bool) {

        //FIXME: use database!
        UserDefaults.standard.set(titleTextField.text, forKey: "PartyHandInTitleText")
        UserDefaults.standard.set(contentTextView.text, forKey: "PartyHandInContentText")
        super.viewWillDisappear(animated)
    }

}
