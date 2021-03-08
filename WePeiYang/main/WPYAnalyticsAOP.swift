//
//  WPYAnalyticsAOP.swift
//  WePeiYang
//
//  Created by 赵家琛 on 2018/12/16.
//  Copyright © 2018 twtstudio. All rights reserved.
//

import UIKit
import PopupDialog
import SwiftMessages

struct WPYAnalyticsAOP {
    static let pageTimeSet = Set(["FavViewController", "NewsViewController", "AllModulesViewController", "SettingsViewController", "NewsDetailViewController", "GPAViewController", "ClassTableViewController", "AuditHomeViewController", "AuditDetailViewController", "AuditSearchViewController", "BicycleServiceViewController", "MallViewController", "YellowPageMainViewController", "YellowPageDetailViewController", "YellowPageSearchViewController", "WLANLoginViewController", "LibraryMainViewController", "BookDetailViewController", "LibraryBindingViewController", "BicycleBindingViewController", "ECardBindingViewController", "TJUBindingViewController", "WLANBindingViewController", "DetailSettingViewController", "ClassTableSettingViewController", "ModulesSettingsViewController", "SupportWebViewController", "ExamtableController"])
    
    // "LibraryBorrowViewController", "LibraryReadViewController", "LibraryListViewController"
    // "BicycleServiceMapController", "BicycleServiceInfoController", "BicycleServiceNotificationController"

    static func findViewController(source: UIView) -> UIViewController? {
        var next = source.next
        while next != nil {
            if next is UIViewController {
                return next as? UIViewController
            }
            
            next = next?.next
        }
        return nil
    }

    static let clickEventDic: [String: [String: String]] = ["ClassTableViewController": ["toggleWeekSelectWithSender:": "点击课程表选择周数按钮",
                                                                                         "audit": "点击课程表蹭课按钮",
                                                                                         "load": "点击课程表刷新按钮"],
                                                            "AuditHomeViewController": ["search:": " 点击蹭课的搜索按钮"],
                                                            "ModulesSettingsViewController": ["switchValueChangedWithSender:": "点击模块开关"],
                                                            "GPAViewController": ["refresh": "点击 GPA 刷新按钮",
                                                                                  "segmentValueChangedWithSender:": "点击 GPA 排序切换按钮"],
                                                            "ECardBindingViewController": ["dismissBinding": "校园卡绑定页面点击暂不绑定",
                                                                                           "bind": "校园卡绑定页面点击绑定"],
                                                            "TJUBindingViewController": ["dismissBinding": "办公网绑定页面点击暂不绑定",
                                                                                         "bind": "办公网绑定页面点击绑定"],
                                                            "LibraryBindingViewController": ["dismissBinding": "图书馆绑定页面点击暂不绑定",
                                                                                             "bind": "图书馆绑定页面点击绑定"],
                                                            "BicycleBindingViewController": ["dismissBinding": "自行车绑定页面点击暂不绑定",
                                                                                             "bind": "自行车绑定页面点击绑定"],
                                                            "WLANBindingViewController": ["dismissBinding": "校园网绑定页面点击暂不绑定",
                                                                                          "bind": "校园网绑定页面点击绑定"],
                                                            "SettingsViewController": ["login": "设置界面点击登录"]]



    static let collectionClickArr: [String] = ["collection 界面点击 GPA 模块", "collection 界面点击课程表模块", "collection 界面点击自行车模块", "collection 界面点击党建模块", "collection 界面点击商城模块", "collection 界面点击黄页模块", "collection 界面点击上网模块", "collection 界面点击图书馆模块"]
}

extension UIApplication {
    static func beginSwizzling() {
        swizzleMethod
    }

    private static let swizzleMethod: Void = {
        let originalSelector = #selector(UIApplication.sendAction(_:to:from:for:))
        let swizzledSelector = #selector(UIApplication.swizzled_sendAction(_:to:from:for:))

        let originalMethod = class_getInstanceMethod(UIApplication.self, originalSelector)
        let swizzledMethod = class_getInstanceMethod(UIApplication.self, swizzledSelector)

        method_exchangeImplementations(originalMethod!, swizzledMethod!)
    }()

