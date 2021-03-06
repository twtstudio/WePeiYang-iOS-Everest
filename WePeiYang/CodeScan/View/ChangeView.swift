//
//  ChangeView.swift
//  WePeiYang
//
//  Created by 安宇 on 2019/10/10.
//  Copyright © 2019 twtstudio. All rights reserved.
//

import UIKit
import SnapKit
class ChangeView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        layout()
    }
    
    func layout() {
        var button = [UIButton]()
        let tmp = 3
        for i in 0..<tmp {
            button.append(UIButton())
            if i == 0 {
                button[i].setTitle("管理", for: .normal)
            } else if i == 1 {
                button[i].setTitle("待参加", for: .normal)
            } else {
                button[i].setTitle("已参加", for: .normal)
            }
            button[i].layer.cornerRadius = 20
            button[i].layer.masksToBounds = true
            button[i].backgroundColor = .clear
            button[i].layer.shadowColor = UIColor.black.cgColor
            button[i].layer.shadowOffset = CGSize(width: 5,height: 5)
            button[i].layer.shadowRadius = 5
            button[i].layer.shadowOpacity = 0.5
        }
    }
    @objc func push() {
        
    }
        
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
