//
//  FBTagCollectionViewCell.swift
//  WePeiYang
//
//  Created by Zr埋 on 2020/9/23.
//  Copyright © 2020 twtstudio. All rights reserved.
//

import UIKit

class FBTagCollectionViewCell: UICollectionViewCell {
     
     lazy var label: UILabel = {
          let label = UILabel(frame: CGRect.zero)
          label.textColor = .white
          label.font = .systemFont(ofSize: 12, weight: .semibold)
          label.numberOfLines = 1
          return label
     }()
     
     var tagSelected: Bool? {
          didSet {
               contentView.backgroundColor = tagSelected ?? false ? UIColor(hex6: 0x00a1e9) : .gray
          }
     }
     
     override init(frame: CGRect) {
          super.init(frame: frame)
          contentView.layer.cornerRadius = 5
          contentView.layer.masksToBounds = true
          contentView.addSubview(label)
          label.snp.makeConstraints { (make) in
               make.center.equalTo(contentView)
          }
     }
     
     required init?(coder: NSCoder) {
          fatalError("init(coder:) has not been implemented")
     }
     
     func update(by tag: FBTagModel, selected: Bool) {
          label.text = tag.name
          tagSelected = selected
     }
     
     func update(by tag: String, selected: Bool) {
          label.text = tag
          tagSelected = selected
     }
     
     func toggle() {
          tagSelected?.toggle()
     }
     
     override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
          let layout = super.preferredLayoutAttributesFitting(layoutAttributes)
          if !label.text!.isEmpty {
               label.sizeToFit()
          }
          //          print(layout.frame.width)
          layout.frame = CGRect(x: layout.frame.minX, y: layout.frame.minY, width: label.width + 20, height: layout.frame.height)
          //          print(layout.frame.width, label.text)
          return layout
     }
     
     override func layoutSubviews() {
          super.layoutSubviews()
          addShadow(.black, sRadius: 2, sOpacity: 0.2, offset: (1, 1))
     }
}
