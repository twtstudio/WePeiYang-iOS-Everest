//
//  FourProgressRateController.swift
//  WePeiYang
//
//  Created by 赵家琛 on 2017/9/29.
//  Copyright © 2017年 twtstudio. All rights reserved.
//

import UIKit

class FourProgressRateController: UIViewController {
    
    var tabelView: UITableView!
    var oneSubView: UIView!
    var twoSubView: UIView!
    var threeSubView: UIView!
    var itemRepairLabel: UILabel!
    var itemLabel: UILabel = UILabel()
    var detailRepairLabel: UILabel!
    var detailLabel: UILabel = UILabel()
    var locationRepairLabel: UILabel!
    var locationLabel: UILabel = UILabel()
    var timeRepairLabel: UILabel!
    var timeLabel: UILabel = UILabel()
    var imageView: UIImageView!
    var oneLabel: UILabel!
    var twoLabel: UILabel!
    var threeLabel: UILabel!
    var fourLabel: UILabel!
    var stateRepairLabel: UILabel!
    var numberRepairLabel: UILabel!
    var stateLabel: UILabel!
    var numberLabel: UILabel!
    var ButtonLeft: UIButton!
    var ButtonRight: UIButton!
    var list: [String] = [String]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(red: 239.0 / 255.0, green: 239.0 / 255.0, blue: 244.0 / 255.0, alpha: 1.0)
        
        oneSubView = UIView(color: .white)
        oneSubView.layer.cornerRadius = 5
        twoSubView = UIView(color: .white)
        twoSubView.layer.cornerRadius = 5
        threeSubView = UIView(color: UIColor.gray)
        
        itemRepairLabel = UILabel(text: "报修项目", color: .darkGray)
        itemRepairLabel.font = UIFont.systemFont(ofSize: 11)
        detailRepairLabel = UILabel(text: "补充说明", color: .darkGray)
        detailRepairLabel.font = UIFont.systemFont(ofSize: 11)
        locationRepairLabel = UILabel(text: "维修地点", color: .darkGray)
        locationRepairLabel.font = UIFont.systemFont(ofSize: 11)
        timeRepairLabel = UILabel(text: "报修时间", color: .darkGray)
        timeRepairLabel.font = UIFont.systemFont(ofSize: 11)
        //itemLabel = UILabel()
        itemLabel.font = UIFont.systemFont(ofSize: 11)
        itemLabel.textColor = .black
        //detailLabel = UILabel()
        detailLabel.font = UIFont.systemFont(ofSize: 11)
        detailLabel.textColor = .black
        //locationLabel = UILabel()
        locationLabel.font = UIFont.systemFont(ofSize: 11)
        locationLabel.textColor = .black
        //timeLabel = UILabel()
        timeLabel.font = UIFont.systemFont(ofSize: 11)
        timeLabel.textColor = .black
        
        //        let image = ImageData.repairHalfImage
        //        image?.size = CGSize(width: self.view.bounds.size.width - 10, height: 10)
        //        imageView = UIImageView()
        //        imageView.image = image.re
        imageView = UIImageView(image: ImageData.repairHalfImage)
        oneLabel = UILabel()
        twoLabel = UILabel()
        threeLabel = UILabel()
        fourLabel = UILabel()
        stateLabel = UILabel()
        numberLabel = UILabel()
        stateRepairLabel = UILabel()
        numberRepairLabel = UILabel()
        
        stateLabel = UILabel()
        stateLabel.font = UIFont.systemFont(ofSize: 11)
        stateLabel.textColor = .black
        
        numberLabel = UILabel()
        numberLabel.font = UIFont.systemFont(ofSize: 11)
        numberLabel.textColor = .black
        
        stateRepairLabel = UILabel(text: "维修状态", color: .darkGray)
        stateRepairLabel.font = UIFont.systemFont(ofSize: 11)
        numberRepairLabel = UILabel(text: "报修单号", color: .darkGray)
        numberRepairLabel.font = UIFont.systemFont(ofSize: 11)
        
        
        oneSubView.addSubview(detailRepairLabel)
        oneSubView.addSubview(itemRepairLabel)
        oneSubView.addSubview(locationRepairLabel)
        oneSubView.addSubview(timeRepairLabel)
        oneSubView.addSubview(itemLabel)
        oneSubView.addSubview(detailLabel)
        oneSubView.addSubview(locationLabel)
        oneSubView.addSubview(timeLabel)
        
