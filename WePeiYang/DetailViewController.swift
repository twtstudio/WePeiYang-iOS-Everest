//
//  DetailViewController.swift
//  WePeiYang
//
//  Created by Hado on 2017/7/14.
//  Copyright © 2017年 twtstudio. All rights reserved.
//

import UIKit
import SnapKit

class DetailViewController: UIViewController {
    
    var detailView : UIView!
    var detailImageView = UIImageView()
    var detailTitleLabel = UILabel()
//    var detailLabel = UILabel()
    var Y = 30
    
    let detailImageArray = ["详情 时间","详情 地点","详情 分类","详情 姓名","详情 联系方式","附言"]
    
    let dic : [String:String] = ["time":"pic3","place":"2---------------","time1":"3","time2":"4","time3":"5","time4":"6"]
    var array = [String]()

 
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        array.append(dic["place"]!)
        print(array)
        
        self.detailView = UIView(frame: self.view.bounds)
        self.view.addSubview(self.detailView)
        detailView.backgroundColor = .white
        detailImageView.image = UIImage(named: dic["time"]!)
        detailTitleLabel.backgroundColor = .black
        
        self.view.addSubview(detailImageView)
        self.view.addSubview(detailTitleLabel)
        
        enumeratedImage()
        enumeratedLabel()
        
        
        
//        detailTitleLabel.center.x = self.view.bounds.width/2
        
        detailImageView.snp.makeConstraints{
            make in
            make.left.equalToSuperview().offset(-1)
            make.top.equalToSuperview().offset(0)
            make.right.equalToSuperview().offset(0)
            make.width.equalTo(self.view.frame.width)
            make.height.equalTo(320)

        
        }
        
        detailTitleLabel.snp.makeConstraints{
            make in
            make.top.equalTo(detailImageView.snp.bottom).offset(10)
            make.width.equalTo(250)
            make.height.equalTo(50)
            make.centerX.equalTo(self.view.bounds.width/2)
        
        }
        print(detailImageView.frame.width)

    }
    
    func enumeratedImage(){
    
        for (index, name) in detailImageArray.enumerated(){
        
            let imageView = UIImageView(frame: CGRect(x: 50, y: 400+CGFloat(index*Y), width: 20, height: 20))
            imageView.image = UIImage(named: name)
            self.view.addSubview(imageView)
        }
        
    }
//    func enumratedceshi{
//        
//        
//        
//    }

    func enumeratedLabel(){
        for (index, name) in detailImageArray.enumerated(){
            let label = UILabel(frame: CGRect(x: 80, y: 400+CGFloat(index*Y), width: 200, height: 20))
            
            label.text = name
            self.view.addSubview(label)
            
        }
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    



}
