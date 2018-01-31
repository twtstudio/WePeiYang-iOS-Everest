//
//  TJUBindingViewController.swift
//  WePeiYang
//
//  Created by Tigris on 23/11/2017.
//  Copyright © 2017 twtstudio. All rights reserved.
//

import UIKit
import WMPageController
import SnapKit
import Alamofire

class TJUBindingViewController: WMPageController {
    
    var usernameTextField: UITextField!
    var passwordTextField: UITextField!
    var bindButton: UIButton!
    var logoutButton: UIButton!
    var dismissButton: UIButton!
    var logoImage: UIImage!
    var logoImageView: UIImageView!
    var warningText: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        self.navigationController?.navigationBar.barStyle = .black
        
        self.title = "办公网绑定"
        
        logoImage = UIImage(named: "TJUAccoundBinding")
        let imageRatio: CGFloat = logoImage.size.width / logoImage.size.height
        let imageViewWidth: CGFloat = UIScreen.main.bounds.width * 0.5
        logoImageView = UIImageView.init(image: logoImage)
        logoImageView.frame = CGRect(center: CGPoint(x: self.view.center.x, y: self.view.frame.size.height*1.0/5.0), size: CGSize(width: imageViewWidth, height: imageViewWidth / imageRatio))
        self.view.addSubview(logoImageView)
        
        let textFieldWidth: CGFloat = 250
        usernameTextField = UITextField()
        usernameTextField.frame = CGRect(center: CGPoint(x: self.view.center.x, y: self.view.frame.size.height*2.0/5.0), size: CGSize(width: textFieldWidth, height: 40))
        usernameTextField.placeholder = "请输入账号"
        usernameTextField.keyboardType = .numberPad
        usernameTextField.borderStyle = .roundedRect
        usernameTextField.clearButtonMode = .always
        usernameTextField.autocapitalizationType = .none
        passwordTextField = UITextField()
        passwordTextField.frame = CGRect(center: CGPoint(x: self.view.center.x, y: usernameTextField.frame.origin.y + usernameTextField.frame.size.height + 30), size: CGSize(width: textFieldWidth, height: 40))
        passwordTextField.placeholder = "请输入密码"
        passwordTextField.keyboardType = .default
        passwordTextField.borderStyle = .roundedRect
        passwordTextField.isSecureTextEntry = true
        passwordTextField.clearButtonMode = .always
        self.view.addSubview(usernameTextField)
        self.view.addSubview(passwordTextField)
        
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
        dismissButton = UIButton()
        dismissButton.setTitle("暂不绑定", for: .normal)
        dismissButton.isUserInteractionEnabled = true
        dismissButton.backgroundColor = UIColor(hex6: 0xd3d3d3)
        dismissButton.layer.borderColor = UIColor(hex6: 0xd3d3d3).cgColor
        dismissButton.layer.borderWidth = 2
        dismissButton.layer.cornerRadius = 5
        dismissButton.addTarget(self, action: #selector(dismissBinding), for: .touchUpInside)
        self.view.addSubview(dismissButton)
        dismissButton.snp.makeConstraints { (make) -> Void in
            make.left.equalTo(20)
            make.right.equalTo(-20)
            make.top.equalTo(bindButton.snp.bottom).offset(10)
        }
         */
 
        dismissButton = UIButton(frame: CGRect(x: self.view.frame.width, y: self.view.frame.size.height*4.0/5.0, width: 30, height: 20))
        dismissButton.titleLabel?.font = UIFont.systemFont(ofSize: 13)
        dismissButton.setTitleColor(UIColor(hex6: 0xd3d3d3), for: .normal)
        dismissButton.setTitle("暂不绑定", for: .normal)
        dismissButton.sizeToFit()
        dismissButton.center = CGPoint(x: self.view.center.x, y: self.view.frame.height*4.8/5)
        dismissButton.addTarget(self, action: #selector(dismissBinding), for: .touchUpInside)
        self.view.addSubview(dismissButton)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func bind() {
        
        if usernameTextField.hasText && passwordTextField.hasText {
            var loginInfo: [String: String] = [String: String]()
            loginInfo["tjuuname"] = usernameTextField.text
            loginInfo["tjupasswd"] = passwordTextField.text
            
            SolaSessionManager.solaSession(type: .get, baseURL: baseURL, url: "api/v1/auth/bind/tju",  parameters: loginInfo, success: { dictionary in
                
                print(dictionary)
                print("Succeeded")
                guard let errorCode: Int = dictionary["error_code"] as? Int else {
                    return
                }
                
                if errorCode == -1 {
                    TwTUser.shared.tjuBindingState = true
                    TwTUser.shared.save()
                    NotificationCenter.default.post(name: NotificationName.NotificationBindingStatusDidChange.name, object: ("tju", true))
                    self.dismiss(animated: true, completion: nil)
                    print("TJUBindingState:")
                    print(TwTUser.shared.tjuBindingState)
                } else {
                    let alert = UIAlertController(title: "未知错误", message: nil, preferredStyle: .alert)
                    let okAction = UIAlertAction(title: "好的", style: .default, handler: { (result) in
                        print("OK.")
                    })
                    alert.addAction(okAction)
                    self.present(alert, animated: true, completion: nil)
                }
            }, failure: { error in
                
                print(error)
                print("Failed")
                self.dismiss(animated: true, completion: nil)
                
            })
        } else {
            let alert = UIAlertController(title: "请填写账号和密码", message: nil, preferredStyle: .alert)
            let okAction = UIAlertAction(title: "好的", style: .default, handler: { (result) in
                print("OK.")
            })
            alert.addAction(okAction)
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    
    func cancelLogin() {
        
        // unbind tju account
        var loginInfo: [String: String] = [String: String]()
        loginInfo["tjuuname"] = usernameTextField.text
        loginInfo["tjupasswd"] = passwordTextField.text
        
        SolaSessionManager.solaSession(type: .get, baseURL: baseURL, url: "api/v1/auth/unbind/tju", token: TwTUser.shared.token, parameters: loginInfo, success: { dictionary in
            
            print(dictionary)
            print("Succeeded")
            guard let errorCode: Int = dictionary["error_code"] as? Int else {
                return
            }
            
            if errorCode == -1 {
                TwTUser.shared.tjuBindingState = false
                TwTUser.shared.save()
                self.dismiss(animated: true, completion: nil)
                print("TJUBindingState:")
                print(TwTUser.shared.tjuBindingState)
            } else {
                let alert = UIAlertController(title: "未知错误", message: nil, preferredStyle: .alert)
                let okAction = UIAlertAction(title: "好的", style: .default, handler: { (result) in
                    print("OK.")
                })
                alert.addAction(okAction)
                self.present(alert, animated: true, completion: nil)
            }
        }, failure: { error in
            
            print(error)
            print("Failed")
            self.dismiss(animated: true, completion: nil)
            
        })
    }
    
    func dismissBinding() {
        self.dismiss(animated: true, completion: nil)
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
