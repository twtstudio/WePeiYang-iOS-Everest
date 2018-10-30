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
        //NavigationBar 的文字
        self.navigationController?.navigationBar.tintColor = .white

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

    @objc func submit() {
        guard let title = titleTextField.text, !title.isEmpty else {
            SwiftMessages.showErrorMessage(body: "标题不能为空")
            return
        }

        guard let content = contentTextView.text, !content.isEmpty else {
            SwiftMessages.showErrorMessage(body: "内容不能为空")
            return
        }

        if let type = type {
            Applicant.sharedInstance.handIn(title, content: content, fileType: type, doSomething: {
                self.navigationController?.popViewController(animated: true)
            })
        }
    }

    override func viewWillDisappear(_ animated: Bool) {

        //FIXME: use database!
        UserDefaults.standard.set(titleTextField.text, forKey: "PartyHandInTitleText")
        UserDefaults.standard.set(contentTextView.text, forKey: "PartyHandInContentText")
        super.viewWillDisappear(animated)
    }

}
