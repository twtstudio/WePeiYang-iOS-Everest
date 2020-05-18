//
//  ScrollViewHeaderView.swift
//  WePeiYang
//
//  Created by 安宇 on 2019/10/19.
//  Copyright © 2019 twtstudio. All rights reserved.
//

import UIKit
protocol CodePageContentViewDelegate: class {
    func CodePageContentView(contentView: CodePageContentView, progress: CGFloat, sourceIndex: Int, targetIndex: Int)
}

class CodePageContentView: UIView {
    private let ContentCellID = "ContentCellID"
    
    private var childVCs: [UIViewController]
    private weak var parentVC: UIViewController?
    private var starOffsetX: CGFloat = 0
    private var isFobidScroll: Bool = false
    weak var delegate: CodePageContentViewDelegate?
    
    private lazy var collectionView: UICollectionView = {[weak self] in
        
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = (self?.bounds.size)!
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.scrollDirection = .horizontal
        
        let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.bounces = false
        collectionView.isPagingEnabled = true
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: ContentCellID)
        
        return collectionView
        }()
    
    init(frame: CGRect, childVCs: [UIViewController], parentVC: UIViewController?) {
        self.childVCs = childVCs
        self.parentVC = parentVC
        
        super.init(frame: frame)
        
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension CodePageContentView {
    private func setupUI() {
        //将子控制器添加到父控制器
        for childVC in childVCs {
            parentVC?.addChildViewController(childVC)
        }
        
        //添加collectionView，在cell中存放控制器的view
        addSubview(collectionView)
        collectionView.frame = bounds
    }
}

extension CodePageContentView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return childVCs.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ContentCellID, for: indexPath)
        
        for view in cell.contentView.subviews {
            view.removeFromSuperview()
        }
        let childVC = childVCs[indexPath.item]
        childVC.view.frame = cell.contentView.bounds
        cell.contentView.addSubview(childVC.view)
        
        return cell
    }
}

extension CodePageContentView: UICollectionViewDelegate {
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        isFobidScroll = false
        starOffsetX = scrollView.contentOffset.x
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        var progress: CGFloat = 0
        var sourceIndex: Int = 0
        var targetIndex: Int = 0
        
        //判断是否点击事件
        if isFobidScroll { return }
        
        //判断左滑还是右滑
        let currentOffsetX = scrollView.contentOffset.x
        let scrollViewW = scrollView.frame.width
        if currentOffsetX > starOffsetX {//左滑
            progress = currentOffsetX / scrollViewW - floor(currentOffsetX / scrollViewW)
            
            sourceIndex = Int(currentOffsetX / scrollViewW)
            targetIndex = sourceIndex + 1
            if targetIndex >= childVCs.count {
                targetIndex = childVCs.count - 1
            }
            
            if currentOffsetX - starOffsetX == scrollViewW {
                progress = 1
                targetIndex = sourceIndex
            }
        } else {
            progress = 1 - (currentOffsetX / scrollViewW - floor(currentOffsetX / scrollViewW))
            
            targetIndex = Int(currentOffsetX / scrollViewW)
            sourceIndex = targetIndex + 1
            if sourceIndex >= childVCs.count {
                sourceIndex = childVCs.count - 1
            }
            
        }
        
        //将数据传递给titleView
        delegate?.CodePageContentView(contentView: self, progress: progress, sourceIndex: sourceIndex, targetIndex: targetIndex)
    }
}

extension CodePageContentView {
    func setCurrentIndex(currentIndex: Int) {
        //禁止执行代理
        isFobidScroll = true
        
        //滚动位置
        let offsetX = CGFloat(currentIndex) * collectionView.frame.width
        collectionView.setContentOffset(CGPoint(x: offsetX, y: 0), animated: false)
    }
}
