//
//  PartyComplainViewController.swift
//  WePeiYang
//
//  Created by JinHongxu on 16/8/16.
//  Copyright © 2016年 Qin Yubo. All rights reserved.
//

import UIKit

class PartyComplainViewController: UIViewController, UITextViewDelegate {

    @IBOutlet var titleField: UITextField!
    @IBOutlet var contentField: UITextView!
    var testID: String?
    @objc var testType: String?

    convenience init(ID: String, type: String) {
        self.init(nibName: "PartyComplainViewController", bundle: nil)

        self.testID = ID
        self.testType = type
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(PartyComplainViewController.complain))

        self.navigationItem.rightBarButtonItem = doneButton
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        //NavigationBar 的文字
        self.navigationController?.navigationBar.tintColor = UIColor.white

        //NavigationBar 的背景，使用了View
//        self.navigationController!.jz_navigationBarBackgroundAlpha = 0;
        let height = (self.navigationController?.navigationBar.frame.size.height ?? 0) + UIApplication.shared.statusBarFrame.size.height
        let bgView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: height))

        bgView.backgroundColor = .partyRed
        self.view.addSubview(bgView)

        //改变 statusBar 颜色
//        UIApplication.shared.setStatusBarStyle(.lightContent, animated: true)
        navigationController?.navigationBar.barStyle = .black
    }

    @objc func complain() {

        guard let title = titleField.text, !title.isEmpty else {
            SwiftMessages.showErrorMessage(body: "标题不能为空")
            return
        }

        guard let content = contentField.text, !content.isEmpty else {
            SwiftMessages.showErrorMessage(body: "内容不能为空")
            return
        }

        if let testID = testID, let testType = testType {
            Applicant.sharedInstance.complain(testID, testType: testType, title: title, content: content, doSomething: {
                self.navigationController?.popViewController(animated: true)
            })
        }
    }
}
