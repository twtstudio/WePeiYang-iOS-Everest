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
    var textField: UITextField!
    var delegate: PublishLostViewController?
    
    let dateArr = ["请选择天数","7天","15天","30天"]
//    let dateArr = ["7天","15天","30天"]
    override var frame: CGRect{
        
        didSet{
            var newFrame = frame;
            newFrame.origin.x += 10;
            newFrame.size.width -= 20;
            newFrame.origin.y += 10;
            //            newFrame.size.height -= 10;
            super.frame = newFrame;
            
        }
    }
    
    // 完成按钮
    override func draw(_ rect: CGRect) {
        
        super.draw(rect)
        let toolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: 40))
        toolBar.barStyle = UIBarStyle.default
        
        let btnFished = UIButton(frame: CGRect(x: 0, y: 0, width: 50, height: 25))
        
        btnFished.setTitle("完成", for: .normal)
        btnFished.setTitleColor(UIColor(hex6: 0x13a8df), for: .normal)
        btnFished.addTarget(self, action: #selector(finishTapped(sender:)), for: .touchUpInside)
        
        let item2 = UIBarButtonItem(customView: btnFished)
        let space = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width-btnFished.frame.size.width-30, height: 25))
        let item = UIBarButtonItem(customView: space)
        toolBar.setItems([item, item2], animated: true)

        textField.inputAccessoryView = toolBar
        
        
    }
    

    func finishTapped(sender: UIButton) {
        
//        delegate?.means(input: textField.text!, key: "duration")
        
//        delegate?.means(input: dateArr[row], key: "duration")
        textField.resignFirstResponder()
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
        textField = UITextField()
        textField.inputView = pickerView
        textField.borderStyle = .roundedRect
        textField.placeholder = "请输入天数"
        
        textField.textAlignment = .center
        self.addSubview(textField)
        
        
        //        pickerView.selectRow(1, inComponent: 0, animated: true)
        //        self.addSubview(pickerView)
        
        pickerView.delegate = self
        pickerView.dataSource = self
        
        textField.delegate = self
        
        
        textField.snp.makeConstraints{
            
            make in
            make.top.equalToSuperview().offset(5)
            make.right.equalToSuperview().offset(-5)
            make.left.equalToSuperview().offset(180)
            make.bottom.equalToSuperview().offset(-5)
            make.height.equalTo(30)
        }

    }
    
    
}

extension LFPickerCell: UIPickerViewDelegate {
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        return dateArr[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        
        return 200
    }
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 50
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {

        
        self.textField.text = dateArr[row]
        if row == 0 {
            print("请选择天数")
            self.textField.textColor = UIColor(hex6: 0xc8ccd3)
        } else {
            let tag = row - 1
            print(tag)
        self.textField.textColor = UIColor.black

        delegate?.means(input: "\(tag)", key: "duration")
        }

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

extension LFPickerCell: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
        
    }
}

