//
//  LoginViewController.swift
//  WePeiYang
//
//  Created by Halcao on 2017/10/23.
//  Copyright © 2017年 twtstudio. All rights reserved.
//

import UIKit
import AVFoundation

class LoginViewController: UIViewController {

    var videoPlayer: AVPlayer!
    var usernameField: UITextField!
    var passwordField: UITextField!
    var loginButton: UIButton!
    var dismissButton: UIButton!
    var playerLayer: AVPlayerLayer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.tintColor = .white
        let url = Bundle.main.url(forResource: "FlowingColor", withExtension: "mp4")
        videoPlayer = AVPlayer(url: url!)
        videoPlayer.isMuted = true
        playerLayer = AVPlayerLayer(player: videoPlayer)
        playerLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
        playerLayer.frame = self.view.frame
        self.view.layer.addSublayer(playerLayer)
        videoPlayer.isMuted = true
        
        NotificationCenter.default.addObserver(self, selector: #selector(loopVideo), name: Notification.Name.AVPlayerItemDidPlayToEndTime, object: nil)
        videoPlayer.play()
        
        // Do any additional setup after loading the view, typically from a nib.
        let titleLabel: UILabel = {
            let label = UILabel()
            label.text = "微北洋"
            label.textColor = .white
            label.font = UIFont.systemFont(ofSize: 50, weight: UIFontWeightHeavy)
            label.sizeToFit()
            label.center.x = self.view.center.x
            label.center.y = self.view.frame.size.height*1/5
            return label
        }()
        
        let blurEffect = UIBlurEffect(style: .light)
        let blurView = UIVisualEffectView(effect: blurEffect)
        blurView.frame = self.view.frame
        self.view.addSubview(blurView)
        
        let vibrancyEffect = UIVibrancyEffect(blurEffect: blurEffect)
        let visualEffectView = UIVisualEffectView(effect: vibrancyEffect)
        visualEffectView.frame = self.view.frame
        //        visualEffectView.frame = titleLabel.frame
        blurView.addSubview(visualEffectView)
        //        titleLabel.frame.origin = CGPoint(x: 0, y: 0)
        visualEffectView.contentView.addSubview(titleLabel)
        
        //        usernameField = UITextField(frame: CGRect(center: CGPoint(x: self.view.center.x, y: self.view.frame.size.height*1.5/5.0), size: CGSize(width: 200, height: 40)))
        
        let textFieldWidth: CGFloat = 250

        usernameField = UITextField(frame: CGRect(center: CGPoint(x: self.view.center.x, y: self.view.frame.size.height*2.0/5.0), size: CGSize(width: textFieldWidth, height: 40)))
        passwordField = UITextField(frame: CGRect(center: CGPoint(x: self.view.center.x, y: self.view.frame.size.height*2.4/5.0), size: CGSize(width: textFieldWidth, height: 40)))
    
        
        self.usernameField.textColor = .white
        self.usernameField.backgroundColor = UIColor(white: 1, alpha: 0.1);
        self.usernameField.layer.cornerRadius = 3;
        self.usernameField.layer.borderWidth = 0.5
        self.usernameField.keyboardType = .asciiCapable
        self.usernameField.isSecureTextEntry = false
        self.usernameField.layer.borderColor = UIColor(white: 1, alpha: 0.8).cgColor;
        self.usernameField.placeholder = "用户名"
        self.usernameField.clearButtonMode = .always
        self.usernameField.autocapitalizationType = .none
        
        self.passwordField.textColor = .white
        self.passwordField.backgroundColor = UIColor(white: 1, alpha: 0.1);
        self.passwordField.layer.cornerRadius = 3;
        self.passwordField.layer.borderWidth = 0.5
        self.passwordField.keyboardType = .asciiCapable
        self.passwordField.isSecureTextEntry = true
        self.passwordField.layer.borderColor = UIColor(white: 1, alpha: 0.8).cgColor;
        self.passwordField.placeholder = "密码"
        self.passwordField.clearButtonMode = .always
        
        let userNameIconImageView = UIImageView(image: UIImage(named: "ic_account_circle")!.withRenderingMode(.alwaysTemplate))
        userNameIconImageView.frame = CGRect(x: 0, y: 0, width: 34, height: 22)
        userNameIconImageView.tintColor = UIColor.white
        userNameIconImageView.contentMode = .scaleAspectFit
        self.usernameField.leftView = userNameIconImageView
        self.usernameField.leftViewMode = .always
        
        let passwordIconImageView = UIImageView(image: UIImage(named: "ic_lock")!.with(color: .white).withRenderingMode(.alwaysOriginal))
        passwordIconImageView.frame = CGRect(x: 0, y: 0, width: 34, height: 22)
        passwordIconImageView.contentMode = .scaleAspectFit
        userNameIconImageView.tintColor = UIColor.white
        self.passwordField.leftView = passwordIconImageView
        self.passwordField.leftViewMode = .always
        
        self.loginButton = UIButton(frame: CGRect(x: (self.view.frame.size.width-textFieldWidth)/2, y: passwordField.frame.origin.y + passwordField.frame.size.height + 20, width: textFieldWidth, height: 38))
        self.loginButton.setTitle("登  录", for: UIControlState())
        self.loginButton.layer.cornerRadius = 3;
        self.loginButton.layer.borderWidth = 0.5
        self.loginButton.layer.borderColor = UIColor(white: 1, alpha: 0.8).cgColor;
        
        self.dismissButton = UIButton(frame: CGRect(x: self.view.frame.width, y: self.view.frame.size.height*4.0/5.0, width: 30, height: 20))
        self.dismissButton.titleLabel?.font = UIFont.systemFont(ofSize: 13)
        dismissButton.setTitle("暂不登录", for: .normal)
//        self.dismissButton.titleLabel?.sizeToFit()
        self.dismissButton.sizeToFit()
        self.dismissButton.center = CGPoint(x: self.view.center.x, y: self.view.frame.height*4.8/5)
        
        visualEffectView.addSubview(usernameField)
        visualEffectView.addSubview(passwordField)
        visualEffectView.addSubview(loginButton)
        visualEffectView.addSubview(dismissButton)

        loginButton.addTarget(self, action: #selector(login), for: .touchUpInside)
        dismissButton.addTarget(self, action: #selector(dismissLogin), for: .touchUpInside)
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func login() {
        guard let username = usernameField.text, !username.isEmpty else {
            // FIXME: username not nil
            return
        }
        guard let password = passwordField.text, !password.isEmpty else {
            // FIXME: password not nil
            return
        }

        
        AccountManager.getToken(username: username, password: password, success: { token in
            TwTUser.shared.token = token
            TwTUser.shared.username = username
            TwTUser.shared.save()
            self.extraProcedures()
            // FIXME: login success
            self.dismiss(animated: true, completion: nil)
        }, failure: { error in
            print(error ?? "")
        })
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        videoPlayer.pause()
    }
    
    func dismissLogin() {
        self.dismiss(animated: true, completion: nil)
    }
    
    func loopVideo() {
        videoPlayer.seek(to: CMTime(seconds: 0, preferredTimescale: 1))
        videoPlayer.play()
    }

    func extraProcedures() {
        Applicant.sharedInstance.getStudentNumber {
//            UserDefaults.standard.set(Applicant.sharedInstance.studentNumber, forKey: "studentID")
//            UserDefaults.standard.set(Applicant.sharedInstance.realName, forKey: "studentName")
//            //log.word("fuckin awesome")/
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}
