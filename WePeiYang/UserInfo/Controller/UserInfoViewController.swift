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
    private var avatarUrl: String!
    
    private var idView: InfoView!
    private var nameView: InfoView!
    private var schoolView: InfoView!
    private var majorView: InfoView!
    private var phoneView: InfoView!
    private var codeView: InfoView!
    private var emailView: InfoView!
    private var commitButton: UIButton!
    
    var sendCodeRemainTime = 0
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(color: UIColor(red: 0.42, green: 0.62, blue: 0.64, alpha: 1)), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.titleTextAttributes =
            [NSAttributedString.Key.foregroundColor: UIColor.white]
        self.navigationController?.navigationBar.tintColor = UIColor.white
        super.viewWillAppear(animated)

    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        self.navigationItem.title = "个人信息"
        self.navigationItem.hidesBackButton = true
        addView()

        
    }
    
    func addView() {
        
        let avatar = UIImageView()
        view.addSubview(avatar)
        avatar.frame = CGRect(x: UIScreen.main.bounds.width / 2 - 50, y: 100, width: 100, height: 100)
        avatar.addCornerRadius(50)
//        avatar.backgroundColor = .black
//        avatar.ima
        
        if TwTUser.shared.avatarURL == "https://i.twtstudio.com/img/avatar.png" || TwTUser.shared.avatarURL == nil {
            let imageGenerator = Identicon()
            avatar.image = imageGenerator.icon(from: arc4random(), size: CGSize(width: 100, height: 100))
        } else {
            avatarUrl = TwTUser.shared.avatarURL
            avatar.sd_setImage(with: URL(string: avatarUrl!), completed: nil)
        }
        
        idView = InfoView()
        view.addSubview(idView)
        idView.frame = CGRect(x: 30, y: 250, width: UIScreen.main.bounds.width - 60, height: 40)
        idView.isUserInteractionEnabled = true
        idView.sureButton.isUserInteractionEnabled = true
        idView.infoLabel.text = "学号:"
        idView.detailLabel.text = TwTUser.shared.schoolID
        idView.detailTextField.isHidden = true
        idView.sureButton.addTarget(self, action: #selector(sendCode), for: .touchUpInside)
        
        nameView = InfoView()
        view.addSubview(nameView)
        nameView.frame = CGRect(x: 30, y: 300, width: UIScreen.main.bounds.width - 60, height: 40)
        nameView.infoLabel.text = "姓名:"
        nameView.detailLabel.text = TwTUser.shared.realname
        nameView.detailTextField.isHidden = true
        nameView.sureButton.addTarget(self, action: #selector(sendCode), for: .touchUpInside)
        
        schoolView = InfoView()
        view.addSubview(schoolView)
        schoolView.frame = CGRect(x: 30, y: 350, width: UIScreen.main.bounds.width - 60, height: 40)
        schoolView.infoLabel.text = "学院:"
        schoolView.detailLabel.text = TwTUser.shared.department
        schoolView.isUserInteractionEnabled = true
        schoolView.detailTextField.isHidden = true
        schoolView.sureButton.addTarget(self, action: #selector(sendCode), for: .touchUpInside)
        
        majorView = InfoView()
        view.addSubview(majorView)
        majorView.frame = CGRect(x: 30, y: 400, width: UIScreen.main.bounds.width - 60, height: 40)
        majorView.infoLabel.text = "专业:"
        majorView.detailLabel.text = TwTUser.shared.major
        majorView.isUserInteractionEnabled = true
        majorView.detailTextField.isHidden = true
        majorView.sureButton.addTarget(self, action: #selector(sendCode), for: .touchUpInside)
        
        phoneView = InfoView()
        view.addSubview(phoneView)
        phoneView.frame = CGRect(x: 30, y: 450, width: UIScreen.main.bounds.width - 60, height: 40)
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
        
        codeView = InfoView()
        view.addSubview(codeView)
        codeView.frame = CGRect(x: 30, y: 500, width: UIScreen.main.bounds.width - 60, height: 40)
        codeView.infoLabel.text = "验证码:"
        codeView.isUserInteractionEnabled = true
        codeView.detailTextField.placeholder = "请输入验证码"
        codeView.detailTextField.isUserInteractionEnabled = true
        codeView.detailTextField.tag = 2
        codeView.detailTextField.addTarget(self, action: #selector(InsertCodeInfo), for: .editingChanged)
        codeView.detailLabel.isHidden = true
        codeView.sureButton.addTarget(self, action: #selector(sendCode), for: .touchUpInside)
        
        emailView = InfoView()
        view.addSubview(emailView)
        emailView.frame = CGRect(x: 30, y: 550, width: UIScreen.main.bounds.width - 60, height: 40)
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
        commitButton.frame = CGRect(x: UIScreen.main.bounds.width / 2 - 50, y: 630, width: 100, height: 30)
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
            
            
            
        } failure: { (_) in

        }
        
        
    }
    
    

}

struct PhoneInfo {
    static var num: String = ""
    static var code: String = ""
    static var email: String = ""
}
