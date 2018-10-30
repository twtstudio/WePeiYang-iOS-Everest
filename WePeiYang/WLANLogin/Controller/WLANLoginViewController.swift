//
//  WLANLoginViewController.swift
//  WePeiYang
//
//  Created by Tigris on 06/11/2017.
//  Copyright © 2017 twtstudio. All rights reserved.
//

import UIKit
import Alamofire
import SafariServices

class WLANLoginViewController: UIViewController {

    var accountTextField: UITextField!
    var passwordTextField: UITextField!
    var loginButton: UIButton!
    var logoutButton: UIButton!
    var serviceButton: UIButton!
    var WiFiImage: UIImage!
    var WiFiImageView: UIImageView!
    var warningText: UILabel!

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(color: UIColor(hex6: 0x00a1e9)) ?? UIImage(), for: .default)
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
        self.navigationController?.navigationBar.tintColor = UIColor.white
        navigationController?.setNavigationBarHidden(false, animated: animated)

        update()
    }

    func update() {
//        WLANHelper.getStatus(success: { isOnline in
//            if isOnline {
//                self.loginButton.setTitle("注销", for: .normal)
//                self.loginButton.addTarget(self, action: #selector(self.logout(button:)), for: .touchUpInside)
//            } else {
//                self.loginButton.setTitle("登录", for: .normal)
//                self.loginButton.addTarget(self, action: #selector(self.login(button:)), for: .touchUpInside)
//            }
//        }, failure: { errMsg in
//            SwiftMessages.showErrorMessage(body: errMsg)
//        })
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.

        // Set the type of status bar according to the comments written by Allen, .blackTranslucent is deprecated.
        self.navigationController?.navigationBar.barStyle = .black

        self.view.backgroundColor = .white
        self.title = "上网"
        WiFiImage = UIImage(named: "TJU")
        WiFiImageView = UIImageView(image: WiFiImage)
        self.view.addSubview(WiFiImageView)
        WiFiImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(30)
            make.centerX.equalToSuperview()
            make.width.equalTo(self.view.width*0.6)
            make.height.equalTo(self.view.width*0.6/1.407)
        }

        let messageLabel = UILabel()
        messageLabel.text = "微北洋应用内摇一摇即可登录注销校园网"
        messageLabel.font = UIFont.systemFont(ofSize: 13)
        messageLabel.numberOfLines = 0
        messageLabel.textAlignment = .center
        messageLabel.textColor = .gray
        messageLabel.sizeToFit()
        self.view.addSubview(messageLabel)
        messageLabel.snp.makeConstraints { make in
            make.top.equalTo(WiFiImageView.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.8)
        }

        accountTextField = UITextField()
        self.view.addSubview(accountTextField)
        accountTextField.snp.makeConstraints { make in
            make.top.equalTo(messageLabel.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
            make.width.equalTo(self.view.width*0.6)
            make.height.equalTo(30)
        }
        accountTextField.placeholder = "请输入账号"
        accountTextField.keyboardType = .numberPad
        accountTextField.borderStyle = .roundedRect

        passwordTextField = UITextField()
        self.view.addSubview(passwordTextField)
        passwordTextField.snp.makeConstraints { make in
            make.top.equalTo(accountTextField.snp.bottom).offset(10)
            make.centerX.equalToSuperview()
            make.width.equalTo(self.view.width*0.6)
            make.height.equalTo(30)
        }

        passwordTextField.placeholder = "请输入密码"
        passwordTextField.keyboardType = .default
        passwordTextField.borderStyle = .roundedRect
        passwordTextField.isSecureTextEntry = true

        // auto fill
        accountTextField.text = TwTUser.shared.WLANAccount
        passwordTextField.text = TwTUser.shared.WLANPassword

        loginButton = UIButton()
        self.view.addSubview(loginButton)

        loginButton.snp.makeConstraints { make in
            make.top.equalTo(passwordTextField.snp.bottom).offset(25)
            make.centerX.equalToSuperview()

            make.width.equalTo(self.view.width*(isiPad ? 0.4 : 0.6))
            make.height.equalTo(40)
        }

        loginButton.setTitle("登 录", for: .normal)
        loginButton.setTitleColor(.white, for: .normal)
        loginButton.isUserInteractionEnabled = true
        loginButton.backgroundColor = UIColor(hex6: 0x00a1e9)
        // to make button rounded rect
//        loginButton.layer.borderWidth = 2
        loginButton.layer.cornerRadius = 5
        loginButton.addTarget(self, action: #selector(login(button:)), for: .touchUpInside)

        logoutButton = UIButton()
        self.view.addSubview(logoutButton)

        logoutButton.snp.makeConstraints { make in
            make.top.equalTo(loginButton.snp.bottom).offset(10)
            make.centerX.equalToSuperview()
            make.width.equalTo(self.view.width*(isiPad ? 0.4 : 0.6))
            make.height.equalTo(40)
        }

        logoutButton.setTitle("注 销", for: .normal)
        logoutButton.setTitleColor(.white, for: .normal)
        logoutButton.isUserInteractionEnabled = true
        logoutButton.backgroundColor = UIColor(hex6: 0x00a1e9)
        // to make button rounded rect
        //        loginButton.layer.borderWidth = 2
        logoutButton.layer.cornerRadius = 5
        logoutButton.addTarget(self, action: #selector(logout(button:)), for: .touchUpInside)

        serviceButton = UIButton()
        self.view.addSubview(serviceButton)

        serviceButton.snp.makeConstraints { make in
            make.top.equalTo(logoutButton.snp.bottom).offset(10)
            make.centerX.equalToSuperview()
            make.width.equalTo(self.view.width*(isiPad ? 0.4 : 0.6))
            make.height.equalTo(40)
        }

        serviceButton.setTitle("自服务", for: .normal)
        serviceButton.isUserInteractionEnabled = true
        serviceButton.backgroundColor = UIColor(hex6: 0x00a1e9)
//        serviceButton.layer.borderColor = UIColor(hex6: 0xd3d3d3).cgColor
//        serviceButton.layer.borderWidth = 2
        serviceButton.layer.cornerRadius = 5
        serviceButton.addTarget(self, action: #selector(showService), for: .touchUpInside)
    }

    @objc func login(button: UIButton) {

        if accountTextField.hasText && passwordTextField.hasText {

            WLANHelper.login(username: accountTextField.text, password: passwordTextField.text, success: {
                TwTUser.shared.WLANAccount = self.accountTextField.text
                TwTUser.shared.WLANPassword = self.passwordTextField.text
                TwTUser.shared.save()
                SwiftMessages.showSuccessMessage(body: "登录成功", context: .view(self.view))
            }, failure: { msg in
                SwiftMessages.showErrorMessage(body: msg, context: .view(self.view))
            })
        }
    }

    @objc func logout(button: UIButton) {
        if accountTextField.hasText && passwordTextField.hasText {
            WLANHelper.logout(username: accountTextField.text, password: passwordTextField.text, success: {
                SwiftMessages.showSuccessMessage(body: "注销成功", context: .view(self.view))
            }, failure: { msg in
                SwiftMessages.showErrorMessage(body: msg, context: .view(self.view))
            })
        }
    }

    @objc func showService() {
        if let url = URL(string: "http://g.tju.edu.cn") {
            let vc = SFSafariViewController(url: url)
            present(vc, animated: true)
        }
    }

    func heightForView(text: String, fontsize: UIFont, width: CGFloat, xpos: CGFloat) -> CGFloat {
        let label: UILabel = UILabel(frame: CGRect(x: xpos, y: 0, width: width, height: CGFloat.greatestFiniteMagnitude))
        label.numberOfLines = 0
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.font = fontsize
        label.text = text

        label.sizeToFit()
        return label.frame.height
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        self.view.endEditing(true)
    }
}
