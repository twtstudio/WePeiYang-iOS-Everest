//
//  WPYTabBarController.swift
//  WePeiYang
//
//  Created by Allen X on 4/8/17.
//  Copyright © 2017 twtstudio. All rights reserved.
//

import UIKit
import PopupDialog

class WPYTabBarController: UITabBarController {
    private let tabBarVCDelegate = WPYTabBarControllerDelegate()
    // FIXME: should be private
    convenience init(viewControllers: [UIViewController]?) {
        self.init()
        
        guard viewControllers != nil else {
            //TODO: log
            //log.error
            return
        }
        setViewControllers(viewControllers, animated: true)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tabBar.isTranslucent = false

        delegate = tabBarVCDelegate

        selectedIndex = 0
        tabBar.backgroundColor = Metadata.Color.GlobalTabBarBackgroundColor
        tabBar.tintColor = Metadata.Color.WPYAccentColor
        if #available(iOS 10.0, *) {
            tabBar.unselectedItemTintColor = Metadata.Color.grayIconColor
        } else {
            // Fallback on earlier versions
            // Repaint the tabBar item icon image's color and use original color instead of the tintColor
            
        }
        
        UIApplication.shared.applicationSupportsShakeToEdit = true
        self.becomeFirstResponder()
    }

//    override func motionBegan(_ motion: UIEventSubtype, with event: UIEvent?) {
//        super.motionBegan(motion, with: event)
////        print("开始摇动")
//    }
//
//    override func motionCancelled(_ motion: UIEventSubtype, with event: UIEvent?) {
//        super.motionCancelled(motion, with: event)
////        print("取消摇动")
//    }

    func checkWiFiStatus() {
        do {
            let reachability = try Reachability()
            try reachability?.start()
            if let status = reachability?.status {
                switch status {
                case .unreachable:
                    let popup = PopupDialog(title: "摇一摇上网", message: "未检测到网络连接，是否打开 Wi-Fi 设置？", buttonAlignment: .horizontal)
                    let cancelButton = CancelButton(title: "不了", action: nil)
                    let openButton = DestructiveButton(title: "打开", action: {
                        // no internet
                        if !UIApplication.shared.openURL(URL(string: "prefs:root=WIFI")!) {
                            UIApplication.shared.openURL(URL(string: "App-Prefs:root=WIFI")!)
                        }
                    })
                    popup.addButtons([cancelButton, openButton])
                    self.present(popup, animated: true, completion: nil)

                    return
                case .wifi:
                    return
                case .wwan:
                    let popup = PopupDialog(title: "摇一摇上网", message: "检测到正在使用移动网络，是否打开 Wi-Fi 设置？", buttonAlignment: .horizontal)
                    let cancelButton = CancelButton(title: "不了", action: nil)
                    let openButton = DestructiveButton(title: "打开", action: {
                        // no internet
                        if !UIApplication.shared.openURL(URL(string: "prefs:root=WIFI")!) {
                            UIApplication.shared.openURL(URL(string: "App-Prefs:root=WIFI")!)
                        }
                    })
                    popup.addButtons([cancelButton, openButton])
                    self.present(popup, animated: true, completion: nil)
                    return
                }
            }
        } catch {

        }
    }

    override func motionEnded(_ motion: UIEventSubtype, with event: UIEvent?) {
        super.motionEnded(motion, with: event)

        if let event = event, event.subtype == .motionShake {

            let status = UserDefaults.standard.bool(forKey: "shakeWiFiEnabled")
            // 如果没开启
            if !status {
                return
            }

            checkWiFiStatus()

            if WLANHelper.isOnline {
                // 询问是否注销
                let popup = PopupDialog(title: "摇一摇上网", message: "是否要注销校园网登录？", buttonAlignment: .horizontal)
                let cancelButton = CancelButton(title: "不了", action: nil)
                let logoutButton = DestructiveButton(title: "注销", action: {
                    WLANHelper.logout(success: {
                        SwiftMessages.hideAll()
                        SwiftMessages.showSuccessMessage(body: "校园网已经注销")
                        if #available(iOS 10.0, *) {
                            let successNotificationFeedbackGenerator = UINotificationFeedbackGenerator()
                            successNotificationFeedbackGenerator.prepare()
                            successNotificationFeedbackGenerator.notificationOccurred(.success)
                        }
                    }, failure: { msg in
                        SwiftMessages.hideAll()
                        SwiftMessages.showErrorMessage(body: msg)
                    })
                })
                popup.addButtons([cancelButton, logoutButton])
                self.present(popup, animated: true, completion: nil)
            } else {
                WLANHelper.login(success: {
                    SwiftMessages.hideAll()
                    SwiftMessages.showSuccessMessage(body: "已连接到校园网")
                    if #available(iOS 10.0, *) {
                        let successNotificationFeedbackGenerator = UINotificationFeedbackGenerator()
                        successNotificationFeedbackGenerator.prepare()
                        successNotificationFeedbackGenerator.notificationOccurred(.success)
                    }
                }, failure: { msg in
                    SwiftMessages.hideAll()
                    SwiftMessages.showErrorMessage(body: msg)
                })
            }
        }
    }

    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        //TODO: View Controller Transitioning Animation
        
        //print("fuck")
        
    }

}


extension WPYTabBarController: ThemeChanging {
    func changeInto(theme: WPYTheme) {
        
    }
}


class WPYTabBarControllerDelegate: NSObject, UITabBarControllerDelegate {
    
    func tabBarController(_ tabBarController: UITabBarController, animationControllerForTransitionFrom fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        let fromIndex = tabBarController.viewControllers!.index(of: fromVC)!
        let toIndex = tabBarController.viewControllers!.index(of: toVC)!
        
        let tabChangeDirection: TransitionDirection = toIndex < fromIndex ? .left : .right
    
        let animator = TabVCTransitioningAnimator(direction: tabChangeDirection)
        return animator
    }
}
