//
//  AppDelegate.swift
//  WePeiYang
//
//  Created by Allen X on 3/7/17.
//  Copyright © 2017 twtstudio. All rights reserved.
//

import UIKit
import UserNotifications
import PopupDialog

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var mainTabVC: WPYTabBarController!
    var arWindow: UIWindow!

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {

        MTA.start(withAppkey: "IUY2I5P1Y3VI")
        UIApplication.beginSwizzling()
        UIViewController.beginSwizzling()
        UITableView.beginSwizzling()
        UICollectionView.beginSwizzling()

        window = UIWindow(frame: UIScreen.main.bounds)

        UIApplication.shared.applicationIconBadgeNumber = 0

//        TwTUser.shared.load() // load token and so on
        TwTUser.shared.load(success: {
            
            // 迁移旧缓存
            CacheManager.migrate()

            NotificationCenter.default.post(name: NotificationName.NotificationBindingStatusDidChange.name, object: nil)

            BicycleUser.sharedInstance.auth(success: {
                NotificationCenter.default.post(name: NotificationName.NotificationBindingStatusDidChange.name, object: ("bike", TwTUser.shared.bicycleBindingState))
            })

            WLANHelper.getStatus(success: { _ in

            }, failure: { _ in

            })
            AccountManager.getSelf(success: {
                if let deviceToken = UserDefaults.standard.string(forKey: "deviceToken"),
                    let uid = TwTUser.shared.twtid,
                    let uuid = UIDevice.current.identifierForVendor?.uuidString {
                    let para = ["utoken": deviceToken, "uid": uid, "udid": uuid, "ua": DeviceStatus.userAgent]
                    SolaSessionManager.solaSession(type: .post, url: "/push/token/ENcJ1ZYDBaCvC8aM76RnnrT25FPqQg", token: nil, parameters: para, success: nil, failure: nil)
                }
            }, failure: {

            })
        }, failure: {
            // 让他重新登录
        })

        mainTabVC = WPYTabBarController()

        let favoriteVC = FavViewController()
        favoriteVC.tabBarItem.image = #imageLiteral(resourceName: "Favored")
        let favoriteNavigationController = UINavigationController(rootViewController: favoriteVC)

        let newsVC = NewsViewController()
        newsVC.tabBarItem.image = #imageLiteral(resourceName: "News")
        let infoNavigationController = UINavigationController(rootViewController: newsVC)

        let allModulesVC = AllModulesViewController()
        allModulesVC.tabBarItem.image = #imageLiteral(resourceName: "AllModules")
        let allModulesNavigationController = UINavigationController(rootViewController: allModulesVC)

        let settingsVC = SettingsViewController()
        settingsVC.tabBarItem.image = #imageLiteral(resourceName: "Settings")
        let settingsNavigationController = UINavigationController(rootViewController: settingsVC)

        if !isiPad {
            allModulesVC.tabBarItem.imageInsets = UIEdgeInsets(top: 6, left: 0, bottom: -6, right: 0)
            favoriteVC.tabBarItem.imageInsets = UIEdgeInsets(top: 6, left: 0, bottom: -6, right: 0)
            newsVC.tabBarItem.imageInsets = UIEdgeInsets(top: 6, left: 0, bottom: -6, right: 0)
            settingsVC.tabBarItem.imageInsets = UIEdgeInsets(top: 6, left: 0, bottom: -6, right: 0)
        }

        mainTabVC.setViewControllers([favoriteNavigationController, infoNavigationController, allModulesNavigationController, settingsNavigationController], animated: true)

        UITabBar.appearance().backgroundColor = Metadata.Color.GlobalTabBarBackgroundColor
        UITabBar.appearance().tintColor = Metadata.Color.WPYAccentColor
//        UITabBar.appearance().isOpaque = true

        mainTabVC.selectedIndex = 0
        if #available(iOS 10.0, *) {
            mainTabVC.tabBar.unselectedItemTintColor = Metadata.Color.grayIconColor
        } else {
            // Fallback on earlier versions
        }
