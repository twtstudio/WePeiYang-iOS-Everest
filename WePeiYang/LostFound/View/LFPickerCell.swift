//
//  LFPickerCell.swift
//  WePeiYang
//
//  Created by Hado on 2017/9/27.
//  Copyright © 2017年 twtstudio. All rights reserved.
//

import UIKit
import SnapKit

class LFPickerCell: UITableViewCell {

    var pickerView: UIPickerView!
    
    let dateArr = ["7天","15天","30天"]
    override var frame: CGRect{
        
        didSet{
            
            var newFrame = frame;
            
            newFrame.origin.x += 10/2;
            newFrame.size.width -= 10;
            newFrame.origin.y += 10;
            newFrame.size.height -= 10;
            super.frame = newFrame;
            
        }
    }
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
    
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.setUpUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUpUI() {
        
        pickerView = UIPickerView()
        pickerView.selectRow(1, inComponent: 0, animated: true)
        self.addSubview(pickerView)
        
        pickerView.delegate = self
        pickerView.dataSource = self
        
        pickerView.snp.makeConstraints {
            make in
            make.left.equalToSuperview().offset(80)
            make.right.equalToSuperview().offset(-5)
            make.top.equalToSuperview().offset(5)
            make.bottom.equalToSuperview().offset(-5)
        }
    }

}

extension LFPickerCell: UIPickerViewDelegate {
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
    return dateArr[component]
    }
    
    func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        
        return 100
    }
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 50
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        print(row)
    }
}

extension LFPickerCell: UIPickerViewDataSource {
    
    public func numberOfComponents(in pickerView: UIPickerView) -> Int {
        
        return 1
    }
    
    public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        return dateArr.count
    }
}
