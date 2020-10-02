//
//  FBTagCollectionView.swift
//  WePeiYang
//
//  Created by Zr埋 on 2020/9/26.
//  Copyright © 2020 twtstudio. All rights reserved.
//

import UIKit

class FBTagCollectionView: UIView {
     
     var cvDelegate: UICollectionViewDelegate?
     var cvDataSource: UICollectionViewDataSource?
     
     var tagSelectedCollectionView: UICollectionView!
     var tagWillSeletedCollectionView: UICollectionView!
     
     let collectionViewCellId = "feedBackCollectionViewCellID"
     
     init(frame: CGRect, itemSize: CGSize, isSelectedOnly: Bool = false) {
          super.init(frame: frame)
          
          backgroundColor = .white
          
          let tsLayout = UICollectionViewFlowLayout()
          
          tsLayout.estimatedItemSize = itemSize
          tsLayout.minimumInteritemSpacing = 10
          tsLayout.scrollDirection = .horizontal
          
          let twLayout = UICollectionViewFlowLayout()
          
          twLayout.estimatedItemSize = itemSize
          twLayout.minimumInteritemSpacing = 10
          twLayout.scrollDirection = .horizontal
          
          tagSelectedCollectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: tsLayout)
          tagSelectedCollectionView.tag = 0
          tagSelectedCollectionView.register(FBTagCollectionViewCell.self, forCellWithReuseIdentifier: collectionViewCellId)
          
          tagSelectedCollectionView.backgroundColor = .white
          tagSelectedCollectionView.showsHorizontalScrollIndicator = false
          addSubview(tagSelectedCollectionView)
          tagSelectedCollectionView.snp.makeConstraints { (make) in
               make.top.equalTo(self)
               if isSelectedOnly {
                    make.left.equalTo(self)
                    make.right.equalTo(self)
                    make.bottom.equalTo(self)
               } else {
                    make.left.equalTo(self).offset(10)
                    make.right.equalTo(self).offset(-10)
                    make.bottom.equalTo(self.snp.centerY)
               }
          }
          
          if !isSelectedOnly {
               tagWillSeletedCollectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: twLayout)
               tagWillSeletedCollectionView.tag = 1
               tagWillSeletedCollectionView.register(FBTagCollectionViewCell.self, forCellWithReuseIdentifier: collectionViewCellId)
               
               tagWillSeletedCollectionView.backgroundColor = .white
               tagWillSeletedCollectionView.showsHorizontalScrollIndicator = false
               addSubview(tagWillSeletedCollectionView)
               tagWillSeletedCollectionView.snp.makeConstraints { (make) in
                    make.left.equalTo(self).offset(10)
                    make.right.equalTo(self).offset(-10)
                    make.top.equalTo(self.snp.centerY)
                    make.bottom.equalTo(self)
               }
          }
     }
     
     func addDelegate(delegate: UICollectionViewDelegate, dataSource: UICollectionViewDataSource, isSelectedOnly: Bool = false) {
          tagSelectedCollectionView.delegate = delegate
          tagSelectedCollectionView.dataSource = dataSource
          tagSelectedCollectionView.reloadData()
          if !isSelectedOnly {
               tagWillSeletedCollectionView.delegate = delegate
               tagWillSeletedCollectionView.dataSource = dataSource
               tagWillSeletedCollectionView.reloadData()
          }
     }
     
     required init?(coder: NSCoder) {
          fatalError("init(coder:) has not been implemented")
     }
     
     
}
