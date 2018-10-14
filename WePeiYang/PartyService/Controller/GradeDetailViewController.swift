//
//  GradeDetailViewController.swift
//  WePeiYang
//
//  Created by JinHongxu on 16/8/15.
//  Copyright © 2016年 Qin Yubo. All rights reserved.
//

import UIKit

class GradeDetailViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet var tableView: UITableView!

    var index: Int?
    var testType: String?

    let entryStatus = ["", "正常", "作弊", "违纪", "缺考"]
    let passStatus = ["不合格", "合格", "优秀"]

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        self.view.frame.size.width = (UIApplication.shared.keyWindow?.frame.size.width)!

        //NavigationBar 的文字
        self.navigationController!.navigationBar.tintColor = .white

        //NavigationBar 的背景，使用了View
        // FIXME:
        //self.navigationController!.jz_navigationBarBackgroundAlpha = 0;
        let bgView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.navigationController!.navigationBar.frame.size.height+UIApplication.shared.statusBarFrame.size.height))

        bgView.backgroundColor = .partyRed
        self.view.addSubview(bgView)

        //改变 statusBar 颜色
//        UIApplication.shared.setStatusBarStyle(.lightContent, animated: true)
        navigationController?.navigationBar.barStyle = .black

    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    //TableViewDataSource
    func numberOfSections(in tableView: UITableView) -> Int {
        if index != nil {
            return 1
        }
        return 0
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 9
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "identifier")
        if cell == nil {
            cell = UITableViewCell(style: .default, reuseIdentifier: "identifier")
        }

        cell?.textLabel?.textColor = .lightGray
        cell?.textLabel?.font = UIFont.boldSystemFont(ofSize: 14.0)

        let dict = Applicant.sharedInstance.applicantGrade[index!]

        if indexPath.row == 0 {
            cell?.textLabel?.text = "姓名：\(Applicant.sharedInstance.realName!)"
        } else if indexPath.row == 1 {
            cell?.textLabel?.text = "学号：\(dict["sno"] as! String)"
        } else if indexPath.row == 2 {
            cell?.textLabel?.text = "活动期数：\(dict["test_name"] as! String)"
        } else if indexPath.row == 3 {
            cell?.textLabel?.text = "考试时间：\(dict["entry_time"] as! String)"
        } else if indexPath.row == 4 {
            cell?.textLabel?.text = "实践成绩：\(dict["entry_practicegrade"] as! String)"
        } else if indexPath.row == 5 {
            cell?.textLabel?.text = "论文成绩：\(dict["entry_articlegrade"] as! String)"
        } else if indexPath.row == 6 {
            cell?.textLabel?.text = "笔试成绩：暂无"
            if let foo = dict["entry_testgrade"] {
                cell?.textLabel?.text = "笔试成绩：\(foo)"
            }
        } else if indexPath.row == 7 {
            cell?.textLabel?.text = "成绩状态：\(entryStatus[Int(dict["entry_status"] as! String)!])"
        } else if indexPath.row == 8 {
            cell?.textLabel?.text = "考试状态：\(passStatus[Int(dict["entry_ispassed"] as! String)!])"
        }

        cell?.selectionStyle = .none
        return cell!
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if section == 0 {
            return 64
        }
        return 0
    }

    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {

        guard section == 0 else {
            return nil
        }

        let view = UIView(frame: CGRect(x: 0, y: 0, width: (UIApplication.shared.keyWindow?.frame.size.width)!, height: 64))

        let complainButton = UIButton(title: "申诉")
        complainButton.addTarget(self, action: #selector(GradeDetailViewController.complain), for: .touchUpInside)
        complainButton.backgroundColor = UIColor.partyRed
        complainButton.layer.cornerRadius = 8.0
        complainButton.tintColor = .white

        view.addSubview(complainButton)
        complainButton.snp.makeConstraints {
            make in
            make.centerY.equalTo(view)
            make.trailing.equalTo(view).offset(-24)
            make.width.equalTo(96)
            make.height.equalTo(32)
        }

        return view

    }

    @objc func complain() {
        let dict = Applicant.sharedInstance.applicantGrade[index!]
        if testType == "probationary" {
            let complainVC = PartyComplainViewController(ID: dict["train_id"] as! String, type: testType!)
            self.navigationController?.pushViewController(complainVC, animated: true)
        } else {
            let complainVC = PartyComplainViewController(ID: dict["test_id"] as! String, type: testType!)
            self.navigationController?.pushViewController(complainVC, animated: true)
        }

    }
}
