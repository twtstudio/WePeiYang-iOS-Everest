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
        registerAppNotification(launchOptions: launchOptions)

        window = UIWindow(frame: UIScreen.main.bounds)
        
//        TwTUser.shared.load() // load token and so on
        TwTUser.shared.load(success: {
            UIApplication.shared.applicationIconBadgeNumber = 0
            // FIXME: 没有加载成功
            NotificationCenter.default.post(name: NotificationName.NotificationBindingStatusDidChange.name, object: nil)
            AccountManager.getSelf(success:{
//                NotificationCenter.default.post(name: NotificationName.NotificationCardWillRefresh.name, object: nil)
            }, failure: nil)
        }, failure: {
            // 让他重新登录
        })

//        AccountManager.getSelf(success: nil, failure: nil)
//        AccountManager.checkToken(failure: {
//            // 让他重新登录
//        })

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
        
        // To check if network is available
        // Used to determine the network state for WLANLogin
        do {
            Network.reachability = try Reachability(hostname: "www.apple.com/cn/")
            do {
                try Network.reachability?.start()
            } catch let error as Network.Error {
                debugLog(error)
            } catch {
                debugLog(error)
            }
        } catch {
            debugLog(error)
        }
            
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
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
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
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
