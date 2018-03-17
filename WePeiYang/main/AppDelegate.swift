//
//  AppDelegate.swift
//  WePeiYang
//
//  Created by Allen X on 3/7/17.
//  Copyright © 2017 twtstudio. All rights reserved.
//

import UIKit
import WMPageController
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var mainTabVC: WPYTabBarController!

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        // 注册通知
        window = UIWindow(frame: UIScreen.main.bounds)
        UIApplication.shared.applicationIconBadgeNumber = 0

//        TwTUser.shared.load() // load token and so on
        TwTUser.shared.load(success: {
            NotificationCenter.default.post(name: NotificationName.NotificationBindingStatusDidChange.name, object: nil)

            WLANHelper.getStatus(success: { isOnline in

            }, failure: { _ in

            })
            AccountManager.getSelf(success:{
                if let deviceToken = UserDefaults.standard.string(forKey: "deviceToken"),
                    let uid = TwTUser.shared.twtid,
                    let uuid = UIDevice.current.identifierForVendor?.uuidString {
                    let para = ["utoken": deviceToken, "uid": uid, "udid": uuid]
                    SolaSessionManager.solaSession(type: .post, url: "/push/token/ENcJ1ZYDBaCvC8aM76RnnrT25FPqQg", token: nil, parameters: para, success: { dict in
                        print(dict)
                    }, failure: { err in
                        print(err)
                    })
                }
            }, failure: {
                
            })
        }, failure: {
            // 让他重新登录
        })


        mainTabVC = WPYTabBarController()
        
        let favoriteVC = FavViewController()
        favoriteVC.tabBarItem.image = #imageLiteral(resourceName: "Favored")
        favoriteVC.tabBarItem.imageInsets = UIEdgeInsets(top: 6, left: 0, bottom: -6, right: 0)
        let favoriteNavigationController = UINavigationController(rootViewController: favoriteVC)
        
        let newsVC = NewsViewController()
        newsVC.tabBarItem.image = #imageLiteral(resourceName: "News")
        newsVC.tabBarItem.imageInsets = UIEdgeInsets(top: 6, left: 0, bottom: -6, right: 0)
        let infoNavigationController = UINavigationController(rootViewController: newsVC)
        
        let allModulesVC = AllModulesViewController()
        allModulesVC.tabBarItem.image = #imageLiteral(resourceName: "AllModules")
        allModulesVC.tabBarItem.imageInsets = UIEdgeInsets(top: 6, left: 0, bottom: -6, right: 0)
        let allModulesNavigationController = UINavigationController(rootViewController: allModulesVC)
        
        let settingsVC = SettingsViewController()
        settingsVC.tabBarItem.image = #imageLiteral(resourceName: "Settings")
        settingsVC.tabBarItem.imageInsets = UIEdgeInsets(top: 6, left: 0, bottom: -6, right: 0)
        let settingsNavigationController = UINavigationController(rootViewController: settingsVC)
        
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
        //UINavigationController(rootViewController: mainTabVC)
        window?.makeKeyAndVisible()

//        // To check if network is available
//        // Used to determine the network state for WLANLogin
//        do {
//            Network.reachability = try Reachability(hostname: "www.apple.com/cn/")
//            do {
//                try Network.reachability?.start()
//            } catch let error as Network.Error {
//                debugLog(error)
//            } catch {
//                debugLog(error)
//            }
//        } catch {
//            debugLog(error)
//        }

        // new features
        showOnBoard()
        registerAppNotification(launchOptions: launchOptions)
        registerShortcutItems()

        return true
    }

    func showOnBoard() {
        if let info = Bundle.main.infoDictionary,
            let nowVersion = info[kCFBundleVersionKey as String] as? String {
            let lastVersion = UserDefaults.standard.string(forKey: "lastVersion") ?? ""
            if lastVersion != nowVersion {
                UserDefaults.standard.set(true, forKey: "shakeWiFiEnabled")
                UserDefaults.standard.set(nowVersion, forKey: "lastVersion")
                let arrayOfImage = ["ic_welcome_gpa", "ic_welcome_classtable", "ic_welcome_bike", "ic_welcome_network"]
                let arrayOfTitle = ["成绩查询", "课程表", "自行车", "一键上网"]
                let arrayOfDescription = ["全新设计的成绩详情页，各科成绩直观比较",
                                          "不只是传统课表，还有今明日课程提醒、widget 快速查看课程等温馨功能",
                                          "担心车没还上、找不到最近可用车位？打开微北洋，即时查询各种信息",
                                          "打开 widget 一键上网。\n更有摇一摇上网功能，应用内摇一摇，轻松上网"]
                let alertView = AlertOnboarding(arrayOfImage: arrayOfImage, arrayOfTitle: arrayOfTitle, arrayOfDescription: arrayOfDescription)
                
                alertView.percentageRatioHeight = 1
                alertView.percentageRatioWidth = 1
                alertView.titleGotItButton = "开启新版微北洋"
                alertView.titleSkipButton = "跳过"
                //... and show it !
                alertView.show()
            }
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
            for subview in subviews {
                if subview is UIVisualEffectView {
                    subview.removeFromSuperview()
                    return
                }
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
            center.requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
                if granted {
                    log.word("Push notification request succeed")/
                    DispatchQueue.main.async {
                        UIApplication.shared.registerForRemoteNotifications()
                    }
                } else {
                    log.word("Push notification request failed...")/
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
        print("------device token: \(deviceToken.hexString)")
        UserDefaults.standard.set(deviceToken.hexString, forKey: "deviceToken")
    }


    // iOS 10: 处理前台收到通知的代理方法
    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        let info = notification.request.content.userInfo
        print("iOS 10 foreground userInfo: \(info)")

        if notification.request.trigger is UNPushNotificationTrigger {
            // 远程通知
        } else {
            // 本地通知
        }
        completionHandler([.sound, .alert])
    }

    // iOS 10: 处理后台点击通知的代理方法
    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        let info = response.notification.request.content.userInfo
        print("iOS 10 background tap userInfo: \(info)")
        completionHandler()
    }

    // iOS 9
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        if application.applicationState == .active {
            // 前台
        } else {
            // 后台接受消息进入 app
            // badge清零
            UIApplication.shared.applicationIconBadgeNumber = 0
        }
        completionHandler(.newData)
    }
}
