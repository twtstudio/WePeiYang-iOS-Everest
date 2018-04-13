//
//  LibraryBindingViewController.swift
//  WePeiYang
//
//  Created by Tigris on 23/11/2017.
//  Copyright © 2017 twtstudio. All rights reserved.
//

import UIKit
import SwiftMessages

class LibraryBindingViewController: UIViewController {
    
    var usernameTextField: UITextField!
    var passwordTextField: UITextField!
    var captionLabel: UILabel!
    var bindButton: UIButton!
    var logoutButton: UIButton!
    var dismissButton: UIButton!
    var logoImage: UIImage!
    var logoImageView: UIImageView!
    var warningText: UITextView!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        // Do any additional setup after loading the view.
        
        self.navigationController?.navigationBar.barStyle = .black
        
        self.title = "图书馆绑定"
        
        logoImage = UIImage(named: "libBinding")
        let imageRatio: CGFloat = logoImage.size.width / logoImage.size.height
        let imageViewWidth: CGFloat = UIScreen.main.bounds.width * 0.5
        logoImageView = UIImageView.init(image: logoImage)
        logoImageView.frame = CGRect(center: CGPoint(x: self.view.center.x, y: self.view.frame.size.height*1.0/5.0), size: CGSize(width: imageViewWidth, height: imageViewWidth / imageRatio))
        self.view.addSubview(logoImageView)

        let textFieldWidth: CGFloat = 250
        passwordTextField = UITextField()
        passwordTextField.frame = CGRect(center: CGPoint(x: self.view.center.x, y: self.view.frame.size.height*2.0/5.0), size: CGSize(width: textFieldWidth, height: 40))
        passwordTextField.placeholder = "请输入密码"
        passwordTextField.keyboardType = .default
        passwordTextField.borderStyle = .roundedRect
        passwordTextField.isSecureTextEntry = true
        passwordTextField.clearButtonMode = .always
        self.view.addSubview(passwordTextField)

        captionLabel = UILabel()
        captionLabel.textAlignment = .center
        captionLabel.text = "默认密码是 000000 或 666666"
        captionLabel.font = UIFont.systemFont(ofSize: 13)
        captionLabel.textColor = UIColor(hex6: 0xd3d3d3)
        self.view.addSubview(captionLabel)
        captionLabel.snp.makeConstraints { make in
            make.left.equalTo(passwordTextField.snp.left)
            make.bottom.equalTo(passwordTextField.snp.top).offset(-10)
        }


        bindButton = UIButton()
        bindButton.frame = CGRect(x: (self.view.frame.size.width-textFieldWidth)/2, y: passwordTextField.frame.origin.y + passwordTextField.frame.size.height + 20, width: textFieldWidth, height: 38)
        bindButton.setTitle("绑 定", for: .normal)
        bindButton.setTitleColor(.white, for: .normal)
        bindButton.isUserInteractionEnabled = true
        bindButton.backgroundColor = UIColor(hex6: 0x00a1e9)
        // to make button rounded rect
        bindButton.layer.borderColor = UIColor(hex6: 0x00a1e9).cgColor
        bindButton.layer.borderWidth = 2
        bindButton.layer.cornerRadius = 5
        bindButton.addTarget(self, action: #selector(bind), for: .touchUpInside)
        self.view.addSubview(bindButton)
        
        /*
        cancelButton = UIButton()
        cancelButton.setTitle("暂不绑定", for: .normal)
        cancelButton.isUserInteractionEnabled = true
        cancelButton.backgroundColor = UIColor(hex6: 0xd3d3d3)
        cancelButton.layer.borderColor = UIColor(hex6: 0xd3d3d3).cgColor
        cancelButton.layer.borderWidth = 2
        cancelButton.layer.cornerRadius = 5
        cancelButton.addTarget(self, action: #selector(dismissBinding), for: .touchUpInside)
        self.view.addSubview(cancelButton)
        cancelButton.snp.makeConstraints { (make) -> Void in
            make.left.equalTo(20)
            make.right.equalTo(-20)
            make.top.equalTo(bindButton.snp.bottom).offset(10)
        }
         */
        
        dismissButton = UIButton(frame: CGRect(x: self.view.frame.width, y: bindButton.y + bindButton.height + 20, width: 30, height: 20))
        dismissButton.titleLabel?.font = UIFont.systemFont(ofSize: 13)
        dismissButton.setTitleColor(UIColor.gray, for: .normal)
        dismissButton.setTitle("暂不绑定", for: .normal)
        dismissButton.sizeToFit()
        dismissButton.center = CGPoint(x: self.view.center.x, y: bindButton.y + bindButton.height + 20)
        dismissButton.addTarget(self, action: #selector(dismissBinding), for: .touchUpInside)
        self.view.addSubview(dismissButton)
 
        self.view.backgroundColor = .white
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: .UIKeyboardWillHide, object: nil)
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    @objc func keyboardWillShow(notification: NSNotification) {
        self.view.frame.origin.y = -40
    }

    @objc func keyboardWillHide(notification: NSNotification) {
        self.view.frame.origin.y = 0
    }


    @objc func bind() {
        
        if passwordTextField.hasText {
            var loginInfo: [String: String] = [String: String]()
            loginInfo["libpasswd"] = passwordTextField.text
            
            SolaSessionManager.solaSession(type: .get, url: "/auth/bind/lib", token: TwTUser.shared.token, parameters: loginInfo, success: { dictionary in
                guard let errorCode: Int = dictionary["error_code"] as? Int,
                let errMsg = dictionary["message"] as? String else {
                    return
                }
                
                if errorCode == -1 {
                    TwTUser.shared.libBindingState = true
                    TwTUser.shared.libPassword = self.passwordTextField.text!
                    TwTUser.shared.save()
                    NotificationCenter.default.post(name: NotificationName.NotificationBindingStatusDidChange.name, object: ("lib", true))
                    SwiftMessages.showSuccessMessage(body: "绑定成功！")
                    self.dismiss(animated: true, completion: nil)
                } else {
                    SwiftMessages.showErrorMessage(body: "密码错误！")
                }
            }, failure: { error in
                SwiftMessages.showErrorMessage(body: error.localizedDescription)
            })
        } else {
            SwiftMessages.showWarningMessage(body: "请填写密码")
        }
    }
    
    
    func cancelLogin() {
        
        // unbind tju account
        
        SolaSessionManager.solaSession(type: .get, url: "/auth/unbind/lib", token: TwTUser.shared.token, parameters: nil, success: { dictionary in
            
            print(dictionary)
            print("Succeeded")
            guard let errorCode: Int = dictionary["error_code"] as? Int,
                let errMsg = dictionary["message"] as? String else {
                    return
            }

            
            if errorCode == -1 {
                TwTUser.shared.libBindingState = false
                TwTUser.shared.save()
                SwiftMessages.showSuccessMessage(body: "解绑成功！")
                self.dismiss(animated: true, completion: nil)
                print("TJUBindingState:")
                print(TwTUser.shared.libBindingState)
            } else {
                SwiftMessages.showErrorMessage(body: errMsg)
            }
        }, failure: { error in
            
            debugLog(error)
            print("Failed")
            SwiftMessages.showErrorMessage(body: error.localizedDescription)

        })
    }
    
    @objc func dismissBinding() {
        self.dismiss(animated: true, completion: nil)
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
}
