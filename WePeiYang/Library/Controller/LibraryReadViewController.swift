//
//  LibraryReadViewController.swift
//  WePeiYang
//
//  Created by 毛线 on 2018/10/26.
//  Copyright © 2018 twtstudio. All rights reserved.
//

import UIKit
import SnapKit

class LibraryReadViewController: UIViewController {
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        let image = #imageLiteral(resourceName: "施工中")
        imageView.image = image
        return imageView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(imageView)
        self.view.backgroundColor = LibraryMainViewController.bgColor
        
        imageView.snp.makeConstraints { (make) -> Void in
            make.centerX.equalTo(view)
            make.width.equalTo(view).multipliedBy(0.6)
            make.centerY.equalTo(view)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
