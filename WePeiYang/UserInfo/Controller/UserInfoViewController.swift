//
//  TestVC.swift
//  WePeiYang
//
//  Created by 安宇 on 2021/1/13.
//  Copyright © 2021 twtstudio. All rights reserved.
//

import UIKit
import SnapKit
import SDWebImage
import IGIdenticon
class UserInfoViewController: UIViewController, UITextFieldDelegate {
    
//    var token = ""
    private var userInfo: UserInfo!
    private var avatar: UIImageView!
    private var avatarUrl: String!
    
    private var idView: UserInfoView!
    private var nameView: UserInfoView!
    private var schoolView: UserInfoView!
    private var majorView: UserInfoView!
    private var phoneView: UserInfoView!
    private var codeView: UserInfoView!
    private var emailView: UserInfoView!
    private var commitButton: UIButton!
    
    var sendCodeRemainTime = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        addView()
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    private func addView() {
        
        let full: CGFloat = SCREEN.height - 20
        let seperateHeight: CGFloat = 10
        let remainHeight: CGFloat = full - seperateHeight * 12
        let oddHeight: CGFloat = remainHeight / 12
        let viewWidth = SCREEN.width * 0.8
        
        avatar = UIImageView()
        view.addSubview(avatar)
        avatar.addCornerRadius(50)
        avatar.snp.makeConstraints { (make) in
            make.centerX.equalTo(view)
            make.width.height.equalTo(100)
            make.top.equalTo(view).offset(seperateHeight * 2)
        }
        
        if TwTUser.shared.avatarURL == "https://i.twtstudio.com/img/avatar.png" || TwTUser.shared.avatarURL == nil {
            let imageGenerator = Identicon()
            avatar.image = imageGenerator.icon(from: arc4random(), size: CGSize(width: 100, height: 100))
        } else {
            avatarUrl = TwTUser.shared.avatarURL
            avatar.sd_setImage(with: URL(string: avatarUrl!), completed: nil)
        }
        
        idView = UserInfoView()
        view.addSubview(idView)
        idView.isUserInteractionEnabled = true
        idView.sureButton.isUserInteractionEnabled = true
        idView.infoLabel.text = "学号:"
        idView.detailLabel.text = TwTUser.shared.schoolID
        idView.detailTextField.isHidden = true
        idView.sureButton.addTarget(self, action: #selector(sendCode), for: .touchUpInside)
        idView.snp.makeConstraints { (make) in
            make.centerX.equalTo(avatar)
            make.top.equalTo(avatar.snp.bottom).offset(seperateHeight)
            make.width.equalTo(viewWidth)
            make.height.equalTo(oddHeight)
        }
        
        nameView = UserInfoView()
        view.addSubview(nameView)
        nameView.infoLabel.text = "姓名:"
        nameView.detailLabel.text = TwTUser.shared.realname
        nameView.detailTextField.isHidden = true
        nameView.sureButton.addTarget(self, action: #selector(sendCode), for: .touchUpInside)
        nameView.snp.makeConstraints { (make) in
            make.centerX.equalTo(avatar)
            make.top.equalTo(idView.snp.bottom).offset(seperateHeight)
            make.width.equalTo(viewWidth)
            make.height.equalTo(oddHeight)
        }
        
        schoolView = UserInfoView()
        view.addSubview(schoolView)
        schoolView.infoLabel.text = "学院:"
        schoolView.detailLabel.text = TwTUser.shared.department
        schoolView.isUserInteractionEnabled = true
        schoolView.detailTextField.isHidden = true
        schoolView.sureButton.addTarget(self, action: #selector(sendCode), for: .touchUpInside)
        schoolView.snp.makeConstraints { (make) in
            make.centerX.equalTo(avatar)
            make.top.equalTo(nameView.snp.bottom).offset(seperateHeight)
            make.width.equalTo(viewWidth)
            make.height.equalTo(oddHeight)
        }
        
        majorView = UserInfoView()
        view.addSubview(majorView)
        majorView.infoLabel.text = "专业:"
        majorView.detailLabel.text = TwTUser.shared.major
        majorView.isUserInteractionEnabled = true
        majorView.detailTextField.isHidden = true
        majorView.sureButton.addTarget(self, action: #selector(sendCode), for: .touchUpInside)
        majorView.snp.makeConstraints { (make) in
            make.centerX.equalTo(avatar)
            make.top.equalTo(schoolView.snp.bottom).offset(seperateHeight)
            make.width.equalTo(viewWidth)
            make.height.equalTo(oddHeight)
        }
        
        phoneView = UserInfoView()
        view.addSubview(phoneView)
        phoneView.snp.makeConstraints { (make) in
            make.centerX.equalTo(avatar)
            make.top.equalTo(majorView.snp.bottom).offset(seperateHeight)
            make.width.equalTo(viewWidth)
            make.height.equalTo(oddHeight)
        }
        phoneView.infoLabel.text = "手机号:"
        phoneView.isUserInteractionEnabled = true
        if TwTUser.shared.telephone != nil {
            phoneView.detailTextField.text = TwTUser.shared.telephone
            PhoneInfo.num = TwTUser.shared.telephone!
        }
        phoneView.detailTextField.placeholder = "请输入手机号"
        phoneView.detailTextField.clearButtonMode = .unlessEditing
        phoneView.detailTextField.isUserInteractionEnabled = true
        phoneView.detailTextField.tag = 1
        phoneView.detailTextField.addTarget(self, action: #selector(InsertPhoneInfo), for: .editingChanged)
        phoneView.detailLabel.isHidden = true
        phoneView.sureButton.isHidden = false
        phoneView.sureButton.addTarget(self, action: #selector(sendCode), for: .touchUpInside)
        
        codeView = UserInfoView()
        view.addSubview(codeView)
        codeView.snp.makeConstraints { (make) in
            make.centerX.equalTo(avatar)
            make.top.equalTo(phoneView.snp.bottom).offset(seperateHeight)
            make.width.equalTo(viewWidth)
            make.height.equalTo(oddHeight)
        }
        codeView.infoLabel.text = "验证码:"
        codeView.isUserInteractionEnabled = true
        codeView.detailTextField.placeholder = "请输入验证码"
        codeView.detailTextField.isUserInteractionEnabled = true
        codeView.detailTextField.tag = 2
        codeView.detailTextField.addTarget(self, action: #selector(InsertCodeInfo), for: .editingChanged)
        codeView.detailLabel.isHidden = true
        codeView.sureButton.addTarget(self, action: #selector(sendCode), for: .touchUpInside)
        
        emailView = UserInfoView()
        view.addSubview(emailView)
        emailView.snp.makeConstraints { (make) in
            make.centerX.equalTo(avatar)
            make.top.equalTo(codeView.snp.bottom).offset(seperateHeight)
            make.width.equalTo(viewWidth)
            make.height.equalTo(oddHeight)
        }
        emailView.infoLabel.text = "邮箱:"
        emailView.isUserInteractionEnabled = true
        if TwTUser.shared.email != nil{
            emailView.detailTextField.text = TwTUser.shared.email
            PhoneInfo.email = TwTUser.shared.email!
        }
        emailView.detailTextField.placeholder = "请输入邮箱号"
        emailView.detailTextField.clearButtonMode = .unlessEditing
        emailView.detailTextField.isUserInteractionEnabled = true
        emailView.detailTextField.tag = 3
        emailView.detailTextField.addTarget(self, action: #selector(InsertEmailInfo), for: .editingChanged)
        emailView.detailLabel.isHidden = true
        emailView.sureButton.addTarget(self, action: #selector(sendCode), for: .touchUpInside)
        
        commitButton = UIButton()
        view.addSubview(commitButton)
        commitButton.snp.makeConstraints { (make) in
            make.centerX.equalTo(avatar)
            make.top.equalTo(emailView.snp.bottom).offset(seperateHeight)
            make.width.equalTo(viewWidth)
            make.height.equalTo(oddHeight)
        }
        commitButton.setTitle("确认", for: .normal)
        commitButton.layer.cornerRadius = 5
        commitButton.backgroundColor = UIColor(red: 0.42, green: 0.62, blue: 0.64, alpha: 1)
        commitButton.addTarget(self, action: #selector(refreshData), for: .touchUpInside)
    }
    
    @objc func sendCode(button: UIButton) {
        GetCodeHelper.getRegisterCode { (testInfo) in
//            print(testInfo)
            if testInfo.errorCode != 50014 {
                self.phoneView.sureButton.isEnabled = false
                let time = DispatchSource.makeTimerSource()
                time.schedule(deadline: .now(), repeating: 1)
                self.sendCodeRemainTime = 60
                time.setEventHandler {
                    if self.sendCodeRemainTime < 0 {
                        DispatchQueue.main.async {
                            self.phoneView.sureButton.setTitle("发送验证码", for: .normal)
                            self.phoneView.sureButton.isEnabled = true
                        }
                        time.cancel()
                    } else {
                        DispatchQueue.main.async {
                            self.phoneView.sureButton.setTitle(self.sendCodeRemainTime.description + "s", for: .normal)
                            self.sendCodeRemainTime -= 1
                        }
                    }
                }
                time.resume()
            } else {
                SwiftMessages.showErrorMessage(body: testInfo.message)
            }
        } failure: { (err) in
            print(err)
        }
    }
    
    @objc func InsertPhoneInfo(field: UITextField) {
        PhoneInfo.num = String(field.text!)
    }
    
    @objc func InsertCodeInfo(field: UITextField) {
        PhoneInfo.code = String(field.text!)
    }
    @objc func InsertEmailInfo(field: UITextField) {
        PhoneInfo.email = String(field.text!)
    }
    @objc func refreshData() {
        ChangeUserInfoHelper.changeUserInfo { (none) in
//            print(none)
            let alert = UIAlertController(title: "提示", message: none.message, preferredStyle: .alert)
            let action1 = UIAlertAction(title: "好的", style: .default) { (_) in
                if none.errorCode == 0 {
                    TwTUser.shared.telephone = PhoneInfo.num
                    self.navigationController?.popViewController(animated: true)
                    self.dismiss(animated: true, completion: nil)
                }
            }
            alert.addAction(action1)
            self.present(alert, animated: true, completion: nil)
            
            
            
        } failure: { (err) in
            print(err)
        }
    }
}

extension UserInfoViewController {
    @objc func keyboardWillShow(notification: Notification) {
        if isiPad {
            return
        }
        view.frame.origin.y = -150
    }
    
    @objc func keyboardWillHide(notification: Notification) {
        view.frame.origin.y = 0
    }
}

struct PhoneInfo {
    static var num: String = ""
    static var code: String = ""
    static var email: String = ""
}
