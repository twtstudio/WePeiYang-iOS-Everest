//
//  LFSearchCustomCell.swift
//  WePeiYang
//
//  Created by JasonEWNL on 2018/10/20.
//  Copyright © 2018年 twtstudio. All rights reserved.
//

import UIKit

class LFSearchCustomCell: UITableViewCell {
    
    var buttonAllArray = [UIButton]()
    weak var delegate: LostFoundSearchViewController?
    var currentHeight = 0
    // 我也很无奈啊，必须是CGFloat
    let currenWidth: CGFloat = 40
    var currentLength: CGFloat = 0
    var buttonSeccen = 0
    var currentY: CGFloat = 50
    var currentX: CGFloat = 10
    let titleLabel = UILabel()
    let deleteButton = UIButton()
    var button = UIButton()
    var buttonName = ""
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.contentView.addSubview(deleteButton)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // 循环建立button
    //
    //    func initMark(array: Array<String>, title: String) -> Int {
    
    //        let btn = ButtonGroups()
    //        let hadoCell = btn.addButtonGroupsToCell(buttonArr: array, mainAction: (name: "发布丢失信息", function: {
    //            self.delegate?.buttonTapped()
    //        }))
    //        self.contentView.addSubview(hadoCell!)
    //        return 300
    //    }
    
    func initMark(array: [String], title: String) -> Int {
        let btn = ButtonGroups()
        
        btn.setButtonColor(_textColor: .white, _btnColor: .init(hex6: 0x1BA1E6))
        
        let cvc = btn.addButtonGroupsToCell(buttonArr: array, mainAction: (name: "发布丢失信息", function: {
            //            btn.button.addTarget(self, action: #selector(self.buttonTapped(sender:)), for: .touchUpInside)
            for index in btn.buttonAllArray {
                index.addTarget(self, action: #selector(self.buttonTapped(sender:)), for: .touchUpInside)
                // index.firstController()
            }
            
        }))
        //
        contentView.removeFromSuperview()
        self.addSubview(cvc!)
        
        //cvc?.isExclusiveTouch = true
        for (index, name) in array.enumerated() {
            
            buttonName = name
            buttonOfSize()
            //            button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
            buttonOfRestrict()
            currentLength = currentX + button.frame.size.width
            if currentLength < self.frame.size.width {
                
                button.addTarget(self, action: #selector(self.buttonTapped(sender:)), for: .touchUpInside)
                //                self.contentView.addSubview(button)
                buttonAllArray.append(button)
                currentX = currentX + button.frame.size.width + 10
            } else {
                currentY += 40
                currentX = 10
                
                buttonOfSize()
                button.setTitle(name, for: .normal)
                button.sizeToFit()
                button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
                
                button.addTarget(self, action: #selector(self.buttonTapped(sender:)), for: .touchUpInside)
                //                self.contentView.addSubview(button)
                
                buttonAllArray.append(button)
                button.tag = index
                buttonOfRestrict()
                currentLength = 0
                currentX =  currentX + button.frame.size.width + 10
            }
        }
        
        // cell的标签
        titleOfButtonBuild()
        titleLabel.text = title
        currentHeight = Int(currentY)
        let newHeight = currentHeight + 50
        
        return newHeight
    }
    
    // 循环建立button的回调
    @objc func buttonTapped(sender: UIButton) {
        if let text = sender.titleLabel?.text {
            inputText = text
            self.delegate?.buttonTapped()
        }
    }
    
    // Mark -- ButtonOfSize --
    func buttonOfSize() {
        button = UIButton(frame: CGRect(x: currentX, y: currentY, width: currenWidth, height: 30))
        button.backgroundColor = UIColor(hex6: 0xeeeeee)
        button.setTitleColor(UIColor.black, for: .normal)
        button.setTitleColor(UIColor.init(hex6: 0x00a1e9), for: .selected)
        button.layer.cornerRadius = 16
        button.frame.size.height = 30
        button.setTitle(buttonName, for: .normal)
        button.sizeToFit()
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        
    }
    
    // Mark -- ButtonOfRestrict --
    func buttonOfRestrict() {
        if button.frame.size.width > self.frame.size.width - 40 {
            button.frame.size.width = self.frame.size.width - 40
        }
        if button.frame.size.width < 40 {
            button.frame.size.width = 40
        }
    }
    
    // Mark -- TitleOfButtonBuild --
    func titleOfButtonBuild() {
        titleLabel.font = UIFont.boldSystemFont(ofSize: 15)
        titleLabel.textColor = UIColor(hex6: 0x00a1e9)
        titleLabel.frame = CGRect(x: 10, y: 5, width: 100, height: 20)
        self.contentView.addSubview(titleLabel)
    }
    
    // 删除按钮UI
    // Mark -- DeleteOfUI --
    func delUI() {
        deleteButton.setImage(UIImage(named: "delete"), for: .normal)
        
        deleteButton.snp.makeConstraints {
            make in
            make.top.equalToSuperview().offset(5)
            make.right.equalToSuperview().offset(-10)
            make.width.equalTo(40)
            make.height.equalTo(20)
        }
        deleteButton.imageView?.snp.makeConstraints {
            make in
            make.width.equalTo(20)
            make.height.equalTo(20)
            
        }
    }
    
}
