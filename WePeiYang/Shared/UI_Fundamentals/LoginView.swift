//
//  LoginView.swift
//  WePeiYang
//
//  Created by Halcao on 2018/3/11.
//  Copyright © 2018年 twtstudio. All rights reserved.
//

import UIKit
import PopupDialog

class LoginView: MessageView {
    fileprivate var usernameField = WPYTextField()
    fileprivate var passwordField = WPYTextField()
    fileprivate var sendButton = CardButton()
    fileprivate var loginButton = CardButton()
    fileprivate var switchButton = UIButton()
    fileprivate var codeButton = UIButton()
    fileprivate var sLine = UIView()
    var successHandler: (() -> Void)?
    var failureHandler: (() -> Void)?
    
    var loginFlag = 0
    var sendCodeRemainTime = 0
    
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
            make.height.equalTo(300)
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
        
        switchButton.tag = 0
        switchButton.addTarget(self, action: #selector(switchCase(button:)), for: .touchUpInside)
        switchButton.setTitle("密码登录", for: .normal)
        //        switchButton.backgroundColor = Metadata.Color.WPYAccentColor
        switchButton.setTitleColor(.gray, for: .normal)
        switchButton.isSelected = true
        switchButton.setTitleColor(Metadata.Color.WPYAccentColor, for: .selected)
        contentView.addSubview(switchButton)
        switchButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview().offset(-50)
            make.top.equalTo(iconView.snp.bottom).offset(10)
            make.width.equalTo(100)
            make.height.equalTo(30)
        }
        
        sLine.backgroundColor = Metadata.Color.WPYAccentColor
        switchButton.addSubview(sLine)
        sLine.snp.makeConstraints { (make) in
            make.bottom.equalTo(switchButton.snp.bottom)
            make.width.equalTo(switchButton.snp.width)
            make.left.equalTo(switchButton.snp.left)
            make.height.equalTo(3)
        }
        
        codeButton.tag = 1
        codeButton.addTarget(self, action: #selector(switchCase(button:)), for: .touchUpInside)
        codeButton.setTitle("短信登录", for: .normal)
        //        switchButton.backgroundColor = Metadata.Color.WPYAccentColor
        codeButton.setTitleColor(.gray, for: .normal)
        codeButton.setTitleColor(Metadata.Color.WPYAccentColor, for: .selected)
        contentView.addSubview(codeButton)
        codeButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview().offset(50)
            make.top.equalTo(iconView.snp.bottom).offset(10)
            make.width.equalTo(100)
            make.height.equalTo(30)
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
            make.top.equalTo(iconView.snp.bottom).offset(55)
            make.width.equalTo(200)
            make.height.equalTo(28)
        }
        
        
        passwordField.autocorrectionType = .no
        passwordField.delegate = self
        passwordField.autocapitalizationType = .none
        passwordField.keyboardType = .asciiCapable
        passwordField.returnKeyType = .go
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
        
