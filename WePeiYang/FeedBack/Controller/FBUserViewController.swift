//
//  FBUserViewController.swift
//  WePeiYang
//
//  Created by Zr埋 on 2020/9/29.
//  Copyright © 2020 twtstudio. All rights reserved.
//

import UIKit
import IGIdenticon

class FBUserViewController: UIViewController {
     
     var userImg: UIImageView! // 头像
     var detialLabel: UILabel! // 信息
     
     private let cellID = "FBUSCVCell"
     var collectionView: UICollectionView!
     
     var myQBtn: UIButton! // 我发布的问题
     var myTQBtn: UIButton! // 我点赞过的问题
     
     var posted, thumbed, replied: Int!
     var user: FBUserModel!
     
     
     override func viewDidLoad() {
          super.viewDidLoad()
          setUp()
          loadData()
     }
}

//MARK: - UI & Data
extension FBUserViewController {
     private func setUp() {
          view.backgroundColor = UIColor(hex6: 0xf6f6f6)
          navigationItem.title = "个人中心"
          
          userImg = UIImageView()
          view.addSubview(userImg)
          userImg.backgroundColor = .white
          let imageGenerator = Identicon()
          userImg.image = imageGenerator.icon(from: arc4random(), size: CGSize(width: 88, height: 88))
          userImg.addCornerRadius(44)
//          userImg.sd_setImage(with: URL(string: TwTUser.shared.avatarURL ?? "")!, completed: nil)
          userImg.snp.makeConstraints { (make) in
               make.centerX.equalTo(view)
               make.centerY.equalTo(SCREEN.height * 0.2)
               make.width.height.equalTo(88)
          }
          
          detialLabel = UILabel()
          view.addSubview(detialLabel)
          detialLabel.backgroundColor = UIColor(hex6: 0xf6f6f6)
          detialLabel.text = (TwTUser.shared.schoolID ?? "") + "  " + (TwTUser.shared.realname ?? "")
          detialLabel.snp.makeConstraints { (make) in
               make.centerX.equalTo(userImg)
               make.top.equalTo(userImg.snp.bottom).offset(5)
          }
          
          let layout = UICollectionViewFlowLayout()
          layout.scrollDirection = .horizontal
          layout.itemSize = CGSize(width: 80, height: 80)
          layout.minimumLineSpacing = (SCREEN.width * 0.8 - 240) / 2
          
          collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
          collectionView.backgroundColor = .white
          collectionView.delegate = self
          collectionView.dataSource = self
          view.addSubview(collectionView)
          collectionView.register(FBUserStatusCollectionViewCell.self, forCellWithReuseIdentifier: cellID)
          collectionView.addCornerRadius(15)
          collectionView.snp.makeConstraints { (make) in
               make.top.equalTo(detialLabel.snp.bottom).offset(10)
               make.centerX.equalTo(view)
               make.width.equalTo(SCREEN.width * 0.8)
               make.height.equalTo(80)
          }
          
          myQBtn = UIButton()
          view.addSubview(myQBtn)
          myQBtn.tag = 0
          myQBtn.backgroundColor = .white
          myQBtn.setTitle("我发布的问题", for: .normal)
          myQBtn.setTitleColor(.black, for: .normal)
          myQBtn.addTarget(self, action: #selector(loadData(btn:)), for: .touchUpInside)
          myQBtn.layer.cornerRadius = 15
          myQBtn.layer.masksToBounds = true
          myQBtn.snp.makeConstraints { (make) in
               make.centerX.equalTo(view)
               make.top.equalTo(collectionView.snp.bottom).offset(30)
               make.width.equalTo(SCREEN.width * 0.7)
               make.height.equalTo(60)
          }
          
          myTQBtn = UIButton()
          view.addSubview(myTQBtn)
          myTQBtn.tag = 1
          myTQBtn.backgroundColor = .white
          myTQBtn.setTitle("我点赞的问题", for: .normal)
          myTQBtn.setTitleColor(.black, for: .normal)
          myTQBtn.addTarget(self, action: #selector(loadData(btn:)), for: .touchUpInside)
          myTQBtn.layer.cornerRadius = 15
          myTQBtn.layer.masksToBounds = true
          myTQBtn.snp.makeConstraints { (make) in
               make.centerX.equalTo(view)
               make.top.equalTo(myQBtn.snp.bottom).offset(10)
               make.width.equalTo(SCREEN.width * 0.7)
               make.height.equalTo(60)
          }
          
     }
     
     override func viewDidLayoutSubviews() {
          super.viewDidLayoutSubviews()
          collectionView.addShadow(.black, sRadius: 5, sOpacity: 0.2, offset: (1, 1))
          myQBtn.addShadow(.black, sRadius: 5, sOpacity: 0.2, offset: (1, 1))
          myTQBtn.addShadow(.black, sRadius: 5, sOpacity: 0.2, offset: (1, 1))
     }
     
     func loadData() {
          UserHelper.getDetail { (result) in
               switch result {
               case .success(let user):
                    self.user = user
                    self.collectionView.reloadData()
               case .failure(let err):
                    print(err)
               }
          }
     }
     
     @objc func loadData(btn: UIButton) {
          let qvc = FBQuestionTableViewController()
          qvc.title = btn.tag == 0 ? "我发布的问题" : "我点赞的问题"
          qvc.type = btn.tag == 0 ? .posted : .thumbed
          navigationController?.pushViewController(qvc, animated: true)
     }
}

//MARK: - Delegate
extension FBUserViewController: UICollectionViewDelegate, UICollectionViewDataSource {
     //    item个数
     func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
          return 3
     }
     
     //    对象
     func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
          let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as! FBUserStatusCollectionViewCell
          if user != nil {
               switch indexPath.row {
               case 0:
                    cell.update(title: "发布", cnt: (user.myQuestionNum ?? 0).description, addSeparator: true)
               case 1:
                    cell.update(title: "点赞", cnt: (user.myLikedQuestionNum ?? 0).description, addSeparator: true)
               default:
                    cell.update(title: "已回复", cnt: (user.mySolvedQuestionNum ?? 0).description)
               }
          }
          return cell
     }
}