    @objc func swizzled_sendAction(_ action: Selector, to target: Any?, from sender: Any?, for event: UIEvent?) -> Bool {
        if let targetVC = target as? UIViewController {
            let pageName = String(describing: type(of: targetVC.self))
            if let pageDic = WPYAnalyticsAOP.clickEventDic[pageName], let actionName = pageDic[NSStringFromSelector(action)] {
                //log(actionName)
//                MTA.trackCustomKeyValueEvent("click", props: ["name": actionName])
            }
        }
        return self.swizzled_sendAction(action, to: target, from: sender, for: event)
//        var count: UInt32 = 0
//        let list = class_copyIvarList(object_getClass(sender), &count)
//        for i in 0..<Int(count) {
//            let ivar = list![i]
//            let name = ivar_getName(ivar)
//            let type = ivar_getTypeEncoding(ivar)
//            log("\n\(String.init(cString: name!))" + "--------------------" + "\(String.init(cString: type!))\n")
//
//        }
    }
}

extension UITableView {
    static func beginSwizzling() {
        swizzleMethod
    }

    private static let swizzleMethod: Void = {
        let originalSelector = #selector(setter: UITableView.delegate)
        let swizzledSelector = #selector(UITableView.swizzled_setDelegate(delegate:))

        let originalMethod = class_getInstanceMethod(UITableView.self, originalSelector)
        let swizzledMethod = class_getInstanceMethod(UITableView.self, swizzledSelector)

        method_exchangeImplementations(originalMethod!, swizzledMethod!)
    }()

    @objc private func swizzled_setDelegate(delegate: UITableViewDelegate?) {
        self.swizzled_setDelegate(delegate: delegate)
        guard let delegate = delegate else {
            return
        }

        let originalSelector = #selector(delegate.tableView(_:didSelectRowAt:))
        let swizzledSelector = #selector(UITableView.swizzled_tableView(_:didSelectRowAt:))

        guard let swizzledMethod = class_getInstanceMethod(UITableView.self, swizzledSelector), let _ = class_getInstanceMethod(object_getClass(delegate), originalSelector) else {
            return
        }

        if class_addMethod(object_getClass(delegate), swizzledSelector, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod)) {
            let didSelectOriginalMethod = class_getInstanceMethod(object_getClass(delegate), originalSelector)
            let didSelectSwizzledMethod = class_getInstanceMethod(object_getClass(delegate), swizzledSelector)

            method_exchangeImplementations(didSelectOriginalMethod!, didSelectSwizzledMethod!)
        }
    }

    @objc func swizzled_tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.swizzled_tableView(tableView, didSelectRowAt: indexPath)

        if let VC = WPYAnalyticsAOP.findViewController(source: tableView) {
            switch VC {
            case is SettingsViewController:
                if indexPath.section == 1 {
                    //log("【设置】点击设置")
//                    MTA.trackCustomKeyValueEvent("click", props: ["name": "【设置】点击设置"])
                } else {
                    let row = indexPath.row
                    if row == 0 {
                        //log("【设置】点击图书馆")
//                        MTA.trackCustomKeyValueEvent("click", props: ["name": "【设置】点击图书馆"])
                    } else if row == 1 {
                        //log("【设置】点击自行车")
//                        MTA.trackCustomKeyValueEvent("click", props: ["name": "【设置】点击自行车"])
                    } else if row == 2 {
                        //log("【设置】点击办公网")
//                        MTA.trackCustomKeyValueEvent("click", props: ["name": "【设置】点击办公网"])
                    } else if row == 3 {
                        //log("【设置】点击校园网")
//                        MTA.trackCustomKeyValueEvent("click", props: ["name": "【设置】点击校园网"])
                    } else if row == 4 {
                        //log("【设置】点击校园卡")
//                        MTA.trackCustomKeyValueEvent("click", props: ["name": "【设置】点击校园卡"])
                    }
                }
            case is DetailSettingViewController:
                let row = indexPath.row
                switch indexPath.section {
                case 0:
                    if row == 0 {
                        //log("【设置】点击课表提醒设置")
//                        MTA.trackCustomKeyValueEvent("click", props: ["name": "【设置】点击课表提醒设置"])
                    } else if row == 1 {
                        //log("【设置】点击摇一摇登录校园网")
//                        MTA.trackCustomKeyValueEvent("click", props: ["name": "【设置】点击摇一摇登录校园网"])
                    } else if row == 2 {
                        //log("【设置】点击模块设置")
//                        MTA.trackCustomKeyValueEvent("click", props: ["name": "【设置】点击模块设置"])
                    }
                case 1:
                    if row == 0 {
                        //log("【设置】点击加入我们")
//                        MTA.trackCustomKeyValueEvent("click", props: ["name": "【设置】点击加入我们"])
                    } else if row == 1 {
                        //log("【设置】点击用户协议")
//                        MTA.trackCustomKeyValueEvent("click", props: ["name": "【设置】点击用户协议"])
                    } else if row == 2 {
                        //log("【设置】点击建议与反馈")
//                        MTA.trackCustomKeyValueEvent("click", props: ["name": "【设置】点击建议与反馈"])
                    } else if row == 3 {
                        //log("【设置】点击加入 QQ 反馈群")
//                        MTA.trackCustomKeyValueEvent("click", props: ["name": "【设置】点击加入 QQ 反馈群"])
                    }
                case 2:
                    if row == 0 {
                        //log("【设置】点击推荐给朋友")
//                        MTA.trackCustomKeyValueEvent("click", props: ["name": "【设置】点击推荐给朋友"])
                    } else if row == 1 {
                        //log("【设置】点击给微北洋评分")
//                        MTA.trackCustomKeyValueEvent("click", props: ["name": "【设置】点击给微北洋评分"])
                    } else if row == 2 {
                        //log("【设置】点击退出登录")
//                        MTA.trackCustomKeyValueEvent("click", props: ["name": "【设置】点击退出登录"])
                    }
                default :
                    break;
                }
            default:
                break
            }
        }

    }
}

