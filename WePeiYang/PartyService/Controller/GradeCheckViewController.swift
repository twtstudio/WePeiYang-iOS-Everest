//
//  GradeCheckViewController.swift
//  WePeiYang
//
//  Created by JinHongxu on 16/8/14.
//  Copyright © 2016年 Qin Yubo. All rights reserved.
//

import UIKit

class GradeCheckViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet var tableView: UITableView!
    
    var testType: String?
    var gradeList = [[String: Any]]()
    
    /*convenience init(type: String) {
        self.init()
        testType = type
    }*/
    
    //iOS 8 fucking bug
    init(){
        super.init(nibName: "GradeCheckViewController", bundle: nil)
        //print("haha")
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //print("didload")
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    //TableViewDataSource
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return gradeList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell = tableView.dequeueReusableCell(withIdentifier: "GradeCheckCell")
        if cell == nil {
            cell = UITableViewCell(style: .value1, reuseIdentifier: "GradeCheckCell")
        }
        
        let dict = gradeList[indexPath.row]
        //print(dict)
        
        if testType == "probationary" {
            cell?.textLabel?.text = dict["train_name"] as? String
        } else {
            cell?.textLabel?.text = dict["test_name"] as? String
        }
        cell?.detailTextLabel?.text = "0000-00-00"
        
        
        //不想直接做字符串操作
        /*if let fooString = dict["entry_time"] {
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            let date = dateFormatter.dateFromString(fooString as! String)
            print(date)
            cell?.detailTextLabel?.text = dateFormatter.stringFromDate(date!)
        }*/
        
        if let foo = dict["entry_time"] as? String {
            cell?.detailTextLabel?.text = (foo as NSString).substring(to: 10)
        }
        
        cell?.textLabel?.font = UIFont.boldSystemFont(ofSize: 13)
        cell?.detailTextLabel?.font = UIFont.boldSystemFont(ofSize: 13)
        //cell?.detailTextLabel?.textColor = .lightGray
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard section == 0 else {
            return nil
        }
        
        let view = UIView(frame: CGRect(x: 0, y: 0, width: (UIApplication.shared.keyWindow?.frame.size.width)!, height: 40))
        
        let titleLabel = UILabel(text: "考试名称")
        let timeLabel = UILabel(text: "完成时间")
        
        titleLabel.font = UIFont.boldSystemFont(ofSize: 13.0)
        titleLabel.textColor = .lightGray
        timeLabel.font = UIFont.boldSystemFont(ofSize: 13.0)
        timeLabel.textColor = .lightGray
        
        view.addSubview(titleLabel)
        view.addSubview(timeLabel)
        
        timeLabel.snp.makeConstraints {
            make in
            make.right.equalTo(view).offset(-8)
            make.centerY.equalTo(view)
        }
        
        titleLabel.snp.makeConstraints {
            make in
            make.left.equalTo(view).offset(8)
            make.centerY.equalTo(view)
            
        }
        
        return view
        
    }
    
    //TableViewDelegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailVC = GradeDetailViewController(nibName: "GradeDetailViewController", bundle: nil)
        detailVC.index = indexPath.row
        detailVC.testType = testType
        
        self.navigationController?.pushViewController(detailVC, animated: true)
        
        tableView.deselectRow(at: indexPath, animated: true)
    }

    
    func refreshUI() {
        
        //TODO: 写成闭包
        if testType == "applicant" {
            gradeList = Applicant.sharedInstance.applicantGrade
        } else if testType == "academy" {
            gradeList = Applicant.sharedInstance.academyGrade
        } else if testType == "probationary" {
            gradeList = Applicant.sharedInstance.probationaryGrade
        }
        
        tableView.reloadData()
    }
    
    //因为暂时无法使用 init
    func fetchData() {
        Applicant.sharedInstance.getGrade(testType!, doSomething: {
            self.refreshUI()
        })
    }
}
