//
//  LoginView.swift
//  WePeiYang
//
//  Created by Halcao on 2018/3/11.
//  Copyright © 2018年 twtstudio. All rights reserved.
//

import UIKit

class LoginView: MessageView {
    var usernameField: WPYTextField!
    var passwordField: WPYTextField!
    var loginButton: UIButton!

    init() {
        super.init(frame: .zero)
        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func awakeFromNib() {
        super.awakeFromNib()
//        self.backgroundView.subviews.removeAll()
        setup()
    }

    func setup() {
        self.backgroundColor = .clear
        self.backgroundView.snp.makeConstraints { make in
            make.width.equalTo(250)
            make.height.equalTo(300)
        }

        usernameField = WPYTextField()
        usernameField.autocorrectionType = .no
        usernameField.autocapitalizationType = .none
        usernameField.keyboardType = .asciiCapable
        usernameField.returnKeyType = .next
        usernameField.placeholder = "天外天用户名"

        backgroundView.addSubview(usernameField)
        usernameField.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(80)
            make.width.equalTo(200)
            make.height.equalTo(25)
        }

        passwordField = WPYTextField()
        passwordField.autocorrectionType = .no
        passwordField.autocapitalizationType = .none
        passwordField.keyboardType = .asciiCapable
        passwordField.returnKeyType = .go
        passwordField.isSecureTextEntry = true
        passwordField.placeholder = "密码"
        passwordField.layer.shadowColor = UIColor.darkGray.cgColor
//        passwordField.layer.sha
        passwordField.layer.shadowPath = CGPath(rect: CGRect(x: passwordField.x, y: passwordField.height+passwordField.y, width: passwordField.width, height: 1), transform: nil)

        backgroundView.addSubview(passwordField)
        passwordField.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(usernameField.snp.bottom).offset(20)
            make.width.equalTo(200)
            make.height.equalTo(25)
        }

        loginButton = CardButton()
//        loginButton
        loginButton.addTarget(self, action: #selector(buttonTapped(button:)), for: .touchUpInside)
        loginButton.setTitle("登录", for: .normal)
        loginButton.layer.cornerRadius = loginButton.height/2
        loginButton.backgroundColor = Metadata.Color.WPYAccentColor
        loginButton.setTitleColor(.white, for: .normal)
        backgroundView.addSubview(loginButton)
        loginButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(passwordField.snp.bottom).offset(30)
            make.width.equalTo(100)
            make.height.equalTo(30)
        }

        backgroundView.backgroundColor = UIColor.init(white: 0.97, alpha: 1)
        backgroundView.layer.cornerRadius = 10

//        configureBackgroundView(width: 250)
    }

    @objc func buttonTapped(button: UIButton) {
        buttonTapHandler?(button)
    }
}
