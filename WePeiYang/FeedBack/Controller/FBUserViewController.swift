//
//  FBUserViewController.swift
//  WePeiYang
//
//  Created by Zr埋 on 2020/9/29.
//  Copyright © 2020 twtstudio. All rights reserved.
//

import UIKit

class FBUserViewController: UIViewController {
     
     var userImg: UIImageView!
     
     var myQBtn: UIButton! // 我发布的问题
     var myTQBtn: UIButton! // 我点赞过的问题
     
     
     override func viewDidLoad() {
          super.viewDidLoad()
          setUp()
     }
}

//MARK: - UI & Data
extension FBUserViewController {
     private func setUp() {
          view.backgroundColor = .white
          navigationItem.title = "个人中心"
          
          myQBtn = UIButton()
          view.addSubview(myQBtn)
          myQBtn.tag = 0
          myQBtn.setTitle("我发布的问题", for: .normal)
          myQBtn.setTitleColor(.black, for: .normal)
          myQBtn.addTarget(self, action: #selector(loadData(btn:)), for: .touchUpInside)
          myQBtn.layer.cornerRadius = 15
          myQBtn.layer.masksToBounds = true
          myQBtn.snp.makeConstraints { (make) in
               make.centerX.equalTo(view)
               make.top.equalTo(SCREEN.height / 2)
               make.width.equalTo(SCREEN.width / 2)
               make.height.equalTo(100)
          }
          
          myTQBtn = UIButton()
          view.addSubview(myTQBtn)
          myTQBtn.tag = 1
          myTQBtn.setTitle("我点赞的问题", for: .normal)
          myTQBtn.setTitleColor(.black, for: .normal)
          myTQBtn.addTarget(self, action: #selector(loadData(btn:)), for: .touchUpInside)
          myTQBtn.layer.cornerRadius = 15
          myTQBtn.layer.masksToBounds = true
          myTQBtn.snp.makeConstraints { (make) in
               make.centerX.equalTo(view)
               make.top.equalTo(myQBtn.snp.bottom).offset(50)
               make.width.equalTo(SCREEN.width / 2)
               make.height.equalTo(100)
          }
          
     }
     
     override func viewDidLayoutSubviews() {
          super.viewDidLayoutSubviews()
          myQBtn.addShadow(.black, sRadius: 5, sOpacity: 0.2, offset: (3, 3))
          myTQBtn.addShadow(.black, sRadius: 5, sOpacity: 0.2, offset: (3, 3))
     }
     
     @objc func loadData(btn: UIButton) {
          let qvc = FBQuestionTableViewController()
          qvc.title = btn.tag == 0 ? "我发布的问题" : "我点赞的问题"
          qvc.type = btn.tag == 0 ? .posted : .thumbed
          navigationController?.pushViewController(qvc, animated: true)
     }
}