extension UICollectionView {
    static func beginSwizzling() {
        swizzleMethod
    }

    private static let swizzleMethod: Void = {
        let originalSelector = #selector(setter: UICollectionView.delegate)
        let swizzledSelector = #selector(UICollectionView.swizzled_setDelegate(delegate:))

        let originalMethod = class_getInstanceMethod(UICollectionView.self, originalSelector)
        let swizzledMethod = class_getInstanceMethod(UICollectionView.self, swizzledSelector)

        method_exchangeImplementations(originalMethod!, swizzledMethod!)
    }()

    @objc private func swizzled_setDelegate(delegate: UICollectionViewDelegate?) {
        self.swizzled_setDelegate(delegate: delegate)
        guard let delegate = delegate else {
            return
        }

        let originalSelector = #selector(delegate.collectionView(_:didSelectItemAt:))
        let swizzledSelector = #selector(UICollectionView.swizzled_collectionView(_:didSelectItemAt:))

        guard let swizzledMethod = class_getInstanceMethod(UICollectionView.self, swizzledSelector), let _ = class_getInstanceMethod(object_getClass(delegate), originalSelector) else {
            return
        }

        if class_addMethod(object_getClass(delegate), swizzledSelector, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod)) {
            let didSelectOriginalMethod = class_getInstanceMethod(object_getClass(delegate), originalSelector)
            let didSelectSwizzledMethod = class_getInstanceMethod(object_getClass(delegate), swizzledSelector)

            method_exchangeImplementations(didSelectOriginalMethod!, didSelectSwizzledMethod!)
        }
    }

    @objc private func swizzled_collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.swizzled_collectionView(collectionView, didSelectItemAt: indexPath)

        if let VC = WPYAnalyticsAOP.findViewController(source: collectionView), VC is AllModulesViewController {
            let row = indexPath.row
            if row < WPYAnalyticsAOP.collectionClickArr.count {
                //log(WPYAnalyticsAOP.collectionClickArr[row])
//                MTA.trackCustomKeyValueEvent("click", props: ["name": WPYAnalyticsAOP.collectionClickArr[row]])
            }
        }
    }
}

