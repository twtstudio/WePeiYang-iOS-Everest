//
//  ComplaintViewController.swift
//  WePeiYang
//
//  Created by 赵家琛 on 2017/9/5.
//  Copyright © 2017年 twtstudio. All rights reserved.
//

import UIKit

class ComplaintViewController: UIViewController, UITextViewDelegate, UITextFieldDelegate {
    
    var subView: UIView!
    var complaintLabel: UILabel!
    var complaintReasonTextField: UITextField!
    var complaintDetailTextView: UITextView!
    var complaintButton: UIButton!
    var complaintTextViewLabelFirst: UILabel!
    var complaintTextViewLabelSecond: UILabel!
    var complaintTextFieldLabelFirst: UILabel!
    var complaintTextFieldLabelSecond: UILabel!
    var id: String!
    var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        subView = UIView()
        complaintLabel = UILabel()
        complaintReasonTextField = UITextField()
        complaintDetailTextView = UITextView()
        complaintButton = UIButton()
        complaintTextViewLabelFirst = UILabel()
        complaintTextViewLabelSecond = UILabel()
        complaintTextFieldLabelFirst = UILabel()
        complaintTextFieldLabelSecond = UILabel()
        self.title = "投诉"
        self.subView.backgroundColor = UIColor.white
        self.view.backgroundColor = UIColor(red: 239.0 / 255.0, green: 239.0 / 255.0, blue: 244.0 / 255.0, alpha: 1.0)
        
        subView.addSubview(complaintLabel)
        subView.addSubview(complaintDetailTextView)
        subView.addSubview(complaintReasonTextField)
        subView.addSubview(complaintButton)
        subView.addSubview(complaintTextViewLabelFirst)
        subView.addSubview(complaintTextViewLabelSecond)
        subView.addSubview(complaintTextFieldLabelFirst)
        subView.addSubview(complaintTextFieldLabelSecond)
        self.view.addSubview(subView)
        
        self.complaintDetailTextView.delegate = self
        self.complaintReasonTextField.delegate = self
        
        subView.snp.makeConstraints { make in
            make.left.equalTo(5)
            make.right.equalTo(-5)
            make.height.equalTo(330)
            make.top.equalTo(70)
        }
        
        complaintTextViewLabelFirst.alpha = 0.5
        complaintTextViewLabelSecond.alpha = 1
        complaintTextViewLabelFirst.text = "事件详情"
        complaintTextViewLabelFirst.font = UIFont.systemFont(ofSize: 13)
        complaintTextViewLabelFirst.textColor = UIColor.black
        complaintTextViewLabelFirst.snp.makeConstraints { make in
            make.width.equalTo(60)
            make.height.equalTo(20)
            make.bottom.equalTo(-205)
            make.left.equalTo(10)
        }
        complaintTextViewLabelSecond.text = "*"
        complaintTextViewLabelSecond.font = UIFont.systemFont(ofSize: 13)
        complaintTextViewLabelSecond.textColor = UIColor.red
        complaintTextViewLabelSecond.snp.makeConstraints { make in
            make.width.equalTo(20)
            make.height.equalTo(20)
            make.bottom.equalTo(-205)
            make.left.equalTo(65)
        }
        
        complaintTextFieldLabelFirst.alpha = 0.5
        complaintTextFieldLabelSecond.alpha = 1
        complaintTextFieldLabelFirst.text = "投诉原因"
        complaintTextFieldLabelFirst.font = UIFont.systemFont(ofSize: 13)
        complaintTextFieldLabelFirst.textColor = UIColor.black
        complaintTextFieldLabelFirst.snp.makeConstraints { make in
            make.width.equalTo(60)
            make.height.equalTo(20)
            make.bottom.equalTo(-245)
            make.left.equalTo(10)
        }
        complaintTextFieldLabelSecond.text = "*"
        complaintTextFieldLabelSecond.font = UIFont.systemFont(ofSize: 13)
        complaintTextFieldLabelSecond.textColor = UIColor.red
        complaintTextFieldLabelSecond.snp.makeConstraints { make in
            make.width.equalTo(20)
            make.height.equalTo(20)
            make.bottom.equalTo(-245)
            make.left.equalTo(65)
            
        }
        
        complaintLabel.snp.makeConstraints { make in
            make.left.equalTo(5)
            make.right.equalTo(-5)
            //make.width.equalTo(350)
            make.height.equalTo(50)
            make.top.equalTo(0)
        }
        complaintLabel.text = "我们将认真阅读您的投诉内容，仔细审查维修方的责任，妥善解决您的问题。"
        complaintLabel.backgroundColor = UIColor.white
        complaintLabel.lineBreakMode = .byWordWrapping
        complaintLabel.numberOfLines = 0
        complaintLabel.font = UIFont.systemFont(ofSize: 13)
        
