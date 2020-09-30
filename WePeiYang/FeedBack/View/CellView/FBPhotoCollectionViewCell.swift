//
//  FBPhotoCollectionViewCell.swift
//  WePeiYang
//
//  Created by Zr埋 on 2020/9/27.
//  Copyright © 2020 twtstudio. All rights reserved.
//

import UIKit

class FBPhotoCollectionViewCell: UICollectionViewCell {
     var imgView: UIImageView!
     
     override init(frame: CGRect) {
          super.init(frame: frame)
          imgView = UIImageView()
          contentView.addSubview(imgView)
          imgView.contentMode = .scaleToFill
          imgView.snp.makeConstraints { (make) in
               make.width.height.equalTo(self)
               make.center.equalTo(self)
          }
     }
     
     required init?(coder: NSCoder) {
          fatalError("init(coder:) has not been implemented")
     }
}