extension UIViewController {
    static func beginSwizzling() {
        swizzleViewDidAppearMethod
        swizzleViewWillDisappearMethod
        swizzleViewDidLoadMethod
    }

    private static let swizzleViewDidAppearMethod: Void = {
        let originalSelector = #selector(UIViewController.viewDidAppear(_:))
        let swizzledSelector = #selector(UIViewController.swizzled_viewDidAppear(_:))

        let originalMethod = class_getInstanceMethod(UIViewController.self, originalSelector)
        let swizzledMethod = class_getInstanceMethod(UIViewController.self, swizzledSelector)

        let didAddMethod: Bool = class_addMethod(UIViewController.self, originalSelector, method_getImplementation(swizzledMethod!), method_getTypeEncoding(swizzledMethod!))

        if didAddMethod {
            class_replaceMethod(UIViewController.self, swizzledSelector, method_getImplementation(originalMethod!), method_getTypeEncoding(originalMethod!))
        } else {
            method_exchangeImplementations(originalMethod!, swizzledMethod!)
        }
    }()

    private static let swizzleViewWillDisappearMethod: Void = {
        let originalSelector = #selector(UIViewController.viewWillDisappear(_:))
        let swizzledSelector = #selector(UIViewController.swizzled_viewWillDisappear(_:))

        let originalMethod = class_getInstanceMethod(UIViewController.self, originalSelector)
        let swizzledMethod = class_getInstanceMethod(UIViewController.self, swizzledSelector)

        let didAddMethod: Bool = class_addMethod(UIViewController.self, originalSelector, method_getImplementation(swizzledMethod!), method_getTypeEncoding(swizzledMethod!))

        if didAddMethod {
            class_replaceMethod(UIViewController.self, swizzledSelector, method_getImplementation(originalMethod!), method_getTypeEncoding(originalMethod!))
        } else {
            method_exchangeImplementations(originalMethod!, swizzledMethod!)
        }
    }()

    private static let swizzleViewDidLoadMethod: Void = {
        let originalSelector = #selector(UIViewController.viewDidLoad)
        let swizzledSelector = #selector(UIViewController.swizzled_viewDidLoad)

        let originalMethod = class_getInstanceMethod(UIViewController.self, originalSelector)
        let swizzledMethod = class_getInstanceMethod(UIViewController.self, swizzledSelector)

        let didAddMethod: Bool = class_addMethod(UIViewController.self, originalSelector, method_getImplementation(swizzledMethod!), method_getTypeEncoding(swizzledMethod!))

        if didAddMethod {
            class_replaceMethod(UIViewController.self, swizzledSelector, method_getImplementation(originalMethod!), method_getTypeEncoding(originalMethod!))
        } else {
            method_exchangeImplementations(originalMethod!, swizzledMethod!)
        }
    }()

    @objc func swizzled_viewDidAppear(_ animated: Bool) {
        self.swizzled_viewDidAppear(animated)

        let pageName = String(describing: self.classForCoder)
        if WPYAnalyticsAOP.pageTimeSet.contains(pageName) {
            //log(pageName)
//            MTA.trackPageViewBegin(pageName)
        }
    }

    @objc func swizzled_viewWillDisappear(_ animated: Bool) {
        self.swizzled_viewWillDisappear(animated)

        let pageName = String(describing: self.classForCoder)
        if WPYAnalyticsAOP.pageTimeSet.contains(pageName) {
            //log(pageName)
//            MTA.trackPageViewEnd(pageName)
        }

    }

