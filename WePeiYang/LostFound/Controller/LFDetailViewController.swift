//
//  LFDetailViewController.swift
//  WePeiYang
//
//  Created by JasonEWNL on 2018/10/20.
//  Copyright © 2018年 twtstudio. All rights reserved.
//

import UIKit
import SDWebImage

class LFDetailViewController: UIViewController {
    
    var detailImageView = UIImageView()
    var detailTitleLabel = UILabel()
    let detailApi = DetailAPI()
    var imageURL = ""
    
    var id = 0
    var Y = 30

    let detailImageArray = [#imageLiteral(resourceName: "LFTime"), #imageLiteral(resourceName: "LFLocation"), #imageLiteral(resourceName: "LFObject"), #imageLiteral(resourceName: "LFLook"), #imageLiteral(resourceName: "LFPencil"), #imageLiteral(resourceName: "LFBlueCategory")] //"详情 时间", "详情 地点", "详情 分类", "详情 姓名", "详情 联系方式", "附言"]
    var markArray = ["身份证", "饭卡", "手机", "钥匙", "书包", "手表&饰品", "U盘&硬盘", "水杯", "钱包", "银行卡", "书", "伞", "其他"]
    
//    var detailArray: [LostFoundDetailModel] = []
//    var detailArray: [LFDetailModel] = []
    var detail: LFDetailModel!
    var detailDisplayArray: [String] = []
    var image = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let scrollView = UIScrollView(frame: view.frame)
        scrollView.contentSize = CGSize(width: view.width, height: view.height * 2)
        scrollView.bounces = false
        self.view = scrollView
        
        initUI()
        refresh()
        
//        let btn = ButtonGroups()
//        btn.setButtonColor(_textColor: .white, _btnColor: .blue)
//        let cvc = btn.addButtonGroupsToCell(buttonArr: markArray, mainAction: (name: "发布丢失信息", function: {
//            let vc = MyLostFoundPageViewController(viewControllerClasses: [MyLostViewController.self, MyFoundViewController.self], andTheirTitles: ["我的丢失", "我的发布"])
//            self.navigationController?.pushViewController(vc, animated: true)
//        }))
//        self.view.addSubview(cvc!)
    }
    
    func initUI() {
        self.view.backgroundColor = .white
        
        self.detailImageView.contentMode = .scaleAspectFit
        self.detailImageView.frame = CGRect(x: 0, y: 0, width: self.view.bounds.width, height: 320)
        self.detailImageView.isUserInteractionEnabled = true
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(share))
        self.view.addSubview(detailImageView)
        self.view.addSubview(detailTitleLabel)
        let tapSingle = UITapGestureRecognizer(target: self, action: #selector(swipeClicked))
        tapSingle.numberOfTapsRequired = 1
        tapSingle.numberOfTouchesRequired = 1
        detailImageView.addGestureRecognizer(tapSingle)
    }
    
