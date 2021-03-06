//
//  ScrollerView.swift
//  WePeiYang
//
//  Created by 安宇 on 2019/10/16.
//  Copyright © 2019 twtstudio. All rights reserved.
//

import UIKit

class scrollerView: UIViewController {
    
    let width = UIScreen.main.bounds.width
    let height = UIScreen.main.bounds.height
    var currentIndex = 0
    var myScrollerView = UIScrollView()
    let count  = 3
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
    }
    
    func setupScrollerView() {
        self.view.addSubview(myScrollerView)
        myScrollerView.snp.makeConstraints { (make) in
            make.left.equalTo(0)
            make.height.equalTo(height)
            make.width.equalTo(width)
            make.top.equalTo(0)
        }
        myScrollerView.contentSize = CGSize(width: width * 3, height: height)
        myScrollerView.isScrollEnabled = true
//
        myScrollerView.showsHorizontalScrollIndicator = false
        myScrollerView.showsVerticalScrollIndicator = false
//        整页移动
        myScrollerView.isPagingEnabled = true
        myScrollerView.bounces = false
        myScrollerView.scrollsToTop = true
//        for i in 0..<count {
//            myScrollerView.addSubview(<#T##view: UIView##UIView#>)
//        }
    }
}
extension scrollerView: UIScrollViewDelegate {
    
}
