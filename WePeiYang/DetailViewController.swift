//
//  DetailViewController.swift
//  WePeiYang
//
//  Created by Hado on 2017/7/14.
//  Copyright © 2017年 twtstudio. All rights reserved.
//

import UIKit
import SnapKit
import SDWebImage


class DetailViewController: UIViewController {
    
    var detailView : UIView!
    var detailImageView = UIImageView()
    var detailTitleLabel = UILabel()
    let detailApi = DetailAPI()
    let TWT_URL = "http://open.twtstudio.com/"
    var imageURL = ""
    
    var id = 0
//    var detailLabel = UILabel()
    var Y = 30
    
    let detailImageArray = ["详情 时间","详情 地点","详情 分类","详情 姓名","详情 联系方式","附言"]
    
    var detailArray: [LostFoundDetailModel] = []
    var detailDisplayArray: [String] = []

 
    

    override func viewDidLoad() {
        super.viewDidLoad()
        

        
        self.detailView = UIView(frame: self.view.bounds)
        self.view.addSubview(self.detailView)
        detailView.backgroundColor = .white
//        detailImageView.image = UIImage(named: dic["time"]!)
//        detailTitleLabel.backgroundColor = .black
        
        self.view.addSubview(detailImageView)
        self.view.addSubview(detailTitleLabel)
        print(id)
        
        refresh()

        
//        enumeratedImage()
//        enumeratedLabel()
        
        
        
//        detailTitleLabel.center.x = self.view.bounds.width/2
        
        detailImageView.snp.makeConstraints{
            make in
            make.left.equalToSuperview().offset(-5)
            make.top.equalToSuperview().offset(0)
            make.right.equalToSuperview().offset(5)
            make.width.equalTo(self.view.frame.width)
            make.height.equalTo(320)

        
        }

        print(detailImageView.frame.width)

    }
    // Mark - 更新UI
    func refresh() {
        detailApi.getDetail(id: id, success: { (details) in
            self.detailArray = details
            self.detailDisplayArray = [self.detailArray[0].time,self.detailArray[0].place, "\(self.detailArray[0].detail_type)", self.detailArray[0].name, self.detailArray[0].phone, self.detailArray[0].item_description]
            print(self.detailDisplayArray)
            
            for (index, name) in self.detailImageArray.enumerated(){
                
                let imageView = UIImageView(frame: CGRect(x: 50, y: 400+CGFloat(index*self.Y), width: 20, height: 20))
                imageView.image = UIImage(named: name)
                self.view.addSubview(imageView)
            }
            
            for (index, name) in self.detailDisplayArray.enumerated(){
                let label = UILabel(frame: CGRect(x: 80, y: 400+CGFloat(index*self.Y), width: 200, height: 20))
                print(self.detailDisplayArray)
                
                label.text = name
                self.view.addSubview(label)
                
            }
            
            print(self.detailArray[0].picture)
            if self.detailArray[0].picture == "" {
                self.imageURL = "uploads/17-07-12/945139dcd91e9ed3d5967ef7f81e18f6.jpg"
            
            } else {
                self.imageURL = self.detailArray[0].picture
            }
            self.detailImageView.sd_setImage(with: URL(string: self.TWT_URL + self.imageURL))
            self.detailImageView.snp.makeConstraints{
                make in
                make.left.equalToSuperview().offset(-5)
                make.top.equalToSuperview().offset(0)
                make.right.equalToSuperview().offset(5)
                make.width.equalTo(self.view.frame.width)
                make.height.equalTo(320)
                
                
            }
            self.detailTitleLabel.text = self.detailArray[0].title
            self.detailTitleLabel.textAlignment = .center
            self.detailTitleLabel.snp.makeConstraints{
                make in
                make.top.equalTo(self.detailImageView.snp.bottom).offset(10)
                make.width.equalTo(250)
                make.height.equalTo(50)
                make.centerX.equalTo(self.view.bounds.width/2)
                
            }
            
            
            
        
        }, failure: { error in
            print(error)
        
        
        })
    }
//    func enumeratedImage(){
//    
//        for (index, name) in detailImageArray.enumerated(){
//        
//            let imageView = UIImageView(frame: CGRect(x: 50, y: 400+CGFloat(index*Y), width: 20, height: 20))
//            imageView.image = UIImage(named: name)
//            self.view.addSubview(imageView)
//        }
//        
//    }


//    func enumeratedLabel(){
//        for (index, name) in detailDisplayArray.enumerated(){
//            let label = UILabel(frame: CGRect(x: 80, y: 400+CGFloat(index*Y), width: 200, height: 20))
//            print(self.detailDisplayArray)
//            
//            label.text = name
//            self.view.addSubview(label)
//            
//        }
//        
//    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    



}
