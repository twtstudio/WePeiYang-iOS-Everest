


//
//  CourseAppraiseViewController.swift
//  WePeiYang
//
//  Created by Halcao on 2017/7/15.
//  Copyright © 2017年 twtstudio. All rights reserved.
//

import UIKit
import SnapKit

class CourseAppraiseViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, CourseAppraiseCellDelegate {
    
    let tableView = UITableView(frame: CGRect.zero, style: .grouped)
    let identifier = "appraise"
    let questionArray = ["总体评价——综合考虑您认为该老师的教学如何？",
                         "教学态度——为人师表、备课认真、教学有激情、热爱学生等。",
                         "教学内容——内容充实，设计合理，结合学科前沿，重点突出，思路清晰等。",
                         "教学方法与手段——采用启发式、互动式教学，教材选用得当，多媒体或板书运用合理，作业批改与答疑认真等。",
                         "教学效果——通过教学，学生对课堂知识的掌握情况",
                         "意见或建议——为了进一步提高教师的授课效果，您认为教师需要改进的地方是：(限50字)"]
    
    var note = ""
    var shouldLoadDetail = false
    var data: GPAClassModel!
    var GPASession: String?

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let image = UIImage(color: UIColor.gpaPink, size: CGSize(width: self.view.width, height: 64))
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
        self.navigationController?.navigationBar.setBackgroundImage(image, for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard data != nil else {
            fatalError("CourseAppraiseViewController.data 赋值啊大哥")
        }
//        print(data?.evaluate)
        //初始化课程数据
        CourseAppraiseManager.shared.setInfo(lesson_id: data.lessonID, union_id: data.unionID, course_id: data.courseID, term: data.term, GPASession: GPASession!)
        
        //View
        self.navigationItem.title = "评价";
        let rightButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(finishEvaluate))
        self.navigationItem.rightBarButtonItem = rightButton
        
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.top.equalTo(view)
            make.bottom.equalTo(view)
            make.left.equalTo(view)
            make.right.equalTo(view)
        }
        tableView.delegate = self
        tableView.dataSource = self
        tableView.allowsSelection = false
        
        tableView.estimatedRowHeight = 180
        tableView.rowHeight = UITableViewAutomaticDimension
        
        registerForKeyboardNotifications()
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTap(sender:))))
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //MARK: tableViewDataSource
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        case 1:
            if shouldLoadDetail {
                return 5
            }
            return 0
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = CourseAppraiseCell(title: questionArray[0], style: .main, id: 4)
            cell.delegate = self
            return cell
        } else {
            switch indexPath.row {
            case 0:
                let cell = CourseAppraiseCell(title: questionArray[1], style: .normal, id: 0)
                return cell
            case 1:
                let cell = CourseAppraiseCell(title: questionArray[2], style: .normal, id: 1)
                return cell
            case 2:
                let cell = CourseAppraiseCell(title: questionArray[3], style: .normal, id: 2)
                return cell
            case 3:
                let cell = CourseAppraiseCell(title: questionArray[4], style: .normal, id: 3)
                return cell
            case 4:
                let cell = CourseAppraiseCell(title: questionArray[5], style: .edit, id: 5)
                return cell
            default:
                let cell = CourseAppraiseCell()
                return cell
            }
        }
    }
    
    /*
     func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
     if indexPath.section == 0 {
     return 150
     } else {
     switch indexPath.row {
     case 2:
     return 128
     case 4:
     return 216
     default:
     return 100
     }
     }
     }
     */
    
    //MARK: tableViewDelegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
    //MARK: CourseAppraiseCellDelegate
    func loadDetail() {
        if shouldLoadDetail == false {
            shouldLoadDetail = true
            CourseAppraiseManager.shared.detailAppraiseEnabled = true
            tableView.reloadSections(IndexSet(integer: 1), with: .middle)
        } else { // shouldLoadDetail == true
            // fold
            shouldLoadDetail = false
            CourseAppraiseManager.shared.detailAppraiseEnabled = false
            tableView.reloadSections(IndexSet(integer: 1), with: .middle)
        }
    }
    
    
    func registerForKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: .UIKeyboardWillHide, object: nil)
    }
    
    func finishEvaluate() {
        CourseAppraiseManager.shared.submit {
            NotificationCenter.default.post(name: NotificationName.NotificationAppraiseDidSucceed.name, object: nil)
            let _ = self.navigationController?.popViewController(animated: true)
        }
    }
    
    func keyboardWillShow(notification: NSNotification) {
        let userInfo:NSDictionary = notification.userInfo! as NSDictionary
        let keyboardFrame:NSValue = userInfo.value(forKey: UIKeyboardFrameEndUserInfoKey) as! NSValue
        let keyboardRectangle = keyboardFrame.cgRectValue
        let keyboardHeight = keyboardRectangle.height
        print(keyboardHeight)
        
        UIView.animate(withDuration: 0.5, animations: {
            self.view.frame.origin.y = -keyboardHeight
        })
    }
    
    func keyboardWillHide(notification:NSNotification) {
        UIView.animate(withDuration: 0.5, animations: {
            self.view.frame.origin.y = 0
        })
    }
    
    func handleTap(sender: UITapGestureRecognizer) {
        tableView.endEditing(true)
    }
    
}
