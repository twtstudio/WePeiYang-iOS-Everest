//
//  OperationDetail.swift
//  WePeiYang
//
//  Created by 赵家琛 on 2017/9/5.
//  Copyright © 2017年 twtstudio. All rights reserved.
//


import UIKit

class OperationDetail: UIViewController {
    var isSubmit: Bool = false
    var isComplaint: Bool = false
    var isLocation: Bool = false
    var label: UILabel?
    var image: UIImage?
    var imageView: UIImageView?
    var content: String = ""
    var subView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func check(submitSituation: Bool, complaintSituation: Bool, locationSituation: Bool) {
        subView = UIView()
        isSubmit = submitSituation
        isComplaint = complaintSituation
        isLocation = locationSituation
        if isLocation {
            if isComplaint {
                //isComplaint: true, isLocation: true
                content += "您的投诉需求已提交，我们将会认真对待"
                image = UIImage(named: "repair_success.png")
                
            } else {
                //isComplaint: false, isLocation: true;
                content += "您的投诉信息提交失败，如有需要请发邮件至邮箱1919537704@qq.com"
                image = UIImage(named: "repair_fail.png")
            }
        } else {
            if isSubmit {
                //isSubmit: true, isLocation: false
                content += "您的报修需求已提交，通常维修方法将在一个工作日内给予应答，否则系统将自动重新提交，请耐心等候～"
                image = UIImage(named: "repair_success.png")
            } else {
                //isSubmit: false, isLocation: false
                content += "您的报修信息提交失败，请稍后尝试"
                image = UIImage(named: "repair_fail.png")
            }
        }
       
        label = UILabel()
        label?.font = UIFont.systemFont(ofSize: 11)
        label?.text = content
        label?.lineBreakMode = .byWordWrapping
        label?.numberOfLines = 0
        label?.backgroundColor = UIColor.white
        label?.textAlignment = .center
        
        imageView = UIImageView()
        imageView?.image = image
        imageView?.backgroundColor = UIColor.white
        
        subView.addSubview(label!)
        subView.addSubview(imageView!)
        self.view.addSubview(subView)
        subView.backgroundColor = UIColor.white
        self.view.backgroundColor = UIColor(red: 239.0 / 255.0, green: 239.0 / 255.0, blue: 244.0 / 255.0, alpha: 1.0)
        
        subView.snp.makeConstraints { make in
            make.left.equalTo(5)
            make.right.equalTo(-5)
            make.top.equalTo(70)
            make.height.equalTo(100)
        }
        
        label?.snp.makeConstraints { make in
            make.left.equalTo(20)
            make.right.equalTo(-20)
            make.top.equalTo(50)
            make.height.equalTo(50)
        }
        
        imageView?.snp.makeConstraints { make in
            make.width.height.equalTo(35)
            make.centerX.equalTo(subView)
            make.top.equalTo(10)
        }
        
    }
    
//    self.navigationController?.popToViewController((self.navigationController?.viewControllers[1])!, animated: true)
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        //返回首页
        if isLocation {
            if isComplaint {
            self.navigationController?.popToViewController((self.navigationController?.viewControllers[1])!, animated: true)
            }
        } else {
            if isSubmit {
            self.navigationController?.popToViewController((self.navigationController?.viewControllers[1])!, animated: true)
            }
        }
    }
    
    
}