        twoSubView.addSubview(imageView)
        twoSubView.addSubview(threeSubView)
        
        self.view.addSubview(oneSubView)
        self.view.addSubview(twoSubView)
        self.view.addSubview(oneLabel)
        self.view.addSubview(twoLabel)
        self.view.addSubview(threeLabel)
        self.view.addSubview(fourLabel)
        let wid = self.view.bounds.width / 4
        
        oneSubView.snp.makeConstraints { make in
            make.left.equalTo(5)
            make.right.equalTo(-5)
            make.top.equalTo(70)
            make.height.equalTo(90)
        }
        
        twoSubView.snp.makeConstraints { make in
            make.left.equalTo(5)
            make.right.equalTo(-5)
            make.top.equalTo(165)
            make.height.equalTo(230)
        }
        
        itemRepairLabel.snp.makeConstraints { make in
            make.left.equalTo(8)
            make.width.equalTo(50)
            make.height.equalTo(15)
            make.top.equalTo(6)
        }
        
        detailRepairLabel.snp.makeConstraints { make in
            make.left.equalTo(8)
            make.width.equalTo(50)
            make.height.equalTo(15)
            make.top.equalTo(27)
        }
        
        locationRepairLabel.snp.makeConstraints { make in
            make.left.equalTo(8)
            make.width.equalTo(50)
            make.height.equalTo(15)
            make.bottom.equalTo(-27)
        }
        
        timeRepairLabel.snp.makeConstraints { make in
            make.left.equalTo(8)
            make.width.equalTo(50)
            make.height.equalTo(15)
            make.bottom.equalTo(-6)
        }
        
        
        itemLabel.snp.makeConstraints { make in
            make.left.equalTo(75)
            make.width.equalTo(200)
            make.height.equalTo(15)
            make.top.equalTo(6)
        }
        
        detailLabel.snp.makeConstraints { make in
            make.left.equalTo(75)
            make.width.equalTo(200)
            make.height.equalTo(15)
            make.top.equalTo(27)
        }
        
        locationLabel.snp.makeConstraints { make in
            make.left.equalTo(75)
            make.width.equalTo(200)
            make.height.equalTo(15)
            make.bottom.equalTo(-27)
        }
        
        timeLabel.snp.makeConstraints { make in
            make.left.equalTo(75)
            make.width.equalTo(200)
            make.height.equalTo(15)
            make.bottom.equalTo(-6)
        }
        
        imageView.snp.makeConstraints { make in
            make.right.equalTo(0);
            make.top.equalTo(15)
            make.left.equalTo(0)
            make.height.equalTo(0.04 * (self.view.bounds.width - 10))
        }
        
        oneLabel.text = "已上报"
        oneLabel.textColor = UIColor(red: 0.55, green: 0.78, blue: 0.59, alpha: 1.00)
        //labelOne.alpha = 0.5
        oneLabel.textAlignment = .center
        oneLabel.font = UIFont.systemFont(ofSize: 10)
        oneLabel.snp.makeConstraints { make in
            make.width.equalTo(wid)
            make.height.equalTo(15)
            make.top.equalTo(200)
            make.left.equalTo(0)
        }
        
        twoLabel.text = "已接受"
        twoLabel.textColor = UIColor(red: 0.55, green: 0.78, blue: 0.59, alpha: 1.00)
        //labelTwo.alpha = 0.5
        twoLabel.textAlignment = .center
        twoLabel.font = UIFont.systemFont(ofSize: 10)
        twoLabel.snp.makeConstraints { make in
            make.width.equalTo(wid)
            make.height.equalTo(15)
            make.top.equalTo(200)
            make.left.equalTo(wid)
        }
        
        threeLabel.text = "已维修"
        threeLabel.textColor = UIColor(red: 0.55, green: 0.78, blue: 0.59, alpha: 1.00)
        //labelThree.alpha = 0.5
        threeLabel.textAlignment = .center
        threeLabel.font = UIFont.systemFont(ofSize: 10)
        threeLabel.snp.makeConstraints { make in
            make.width.equalTo(wid)
            make.height.equalTo(15)
            make.top.equalTo(200)
            make.left.equalTo(wid * 2)
        }
        
