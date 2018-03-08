//
//  LoginViewController.swift
//  WePeiYang
//
//  Created by Halcao on 2017/10/23.
//  Copyright © 2017年 twtstudio. All rights reserved.
//

import UIKit
import AVFoundation
import SwiftMessages

class LoginViewController: UIViewController {

//    var videoPlayer: AVPlayer!
    var usernameField: UITextField!
    var passwordField: UITextField!
    var loginButton: UIButton!
    var dismissButton: UIButton!
//    var playerLayer: AVPlayerLayer!

    override func viewDidLoad() {
        super.viewDidLoad()
        
//        let url = Bundle.main.url(forResource: "FlowingColor", withExtension: "mp4")
//        videoPlayer = AVPlayer(url: url!)
//        videoPlayer.isMuted = true
//        playerLayer = AVPlayerLayer(player: videoPlayer)
//        playerLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
//        playerLayer.frame = view.frame
//        view.layer.addSublayer(playerLayer)
//        videoPlayer.isMuted = true
//
//        NotificationCenter.default.addObserver(self, selector: #selector(loopVideo), name: Notification.Name.AVPlayerItemDidPlayToEndTime, object: nil)
//        videoPlayer.play()

        // Do any additional setup after loading the view, typically from a nib.
        let titleLabel: UILabel = {
            let label = UILabel()
            label.text = "微北洋"
            label.textColor = .white
            label.font = UIFont.systemFont(ofSize: 50, weight: UIFont.Weight.heavy)
            label.sizeToFit()
            label.center.x = view.center.x
            label.center.y = view.frame.size.height*1/5
            return label
        }()
        
//        let blurEffect = UIBlurEffect(style: .extraLight)
//        let blurView = UIVisualEffectView(effect: blurEffect)
//        blurView.frame = view.frame
//        view.addSubview(blurView)
//
//        let vibrancyEffect = UIVibrancyEffect(blurEffect: blurEffect)
//        let visualEffectView = UIVisualEffectView(effect: vibrancyEffect)
//        visualEffectView.frame = view.frame
//        //        visualEffectView.frame = titleLabel.frame
//        blurView.contentView.addSubview(visualEffectView)
//        //        titleLabel.frame.origin = CGPoint(x: 0, y: 0)
//        visualEffectView.contentView.addSubview(titleLabel)

        //        usernameField = UITextField(frame: CGRect(center: CGPoint(x: view.center.x, y: view.frame.size.height*1.5/5.0), size: CGSize(width: 200, height: 40)))
        
        let textFieldWidth: CGFloat = 250

        usernameField = UITextField(frame: CGRect(center: CGPoint(x: view.center.x, y: view.frame.size.height*2.0/5.0), size: CGSize(width: textFieldWidth, height: 40)))
        passwordField = UITextField(frame: CGRect(center: CGPoint(x: view.center.x, y: view.frame.size.height*2.4/5.0), size: CGSize(width: textFieldWidth, height: 40)))
    
        
        usernameField.textColor = .white
        usernameField.backgroundColor = UIColor(white: 1, alpha: 0.1);
        usernameField.layer.cornerRadius = 3;
        usernameField.layer.borderWidth = 0.5
        usernameField.keyboardType = .asciiCapable
        usernameField.isSecureTextEntry = false
        usernameField.layer.borderColor = UIColor(white: 1, alpha: 0.8).cgColor;
        usernameField.placeholder = "用户名"
        usernameField.clearButtonMode = .always
        usernameField.autocapitalizationType = .none
        
        passwordField.textColor = .white
        passwordField.backgroundColor = UIColor(white: 1, alpha: 0.1);
        passwordField.layer.cornerRadius = 3;
        passwordField.layer.borderWidth = 0.5
        passwordField.keyboardType = .asciiCapable
        passwordField.isSecureTextEntry = true
        passwordField.layer.borderColor = UIColor(white: 1, alpha: 0.8).cgColor;
        passwordField.placeholder = "密码"
        passwordField.clearButtonMode = .always
        
        let userNameIconImageView = UIImageView(image: UIImage(named: "ic_account_circle")!.withRenderingMode(.alwaysTemplate))
        userNameIconImageView.frame = CGRect(x: 0, y: 0, width: 34, height: 22)
        userNameIconImageView.tintColor = UIColor.white
        userNameIconImageView.contentMode = .scaleAspectFit
        usernameField.leftView = userNameIconImageView
        usernameField.leftViewMode = .always
        
        let passwordIconImageView = UIImageView(image: UIImage(named: "ic_lock")!.with(color: .white).withRenderingMode(.alwaysOriginal))
        passwordIconImageView.frame = CGRect(x: 0, y: 0, width: 34, height: 22)
        passwordIconImageView.contentMode = .scaleAspectFit
        userNameIconImageView.tintColor = UIColor.white
        passwordField.leftView = passwordIconImageView
        passwordField.leftViewMode = .always
        
        loginButton = UIButton(frame: CGRect(x: (view.frame.size.width-textFieldWidth)/2, y: passwordField.frame.origin.y + passwordField.frame.size.height + 20, width: textFieldWidth, height: 38))
        loginButton.setTitle("登  录", for: UIControlState())
        loginButton.layer.cornerRadius = 3;
        loginButton.layer.borderWidth = 0.5
        loginButton.layer.borderColor = UIColor(white: 1, alpha: 0.8).cgColor;
        
        dismissButton = UIButton(frame: CGRect(x: view.frame.width, y: view.frame.size.height*3.6/5.0, width: 30, height: 20))
        dismissButton.titleLabel?.font = UIFont.systemFont(ofSize: 13)
        dismissButton.setTitle("暂不登录", for: .normal)
//        dismissButton.titleLabel?.sizeToFit()
        dismissButton.sizeToFit()
        dismissButton.center = CGPoint(x: view.center.x, y: view.frame.height*4.8/5)
        
//        visualEffectView.contentView.addSubview(usernameField)
//        visualEffectView.contentView.addSubview(passwordField)
//        visualEffectView.contentView.addSubview(loginButton)
//        visualEffectView.contentView.addSubview(dismissButton)
        view.addSubview(titleLabel)
        view.addSubview(usernameField)
        view.addSubview(passwordField)
        view.addSubview(loginButton)
        view.addSubview(dismissButton)

        loginButton.addTarget(self, action: #selector(login), for: .touchUpInside)
        dismissButton.addTarget(self, action: #selector(dismissLogin), for: .touchUpInside)
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    @objc func login() {
        guard let username = usernameField.text, !username.isEmpty else {
//            let view = MessageView.viewFromNib(layout: .cardView)
//            view.configureContent(title: "输入错误", body: "用户名不能为空")
//            view.alpha = 0.5
//            view.button?.isHidden = true
//            view.configureTheme(.error)
//            var config = SwiftMessages.Config()
//            config.presentationContext = .window(windowLevel: .infinity)
//            SwiftMessages.show(config: config, view: view)

            SwiftMessages.showErrorMessage(title: "输入错误", body: "用户名不能为空")
            return
        }
        guard let password = passwordField.text, !password.isEmpty else {
            SwiftMessages.showErrorMessage(title: "输入错误", body: "密码不能为空")
            return
        }

        
        AccountManager.getToken(username: username, password: password, success: { token in
            TwTUser.shared.token = token
            TwTUser.shared.username = username
            TwTUser.shared.password = password
            TwTUser.shared.save()
            self.extraProcedures()
            // FIXME: login success
            self.dismiss(animated: true, completion: nil)
        }, failure: { error in
            SwiftMessages.showErrorMessage(body: error?.localizedDescription ?? "未知错误❌")
        })
    }
    
//    override func viewWillDisappear(_ animated: Bool) {
//        videoPlayer.pause()
//    }
//
    @objc func dismissLogin() {
        dismiss(animated: true, completion: nil)
    }
//
//    @objc func loopVideo() {
//        videoPlayer.seek(to: CMTime(seconds: 0, preferredTimescale: 1))
//        videoPlayer.play()
//    }

    // 登录成功
    func extraProcedures() {
        NotificationCenter.default.post(name: NotificationName.NotificationUserDidLogin.name, object: nil)
        AccountManager.getSelf(success: {
            NotificationCenter.default.post(name: NotificationName.NotificationBindingStatusDidChange.name, object: nil)

        }, failure: nil)
        
        Applicant.sharedInstance.getStudentNumber {
            UserDefaults.standard.set(Applicant.sharedInstance.studentNumber, forKey: "studentID")
            UserDefaults.standard.set(Applicant.sharedInstance.realName, forKey: "studentName")
//            //log.word("fuckin awesome")/
        }

        GPASessionManager.getGPA(success: { model in
            if let string = model.toJSONString() {
                CacheManager.store(object: string, in: .group, as: "gpa/gpa.json")
            }
        }, failure: { err in

        })

        BicycleUser.sharedInstance.auth {
            NotificationCenter.default.post(name: NotificationName.NotificationBindingStatusDidChange.name, object: ("bike", TwTUser.shared.bicycleBindingState))
        }

        ClasstableDataManager.getClassTable(success: { model in
            if let string = model.toJSONString() {
                CacheManager.store(object: string, in: .group, as: "classtable/classtable.json")
            }
        }, failure: { str in
            
        })


        // FIXME: 上网状态咋获得?
//        NotificationCenter.default.post(name: NotificationName.NotificationBindingStatusDidChange.name, object: ("WLAN", TwTUser.shared.WLANBindingState))
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}
