//
//  CommonView.swift
//  YellowPage
//
//  Created by Halcao on 2017/2/22.
//  Modified by Halcao on 2017/7/18.
//  Copyright © 2017年 Halcao. All rights reserved.
//

import UIKit

class CommonUsedView: UIView {

    var collectionView: UICollectionView! = nil
    var models: [ClientItem] = []

    // FIXME: fix init
    convenience init(with models: [ClientItem]) {
        self.init()
        self.models = models
        self.backgroundColor = UIColor.white
        let layout = UICollectionViewFlowLayout()
        let width = UIScreen.main.bounds.size.width

        let headerLabel = UILabel(frame: CGRect(x: 15, y: 20, width: 0, height: 0))
        headerLabel.text = "常用部门"
        headerLabel.font = UIFont.systemFont(ofSize: 15)
        headerLabel.sizeToFit()

        collectionView = UICollectionView(frame: CGRect(x: 0, y: headerLabel.frame.size.height+30, width: width, height: 150), collectionViewLayout: layout)

        // initial fix
        //collectionView.contentInset = UIEdgeInsetsMake(-20, 0, 0, 0)
        //collectionView.contentSize = CGSize(width: width, height: 150)
        collectionView.backgroundColor = UIColor.white
        collectionView.register(CommonClientCell.self, forCellWithReuseIdentifier: "CommonClientCell")

        layout.itemSize = CGSize(width: (width-50)/2, height: 40)
        self.addSubview(headerLabel)
        self.addSubview(collectionView)
    }
}

class CommonClientCell: UICollectionViewCell {
    var label = UILabel()
    var imgView = UIImageView()
    func load(with name: String, and icon: String) {
        imgView.frame = CGRect(x: 0, y: 4, width: 25, height: 25)
        imgView.image = UIImage(named: icon)
        label.text = "\(name)"
        label.frame = CGRect(x: 35, y: 10, width: 140, height: 20)

        // FIXME: adjust for various iPhones
        //label.font = UIFont.flexibleFont(with: 14)
        label.font = UIFont.systemFont(ofSize: 14)
        label.sizeToFit()
        self.addSubview(imgView)
        self.addSubview(label)
    }
}