        fourLabel.text = "已完成"
        fourLabel.textColor = UIColor.black
        fourLabel.alpha = 0.5
        fourLabel.textAlignment = .center
        fourLabel.font = UIFont.systemFont(ofSize: 10)
        fourLabel.snp.makeConstraints { make in
            make.width.equalTo(wid)
            make.height.equalTo(15)
            make.top.equalTo(200)
            make.left.equalTo(wid * 3)
        }
        
        threeSubView.snp.makeConstraints { make in
            make.left.equalTo(0);
            make.right.equalTo(0)
            make.height.equalTo(1)
            make.top.equalTo(60)
        }
        threeSubView.alpha = 0.5
        
        
        
        tabelView = UITableView()
        tabelView.register(ListCell.self, forCellReuseIdentifier: "listCell")
        tabelView.separatorStyle = .none
        tabelView.delegate = self
        tabelView.dataSource = self
        tabelView.estimatedRowHeight = 50
        tabelView.rowHeight = UITableViewAutomaticDimension
        tabelView.isScrollEnabled = false
        twoSubView.addSubview(tabelView)
        tabelView.snp.makeConstraints { make in
            make.left.equalTo(0)
            make.right.equalTo(0)
            make.top.equalTo(65)
            make.bottom.equalTo(-35)
        }
        
        ButtonLeft = UIButton(title: "维修完成，去评价")
        ButtonLeft.setTitleColor(UIColor.black, for: .normal)
        twoSubView.addSubview(ButtonLeft)
        ButtonLeft.titleLabel?.font = UIFont.systemFont(ofSize: 11)
        ButtonLeft.layer.cornerRadius = 5
        ButtonLeft.backgroundColor = UIColor(red: 254.0 / 255.0, green: 210.0 / 255.0, blue: 44.0 / 255.0, alpha: 1.0)
        ButtonLeft.snp.makeConstraints { make in
            make.centerX.equalTo(self.view.bounds.width / 4 + 20)
            make.width.equalTo(100)
            make.height.equalTo(25)
            make.bottom.equalTo(-5)
        }
        ButtonLeft.addTarget(self, action: #selector(clickMeOne), for: .touchUpInside)
        
        ButtonRight = UIButton(title: "有疑问？去投诉")
        twoSubView.addSubview(ButtonRight)
        ButtonRight.layer.borderWidth = 0.5
        ButtonRight.layer.borderColor = UIColor.darkGray.cgColor
        ButtonRight.setTitleColor(UIColor.black, for: .normal)
        ButtonRight.titleLabel?.font = UIFont.systemFont(ofSize: 11)
        ButtonRight.layer.cornerRadius = 5
        ButtonRight.snp.makeConstraints { make in
            make.centerX.equalTo(self.view.bounds.width * 3 / 4 - 20)
            make.width.equalTo(100)
            make.height.equalTo(25)
            make.bottom.equalTo(-5)
        }
        ButtonRight.addTarget(self, action: #selector(clickMeTwo), for: .touchUpInside)
        ButtonRight.isEnabled = false
        ButtonLeft.isEnabled = false
        
        
    }
    
    func clickMeOne() -> Void {
        
        let evaluationController = EvaluateViewController()
        evaluationController.id = list[1]
        
        self.navigationController?.pushViewController(evaluationController, animated: true)
    }
    
    func clickMeTwo() -> Void {
        let complaintController = ComplaintViewController()
        complaintController.id = list[1]
        self.navigationController?.pushViewController(complaintController, animated: true)
    }
    
}

extension FourProgressRateController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "listCell", for: indexPath) as! ListCell
        if indexPath.row == 0 {
            cell.leftLabel.text = "维修状态"
            cell.rightLabel.text = list[0]
        } else if indexPath.row == 1 {
            cell.leftLabel.text = "报修单号"
            cell.rightLabel.text = list[1]
        } else if indexPath.row == 2 {
            cell.leftLabel.text = "维修负责人"
            cell.rightLabel.text = list[2]
        } else {
            cell.leftLabel.text = "联系电话"
            cell.rightLabel.text = list[3]
        }
        return cell
    }
    
}

