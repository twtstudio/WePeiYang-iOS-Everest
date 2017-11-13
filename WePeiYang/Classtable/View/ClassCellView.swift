//
//  ClassCellView.swift
//  WePeiYang
//
//  Created by Qin Yubo on 16/2/16.
//  Copyright © 2016年 Qin Yubo. All rights reserved.
//

import UIKit

@objc protocol ClassCellViewDelegate {
    @objc optional func cellViewTouched(cellView: ClassCellView)
}

class ClassCellView: UIView {
    
    var classLabel: UILabel!
    var classData: ClassModel?
    
    var delegate: ClassCellViewDelegate!
    
    init() {
        super.init(frame: CGRect.zero)
        
        classLabel = UILabel()
        self.addSubview(classLabel)
        classLabel.snp.makeConstraints { make in
            make.left.equalTo(2)
            make.right.equalTo(-2)
            make.top.equalTo(2)
            make.bottom.equalTo(-2)
        }
        classLabel.numberOfLines = 0
        classLabel.textColor = UIColor.white
        classLabel.textAlignment = .center
        
        // FIXME: gesture
//        let tapRecognizer = UITapGestureRecognizer().bk_initWithHandler({(recognizer, state, point) in
//            if self.classData != nil {
//                self.delegate.cellViewTouched!(self)
//            }
//        }) as! UITapGestureRecognizer
        self.isUserInteractionEnabled = true
//        self.addGestureRecognizer(tapRecognizer)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