        complaintReasonTextField.snp.makeConstraints { make in
            make.left.equalTo(5)
            make.right.equalTo(-5)
            //make.width.equalTo(350)
            make.height.equalTo(30)
            make.top.equalTo(60)
        }
        complaintReasonTextField.font = UIFont.systemFont(ofSize: 13)
        //complaintReasonTextField!.backgroundColor = UIColor.white
        //complaintReasonTextField!.borderStyle = UITextBorderStyle.line
        complaintReasonTextField.layer.borderColor = UIColor.lightGray.cgColor
        complaintReasonTextField.layer.borderWidth = 1
        complaintReasonTextField!.textAlignment = .left
        
        complaintDetailTextView.snp.makeConstraints { make in
            make.left.equalTo(5)
            make.right.equalTo(-5)
            //make.width.equalTo(350)
            make.height.equalTo(180)
            make.top.equalTo(100)
        }
        complaintDetailTextView.isEditable = true
        complaintDetailTextView.isSelectable = true
        complaintDetailTextView.textAlignment = .left
        complaintDetailTextView.layer.borderWidth = 1
        complaintDetailTextView.layer.borderColor = UIColor.lightGray.cgColor
        complaintDetailTextView.font = UIFont.systemFont(ofSize: 13)
        
        complaintButton.snp.makeConstraints { make in
            make.width.equalTo(90)
            make.height.equalTo(30)
            make.centerX.equalTo(subView)
            make.top.equalTo(290)
        }
        complaintButton.setTitle("提交", for: .normal)
        complaintButton.setTitleColor(UIColor.black, for: .normal)
        complaintButton.backgroundColor = UIColor(red: 254.0 / 255.0, green: 210.0 / 255.0, blue: 44.0 / 255.0, alpha: 1.0)
        complaintButton.addTarget(self, action: #selector(clickMe), for: .touchUpInside)
        complaintButton.layer.cornerRadius = 6
        complaintButton.alpha = 0.8
        
        activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .gray)
        activityIndicator.center = self.view.center
        self.view.addSubview(activityIndicator)
        
    }
    
    
    func clickMe() {
        

        if complaintReasonTextField.hasText && complaintDetailTextView.hasText{
            
            var dic: [String : Any] = [String : Any]()
            dic["order_id"] = id
            dic["reason"] = complaintReasonTextField.text
            dic["detail"] = complaintDetailTextView.text
            //dic["authorization"] = TwTUser.shared.token!
            complaintButton.isEnabled = false
            activityIndicator.startAnimating()
            
            UploadRepairApi.submitComplain(diction: dic, success: { (victory) in
                self.activityIndicator.stopAnimating()
                let vc = OperationDetail()
                if victory == true {
                    vc.check(submitSituation: true, complaintSituation: true, locationSituation: true)
                    self.complaintButton.isEnabled = false
                } else {
                    vc.check(submitSituation: true, complaintSituation: false, locationSituation: true)
                    self.complaintButton.isEnabled = true
                }
                self.navigationController?.pushViewController(vc, animated: true)
            }, failure: { error in
                print(error)
                complaintButton.isEnabled = true
            })
            
        } else {
            
            let alert = UIAlertController(title: nil, message: "请确认填写信息无误", preferredStyle: .alert)
            self.present(alert, animated: true, completion: nil)
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
                self.presentedViewController?.dismiss(animated: true, completion: nil)
            }

        }
        
        
        
        
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        complaintTextViewLabelFirst.alpha = 0
        complaintTextViewLabelSecond.alpha = 0
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if complaintDetailTextView.hasText == false {
            complaintTextViewLabelFirst.alpha = 0.5
            complaintTextViewLabelSecond.alpha = 0.5
        } else {
            complaintTextViewLabelFirst.alpha = 0
            complaintTextViewLabelSecond.alpha = 0
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if complaintReasonTextField.hasText == false {
            complaintTextFieldLabelFirst.alpha = 0.5
            complaintTextFieldLabelSecond.alpha = 0.5
        } else {
            complaintTextFieldLabelFirst.alpha = 0
            complaintTextFieldLabelSecond.alpha = 0
        }
    }
    
    
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        complaintTextFieldLabelFirst.alpha = 0
        complaintTextFieldLabelSecond.alpha = 0
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }

    
}
