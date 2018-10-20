//
//  LostFoundPageViewController.swift
//  WePeiYang
//
//  Created by JasonEWNL on 2018/10/20.
//  Copyright © 2018年 twtstudio. All rights reserved.
//

import UIKit
import WMPageController

class LostFoundPageViewController: WMPageController {
    
    var rootView: UIView!
    var fab: FAB!
    
    lazy var levelArr: [Any]? = {
        return ["全部", "日期"]
    }()
    
    lazy var menu: DropDownMenu = {
        var me = DropDownMenu.initMenu(size: CGSize(width: UIScreen.main.bounds.size.width / 3, height: self.view.frame.size.height / 3))
        self.view.addSubview(me)
        return me
    }()
    
    /**
     菜单的弹出 和 收回
     */
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if self.menu.isShow! == false {
            
            let point = CGPoint(x: 100, y: 100)
            self.menu.popupMenu(originPonit: point, arr: self.levelArr!)
            
        } else {
            
            self.menu.packUpMenu()
        }
    }
    
    //    var data: [(title: String, viewController: UIViewController)] {
    //        return [("丢失", LostViewController()), ("捡到", FoundViewController())]
    //    }
    
    //Mark --导航栏（Navigationbar）的配置
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(color: UIColor(hex6: 0x00a1e9)), for: UIBarMetrics.default)
        //        self.navigationController?.navigationBar.barTintColor = UIColor(hex6: 0x00a1e9)
        self.navigationController?.navigationBar.titleTextAttributes =
            [NSAttributedStringKey.foregroundColor: UIColor.white]
        self.navigationController?.navigationBar.tintColor = UIColor.white
        UIApplication.shared.keyWindow?.addSubview(fab)
        fab.showUp()
        self.reloadData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        fab.removeFromSuperview()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configUI()
        // 导航栏的设置
        initNavButton()
        
        refresh()
        self.viewControllerClasses = [FoundViewController.self, LostViewController.self]
        self.titles = ["捡到", "丢失"]
        //        rootView = UIView(frame: UIScreen.main.bounds)
        //        self.view.bringSubview(toFront: rootView)
        fab = FAB(subActions: [
            (name: "发布丢失信息", function: {
                
                let vc = PublishLostViewController()
                vc.pushTag = MyURLState.lostURL.rawValue
                vc.newTitle = "丢失物品"
                self.navigationController?.pushViewController(vc, animated: true)
                self.fab.dismissAnimated()
            }),
            (name: "发布找到信息", function: {
                let vc = PublishLostViewController()
                vc.pushTag = MyURLState.foundURL.rawValue
                vc.newTitle = "找到物品"
                self.navigationController?.pushViewController(vc, animated: true)
                self.fab.dismissAnimated()
            })
            ])
        //        rootView.addSubview(fab)
        self.view.addSubview(fab)
        //        let tap = UITapGestureRecognizer(target: fab, action: #selector(FAB.dismissAnimated))
        
        //        view.addGestureRecognizer(tap)
        fab.showUp()
    }
    
    func configUI() {
        self.title = "失物招领"
        
        //        let leftBarBtn = UIBarButtonItem(title: "返回", style: .plain, target: #selector(backToPrevious(sender:)), action: nil)
        //        self.navigationItem.leftBarButtonItem = leftBarBtn
        
        navigationController?.navigationBar.barStyle = .black
        //        UIApplication.shared.statusBarStyle = .lightContent
        pageAnimatable = true
        menuViewStyle = .line
        titleSizeSelected = 16.0
        titleSizeNormal = 15.0
        menuHeight = 50
        titleColorSelected = UIColor(hex6: 0x00a1e9)
        titleColorNormal = UIColor(hex6: 0xD3D3D3)
        menuItemWidth = self.view.frame.size.width/2
        menuBGColor = .white
        progressColor = UIColor(hex6: 0x00a1e9)
    }
    
    func initNavButton() {
        // 导航栏的设置，代码可以优化
        //        let mine = #imageLiteral(resourceName: "用户")
        //        let search = #imageLiteral(resourceName: "右上角搜索")
        //        let mineButton = UIButton(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
        //        mineButton.setImage(mine, for: .normal)
        //        mineButton.addTarget(self, action: #selector(self.mineButton(item:)), for: .touchUpInside)
        let mineBarButton = UIBarButtonItem(image: UIImage.resizedImage(image: #imageLiteral(resourceName: "用户"), scaledToSize: CGSize(width: 20, height: 20)), style: .plain, target: self, action: #selector(mineButton(item:)))
        
        let searchBarButton = UIBarButtonItem(image: UIImage.resizedImage(image: #imageLiteral(resourceName: "右上角搜索"), scaledToSize: CGSize(width: 20, height: 20)), style: .plain, target: self, action: #selector(searchButton(item:)))
        
        self.navigationItem.rightBarButtonItems = [mineBarButton, searchBarButton]
    }
    
    func refresh() {
        GetFoundAPI.getFound(page: 1, success: { (founds) in
            foundList = founds
            //            self.foundView.reloadData()
        }) { _ in
        }
        
        GetLostAPI.getLost(page: 1, success: { (losts) in
            lostList = losts
            //            self.lostView.reloadData()
        }) { _ in
        }
    }
    
    func backToPrevious(sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func mineButton(item: UIBarButtonItem) {
        let vc = MyLostFoundPageViewController()
        self.navigationController?.pushViewController(vc, animated: true)
        //        if self.menu.isShow! == false {
        //
        //            let point = CGPoint(x:100,y: 100)
        //            self.menu.popupMenu(originPonit:point, arr: self.levelArr!)
        //
        //            self.menu.didSelectIndex = { [unowned self] (index:Int) in
        //
        //            }
        //        }else{
        //
        //            self.menu.packUpMenu()
        //        }
        
    }
    
    @objc func searchButton(item: UIBarButtonItem) {
        let vc = LostFoundSearchViewController()
        self.navigationController?.pushViewController(vc, animated: true)
        //        let successVC = PublishSuccessViewController()
        //        self.navigationController?.pushViewController(successVC, animated: true)
    }
    
}
