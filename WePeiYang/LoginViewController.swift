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

        let textFieldWidth: CGFloat = 250

        self.view.backgroundColor = UIColor(red:0.11, green:0.64, blue:0.90, alpha:1.00)

        let usernameLabel = UILabel(frame: CGRect(center: CGPoint(x: view.center.x, y: view.frame.size.height*1.9/5.0), size: CGSize(width: textFieldWidth, height: 20)))
        usernameLabel.text = "天外天用户名"
        usernameLabel.font = UIFont.systemFont(ofSize: 12)
        usernameLabel.textColor = .lightGray

        usernameField = UITextField(frame: CGRect(center: CGPoint(x: view.center.x, y: view.frame.size.height*2.0/5.0), size: CGSize(width: textFieldWidth, height: 30)))
        usernameField.textColor = .darkGray
        usernameField.backgroundColor = .white
        usernameField.keyboardType = .asciiCapable
        usernameField.isSecureTextEntry = false
//        usernameField.placeholder = "用户名"
        usernameField.clearButtonMode = .always
        usernameField.autocapitalizationType = .none
        usernameField.borderStyle = .none


        let passwordLabel = UILabel(frame: CGRect(center: CGPoint(x: view.center.x, y: view.frame.size.height*2.3/5.0), size: CGSize(width: textFieldWidth, height: 20)))
        passwordLabel.text = "天外天密码"
        passwordLabel.font = UIFont.systemFont(ofSize: 12)
        passwordLabel.textColor = .lightGray

        passwordField = UITextField(frame: CGRect(center: CGPoint(x: view.center.x, y: view.frame.size.height*2.4/5.0), size: CGSize(width: textFieldWidth, height: 30)))
        passwordField.textColor = .white
        passwordField.textColor = .darkGray
        passwordField.backgroundColor = .white
        passwordField.keyboardType = .asciiCapable
        passwordField.isSecureTextEntry = true
//        passwordField.layer.borderColor = UIColor(white: 1, alpha: 0.8).cgColor;
//        passwordField.placeholder = "密码"
        passwordField.clearButtonMode = .always
        passwordField.borderStyle = .none

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
        
        view.addSubview(titleLabel)
        view.addSubview(usernameLabel)
        view.addSubview(passwordLabel)
        view.addSubview(usernameField)
        view.addSubview(passwordField)
        view.addSubview(loginButton)
        view.addSubview(dismissButton)

        loginButton.addTarget(self, action: #selector(login), for: .touchUpInside)
        dismissButton.addTarget(self, action: #selector(dismissLogin), for: .touchUpInside)


//        let loginView = MessageView.viewFromNib(layout: .centeredView)
//        loginView.configureBackgroundView(width: 250)
//        loginView.configureContent(title: "Hey There!", body: "Please try swiping to dismiss this message.", iconImage: nil, iconText: "🦄", buttonImage: nil, buttonTitle: "No Thanks") { _ in
//            SwiftMessages.hide()
//        }
//        loginView.backgroundView.backgroundColor = UIColor.init(white: 0.97, alpha: 1)
//        loginView.backgroundView.layer.cornerRadius = 10

//            let loginView = UINib(nibName: "LoginView", bundle: nil).instantiate(withOwner: self, options: nil).first! as! LoginView
        let loginView = LoginView()
//        loginView.configureBackgroundView(width: 250)

        var config = SwiftMessages.defaultConfig
        config.presentationStyle = .center
        config.duration = .forever
        config.dimMode = .blur(style: .dark, alpha: 1, interactive: true)
        config.presentationContext  = .window(windowLevel: UIWindowLevelStatusBar)
        SwiftMessages.show(config: config, view: loginView)
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
