//
//  PublishSuccessViewController.swift
//  WePeiYang
//
//  Created by Hado on 2017/7/19.
//  Copyright © 2017年 twtstudio. All rights reserved.
//

import UIKit
import SnapKit

class PublishSuccessViewController: UIViewController {
    

    let titleLabel = UILabel()
    let titleImage = UIImageView()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "分享/发布"
        self.view.backgroundColor = UIColor(hex6: 0xeeeeee)
        let successView = UIView(frame: CGRect(x: 20, y: 110, width: self.view.frame.width-40, height: 70))
        successView.backgroundColor = .white
        titleLabel.text = "发布成功"
        self.view.addSubview(successView)
        self.view.addSubview(titleImage)
        self.view.addSubview(titleLabel)
        
        titleImage.image = #imageLiteral(resourceName: "对勾(1)")
        titleImage.snp.makeConstraints {
            make in
            make.top.equalTo(successView.snp.top).offset(25)
            make.left.equalTo(successView.snp.left).offset(successView.frame.width/2-45)
            make.bottom.equalTo(successView.snp.bottom).offset(-25)
            make.height.equalTo(20)
            make.width.equalTo(20)
        }
        
        titleLabel.snp.makeConstraints{
        
            make in
            make.top.equalTo(successView.snp.top).offset(20)
            make.left.equalTo(titleImage.snp.left).offset(20)
            make.right.equalTo(successView.snp.right).offset(-30)
            make.bottom.equalTo(successView.snp.bottom).offset(-20)
            
        }
        
        // Do any additional setup after loading the view.
    }
    


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    


}