        let blankView = UIView()
        blankView.backgroundColor = .white
        contentView.addSubview(blankView)
        contentView.sendSubviewToBack(blankView)
        blankView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(usernameField.snp.top).offset(-15)
            make.bottom.equalTo(passwordField.snp.bottom).offset(15)
        }
        
        sendButton.addTarget(self, action: #selector(sendCode), for: .touchUpInside)
        sendButton.setTitle("发送验证码", for: .normal)
        sendButton.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .light)
        sendButton.layer.cornerRadius = switchButton.height/2
        //        sendButton.backgroundColor = Metadata.Color.WPYAccentColor
        sendButton.setTitleColor(.black, for: .normal)
        sendButton.isHidden = true
        contentView.addSubview(sendButton)
        sendButton.snp.makeConstraints { (make) in
            make.centerY.equalTo(self.usernameField.snp.centerY)
            make.right.equalToSuperview().offset(-30)
        }
        
        
        
        loginButton.addTarget(self, action: #selector(login), for: .touchUpInside)
        loginButton.setTitle("登录", for: .normal)
        loginButton.layer.cornerRadius = loginButton.height/2
        loginButton.backgroundColor = Metadata.Color.WPYAccentColor
        loginButton.setTitleColor(.white, for: .normal)
        contentView.addSubview(loginButton)
        loginButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(passwordField.snp.bottom).offset(50)
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
extension LoginView {
    @objc func switchCase(button: UIButton) {
        if button.tag == 1 {
            button.isSelected = true
            self.switchButton.isSelected = false
            self.usernameField.text = ""
            self.usernameField.placeholder = "请输入手机号"
            self.passwordField.text = ""
            self.passwordField.placeholder = "验证码"
            self.sendButton.isHidden = false
            loginFlag = 1
            UIView.animate(withDuration: 0.2) {
                self.sLine.snp_remakeConstraints { (make) in
                    make.bottom.equalTo(self.codeButton.snp.bottom)
                    make.width.equalTo(self.codeButton.snp.width)
                    make.left.equalTo(self.codeButton.snp.left)
                    make.height.equalTo(3)
                }
                self.layoutIfNeeded()
            }
        } else {
            button.isSelected = true
            self.codeButton.isSelected = false
            self.usernameField.text = ""
            self.usernameField.placeholder = "天外天用户名"
            self.passwordField.text = ""
            self.passwordField.placeholder = "密码"
            self.sendButton.isHidden = true
            loginFlag = 0
            UIView.animate(withDuration: 0.2) {
                self.sLine.snp_remakeConstraints { (make) in
                    make.bottom.equalTo(self.switchButton.snp.bottom)
                    make.width.equalTo(self.switchButton.snp.width)
                    make.left.equalTo(self.switchButton.snp.left)
                    make.height.equalTo(3)
                }
                self.layoutIfNeeded()
            }
        }
        
        
        
    }
    @objc func sendCode() {
        guard let phoneNum = usernameField.text, !phoneNum.isEmpty else {
            self.showErrorMessage(title: "手机号不能为空")
            return
        }
        
        GetCodeHelper.getLoginCode(phone: phoneNum) { _ in
            //            print(testInfo)
            self.sendButton.isEnabled = false
            let time = DispatchSource.makeTimerSource()
            time.schedule(deadline: .now(), repeating: 1)
            self.sendCodeRemainTime = 60
            time.setEventHandler {
                if self.sendCodeRemainTime < 0 {
                    DispatchQueue.main.async {
                        self.sendButton.setTitle("发送验证码", for: .normal)
                        self.sendButton.isEnabled = true
                    }
                    time.cancel()
                } else {
                    DispatchQueue.main.async {
                        self.sendButton.setTitle(self.sendCodeRemainTime.description + "s", for: .normal)
                        self.sendCodeRemainTime -= 1
                    }
                }
            }
            time.resume()
        } failure: { (_) in
            print("获取验证码失败")
        }
    }
    @objc func login() {
        guard let username = usernameField.text, !username.isEmpty else {
            self.showErrorMessage(title: "用户名不能为空")
            return
        }
        
        guard let password = passwordField.text, !password.isEmpty else {
            self.showErrorMessage(title: "密码不能为空")
            return
        }
        
        SwiftMessages.showLoading()
        if loginFlag == 0 {
            GetUserInfoHelper.login(username: username, password: password) { (info) in
                TwTUser.shared.major = info.major
                TwTUser.shared.department = info.department
                TwTUser.shared.telephone = info.telephone
                TwTUser.shared.email = info.email
                TwTUser.shared.schoolID = info.userNumber
                TwTUser.shared.realname = info.realname
                TwTUser.shared.department = info.department
                TwTUser.shared.token = info.token
                TwTUser.shared.save()
                //                TwTUser.shared.major = info.major
                TwTUser.shared.username = username
                TWTKeychain.set(username: username, password: password, of: .root)
                
                self.extraProcedures()
                SwiftMessages.hideLoading()
                SwiftMessages.hideAll()
                self.showSuccessMessage(title: "登录成功✨")
                self.successHandler?()
            } failure: { (err) in
                SwiftMessages.hideLoading()
                self.failureHandler?()
                self.showErrorMessage(title: err.localizedDescription)
            }
//            AccountManager.getToken(username: username, password: password, success: { token in
//                TwTUser.shared.username = username
//                TWTKeychain.set(username: username, password: password, of: .root)
//                TwTUser.shared.token = token
//
//                TwTUser.shared.save()
//                self.extraProcedures()
//                SwiftMessages.hideLoading()
//                SwiftMessages.hideAll()
//                self.showSuccessMessage(title: "登录成功✨")
//                self.successHandler?()
//            }, failure: { errMsg in
//                SwiftMessages.hideLoading()
//                self.failureHandler?()
//                self.showErrorMessage(title: errMsg)
//            })
            
            
        } else {
            GetUserInfoHelper.loginByPhone(phone: username, code: password) { (info) in
                TwTUser.shared.username = info.userNumber
                TwTUser.shared.realname = info.realname
                TwTUser.shared.schoolID = info.userNumber
                TwTUser.shared.token = info.token
                TwTUser.shared.major = info.major
                TwTUser.shared.department = info.department
                TwTUser.shared.telephone = info.telephone
                TwTUser.shared.email = info.email
                TwTUser.shared.save()
                self.extraProcedures()
                SwiftMessages.hideLoading()
                SwiftMessages.hideAll()
                self.showSuccessMessage(title: "登录成功✨")
                self.successHandler?()
            } failure: { (errMsg) in
                SwiftMessages.hideLoading()
                self.failureHandler?()
                self.showErrorMessage(title: "登录失败")
            }
            
        }
        
    }
    
    
    
    func extraProcedures() {
        NotificationCenter.default.post(name: NotificationName.NotificationUserDidLogin.name, object: nil)
//        AccountManager.getSelf(success: {
//            NotificationCenter.default.post(name: NotificationName.NotificationBindingStatusDidChange.name, object: nil)
//            
//        }, failure: nil)
        
        GPASessionManager.getGPA(success: { model in
            if let string = model.toJSONString() {
                CacheManager.store(object: string, in: .group, as: "gpa/gpa.json")
            }
        }, failure: { _ in
            
        })
        
        BicycleUser.sharedInstance.auth(success: {
            NotificationCenter.default.post(name: NotificationName.NotificationBindingStatusDidChange.name, object: ("bike", TwTUser.shared.bicycleBindingState))
        })
        
        ClasstableDataManager.getClassTable(success: { model in
            if let string = model.toJSONString() {
                CacheManager.store(object: string, in: .group, as: "classtable/classtable.json")
            }
        }, failure: { _ in
            
        })
    }
}

extension LoginView: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == usernameField && textField.returnKeyType == .next {
            passwordField.becomeFirstResponder()
            return true
        }
        
        if textField == passwordField && textField.returnKeyType == .go {
            login()
            return true
        }
        return false
    }
}

extension LoginView {
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

extension LoginView {
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
