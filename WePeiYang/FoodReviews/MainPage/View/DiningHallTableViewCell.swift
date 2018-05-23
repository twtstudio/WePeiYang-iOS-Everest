//
//  DiningHallTableViewCell.swift
//  WePeiYang
//
//  Created by 赵家琛 on 2018/3/25.
//  Copyright © 2018年 twtstudio. All rights reserved.
//

import UIKit
import SnapKit

protocol TransmitValueProtocol {
    func chooseDiningHall(location: Int)
}


class DiningHallTableViewCell: UITableViewCell {
    
    typealias DiningHallData = (title: String, image: UIImage)
    fileprivate let NewDiningHallDatas: [DiningHallData] = [
        (title: "学一食堂", image: UIImage(named: "梅")!), (title: "学二食堂", image: UIImage(named: "兰")!),
        (title: "学三食堂", image: UIImage(named: "棠")!), (title: "学四食堂", image: UIImage(named: "竹")!),
        (title: "学五食堂", image: UIImage(named: "桃")!), (title: "学六食堂", image: UIImage(named: "菊")!),
        (title: "留园食堂", image: UIImage(named: "留")!), (title: "青园食堂", image: UIImage(named: "青")!)]
    
    
    var collectionView: UICollectionView!
    var delegate: TransmitValueProtocol?
    
    deinit {
        delegate = nil
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.itemSize = CGSize(width: (UIScreen.main.bounds.size.width-30)/4, height: 90)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        
        collectionView = UICollectionView(frame: self.frame, collectionViewLayout: layout)
        collectionView.alwaysBounceVertical = true
        collectionView.backgroundColor = .white
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.register(DiningHallCollectionViewCell.self, forCellWithReuseIdentifier: "FoodCollectionViewCell")
        
        contentView.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(10)
            make.bottom.equalToSuperview().inset(20)
            make.left.right.equalToSuperview().inset(15)
            make.height.equalTo(180)
        }
        
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

extension DiningHallTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return NewDiningHallDatas.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FoodCollectionViewCell", for: indexPath) as? DiningHallCollectionViewCell {
            let data = NewDiningHallDatas[indexPath.row]
            cell.imageView.image = data.image
            cell.titleLabel.text = data.title
            return cell
        }
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, didHighlightItemAt indexPath: IndexPath) {
        delegate?.chooseDiningHall(location: indexPath.row)
    }
    
}

