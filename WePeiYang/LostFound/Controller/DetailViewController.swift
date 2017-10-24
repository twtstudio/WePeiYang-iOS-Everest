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
    
//    var detailView : UIView!
    var detailImageView = UIImageView()
    var detailTitleLabel = UILabel()
    let detailApi = DetailAPI()
    let TWT_URL = "http://open.twtstudio.com/"
    var imageURL = ""
    
    var id = ""
//    var detailLabel = UILabel()
    var Y = 30
    
    let detailImageArray = ["详情 时间","详情 地点","详情 分类","详情 姓名","详情 联系方式","附言"]
    
    var detailArray: [LostFoundDetailModel] = []
    var detailDisplayArray: [String] = []

 
    var image = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        

        self.view.backgroundColor = .white
//        self.detailView = UIView(frame: self.view.bounds)
//        self.view.addSubview(self.detailView)
//        detailView.backgroundColor = .white
//        detailImageView.image = UIImage(named: dic["time"]!)
//        detailTitleLabel.backgroundColor = .black
        
        self.detailImageView.contentMode = .scaleAspectFit
        self.detailImageView.frame = CGRect(x: 0, y: 62, width: self.view.bounds.width, height: 320)
        self.detailImageView.isUserInteractionEnabled = true
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(share))
        self.view.addSubview(detailImageView)
        self.view.addSubview(detailTitleLabel)
        print(id)

        
        refresh()
        print(image)
        let tapSingle = UITapGestureRecognizer(target: self, action: #selector(swipeClicked(recogizer:)))
        tapSingle.numberOfTapsRequired = 1
        tapSingle.numberOfTouchesRequired = 1
        detailImageView.addGestureRecognizer(tapSingle)
        
//        enumeratedImage()
//        enumeratedLabel()
        
        
        
//        detailTitleLabel.center.x = self.view.bounds.width/2
        
//        detailImageView.snp.makeConstraints{
//            make in
//            make.left.equalToSuperview().offset(-5)
//            make.top.equalToSuperview().offset(0)
//            make.right.equalToSuperview().offset(5)
//            make.width.equalTo(self.view.frame.width)
//            make.height.equalTo(320)
//
//        
//        }

        print(detailImageView.frame.width)

    }
    // Mark -- 更新UI
    func refresh() {
        detailApi.getDetail(id: id, success: { (details) in
            self.detailArray = details
            self.detailDisplayArray = [self.detailArray[0].time,self.detailArray[0].place, "\(self.detailArray[0].detail_type)", self.detailArray[0].name, self.detailArray[0].phone, self.detailArray[0].item_description]
            print(self.detailDisplayArray)
            
            for (index, name) in self.detailImageArray.enumerated(){
                
                let imageView = UIImageView(frame: CGRect(x: 50, y: 440+CGFloat(index*self.Y), width: 20, height: 20))
                imageView.image = UIImage(named: name)
                self.view.addSubview(imageView)
            }
            
            for (index, name) in self.detailDisplayArray.enumerated(){
                let label = UILabel(frame: CGRect(x: 80, y: 440+CGFloat(index*self.Y), width: 250, height: 20))
                print(self.detailDisplayArray)
                
                label.text = name
                self.view.addSubview(label)
                
            }
            
            print(self.detailArray[0].picture)
            if self.detailArray[0].picture == "" {
//                self.imageURL = "uploads/17-07-12/945139dcd91e9ed3d5967ef7f81e18f6.jpg" //暂无图片
                self.detailImageView.image = UIImage(named: "暂无图片")
            } else {
                self.imageURL = self.detailArray[0].picture
                self.detailImageView.sd_setImage(with: URL(string: self.TWT_URL + self.imageURL))
                self.image = self.TWT_URL + self.imageURL
            
                print(self.image)
            }
            
//            self.detailImageView.sd_setImage(with: URL(string: self.TWT_URL + self.imageURL))
//            self.detailImageView.contentMode = .scaleAspectFit
//            self.detailImageView.frame = CGRect(x: 0, y: 62, width: self.view.bounds.width, height: 320)
//            self.detailImageView.isUserInteractionEnabled = true
            
            
            self.detailTitleLabel.text = self.detailArray[0].title
            self.detailTitleLabel.textAlignment = .center
            self.detailTitleLabel.snp.makeConstraints{
                make in
                make.top.equalTo(self.detailImageView.snp.bottom).offset(10)
                make.width.equalTo(250)
                make.height.equalTo(40)
                make.centerX.equalTo(self.view.bounds.width/2)
                
            }
            
            
            
        
        }, failure: { error in
            print(error)
        
        
        })
    }

    
    // Mark -— Share
    
    func share() {
        
        let vc = UIActivityViewController(activityItems: [UIImage(named: "暂无图片")!, "[失物招领]\(self.detailArray[0].title)", URL(string: "http://open.twtstudio.com/lostfound/detail.html#\(id)")!], applicationActivities: [])
        present(vc, animated: true, completion: nil)
        print("https://open.twtstudio.com/lostfound/detail.html#\(id)")
    }
    
    func swipeClicked(recogizer: UITapGestureRecognizer) {
        
        let previewVC = LFImagePreviewViewController(image: image)
        self.navigationController?.pushViewController(previewVC, animated: true)
        
        
    
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    



}
