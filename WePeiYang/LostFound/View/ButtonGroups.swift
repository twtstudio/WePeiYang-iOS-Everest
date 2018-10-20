//
//  ButtonGroups.swift
//  WePeiYang
//
//  Created by JasonEWNL on 2018/10/20.
//  Copyright © 2018年 twtstudio. All rights reserved.
//

import UIKit

class ButtonGroups: UIButton {
    
    //*** addButtonGroups返回的是添加完button的view,所以需要在把这个view添加到父视图;
    // 传参数:
    //* 必须传button的文字显示的字符串、点击事件的闭包;
    // 非必要传buttonGrops所在view的左起点、右界限;
    // 左起点默认值 0 , 右终点默认值 320 ;
    
    //* getViewHeight返回的是view的高度;
    //* 适用场景：tableViewCell自适应高度等, 因为使用frame, 自适应失效, cell高度可等于view高度;
    
    //* setButtonColor设置button的颜色值;
    // 默认颜色是微北洋主题色;
    
    //* 点击button的变色处理, 需要您自己在闭包里面写了;
    
    //ex1:
    /*
     let btn = ButtonGroups()
     btn.setButtonColor(_textColor: .blue, _btnColor: .black)
     let cvc = btn.addButtonGroupsToCell(buttonArr: markArray, mainAction: (name: "发布丢失信息", function: {
     let vc = PublishLostViewController()
     vc.pushTag = MyURLState.lostURL.rawValue
     vc.newTitle = "丢失物品"
     self.navigationController?.pushViewController(vc, animated: true)
     }))
     self.view.addSubview(cvc!)
     */
    
    
    //ex2:
    //利用button的数组进行回调：
    /*
     func initMark(array: Array<String>, title: String) -> Int {
     
     let btn = ButtonGroups()
     btn.setButtonColor(_textColor: .blue, _btnColor: .black)
     let cvc = btn.addButtonGroupsToCell(buttonArr: array, mainAction: (name: "发布丢失信息", function: {
     btn.button.addTarget(self, action: #selector(self.buttonTapped(sender:)), for: .touchUpInside)
     for index in btn.buttonAllArray {
     index.addTarget(self, action: #selector(self.buttonTapped(sender:)), for: .touchUpInside)
     }
     }))
     self.contentView.addSubview(cvc!)
     }
     */
    
    fileprivate var viewHeight: CGFloat = 0
    fileprivate var currentWidth: CGFloat = 40 //
    fileprivate var currentLenght: CGFloat = 0
    fileprivate var currentX: CGFloat = 10 // 每个button的左上角x值
    fileprivate var currentY: CGFloat = 50 //                 y值
    fileprivate var buttonName = ""
    fileprivate var buttonGroupsArr:[String] = []
    fileprivate let limit: CGFloat = 40 // 边界限制，更美观
    fileprivate var btnColor: UIColor?
    fileprivate var textColor: UIColor?
    fileprivate var Color: UIColor = UIColor.black
    //    fileprivate var varBtnColor: UIColor?
    //    fileprivate var varTextColor: UIColor?
    
    
    lazy var button = UIButton()
    lazy var buttonAllArray:[UIButton] = []
    var handler: Action!
    
    
    // MARK -- addButtonGroups
    func addButtonGroupsToCell(buttonArr: Array<String>, leftLimit: CGFloat = 0, rightLimit: CGFloat = 320, mainAction: Action) -> UIView? {
        
        guard buttonArr.count >= 0 else { return nil} // 限制传入的button.cout不为负数
        buttonGroupsArr = buttonArr
        viewHeight = getViewHeight(title: buttonArr, leftLimit: leftLimit, rightLimit: rightLimit)
        let view = buildTextButton(title: buttonArr, leftLimit: leftLimit ,rightLimit: rightLimit, viewHeight: viewHeight, mainAction: mainAction)
        return view
    }
    
