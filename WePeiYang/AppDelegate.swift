//
//  AppDelegate.swift
//  WePeiYang
//
//  Created by Allen X on 3/7/17.
//  Copyright © 2017 twtstudio. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var mainTabVC: UITabBarController!

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        window = UIWindow(frame: UIScreen.main.bounds)
        
        mainTabVC = UITabBarController()
        
        let vc1 = ViewController()
        vc1.tabBarItem.image = #imageLiteral(resourceName: "PersonalSettings")
        vc1.tabBarItem.imageInsets = UIEdgeInsets(top: 6, left: 0, bottom: -6, right: 0)
        
        let nav1 = UINavigationController(rootViewController: vc1)
        let vc2 = ViewController()
        vc2.tabBarItem.image = #imageLiteral(resourceName: "Info")
        
        let nav2 = UINavigationController(rootViewController: vc2)

        vc2.tabBarItem.imageInsets = UIEdgeInsets(top: 6, left: 0, bottom: -6, right: 0)
        mainTabVC.setViewControllers([nav1, nav2], animated: true)
        
        UITabBar.appearance().backgroundColor = Metadata.Color.GlobalTabBarBackgroundColor
        UITabBar.appearance().tintColor = Metadata.Color.WPYAccentColor
        
        
        mainTabVC.selectedIndex = 0
        if #available(iOS 10.0, *) {
            mainTabVC.tabBar.unselectedItemTintColor = Metadata.Color.grayIconColor
        } else {
            // Fallback on earlier versions
        }
//        window?.backgroundColor = .white
        window?.rootViewController = mainTabVC
        window?.makeKeyAndVisible()
        
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

