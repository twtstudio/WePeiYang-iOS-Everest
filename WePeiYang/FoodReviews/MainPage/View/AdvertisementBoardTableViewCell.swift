//
//  AdvertisementBoardTableViewCell.swift
//  WePeiYang
//
//  Created by 赵家琛 on 2018/5/8.
//  Copyright © 2018年 twtstudio. All rights reserved.
//

import UIKit
import SnapKit

class AdvertisementBoardTableViewCell: UITableViewCell {
    
    fileprivate var collectionView: UICollectionView!
    fileprivate var pageControl: UIPageControl!
    fileprivate let WIDTH = UIScreen.main.bounds.width
    fileprivate var timer: Timer?
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupCollectionView()
        setupPageControl()
        
        collectionView.scrollToItem(at: IndexPath(row: 0, section: 40), at: .left, animated: false)
        timer = Timer(timeInterval: 5, target: self, selector: #selector(nextImage), userInfo: nil, repeats: true)
        
        RunLoop.main.add(timer!, forMode: .commonModes)
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    
}

extension AdvertisementBoardTableViewCell {
    
    func setupCollectionView() {
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: WIDTH-20, height: 90)
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        
        collectionView = UICollectionView(frame: frame, collectionViewLayout: layout)
        collectionView.alwaysBounceVertical = false
        collectionView.backgroundColor = .white
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.isPagingEnabled = true
        collectionView.showsHorizontalScrollIndicator = false
        
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "UICollectionViewCell")
        
        contentView.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.left.right.equalToSuperview().inset(10)
            make.height.equalTo(90)
        }
        
        
        collectionView.layoutIfNeeded()
        
    }
    
    func setupPageControl() {
        
        pageControl = UIPageControl(frame: CGRect(x: 0, y: 80, width: self.frame.width, height: 10))
        pageControl.numberOfPages = 5
        pageControl.pageIndicatorTintColor = .yellow
        pageControl.currentPageIndicatorTintColor = .red
        contentView.addSubview(pageControl)
        
    }
    
    @objc func nextImage() {
        
        let currentIndexPath = collectionView.indexPathsForVisibleItems
        let currentIndexPathReset = IndexPath(item: currentIndexPath[0].item, section: 40)
        collectionView.scrollToItem(at: currentIndexPathReset, at: .left, animated: false)
        var nextItem = currentIndexPathReset.item + 1
        var nextSection = currentIndexPathReset.section
        if nextItem == 5 {
            nextItem = 0
            nextSection += 1
        }
        let nextIndexPath = IndexPath(item: nextItem, section: nextSection)
        collectionView.scrollToItem(at: nextIndexPath, at: .left, animated: true)
        
    }
    
}



extension AdvertisementBoardTableViewCell:UICollectionViewDelegate, UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 80
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "UICollectionViewCell", for: indexPath)
        var color: UIColor = .purple
        switch indexPath.row {
        case 0:
            color = .purple
        case 1:
            color = .green
        case 2:
            color = .blue
        case 3:
            color = .black
        case 4:
            color = .red
        default:
            color = .purple
        }
        cell.contentView.backgroundColor = color
        return cell
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let page: Int = Int(scrollView.contentOffset.x/WIDTH+0.5)%5
        pageControl.currentPage = page
        
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        timer?.invalidate()
        timer = nil
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        timer = Timer(timeInterval: 5, target: self, selector: #selector(nextImage), userInfo: nil, repeats: true)
        RunLoop.main.add(timer!, forMode: .commonModes)
    }
}
