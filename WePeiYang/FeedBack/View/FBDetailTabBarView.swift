//
//  FBDetailTabBarView.swift
//  WePeiYang
//
//  Created by Zr埋 on 2020/9/24.
//  Copyright © 2020 twtstudio. All rights reserved.
//

import UIKit

class FBDetailTabBarView: UIView {
     internal var commentBtn: UIButton!
     var likeBtn: UIButton!
     
     override init(frame: CGRect) {
//          self.init(frame: CGRect(x: 0, y: 0, width: SCREEN.width, height: 40))
          super.init(frame: frame)
          backgroundColor = .white
          addShadow(.black, sRadius: 5, sOpacity: 0.3, offset: (0, -1))
          
          commentBtn = UIButton()
          commentBtn.layer.cornerRadius = 20
          commentBtn.layer.masksToBounds = true
          commentBtn.setTitle("发表你的看法", for: .normal)
          commentBtn.setTitleColor(.gray, for: .normal)
          commentBtn.titleLabel?.textAlignment = .center
          commentBtn.backgroundColor = UIColor(hex6: 0xe2e2e2)
          addSubview(commentBtn)
          commentBtn.snp.makeConstraints { (make) in
               make.left.equalTo(self).offset(15)
               make.width.equalTo(SCREEN.width * 0.7)
               make.height.equalTo(40)
               make.top.equalTo(self).offset(10)
          }
          
          likeBtn = UIButton()
          likeBtn.setImage(UIImage(named: "feedback_thumb_up"), for: .normal)
          addSubview(likeBtn)
          likeBtn.snp.makeConstraints { (make) in
               make.top.equalTo(self).offset(10)
               make.width.height.equalTo(40)
               make.right.equalTo(self).offset(-20)
          }
          
     }
     
     required init?(coder: NSCoder) {
          fatalError("init(coder:) has not been implemented")
     }
     
}
