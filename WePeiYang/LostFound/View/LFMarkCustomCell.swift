//
//  LFMarkCustomCell.swift
//  WePeiYang
//
//  Created by JasonEWNL on 2018/10/20.
//  Copyright © 2018年 twtstudio. All rights reserved.
//

import UIKit

class LFMarkCustomCell: UITableViewCell {
    
    weak var delegate: PublishLostViewController?
    
    let buttonArray = ["身份证", "饭卡", "手机", "钥匙", "书包", "手表&饰品", "U盘&硬盘", "水杯", "钱包", "银行卡", "书", "伞", "其他"]
    let types = ["1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12", "13"]
    var functionDic = [Int: [String]]()
    var buttonAllArray = [UIButton]()
    let label = UILabel()
    
    let currenWidth: CGFloat = 40
    var currentLength: CGFloat = 0
    var buttonSeccen = 0
    var currentY: CGFloat = 50
    var currentX: CGFloat = 10
    var button = UIButton()
    
    // 循环建立button
    func enumerated() {
        for (index, name) in buttonArray.enumerated() {
            
            buttonOfSize()
            button.setTitle(name, for: .normal)
            button.sizeToFit()
            button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
            buttonOfRestrict()
            currentLength = currentX + button.frame.size.width
            if currentLength < self.frame.size.width {
                
                button.addTarget(self, action: #selector(self.buttonTapped(sender:)), for: .touchUpInside)
                self.contentView.addSubview(button)
                buttonAllArray.append(button)
                currentX = currentX + button.frame.size.width + 15
            } else {
                currentY += 40
                currentX = 10
                
                buttonOfSize()
                button.setTitle(name, for: .normal)
                button.sizeToFit()
                button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
                
                button.addTarget(self, action: #selector(self.buttonTapped(sender:)), for: .touchUpInside)
                self.contentView.addSubview(button)
                
                buttonAllArray.append(button)
                button.tag = index
                buttonOfRestrict()
                currentLength = 0
                currentX =  currentX + button.frame.size.width + 15
            }
        }
        //            contentView.backgroundColor = UIColor(hex6: 0xeeeeee)
        titleOfLabelBuild()
    }
    
    // Mark -- ButtonOfSize --
    func buttonOfSize() {
        button = UIButton(frame: CGRect(x: currentX, y: currentY, width: currenWidth, height: 30))
        //        button.backgroundColor = UIColor(hex6: 0xeeeeee)
        button.backgroundColor = UIColor(hex6: 0xd9d9d9)
//        button.setTitleColor(UIColor.black, for: .normal)
        button.setTitleColor(UIColor.init(hex6: 0x00a1e9), for: .selected)
        button.layer.cornerRadius = 16
        button.frame.size.height = 30
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
    func titleOfLabelBuild() {
        addSubview(label)
        
        label.font = UIFont.boldSystemFont(ofSize: 15)
        label.textColor = UIColor(hex6: 0x00a1e9)
        
        label.frame = CGRect(x: 10, y: 5, width: 100, height: 20)
    }
    
    // button的回调
    @objc func buttonTapped(sender: UIButton) {
        
        if let title = sender.titleLabel?.text {
            
            if let index =  buttonArray.index(of: title) {
                self.delegate?.means(input: types[index], key: "detail_type")
                switch types[index] {
                case "1":
                    self.delegate?.function[2] = ["卡号 *", "姓名 *"]
                case "2":
                    self.delegate?.function[2] = ["卡号 *", "姓名 *"]
                case "10":
                    self.delegate?.function[2] = ["卡号 *", "姓名 *"]
                default:
                    self.delegate?.function[2] = []
                }
                // 点击button颜色转变
                for indexAll in buttonAllArray {
                    indexAll.backgroundColor = UIColor(hex6: 0xd9d9d9)
                    indexAll.setTitleColor(.black, for: .normal)
                }
                
                sender.backgroundColor = UIColor(hex6: 0x00a1e9)
                sender.setTitleColor(.white, for: .normal)
                
            }
        }
        self.delegate?.tableView.reloadData()
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
}
