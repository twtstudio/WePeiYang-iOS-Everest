//
//  NewsViewController.swift
//  WePeiYang
//
//  Created by Halcao on 2018/3/1.
//  Copyright © 2018年 twtstudio. All rights reserved.
//

import UIKit

class NewsViewController: UIViewController {
    var galleryView: UICollectionView!
    let g = ["https://www.twt.edu.cn/upload/galleries/MPPlLUkF1yA4PfBzp531.jpeg",
        "https://www.twt.edu.cn/upload/galleries/FFlGAdcDXdpoikBqgk82.jpeg",
        "https://www.twt.edu.cn/upload/galleries/XNdvWUQmPk0hILhaeZbx.jpeg",
        "https://www.twt.edu.cn/upload/galleries/qPezeOgW9l4hU7kJ6Bf9.jpeg",
        "https://www.twt.edu.cn/upload/galleries/nFXfAgTiM2PIt2K54pPG.jpeg",
        "https://www.twt.edu.cn/upload/galleries/gtEBQeIFt3WcWGN7l04P.jpeg"
]

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white

        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 150, height: 200)
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 20

        galleryView = UICollectionView(frame: CGRect(x: 0, y: 50, width: view.width, height: 200), collectionViewLayout: layout)

        galleryView.backgroundColor = .white
        galleryView.delegate = self
        galleryView.dataSource = self
        galleryView.showsVerticalScrollIndicator = false
        galleryView.showsHorizontalScrollIndicator = false
        galleryView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "12345")
        self.view.addSubview(galleryView)

    }
}

extension NewsViewController: UICollectionViewDelegate {

}

extension NewsViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return g.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "12345", for: indexPath)

        let imgView = UIImageView(frame: cell.bounds)
        imgView.contentMode = .scaleAspectFill
        imgView.clipsToBounds = true
        imgView.sd_setImage(with: URL(string: g[indexPath.row])) { (image, error, type, url) in
//            if let image = image {
//                image.size
//            }
        }
        cell.contentView.addSubview(imgView)
        return cell
    }
}