    // MARK -- Layout
    fileprivate func buildTextButton(title: [String], leftLimit: CGFloat,rightLimit: CGFloat, viewHeight: CGFloat, mainAction: Action) -> UIView? {
        
        let hadoView = UIView(frame: CGRect(x: 0, y: 0, width: rightLimit, height: viewHeight))
        hadoView.isUserInteractionEnabled = true
        //hadoView.isExclusiveTouch = true
        currentX = 10
        currentY = 50
        for (index, name) in buttonGroupsArr.enumerated() {
            buttonName = name
            setButtonSize(startLimit: leftLimit)
            getButtonColor()
            restrictButton(maxWidth: rightLimit)
            currentLenght = currentX + button.frame.size.width
            if currentLenght < rightLimit {
                button.add(for: .touchUpInside, (mainAction.function))
                hadoView.addSubview(button)
                buttonAllArray.append(button)
                currentX += button.frame.size.width + 10
            } else {
                currentX = 10
                currentY += 40
                setButtonSize(startLimit: leftLimit)
                getButtonColor()
                restrictButton(maxWidth: rightLimit)
                button.add(for: .touchUpInside, (mainAction.function))
                hadoView.addSubview(button)
                buttonAllArray.append(button)
                currentX = currentX + button.frame.size.width + 10;
            }
        }
        return hadoView
    }
    
    func getViewHeight(title: [String], leftLimit: CGFloat,rightLimit: CGFloat) -> CGFloat {
        for (index, name) in buttonGroupsArr.enumerated() {
            buttonName = name
            setButtonSize(startLimit: leftLimit)
            restrictButton(maxWidth: rightLimit)
            getButtonColor()
            currentLenght = currentX + button.frame.size.width
            if currentLenght < rightLimit {
                currentX += button.frame.size.width + 10
            } else {
                currentX = 10
                currentY += 40
                setButtonSize(startLimit: leftLimit)
                restrictButton(maxWidth: rightLimit)
                setButtonColor(_textColor: textColor!, _btnColor: btnColor!)
                currentX = currentX + button.frame.size.width + 10;
            }
        }
        viewHeight = currentY + 50
        return viewHeight
    }
    //
    //    @objc func btnClick() {
    //        if handler != nil {
    //
    //        }
    //    }
    //
    //    func btnClickBlock(btn: Action){
    //        ///调用block
    //        handler = btn
    //    }
    
    
    fileprivate func setButtonSize(startLimit: CGFloat) {
        button = UIButton(frame: CGRect(x: currentX, y: currentY, width: startLimit + currentWidth, height: 30));
        button.layer.cornerRadius = 16
        button.frame.size.height = 30
        button.setTitle(buttonName, for: .normal)
        button.sizeToFit()
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
    }
    //    func setButtonColor(_textColor: UIColor = .black, _btnColor: UIColor = UIColor(hex6: 0xeeeeee)) {
    //        textColor = _textColor
    //        btnColor = _btnColor
    //    }
    func setButtonColor(_textColor: UIColor, _btnColor: UIColor) {
        textColor = _textColor
        btnColor = _btnColor
    }
    
    //    func setChangeButtonColor(_textColor: UIColor, _btnColor: UIColor) {
    //        varTextColor = _textColor
    //        varBtnColor = _btnColor
    //    }
    fileprivate func getButtonColor() {
        button.backgroundColor = btnColor
        button.setTitleColor(textColor, for: .normal);
        //button.setTitleColor(UIColor(hex6: 0x00a1e9), for: .selected)
    }
    fileprivate func setChangeButtonColor(textColor: UIColor, btnColor: UIColor) {
        button.backgroundColor = btnColor
    }
    fileprivate func restrictButton(maxWidth: CGFloat) {
        if button.frame.size.width > maxWidth - limit {
            button.frame.size.width = maxWidth - limit;
        }
        if button.frame.size.width < limit {
            button.frame.size.width = limit
        }
    }
}
extension UIView {
    //获取view所在的 视图控制器
    var viewController: UIViewController? {
        get {
            var nextResponder = next
            while  (nextResponder != nil){
                if nextResponder is UIViewController {
                    return nextResponder as! UIViewController?
                }
                nextResponder = nextResponder?.next
            }
            return nil
        }
    }
}

extension UIView {
    
    func firstController() -> UITableViewCell? {
        for view in sequence(first: self.superview, next: { $0?.superview }) {
            if let responder = view?.next {
                if responder.isKind(of: UITableViewCell.self){
                    return responder as? UITableViewCell
                }
                
            }
        }
        return nil
    }
}
