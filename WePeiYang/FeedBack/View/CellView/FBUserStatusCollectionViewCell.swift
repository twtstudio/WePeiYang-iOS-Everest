//
//  FBUserStatusCollectionViewCell.swift
//  WePeiYang
//
//  Created by Zr埋 on 2020/10/2.
//  Copyright © 2020 twtstudio. All rights reserved.
//

import UIKit

class FBUserStatusCollectionViewCell: UICollectionViewCell {
     var titleLabel: UILabel!
     var cntLabel: UILabel!
     
     override init(frame: CGRect) {
          super.init(frame: frame)
          
          titleLabel = UILabel()
          contentView.addSubview(titleLabel)
          titleLabel.snp.makeConstraints { (make) in
               make.centerX.equalTo(contentView)
               make.centerY.equalTo(80 / 3)
          }
          
          cntLabel = UILabel()
          contentView.addSubview(cntLabel)
          cntLabel.snp.makeConstraints { (make) in
               make.centerX.equalTo(contentView)
               make.centerY.equalTo(80 * 2 / 3)
          }
     }
     
     required init?(coder: NSCoder) {
          fatalError("init(coder:) has not been implemented")
     }
     
     func update(title: String, cnt: String, addSeparator: Bool = false) {
          titleLabel.text = title
          cntLabel.text = cnt
          if addSeparator {
               let lx = contentView.frame.maxX + (SCREEN.width * 0.8 - 240) / 4
               contentView.addLine(points: CGPoint(x: lx, y: contentView.frame.minY + 5),
                                   CGPoint(x: lx, y: contentView.frame.maxY - 5))
          }
     }
     
}