    @objc func swizzled_viewDidLoad() {
        self.swizzled_viewDidLoad()

//        switch self {
//        case is ExamtableController:
//            MTA.trackCustomKeyValueEvent("expose", props: ["name": "进入考表页面"])
//        case is FavViewController:
//            //log("进入首页的卡片页面")
//            MTA.trackCustomKeyValueEvent("expose", props: ["name": "进入首页的卡片页面"])
//        case is AllModulesViewController:
//            //log("进入首页的collection页面")
//            MTA.trackCustomKeyValueEvent("expose", props: ["name": "进入首页的 collection 页面"])
//        case is NewsViewController:
//            //log("进入首页的新闻页面")
//            MTA.trackCustomKeyValueEvent("expose", props: ["name": "进入首页的新闻页面"])
//        case is SettingsViewController:
//            //log("进入首页的设置页面")
//            MTA.trackCustomKeyValueEvent("expose", props: ["name": "进入首页的设置页面"])
//        case is NewsDetailViewController:
//            //log("进入新闻的详情页面")
//            MTA.trackCustomKeyValueEvent("expose", props: ["name": "进入新闻的详情页面"])
//        case is MallViewController:
//            //log("进入天外天商城页面")
//            MTA.trackCustomKeyValueEvent("expose", props: ["name": "进入天外天商城页面"])
//        case is BicycleServiceViewController:
//            //log("进入自行车页面")
//            MTA.trackCustomKeyValueEvent("expose", props: ["name": "进入自行车页面"])
//        case is WLANLoginViewController:
//            //log("进入上网页面")
//            MTA.trackCustomKeyValueEvent("expose", props: ["name": "进入上网页面"])
//        case is LibraryBorrowViewController:
//            //log("进入图书馆已借阅页面")
//            MTA.trackCustomKeyValueEvent("expose", props: ["name": "进入图书馆已借阅页面"])
//        case is LibraryListViewController:
//            //log("进入图书馆借阅统计页面")
//            MTA.trackCustomKeyValueEvent("expose", props: ["name": "进入图书馆借阅统计页面"])
//        case is LibraryReadViewController:
//            //log("进入图书馆阅读板块页面")
//            MTA.trackCustomKeyValueEvent("expose", props: ["name": "进入图书馆阅读板块页面"])
//        case is BookDetailViewController:
//            //log("进入图书详情页面")
//            MTA.trackCustomKeyValueEvent("expose", props: ["name": "进入图书详情页面"])
//        case is LibraryMainViewController:
//            if self.navigationController?.viewControllers.first is LibraryMainViewController {
//                MTA.trackCustomKeyValueEvent("expose", props: ["name": "从卡片页面进入图书馆"])
//            } else {
//                MTA.trackCustomKeyValueEvent("expose", props: ["name": "从 collection 页面进入图书馆"])
//            }
//        case is ClassTableViewController:
//            if self.navigationController?.viewControllers.first is ClassTableViewController {
//                MTA.trackCustomKeyValueEvent("expose", props: ["name": "从卡片页面进入课程表"])
//            } else {
//                MTA.trackCustomKeyValueEvent("expose", props: ["name": "从 collection 页面进入课程表"])
//            }
//        case is GPAViewController:
//            if self.navigationController?.viewControllers.first is GPAViewController {
//                MTA.trackCustomKeyValueEvent("expose", props: ["name": "从卡片页面进入 GPA"])
//            } else {
//                MTA.trackCustomKeyValueEvent("expose", props: ["name": "从 collection 页面进入 GPA"])
//            }
//        case is CardTransactionViewController:
//            if self.navigationController?.viewControllers.first is CardTransactionViewController {
//                MTA.trackCustomKeyValueEvent("expose", props: ["name": "从卡片页面进入校园卡"])
//            } else {
//                //貌似没那个入口。。。
//                MTA.trackCustomKeyValueEvent("expose", props: ["name": "从 collection 页面进入校园卡"])
//            }
//        case is YellowPageMainViewController:
//            //log("进入黄页主页面")
//            MTA.trackCustomKeyValueEvent("expose", props: ["name": "进入黄页主页面"])
//        case is YellowPageSearchViewController:
//            //log("进入黄页搜索页面")
//            MTA.trackCustomKeyValueEvent("expose", props: ["name": "进入黄页搜索页面"])
//        case is YellowPageDetailViewController:
//            if let title = self.navigationItem.title {
//                //log("进入黄页\(title)页面")
//                MTA.trackCustomKeyValueEvent("expose", props: ["name": "进入黄页\(title)页面"])
//            }
//        default:
//            break
//            //log(self)
//        }

    }

}
