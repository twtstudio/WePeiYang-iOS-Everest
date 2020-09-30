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
     
     override init(frame: CGRect) {
          super.init(frame: frame)
          
          backgroundColor = .white
          
          let tsLayout = UICollectionViewFlowLayout()
          
          tsLayout.estimatedItemSize = CGSize(width: 200, height: 30)
          tsLayout.minimumInteritemSpacing = 10
          tsLayout.scrollDirection = .horizontal
          
          let twLayout = UICollectionViewFlowLayout()
          
          twLayout.estimatedItemSize = CGSize(width: 200, height: 30)
          twLayout.minimumInteritemSpacing = 10
          twLayout.scrollDirection = .horizontal
          
          tagSelectedCollectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: tsLayout)
          tagSelectedCollectionView.tag = 0
          tagSelectedCollectionView.register(FBTagCollectionViewCell.self, forCellWithReuseIdentifier: collectionViewCellId)
          
          tagSelectedCollectionView.backgroundColor = .white
          tagSelectedCollectionView.showsHorizontalScrollIndicator = false
          addSubview(tagSelectedCollectionView)
          tagSelectedCollectionView.snp.makeConstraints { (make) in
               make.left.equalTo(self).offset(10)
               make.right.equalTo(self).offset(-10)
               make.bottom.equalTo(self.snp.centerY)
               make.top.equalTo(self)
          }
          
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
     
     func addDelegate(delegate: UICollectionViewDelegate, dataSource: UICollectionViewDataSource) {
          tagSelectedCollectionView.delegate = delegate
          tagSelectedCollectionView.dataSource = dataSource
          tagWillSeletedCollectionView.delegate = delegate
          tagWillSeletedCollectionView.dataSource = dataSource
          tagSelectedCollectionView.reloadData()
          tagWillSeletedCollectionView.reloadData()
     }
     
     required init?(coder: NSCoder) {
          fatalError("init(coder:) has not been implemented")
     }
     
     
}
