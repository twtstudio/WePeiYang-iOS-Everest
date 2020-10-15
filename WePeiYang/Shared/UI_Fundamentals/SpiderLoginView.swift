//
//  SpiderLoginView.swift
//  WePeiYang
//
//  Created by Shawnee on 2020/10/5.
//  Copyright © 2020 twtstudio. All rights reserved.
//


import UIKit

class SpiderLoginView: MessageView {
     fileprivate var captchaURL = "https://sso.tju.edu.cn/cas/images/kaptcha.jpg?id=\(Double.random(in: 0...1))"
     var isLogin = false
     var isError = false
     
     fileprivate var usernameField = WPYTextField()
     fileprivate var passwordField = WPYTextField()
     fileprivate var captchaField = WPYTextField()
     fileprivate var captchaImage = UIImageView()
     fileprivate var loginButton = CardButton()
     var successHandler: (() -> Void)?
     var failureHandler: (() -> Void)?
     
     init() {
          super.init(frame: CGRect(x: 30, y: UIScreen.main.bounds.height*0.2, width: UIScreen.main.bounds.width-60, height: 300))
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
          //        let backgroundView = self.backgroundView ?? self
          
          //        layoutMargins.left = 30
          //        layoutMargins.right = 30
          //        configureBackgroundView(width: 250)
          
          let contentView = UIView()
          contentView.backgroundColor = UIColor(red: 0.95, green: 0.96, blue: 0.97, alpha: 1.00)
          
          self.backgroundColor = .clear
          installBackgroundView(contentView)
          configureBackgroundView(width: 250)
          contentView.snp.makeConstraints { make in
               if isiPad {
                    make.top.equalToSuperview().offset(30)
                    make.bottom.equalToSuperview().offset(-30)
                    make.width.equalToSuperview().multipliedBy(0.6)
                    make.left.equalTo(deviceWidth*0.2)
                    make.right.equalTo(-deviceWidth*0.2)
               } else {
                    make.top.left.equalToSuperview().offset(30)
                    make.bottom.right.equalToSuperview().offset(-30)
                    make.width.equalTo(250)
               }
               make.height.equalTo(350)
          }
          
          let iconView = UIImageView(image: #imageLiteral(resourceName: "logo"))
          iconView.sizeToFit()
          contentView.addSubview(iconView)
          iconView.snp.makeConstraints { make in
               make.centerX.equalToSuperview()
               make.top.equalToSuperview().offset(40)
               make.width.equalTo(50)
               make.height.equalTo(25)
          }
          
          usernameField = WPYTextField()
          usernameField.delegate = self
          usernameField.autocorrectionType = .no
          usernameField.autocapitalizationType = .none
          usernameField.keyboardType = .asciiCapable
          usernameField.returnKeyType = .next
          usernameField.placeholder = "天外天用户名"
          let usernameIconView = UIImageView(image: UIImage(named: "ic_account_circle")!.withRenderingMode(.alwaysTemplate))
          usernameIconView.frame = CGRect(x: 0, y: 0, width: 34, height: 22)
          usernameIconView.tintColor = Metadata.Color.WPYAccentColor
          usernameIconView.contentMode = .scaleAspectFit
          usernameField.leftView = usernameIconView
          usernameField.leftViewMode = .always
          
          contentView.addSubview(usernameField)
          usernameField.snp.makeConstraints { make in
               make.centerX.equalToSuperview()
               //            make.top.equalToSuperview().offset(120)
               make.top.equalTo(iconView.snp.bottom).offset(40)
               make.width.equalTo(200)
               make.height.equalTo(28)
          }
          
          passwordField.autocorrectionType = .no
          passwordField.delegate = self
          passwordField.autocapitalizationType = .none
          passwordField.keyboardType = .asciiCapable
          passwordField.returnKeyType = .next
          passwordField.isSecureTextEntry = true
          passwordField.placeholder = "密码"
          passwordField.layer.shadowColor = UIColor.darkGray.cgColor
          
          let passwordIconView = UIImageView(image: UIImage(named: "ic_lock")!.with(color: .white).withRenderingMode(.alwaysTemplate))
          passwordIconView.frame = CGRect(x: 0, y: 0, width: 34, height: 22)
          passwordIconView.contentMode = .scaleAspectFit
          passwordIconView.tintColor = Metadata.Color.WPYAccentColor
          passwordField.leftView = passwordIconView
          passwordField.leftViewMode = .always
          
          //        passwordField.layer.sha
          passwordField.layer.shadowPath = CGPath(rect: CGRect(x: passwordField.x, y: passwordField.height+passwordField.y, width: passwordField.width, height: 1), transform: nil)
          
          contentView.addSubview(passwordField)
          passwordField.snp.makeConstraints { make in
               make.centerX.equalToSuperview()
               make.top.equalTo(usernameField.snp.bottom).offset(20)
               make.width.equalTo(200)
               make.height.equalTo(28)
          }
          captchaField.delegate = self
          captchaField.autocorrectionType = .no
          captchaField.autocapitalizationType = .none
          captchaField.keyboardType = .asciiCapable
          captchaField.returnKeyType = .go
          captchaField.placeholder = "验证码"
          //     captcha.leftView = passwordIconView
          captchaField.leftViewMode = .always
          contentView.addSubview(captchaField)
          captchaField.snp.makeConstraints { make in
               make.left.equalTo(passwordField)
               make.top.equalTo(passwordField.snp.bottom).offset(20)
               make.width.equalTo(100)
               make.height.equalTo(28)
               //          make.centerX.equalToSuperview()
               //          make.top.equalTo(passwordField.snp.bottom).offset(20)
               //          make.width.equalTo(200)
               //          make.height.equalTo(28)
          }
          let url = URL(string: captchaURL)
          //从网络获取数据流
          let data = try! Data(contentsOf: url!)
          //通过数据流初始化图片
          let newImage = UIImage(data: data)
          captchaImage.image = newImage
//               captchaImage.sd_setImage(with: URL(string: captchaURL), placeholderImage: nil, options: .cacheMemoryOnly, completed: nil)
          
          contentView.addSubview(captchaImage)
          captchaImage.snp.makeConstraints { make in
               make.right.equalTo(passwordField)
               make.top.equalTo(passwordField.snp.bottom).offset(20)
               make.width.equalTo(100)
               make.height.equalTo(28)
          }
          let blankView = UIView()
          blankView.backgroundColor = .white
          contentView.addSubview(blankView)
          contentView.sendSubviewToBack(blankView)
          blankView.snp.makeConstraints { make in
               make.left.right.equalToSuperview()
               make.top.equalTo(usernameField.snp.top).offset(-15)
               make.bottom.equalTo(captchaField.snp.bottom).offset(15)
          }
          
          loginButton.addTarget(self, action: #selector(login), for: .touchUpInside)
          loginButton.setTitle("登录", for: .normal)
          loginButton.layer.cornerRadius = loginButton.height/2
          loginButton.backgroundColor = Metadata.Color.WPYAccentColor
          loginButton.setTitleColor(.white, for: .normal)
          contentView.addSubview(loginButton)
          loginButton.snp.makeConstraints { make in
               make.centerX.equalToSuperview()
               make.top.equalTo(captchaField.snp.bottom).offset(50)
               make.width.equalTo(100)
               make.height.equalTo(30)
          }
          
          backgroundView.backgroundColor = UIColor.init(white: 0.97, alpha: 1)
          backgroundView.layer.cornerRadius = 10
          
          NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
          NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
          
          usernameField.text = TwTUser.shared.username
          passwordField.text = TWTKeychain.password(for: .root)
     }
     
     deinit {
          NotificationCenter.default.removeObserver(self)
     }
}

// 这部分应该是 Controller 在做 但我不知道怎么样比较合适
extension SpiderLoginView {
     func refreshCaptcha() {
          let url = URL(string: captchaURL)
          //从网络获取数据流
          let data = try! Data(contentsOf: url!)
          //通过数据流初始化图片
          let newImage = UIImage(data: data)
          captchaImage.image = newImage
     }
     @objc func login() {
          guard let username = usernameField.text, !username.isEmpty else {
               self.showErrorMessage(title: "用户名不能为空")
               self.refreshCaptcha()
               return
          }
          
          guard let password = passwordField.text, !password.isEmpty else {
               self.showErrorMessage(title: "密码不能为空")
               self.refreshCaptcha()
               return
          }
          
          guard let captcha = captchaField.text, !captcha.isEmpty else {
               self.showErrorMessage(title: "验证码不能为空")
               self.refreshCaptcha()
               return
          }
          
          SwiftMessages.showLoading()
          WPYStorage.defaults.setValue(username, forKey: AccountManager.usernameKey)
          WPYStorage.defaults.setValue(password, forKey: AccountManager.passwordKey)
          AccountManager.ssoPost(captcha: captcha) { result in
               switch result {
               case .success:
//                    self.isLogin = true
                    //               self.extraProcedures()
                    TwTUser.shared.username = username
                    TWTKeychain.set(username: username, password: password, of: .root)
                    // tmp solution
                    TwTUser.shared.token = "xixiCrawl"
                    TwTUser.shared.tjuBindingState = true
                    TwTUser.shared.save()
                    self.extraProcedures()
                    
                    SwiftMessages.hideLoading()
                    SwiftMessages.hideAll()
                    self.showSuccessMessage(title: "登录成功✨")
//                    WPYStorage.defaults.setValue(self.isLogin, forKey: ClassesManager.isLoginKey)
                    self.successHandler?()
               case .failure(let error):
                    if error == .alreadyLogin {
//                         self.isLogin = true
                         TwTUser.shared.username = username
                         TWTKeychain.set(username: username, password: password, of: .root)
                         // tmp solution
                         TwTUser.shared.token = "xixiCrawl"
                         TwTUser.shared.tjuBindingState = true
                         TwTUser.shared.save()
                         self.extraProcedures()
                         
                         SwiftMessages.hideLoading()
                         SwiftMessages.hideAll()
                         self.showSuccessMessage(title: "登录成功✨")
//                         WPYStorage.defaults.setValue(self.isLogin, forKey: ClassesManager.isLoginKey)
                         self.successHandler?()
                    } else {
//                         self.isError = true
                         self.failureHandler?()
                         SwiftMessages.hideLoading()
                         self.showErrorMessage(title: error.localizedDescription)
                         self.refreshCaptcha()
                    }
               }
               
               //         isEnable = true
          }
     }
     
     func extraProcedures() {
          NotificationCenter.default.post(name: NotificationName.NotificationUserDidLogin.name, object: nil)
//          AccountManager.getSelf(success: {
//               NotificationCenter.default.post(name: NotificationName.NotificationBindingStatusDidChange.name, object: nil)
//
//          }, failure: nil)
          
          GPASessionManager.getGPA(success: { model in
               if let string = model.toJSONString() {
                    CacheManager.store(object: string, in: .group, as: "gpa/gpa.json")
               }
          }, failure: { _ in
               
          })
          
//          Deprecated in 20201013
//          BicycleUser.sharedInstance.auth(success: {
//               NotificationCenter.default.post(name: NotificationName.NotificationBindingStatusDidChange.name, object: ("bike", TwTUser.shared.bicycleBindingState))
//          })
          
          ClasstableDataManager.getClassTable(success: { model in
               if let string = model.toJSONString() {
                    CacheManager.store(object: string, in: .group, as: "classtable/classtable.json")
               }
          }, failure: { _ in
               
          })
     }
}

extension SpiderLoginView: UITextFieldDelegate {
     func textFieldShouldReturn(_ textField: UITextField) -> Bool {
          if textField == usernameField && textField.returnKeyType == .next {
               passwordField.becomeFirstResponder()
               return true
          }
          
          if textField == passwordField && textField.returnKeyType == .next {
               captchaField.becomeFirstResponder()
               return true
          }
          if textField == captchaField && textField.returnKeyType == .go {
               login()
               return true
          }
          return false
     }
}

extension SpiderLoginView {
     private func showErrorMessage(title: String, body: String = "") {
          let view = MessageView.viewFromNib(layout: .cardView)
          view.configureContent(title: title, body: body)
          view.button?.isHidden = true
          view.configureTheme(.error)
          SwiftMessages.otherMessages.show(view: view)
     }
     
     private func showSuccessMessage(title: String, body: String = "") {
          let view = MessageView.viewFromNib(layout: .cardView)
          view.configureContent(title: title, body: body)
          view.button?.isHidden = true
          view.configureTheme(.success)
          SwiftMessages.otherMessages.show(view: view)
     }
}

extension SpiderLoginView {
     @objc func keyboardWillShow(notification: Notification) {
          if isiPad {
               return
          }
          self.frame.origin.y = 20
     }
     
     @objc func keyboardWillHide(notification: Notification) {
          self.frame.origin.y = (UIScreen.main.bounds.height - self.frame.height)/2
     }
}
