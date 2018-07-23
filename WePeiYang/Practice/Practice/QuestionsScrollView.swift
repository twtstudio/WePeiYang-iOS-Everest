//
//  File.swift
//  WePeiYang
//
//  Created by yuting jiang on 2018/7/14.
//  Copyright © 2018年 twtstudio. All rights reserved.
//

import Foundation
import UIKit
import SnapKit

class QuestionsScrollView: UIScrollView {
    /// 生成左右滑动切换界面
    ///
    /// - Parameters:
    ///   - questions: An Array
    ///   - wid: the Width of this UI
    ///   - h: the Height of this UI
    func creatScrollView(questionsView: [UIView], answersView:[UIView], wid: CGFloat, h: CGFloat, qvH: CGFloat, avH: CGFloat) {
        for i in 0..<questionsView.count {
//            let qScrollViewH: CGFloat = 0.6 * h
            
            let view = UIView(frame: CGRect(x: CGFloat(i) * wid, y: 0, width: wid, height: h))
            view.backgroundColor = .white
            
            self.addSubview(view)
            view.addSubview(questionsView[i])
            questionsView[i].snp.makeConstraints { (make) in
                make.width.equalTo(wid)
                make.height.equalTo(qvH)
                make.left.equalTo(view)
                make.top.equalTo(view)
            }
            
            view.addSubview(answersView[i])
            answersView[i].snp.makeConstraints { (make) in
                make.width.equalTo(wid)
                make.height.equalTo(avH)
                make.bottom.equalTo(view)
                make.left.equalTo(view)
            }
        }
        
        self.contentSize = CGSize(width: CGFloat(questionsView.count) * wid, height: h)
        self.isPagingEnabled = true
        self.bounces = false
        
    }
}

