//
//  GetJobPageViewController.swift
//  WePeiYang
//
//  Created by 王春杉 on 2019/2/12.
//  Copyright © 2019 twtstudio. All rights reserved.
//

import UIKit
import WMPageController

struct Device {
    static let width = UIScreen.main.bounds.width
    static let height = UIScreen.main.bounds.height
}
class GetJobPageViewController: WMPageController {
    // MARK: - 导航栏设置
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(color: UIColor(hex6: 0x48b28a)), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.titleTextAttributes =
            [NSAttributedStringKey.foregroundColor: UIColor.white]
        self.navigationController?.navigationBar.tintColor = UIColor.white
        self.reloadData()

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        setPageView()
        initNavButton()
        self.viewControllerClasses = [RecruitmentInfoViewController.self, JobFairViewController.self, AnnouncementViewController.self, TrendsViewController.self]
        self.titles = ["招聘信息", "招聘会", "公告", "动态"]
    }
    
    func setPageView() {
        self.title = "就业"
        navigationController?.navigationBar.barStyle = .black

        menuItemWidth = Device.width/6   // 每个 MenuItem 的宽度
        menuHeight = 50            // 导航栏高度
        postNotification = true
        bounces = true
        titleSizeSelected = 15    // 选中时的标题尺寸
        titleSizeNormal = 14      // 非选中时的标题尺寸
        menuViewStyle = .line    // Menu view 的样式，默认为无下划线
        titleColorSelected = UIColor(hex6: 0x48b28a)    //标题选中时的颜色, 颜色是可动画的.
        titleColorNormal = UIColor.black    //标题非选择时的颜色, 颜色是可动画的
        menuBGColor = UIColor.white        //导航栏背景色
    
    }
    // 初始化导航栏右侧按钮
    func initNavButton() {
        let searchBarButton = UIBarButtonItem(image: UIImage.resizedImage(image: #imageLiteral(resourceName: "搜索"), scaledToSize: CGSize(width: 30, height: 30)), style: .plain, target: self, action: #selector(searchButton(item:)))
        self.navigationItem.rightBarButtonItem = searchBarButton
    }
    
    @objc func searchButton(item: UIBarButtonItem) {
        let vc = GetJobSearchViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
