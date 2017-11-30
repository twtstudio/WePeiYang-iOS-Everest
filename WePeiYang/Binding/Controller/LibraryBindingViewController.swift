//
//  LibraryBindingViewController.swift
//  WePeiYang
//
//  Created by Tigris on 23/11/2017.
//  Copyright © 2017 twtstudio. All rights reserved.
//

import UIKit

class LibraryBindingViewController: UIViewController {
    
    var accountTextField: UITextField!
    var passwordTextField: UITextField!
    var loginButton: UIButton!
    var logoutButton: UIButton!
    var cancelButton: UIButton!
    var logoImage: UIImage!
    var logoImageView: UIImageView!
    var warningText: UITextView!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.navigationController?.navigationBar.barStyle = .black
        
        self.title = "图书馆绑定"
        
        logoImage = UIImage(named: "TJU")
        logoImageView = UIImageView.init(image: logoImage)
        logoImageView.frame = CGRect(x: 0, y: -70, width: UIScreen.main.bounds.width, height: self.view.bounds.height)
        self.view.addSubview(logoImageView)
        
        passwordTextField = UITextField()
        passwordTextField.frame = CGRect(x: 20, y: logoImageView.frame.height * 0.4 + 40, width: UIScreen.main.bounds.width - 20 * 2, height: 30)
        passwordTextField.placeholder = "请输入密码"
        passwordTextField.keyboardType = .default
        passwordTextField.borderStyle = .roundedRect
        passwordTextField.isSecureTextEntry = true
        self.view.addSubview(passwordTextField)
        
        loginButton = UIButton()
        loginButton.frame = CGRect(x: 20, y: logoImageView.frame.height * 0.4 + 40 + 50 + 20, width: UIScreen.main.bounds.width - 20 * 2, height: 40)
        loginButton.setTitle("绑 定", for: .normal)
        loginButton.setTitleColor(.white, for: .normal)
        loginButton.isUserInteractionEnabled = true
        loginButton.backgroundColor = UIColor(hex6: 0x00a1e9)
        // to make button rounded rect
        loginButton.layer.borderColor = UIColor(hex6: 0x00a1e9).cgColor
        loginButton.layer.borderWidth = 2
        loginButton.layer.cornerRadius = 5
        loginButton.addTarget(self, action: #selector(login), for: .touchUpInside)
        self.view.addSubview(loginButton)
        
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
            make.top.equalTo(loginButton.snp.bottom).offset(10)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func login() {
        
        if passwordTextField.hasText {
            var loginInfo: [String: String] = [String: String]()
            loginInfo["libpasswd"] = passwordTextField.text
            
            SolaSessionManager.solaSession(type: .get, baseURL: baseURL, url: "api/v1/auth/bind/lib", token: TwTUser.shared.token, parameters: loginInfo, success: { dictionary in
                
                print(dictionary)
                print("Succeeded")
                guard let bindingStatus: String = dictionary["data"] as? String else {
                    return
                }
                
                if bindingStatus == "success" {
                    TwTUser.shared.libBindingState = true
                    TwTUser.shared.save()
                    NotificationCenter.default.post(name: NotificationNames.NotificationStatusDidChange.name, object: ("lib", true))
                    self.dismiss(animated: true, completion: nil)
                    print("TJUBindingState:")
                    print(TwTUser.shared.libBindingState)
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
        
        SolaSessionManager.solaSession(type: .get, baseURL: baseURL, url: "api/v1/auth/unbind/lib", token: TwTUser.shared.token, parameters: nil, success: { dictionary in
            
            print(dictionary)
            print("Succeeded")
            guard let bindingStatus: String = dictionary["data"] as? String else {
                return
            }
            
            if bindingStatus == "unbind success" {
                TwTUser.shared.libBindingState = false
                TwTUser.shared.save()
                self.dismiss(animated: true, completion: nil)
                print("TJUBindingState:")
                print(TwTUser.shared.libBindingState)
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
