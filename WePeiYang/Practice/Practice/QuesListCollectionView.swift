//
//  QuesListCollectionView.swift
//  WePeiYang
//
//  Created by yuting jiang on 2018/8/27.
//  Copyright © 2018 twtstudio. All rights reserved.
//

import Foundation
import UIKit

class QuesCollectionView: UICollectionView, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    static var chosenPage: Int = 0
    
    var pageNum: Int = 0
    var isCorrected: [isCorrect] = []
    var curPage: Int = 1
    let cellW: CGFloat = 40

    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)

        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = 10
        layout.minimumLineSpacing = 10
        layout.itemSize = CGSize(width: cellW, height: cellW)

        self.contentSize = CGSize(width: frame.width - 10, height: frame.height)
        self.backgroundColor = .white
        self.contentInset = UIEdgeInsetsMake(20, 20, 20, 20)
        self.layer.cornerRadius = 5
        self.collectionViewLayout = layout
        self.isPagingEnabled = false
        self.showsVerticalScrollIndicator = true
        self.showsHorizontalScrollIndicator = false
        self.bounces = true
        self.register(QuesCollectionCell.self, forCellWithReuseIdentifier: "quesCollection cell")

        self.delegate = self
        self.dataSource = self

    }
    
    func initCollectionView(currentPage: Int, pagesNum: Int, isCorrect: [isCorrect]) {
        isCorrected = isCorrect
        pageNum = pagesNum
        curPage = currentPage
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return pageNum
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = self.dequeueReusableCell(withReuseIdentifier: "quesCollection cell", for: indexPath) as! QuesCollectionCell
        
        cell.label.text = "\(indexPath.item + 1)"
        cell.layer.cornerRadius = cellW * 0.5
        switch isCorrected[indexPath.item] {
        case .unknown:
            cell.backgroundColor = .white
            cell.layer.borderColor = UIColor.lightGray.cgColor
            cell.label.textColor = UIColor.lightGray
        case .right:
            cell.backgroundColor = UIColor.practiceBlue
            cell.label.textColor = .white
        case .wrong:
            cell.layer.borderColor = UIColor.clear.cgColor
            cell.backgroundColor = UIColor.readRed
            cell.label.textColor = .white
        }
        
        if indexPath.item == curPage - 1 {
            cell.layer.borderColor = UIColor.practiceBlue.cgColor
            cell.label.textColor = UIColor.practiceBlue
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        QuesCollectionView.chosenPage = indexPath.item + 1
        SolaSessionManager.cancelAllTask()
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "changeQues"), object: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    deinit {
        self.delegate = nil
    }
}

class QuesCollectionCell: UICollectionViewCell {    
    let label: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.backgroundColor = .clear
        label.font = UIFont.systemFont(ofSize: 13)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.layer.borderWidth = 1
        self.addSubview(label)
        label.snp.makeConstraints { (make) in
            make.width.equalTo(22)
            make.height.equalTo(12)
            make.center.equalTo(self)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
