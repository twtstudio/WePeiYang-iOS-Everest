//
//  PublishCustomCell.swift
//  WePeiYang
//
//  Created by Hado on 2017/7/5.
//  Copyright © 2017年 twtstudio. All rights reserved.
//

import UIKit
import SnapKit

class PublishCustomCell: UITableViewCell, UITextFieldDelegate {

    weak var delegate: PublishLostViewController?

    var cellkey: String?

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        delegate?.means(input: textField.text!, key: cellkey!)

//        self.textField.becomeFirstResponder()
        textField.resignFirstResponder()

        return true
    }

    var textField = UITextField()

    override var frame: CGRect {

        didSet {

            var newFrame = frame

            newFrame.origin.x += 10
            newFrame.size.width -= 20
            newFrame.origin.y += 10
//            newFrame.size.height -= 10;
            super.frame = newFrame

//            textField.placeholder = "请输入";
            textField.adjustsFontSizeToFitWidth = true
            //当文字超出文本框宽度时，自动调整文字大小
            textField.minimumFontSize = 14

            textField.textAlignment = NSTextAlignment.right
            textField.clearButtonMode = UITextFieldViewMode.unlessEditing

            self.addSubview(textField)

            textField.snp.makeConstraints { make in
                make.top.equalToSuperview().offset(5)
                make.right.equalToSuperview().offset(-5)
                make.left.equalToSuperview().offset(80)
                make.bottom.equalToSuperview().offset(-5)
                make.height.equalTo(30)
            }
        }
    }

    func addTargetMethod() {

        self.textField.addTarget(self, action: #selector(self.textFieldTextChange(sender:)), for: .allEditingEvents)
    }
    @objc func textFieldTextChange(sender: UITextField) {

        delegate?.means(input: textField.text!, key: cellkey!)
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        self.textField.resignFirstResponder()
        self.textField.layoutIfNeeded()
    }
}
