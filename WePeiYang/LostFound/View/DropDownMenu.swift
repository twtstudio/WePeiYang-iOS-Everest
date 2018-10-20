//
//  DropDownMenu.swift
//  WePeiYang
//
//  Created by JasonEWNL on 2018/10/20.
//  Copyright © 2018年 twtstudio. All rights reserved.
//

import UIKit

/*
 
 这是个下拉菜单的封装，通常用在导航栏的二级等，需要传入array和frame，
 如果想要分栏效果，请自己补充，因为我只在失物招领用到单列的，
 单列调用很简单，只需要传入数组和frame就好
 友情提示：
 需要功能自己补充，架子已经成型，多列是使用collectionVC还是tableview自定义cell建立button，随您！
 */

/*
 需要一个传入数组
 lazy var levelArr: Array<Any>? = {
 return ["全部","日期"]
 }()
 
 lazy var menu: DropDownMenu = {
 var me = DropDownMenu.initMenu(size: CGSize(width:UIScreen.main.bounds.size.width / 3,height:self.view.frame.size.height / 3))
 self.view.addSubview(me)
 return me
 }()
 */

/*
 
 菜单的弹出 和 收回
 
 override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
 
 if self.menu.isShow! == false {
 
 let point = CGPoint(x:100,y: 100)
 self.menu.popupMenu(originPonit:point, arr: self.levelArr!)
 
 self.menu.didSelectIndex = { [unowned self] (index:Int) in
 
 }
 }else{
 
 self.menu.packUpMenu()
 }
 }
 */

class DropDownMenu: UIView, UITableViewDelegate, UITableViewDataSource {
    
    // 定义menu
    var menuTableView: UITableView?
    var menuArr: [Any]?
    let cellIdentifier = "cellID"
    //menu选中时的方法
    var didSelectIndex:((_ index: Int) -> Void)?
    //加载动画
    var isShow: Bool?
    var menuSize: CGSize?
    
    class func initMenu(size: CGSize) -> DropDownMenu {
        let frame = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        let me = DropDownMenu.init(frame: frame)
        me.menuSize = size
        return me
    }
    
    override init(frame: CGRect) {
        let initialFrame = CGRect(x: frame.origin.x, y: frame.origin.y, width: frame.size.width, height: 0.0)
        super.init(frame: initialFrame)
        self.backgroundColor = .black
        menuTableView = UITableView.init(frame: CGRect(x: 0, y: 0, width: frame.size.width, height: 0 ), style: .plain)
        menuTableView?.tableFooterView = UIView.init()
        //        menuTableView?.separatorColor = .clear
        menuTableView?.delegate = self
        menuTableView?.dataSource = self
        addSubview(menuTableView!)
        menuTableView?.isHidden = true
        isShow = false
        isHidden = true
        //self.isUserInteractionEnabled = true
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // 弹出菜单
    func popupMenu(originPonit: CGPoint, arr: [Any]) {
        if isShow == true {
            return
        }
        isShow = true
        isHidden = false
        menuTableView?.isHidden = false
        
        self.frame.origin = originPonit
        self.menuArr = arr
        self.menuTableView?.reloadData()
        self.superview?.bringSubview(toFront: self)
        self.menuTableView?.frame.size.height = 0.0
        
        // 动画
        UIView.animate(withDuration: 0.5, animations: {
            
            self.frame.size.height = (self.menuSize!.height)
            self.menuTableView?.frame.size.height = (self.menuSize!.height)
            
        }) { _ in
        }
    }
    
    func packUpMenu() {
        
        if self.isShow == false {
            return
        }
        self.isShow = false
        
        UIView.animate(withDuration: 0.5, animations: {
            
            self.menuTableView?.frame.size.height = 0.0
            self.frame.size.height = 0.0
            
        }) { _ in
            
            self.isHidden = true
            self.menuTableView?.isHidden = true
        }
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if (menuArr?.count) != nil {
            return (menuArr?.count)!
        }
        return 1
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell = menuTableView?.dequeueReusableCell(withIdentifier: cellIdentifier)
        if cell == nil {
            cell = UITableViewCell.init(style: .default, reuseIdentifier: cellIdentifier)
        }
        cell?.textLabel?.text = menuArr?[indexPath.row] as? String
        cell?.textLabel?.textAlignment = .center
        cell?.textLabel?.font = UIFont.systemFont(ofSize: 11.0)
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 20
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        /**
         这里是把 选中的 indexPath 传值出去 ， 关闭menu列表
         */
        if self.didSelectIndex != nil {
            self.didSelectIndex!(indexPath.row)
        }
        self.packUpMenu()
    }
    
    /*
     // Only override draw() if you perform custom drawing.
     // An empty implementation adversely affects performance during animation.
     override func draw(_ rect: CGRect) {
     // Drawing code
     }
     */
    
}
