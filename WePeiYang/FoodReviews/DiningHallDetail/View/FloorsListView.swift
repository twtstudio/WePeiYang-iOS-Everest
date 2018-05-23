//
//  FloorsListView.swift
//  WePeiYang
//
//  Created by 赵家琛 on 2018/5/22.
//  Copyright © 2018年 twtstudio. All rights reserved.
//

import UIKit
import SnapKit

protocol FloorsLevelListDelegate {
    func selectedButton(isLeftButton: Bool)
}

class FloorsListView: UIView {
    
    fileprivate let ButtonWIDTH: CGFloat = 80
    fileprivate let ScreenWIDTH: CGFloat = UIScreen.main.bounds.size.width
    
    let lineView: UIView!
    let firstFloorButton: UIButton!
    let secondFloorButton: UIButton!
    var selectedIndex = 0
    
    var delegate: FloorsLevelListDelegate?
    
    
    override init(frame: CGRect) {
        
        
        lineView = UIView(frame: CGRect(x: (ScreenWIDTH-ButtonWIDTH*2)/3, y: 40-2, width: ButtonWIDTH, height: 2))
        lineView.backgroundColor = .blue
        
        firstFloorButton = UIButton(frame: CGRect(x: (ScreenWIDTH-ButtonWIDTH*2)/3, y: 0, width: ButtonWIDTH, height: 40))
        secondFloorButton = UIButton(frame: CGRect(x: (ScreenWIDTH-ButtonWIDTH*2)*2/3+ButtonWIDTH, y: 0, width: ButtonWIDTH, height: 40))
        
        firstFloorButton.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        secondFloorButton.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        firstFloorButton.setTitle("一层", for: .normal)
        secondFloorButton.setTitle("二层", for: .normal)
        firstFloorButton.setTitleColor(.black, for: .normal)
        firstFloorButton.setTitleColor(.blue, for: .selected)
        secondFloorButton.setTitleColor(.black, for: .normal)
        secondFloorButton.setTitleColor(.blue, for: .selected)
        
        super.init(frame: frame)
        
        self.addSubview(firstFloorButton)
        self.addSubview(secondFloorButton)
        self.addSubview(lineView)
        
        firstFloorButton.addTarget(self, action: #selector(clickButton(sender:)), for: .touchUpInside)
        secondFloorButton.addTarget(self, action: #selector(clickButton(sender:)), for: .touchUpInside)
        
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func clickButton(sender: UIButton) {
        let isLeftButton = sender == firstFloorButton ? true : false
        if delegate != nil {
            self.delegate?.selectedButton(isLeftButton: isLeftButton)
        }
        
    }
    
    func changeLineViewOffsetX(offsetX: CGFloat) {
        var lineViewFrame = lineView.frame
        lineViewFrame.origin.x = (ScreenWIDTH-ButtonWIDTH*2)/3 + ((ScreenWIDTH-ButtonWIDTH*2)/3+ButtonWIDTH)*(offsetX/ScreenWIDTH)
        lineView.frame = lineViewFrame
        
        if offsetX == 0 || offsetX == ScreenWIDTH {
            firstFloorButton.isSelected = offsetX/ScreenWIDTH == 0 ? true : false
            secondFloorButton.isSelected = !firstFloorButton.isSelected
        }
        
    }
    
}