//        window?.backgroundColor = .white
        window?.rootViewController = mainTabVC
        window?.makeKeyAndVisible()

        if #available(iOS 11.0, *) {
            let ARModeEnabledKey = "ARModeEnabledKey"
            if UserDefaults.standard.bool(forKey: ARModeEnabledKey) {
//                arWindow = ARKeyWindow()
                arWindow = ARKeyWindow.init(frame: CGRect.zero)
                arWindow.makeKeyAndVisible()
            }
        }

        registerAppNotification(launchOptions: launchOptions)
        registerShortcutItems()
        showMessage()
        showNewFeature()

        return true
    }

    func showMessage() {
        SolaSessionManager.solaSession(type: .get, url: "/app/message", token: nil, parameters: nil, success: { dict in
            if let data = dict["data"] as? [String: Any],
                let version = data["version"] as? Int,
                let title = data["title"] as? String,
                let message = data["message"] as? String {
                let prev = UserDefaults.standard.integer(forKey: MessageKey)
                if version > prev {
                    // new message
                    SwiftMessages.showNotification(title: title, message: message, handler: { _ in
                        UserDefaults.standard.set(version, forKey: MessageKey)
                        SwiftMessages.hideAll()
                    })
                }
            }
        })
    }

    func showNewFeature() {
        let NewFeatureVersionKey = "NewFeatureVersionKey"
        // plus one next version
        let currentVersion = 2

        let version = UserDefaults.standard.integer(forKey: NewFeatureVersionKey)
        if currentVersion > version {
            let popup = PopupDialog(title: "新功能提醒", message: "微北洋支持校园卡查询啦！\n如果使用中发现有问题，请加入「设置」中的QQ群反馈问题，我们会积极解决的!", buttonAlignment: .vertical)
//            let cancelButton = CancelButton(title: "取消", action: nil)
            let goButton = DefaultButton(title: "好哒！", action: {
                UserDefaults.standard.set(currentVersion, forKey: NewFeatureVersionKey)
            })
            popup.addButton(goButton)
            window?.rootViewController?.present(popup, animated: true, completion: nil)
        }
    }

    func registerShortcutItems() {
        // Create Dynamic quick actions using the icon
        let infos = [
            (title: "GPA 查询", iconName: "chart-line", type: "com.twtstudio.gpa"),
            (title: "课程表", iconName: "calendar-text", type: "com.twtstudio.classtable"),
            (title: "自行车", iconName: "bike", type: "com.twtstudio.bike"),
            (title: "黄页", iconName: "contact-mail", type: "com.twtstudio.yellowpage")
        ]

        var shortcutItems = [UIApplicationShortcutItem]()
        for info in infos {
            let item = UIApplicationShortcutItem(type: info.type, localizedTitle: info.title, localizedSubtitle: nil, icon: UIApplicationShortcutIcon(templateImageName: info.iconName), userInfo: nil)
            shortcutItems.append(item)
        }
        // Register the Dynamic quick actions to display on the home Screen
        UIApplication.shared.shortcutItems = shortcutItems
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
        if UIViewController.current is GPAViewController {
            let frostedView = UIVisualEffectView(effect: UIBlurEffect(style: .light))
            frostedView.frame = UIApplication.shared.keyWindow?.bounds ?? UIScreen.main.bounds
            UIApplication.shared.keyWindow?.addSubview(frostedView)
        }
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        if let subviews = UIApplication.shared.keyWindow?.subviews {
            for subview in subviews where subview is UIVisualEffectView {
                subview.removeFromSuperview()
                return
            }
        }
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
}

extension AppDelegate {
    func application(_ application: UIApplication, performActionFor shortcutItem: UIApplicationShortcutItem, completionHandler: @escaping (Bool) -> Void) {
        if TwTUser.shared.token == nil && shortcutItem.type != "com.twtstudio.yellowpage" {
            SwiftMessages.showWarningMessage(body: "请先登录")
            return
        }

        let naviVC = (self.window?.rootViewController as? UITabBarController)?.selectedViewController as? UINavigationController
        switch shortcutItem.type {
        case "com.twtstudio.gpa":
            let gpaVC = GPAViewController()
            gpaVC.hidesBottomBarWhenPushed = true
            naviVC?.pushViewController(gpaVC, animated: true)
        case "com.twtstudio.classtable":
            let classtableVC = ClassTableViewController()
            classtableVC.hidesBottomBarWhenPushed = true
            naviVC?.pushViewController(classtableVC, animated: true)
        case "com.twtstudio.bike":
            let bikeVC = BicycleServiceViewController()
            bikeVC.hidesBottomBarWhenPushed = true
            naviVC?.pushViewController(bikeVC, animated: true)
        case "com.twtstudio.yellowpage":
            let yellowpageVC = YellowPageMainViewController()
            yellowpageVC.hidesBottomBarWhenPushed = true
            naviVC?.pushViewController(yellowpageVC, animated: true)
        default:
            return
        }
        completionHandler(true)
    }
}

// MARK: User Notification
extension AppDelegate: UNUserNotificationCenterDelegate {

    func registerAppNotification(launchOptions: [UIApplicationLaunchOptionsKey: Any]?) {
        // 注册通知
        if #available(iOS 10.0, *) {
            let center = UNUserNotificationCenter.current()
            center.delegate = self
            center.requestAuthorization(options: [.alert, .badge, .sound]) { granted, _ in
                if granted {
                    DispatchQueue.main.async {
                        UIApplication.shared.registerForRemoteNotifications()
                    }
                } else {
                    log("Push notification request failed...")
                }
            }
        } else {
            // Fallback on earlier versions
            let settings = UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            UIApplication.shared.registerUserNotificationSettings(settings)
            UIApplication.shared.registerForRemoteNotifications()
        }
    }

    // 收到推送token
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        log("------device token: \(deviceToken.hexString)")
        UserDefaults.standard.set(deviceToken.hexString, forKey: "deviceToken")
    }

    // iOS 10: 处理前台收到通知的代理方法
    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        _ = notification.request.content.userInfo
        if notification.request.trigger is UNPushNotificationTrigger {
            // 远程通知
        } else {
            // 本地通知
        }
        completionHandler([.sound, .alert, .badge])
    }

    // iOS 10: 处理后台点击通知的代理方法
    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        let userInfo = response.notification.request.content.userInfo
        if let urlString = userInfo["url"] as? String,
            let url = URL(string: urlString) {
            UIApplication.shared.openURL(url)
        }
        completionHandler()
    }

    // iOS 9
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        if application.applicationState == .active {
            // 前台
        } else {
            // 后台接受消息进入 app
            // badge清零
            UIApplication.shared.applicationIconBadgeNumber = 0

            if let urlString = userInfo["url"] as? String,
                let url = URL(string: urlString) {
                UIApplication.shared.openURL(url)
            }
        }
        completionHandler(.newData)
    }
}