    func refresh() {
//        detailApi.getDetail(id: "\(id)", success: { details in
//            self.detailArray = details
//            self.detailDisplayArray = [self.detailArray[0].time, self.detailArray[0].place, "\(self.detailArray[0].detailType)", self.detailArray[0].name, self.detailArray[0].phone, self.detailArray[0].item_description]
//
//            var lastLabel: UILabel!
//            var labels: [UILabel] = []
//            for (index, name) in self.detailDisplayArray.enumerated() {
//                let label = UILabel()
//                labels.append(label)
//                label.numberOfLines = 0
//                self.view.addSubview(label)
//                if index == 2, let mark = Int(name) {
//                    label.text = self.markArray[mark]
//                }
//                label.textColor = .lightGray
//                label.text = name
//                label.sizeToFit()
//
//                if index == 0 {
//                    label.snp.makeConstraints { make in
//                        make.left.equalToSuperview().offset(80)
//                        make.top.equalToSuperview().offset(400)
//                        make.right.equalToSuperview().offset(-50)
//                        make.width.equalTo(UIScreen.main.bounds.width - 130)
//                    }
//                    lastLabel = label
//                } else {
//                    label.snp.makeConstraints { make in
//                        make.left.equalToSuperview().offset(80)
//                        make.top.equalTo(lastLabel.snp.bottom).offset(10)
//                        make.right.equalToSuperview().offset(-50)
//                        make.width.equalTo(UIScreen.main.bounds.width - 130)
//                    }
//                    lastLabel = label
//                }
//            }
//
//            lastLabel.snp.makeConstraints { make in
//                make.bottom.equalToSuperview().offset(-40)
//            }
//
//            for (index, name) in self.detailImageArray.enumerated() {
//                let imageView = UIImageView(image: UIImage(named: name))
//
//                self.view.addSubview(imageView)
//                imageView.snp.makeConstraints { make in
//                    make.left.equalToSuperview().offset(50)
//                    make.top.equalTo(labels[index].snp.top)
//                    make.width.height.equalTo(20)
//                }
//            }
//
//            if self.detailArray[0].picture == "" {
//                self.detailImageView.image = UIImage(named: "暂无图片")
//            } else {
//                self.imageURL = self.detailArray[0].picture
//                let TWT_URL = "http://open.twtstudio.com/"
//                self.detailImageView.sd_setImage(with: URL(string: TWT_URL + self.imageURL))
//                self.image = TWT_URL + self.imageURL
//            }
//
//            self.detailTitleLabel.text = self.detailArray[0].title
//            self.detailTitleLabel.textAlignment = .center
//            self.detailTitleLabel.numberOfLines = 0
//            self.detailTitleLabel.font = UIFont.preferredFont(forTextStyle: .title3)
//            self.detailTitleLabel.snp.makeConstraints { make in
//                make.top.equalTo(self.detailImageView.snp.bottom).offset(10)
//                make.width.equalTo(250)
//                make.centerX.equalToSuperview()
//            }
//        }) { _ in
//        }
        LostFoundHelper.getLFDetail(id: id, success: { detail in
            self.detail = detail
            guard let detailData = detail.data else { return }
            self.detailDisplayArray = [detailData.time ?? "", detailData.place ?? "", "\(detailData.detailType!)", detailData.name ?? "", detailData.phone ?? "", detailData.itemDescription ?? ""]
            
            var lastLabel: UILabel!
            var labels: [UILabel] = []
            for (index, name) in self.detailDisplayArray.enumerated() {
                let label = UILabel()
                labels.append(label)
                label.numberOfLines = 0
                self.view.addSubview(label)
                if index == 2, let mark = Int(name) {
                    label.text = self.markArray[mark-1]
                }
                label.textColor = .lightGray
                label.text = name
                label.sizeToFit()
                
                if index == 0 {
                    label.snp.makeConstraints { make in
                        make.left.equalToSuperview().offset(80)
                        make.top.equalToSuperview().offset(400)
                        make.right.equalToSuperview().offset(-50)
                        make.width.equalTo(UIScreen.main.bounds.width - 130)
                    }
                    lastLabel = label
                } else {
                    label.snp.makeConstraints { make in
                        make.left.equalToSuperview().offset(80)
                        make.top.equalTo(lastLabel.snp.bottom).offset(10)
                        make.right.equalToSuperview().offset(-50)
                        make.width.equalTo(UIScreen.main.bounds.width - 130)
                    }
                    lastLabel = label
                }
            }
            
            lastLabel.snp.makeConstraints { make in
                make.bottom.equalToSuperview().offset(-40)
            }
            
            for (index, image) in self.detailImageArray.enumerated() {
                let imageView = UIImageView(image: image)
                imageView.contentMode = .scaleAspectFill
                self.view.addSubview(imageView)
                imageView.snp.makeConstraints { make in
                    make.left.equalToSuperview().offset(50)
                    make.top.equalTo(labels[index].snp.top)
                    make.width.height.equalTo(20)
                }
            }
            
            if let picture = detailData.picture {
                if picture[0] == "" {
                    self.detailImageView.image = #imageLiteral(resourceName: "LFNoImage")
                } else {
                    self.imageURL = picture[0]
                    // let TWT_URL = "http://open.twtstudio.com/"
                    self.detailImageView.sd_setImage(with: URL(string: TWT_URL + self.imageURL))
                    self.image = TWT_URL + self.imageURL
                }
            }
            
            self.detailTitleLabel.text = detailData.title!
            self.detailTitleLabel.textAlignment = .center
            self.detailTitleLabel.numberOfLines = 0
            self.detailTitleLabel.font = UIFont.preferredFont(forTextStyle: .title3)
            self.detailTitleLabel.snp.makeConstraints { make in
                make.top.equalTo(self.detailImageView.snp.bottom).offset(10)
                make.width.equalTo(250)
                make.centerX.equalToSuperview()
            }
        }) { _ in
        }
    }
    
    @objc func share() {
        let vc = UIActivityViewController(activityItems: [#imageLiteral(resourceName: "LFNoImage"), "[失物招领]\(self.detail.data!.title!)", URL(string: "http://open.twtstudio.com/lostfound/detail.html#\(id)")!], applicationActivities: [])
        present(vc, animated: true, completion: nil)
    }
    
    @objc func swipeClicked(recogizer: UITapGestureRecognizer) {
        let previewVC = LFImagePreviewViewController(image: image)
        self.present(previewVC, animated: true, completion: nil)
    }
}
