//
//  ActivitiesView.swift
//  WePeiYang
//

//  Created by Emo on 25/07/2019.
//  Copyright © 2019 twtstudio. All rights reserved.
//

import UIKit
import SnapKit

class ActivityView: UIView {
    
    var activityName: UILabel = {
        
        let label = UILabel()
//        设置字间距
        
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 18, weight: UIFont.Weight.medium)
        return label
    }()
    var loc: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        return label
    }()
    var time: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        return label
    }()
    var sponsor: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        return label
    }()
    var codeLogin: UIButton = {
        let button = UIButton()
//        设置按钮左端对齐
        button.contentHorizontalAlignment = UIControl.ContentHorizontalAlignment.left
        return button
    }()
    var idLogin: UIButton = {
        let button = UIButton()
        button.contentHorizontalAlignment = UIControl.ContentHorizontalAlignment.left
        return button
    }()
    var arrow: UIButton = {
        let button = UIButton()
        button.contentHorizontalAlignment = UIControl.ContentHorizontalAlignment.left
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white
        
        layout()
        addInformation()
    }
    func layout() {
        self.addSubview(activityName)
        self.addSubview(codeLogin)
        self.addSubview(idLogin)
        self.addSubview(arrow)
        self.addSubview(loc)
        self.addSubview(time)
        self.addSubview(sponsor)
        
        activityName.snp.makeConstraints { (make) in
            make.top.equalTo(18)
            make.height.equalTo(28)
            make.left.equalTo(20)
            make.centerX.equalTo(UIScreen.main.bounds.width / 2)
        }
        codeLogin.snp.makeConstraints { (make) in
            make.bottom.equalTo(-15)
            make.height.equalTo(20)
            make.left.equalTo(self.activityName.snp.left)
            make.width.equalTo(130)
        }
        idLogin.snp.makeConstraints { (make) in
            make.top.equalTo(self.codeLogin.snp.top)
//            make.bottom.equalTo(self.codeLogin.snp.bottom)
            make.height.equalTo(self.codeLogin.snp.height)
            make.left.equalTo(UIScreen.main.bounds.width / 2)
            make.width.equalTo(self.codeLogin.snp.width)
        }
        arrow.snp.makeConstraints { (make) in
            make.right.equalTo(-25)
            make.top.equalTo(self.activityName.snp.top).offset(5)
            make.bottom.equalTo(self.activityName.snp.bottom).offset(-5)
            make.width.equalTo(20)
        }
        loc.snp.makeConstraints { (make) in
            make.top.equalTo(self.activityName.snp.bottom).offset(15)
            make.height.equalTo(20)
            make.left.equalTo(self.activityName.snp.left)
            make.centerX.equalTo(UIScreen.main.bounds.width / 2)
        }
        time.snp.makeConstraints { (make) in
            make.top.equalTo(self.loc.snp.bottom).offset(13)
            make.height.equalTo(self.loc.snp.height)
            make.left.equalTo(self.loc.snp.left)
            make.centerX.equalTo(UIScreen.main.bounds.width / 2)
        }
        sponsor.snp.makeConstraints { (make) in
            make.top.equalTo(self.time.snp.bottom).offset(13)
            make.height.equalTo(self.loc.snp.height)
            make.left.equalTo(self.loc.snp.left)
            make.centerX.equalTo(UIScreen.main.bounds.width / 2)
        }
    }
    func addInformation() {
        
        //        图文混排
        let dictAttr = [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 15, weight: .regular)]
        var attrStr1 = NSAttributedString(string: "  扫码录入", attributes: dictAttr)
        let attacment1 = NSTextAttachment()
        let image = UIImage(named: "2")
        attacment1.image = UIImage.resizedImage(image: image!, scaledToSize: CGSize(width: 20, height: 20))
        //获取文字字体
        let font1 = codeLogin.titleLabel?.font
        attacment1.bounds = CGRect(x: 0, y: -4, width: (font1?.lineHeight)!, height: (font1?.lineHeight)! + 1)
        let attrImage1 = NSAttributedString(attachment: attacment1)
        let attr1 = NSMutableAttributedString()
        attr1.append(attrImage1)
        attr1.append(attrStr1)
        codeLogin.setAttributedTitle(attr1, for: .normal)
        
        //图文混排
        var attrStr2 = NSAttributedString(string: "  学号录入", attributes: dictAttr)
        let attacment2 = NSTextAttachment()
        attacment2.image = UIImage(named: "4")
        //获取文字字体
        let font2 = idLogin.titleLabel?.font
        attacment2.bounds = CGRect(x: 0, y: -4, width: (font2?.lineHeight)!, height: (font2?.lineHeight)!)
        let attrImage2 = NSAttributedString(attachment: attacment2)
        let attr2 = NSMutableAttributedString()
        attr2.append(attrImage2)
        attr2.append(attrStr2)
        idLogin.setAttributedTitle(attr2, for: .normal)
        
        arrow.setBackgroundImage(UIImage(named: "ic_arrow_down"), for: .normal)
        arrow.setBackgroundImage(UIImage(named: "ic_arrow_up"), for: .selected)
    }
        
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
