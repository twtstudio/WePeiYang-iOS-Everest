//
//  StrikeTableView.swift
//  WePeiYang
//
//  Created by 赵家琛 on 2018/5/6.
//  Copyright © 2018年 twtstudio. All rights reserved.
//

import UIKit

//手势穿透
class StrikeTableView: UITableView, UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    override init(frame: CGRect, style: UITableViewStyle) {
        super.init(frame: frame, style: style)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
