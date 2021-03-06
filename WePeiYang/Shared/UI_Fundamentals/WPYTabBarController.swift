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
    convenience init(viewControllers: [UIViewController]?) {
        self.init()

        guard viewControllers != nil else {
            return
        }
        setViewControllers(viewControllers, animated: true)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        tabBar.isTranslucent = false

        self.delegate = self

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

    func checkWiFiStatus() {
        do {
            let reachability = try Reachability()
            try reachability?.start()
            if let status = reachability?.status {
                switch status {
                case .unreachable:
                    let popup = PopupDialog(title: "摇一摇上网", message: "未检测到网络连接，请打开 Wi-Fi 后重试", buttonAlignment: .horizontal)
                    let cancelButton = CancelButton(title: "好的", action: nil)
                    popup.addButton(cancelButton)
                    self.present(popup, animated: true, completion: nil)

                    return
                case .wifi:
                    return
                case .wwan:
                    let popup = PopupDialog(title: "摇一摇上网", message: "检测到正在使用移动网络，请打开 Wi-Fi 后重试", buttonAlignment: .horizontal)
                    let cancelButton = CancelButton(title: "不了", action: nil)
                    popup.addButton(cancelButton)
                    self.present(popup, animated: true, completion: nil)
                    return
                }
            }
        } catch {

        }
    }

    override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
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
}

extension WPYTabBarController: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, animationControllerForTransitionFrom fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
     let fromIndex = tabBarController.viewControllers!.firstIndex(of: fromVC)!
     let toIndex = tabBarController.viewControllers!.firstIndex(of: toVC)!

        let tabChangeDirection: TransitionDirection = toIndex < fromIndex ? .left : .right

        let animator = TabVCTransitioningAnimator(direction: tabChangeDirection)
        return animator
    }
}
