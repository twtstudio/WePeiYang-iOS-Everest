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
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(color: UIColor(hex6: 0x00a1e9))!, for: .default)
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
        self.navigationController?.navigationBar.tintColor = UIColor.white
        navigationController?.setNavigationBarHidden(false, animated: animated)

        let manager = Alamofire.NetworkReachabilityManager(host: "www.apple.com/cn")

                Network.reachability = try! Reachability(hostname: "www.apple.com/cn/")
//        try! Network.reachability?
    }


    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        // Set the type of status bar according to the comments written by Allen, .blackTranslucent is deprecated.
        self.navigationController?.navigationBar.barStyle = .black

        self.view.backgroundColor = .white
        self.title = "上网"
        WiFiImage = UIImage(named: "TJU")
        WiFiImageView = UIImageView.init(image: WiFiImage)
        WiFiImageView.frame = CGRect(x: 0, y: -70, width: UIScreen.main.bounds.width, height: self.view.bounds.height)
        self.view.addSubview(WiFiImageView)
        
        updateUserInterface()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func updateUserInterface() {
        guard let reachability = Network.reachability else { return }
        print("\nReachability Summary")
        print("Status:", reachability.status)
//        print("HostName:", reachability.hostname)
        print("Reachable:", reachability.isReachable)
        print("Wifi:", reachability.isReachableViaWiFi)
        print(getWiFiSSID() ?? "nil")
        
        /*
         guard let isReady: Bool = Network.reachability?.isReachable, (getWiFiSSID() == "tjuwlan" || getWiFiSSID() == "tjuwlan-lib") && isReady else {
         // NetworkReachability went wrong and I don't know what to do
         // or the device is just not connected to tjuwlan
         return
         }
         */
        
        switch reachability.status {
        case .unreachable:
            if getWiFiSSID() == "tjuwlan" || getWiFiSSID() == "tjuwlan-lib" {
                accountTextField = UITextField()
                accountTextField.frame = CGRect(x: 20, y: WiFiImageView.frame.height - WiFiImageView.frame.height * 0.6, width: UIScreen.main.bounds.width - 20 * 2, height: 30)
                accountTextField.placeholder = "请输入账号"
                accountTextField.keyboardType = .numberPad
                accountTextField.borderStyle = .roundedRect
                passwordTextField = UITextField()
                passwordTextField.frame = CGRect(x: 20, y: WiFiImageView.frame.height * 0.4 + 40, width: UIScreen.main.bounds.width - 20 * 2, height: 30)
                passwordTextField.placeholder = "请输入密码"
                passwordTextField.keyboardType = .default
                passwordTextField.borderStyle = .roundedRect
                passwordTextField.isSecureTextEntry = true
                self.view.addSubview(accountTextField)
                self.view.addSubview(passwordTextField)

                // auto fill
                accountTextField.text = TwTUser.shared.WLANAccount
                passwordTextField.text = TwTUser.shared.WLANPassword

                loginButton = UIButton()
                loginButton.frame = CGRect(x: 20, y: WiFiImageView.frame.height * 0.4 + 40 + 50 + 20, width: UIScreen.main.bounds.width - 20 * 2, height: 40)
                loginButton.setTitle("登 录", for: .normal)
                loginButton.setTitleColor(.white, for: .normal)
                loginButton.isUserInteractionEnabled = true
                loginButton.backgroundColor = UIColor(hex6: 0x00a1e9)
                // to make button rounded rect
                loginButton.layer.borderColor = UIColor(hex6: 0x00a1e9).cgColor
                loginButton.layer.borderWidth = 2
                loginButton.layer.cornerRadius = 5
                loginButton.addTarget(self, action: #selector(login), for: .touchUpInside)
                self.view.addSubview(loginButton)

                serviceButton = UIButton()
                serviceButton.setTitle("自服务", for: .normal)
                serviceButton.isUserInteractionEnabled = true
                serviceButton.backgroundColor = UIColor(hex6: 0xd3d3d3)
                serviceButton.layer.borderColor = UIColor(hex6: 0xd3d3d3).cgColor
                serviceButton.layer.borderWidth = 2
                serviceButton.layer.cornerRadius = 5
                serviceButton.addTarget(self, action: #selector(showService), for: .touchUpInside)
                self.view.addSubview(serviceButton)
                serviceButton.snp.makeConstraints { (make) -> Void in
                    make.left.equalTo(20)
                    make.right.equalTo(-20)
                    make.top.equalTo(loginButton.snp.bottom).offset(10)
                }
            } else {
                warningText = UILabel()
                warningText.text = "请连接到 tjuwlan 或 tjuwlan-lib"
                warningText.font = UIFont.systemFont(ofSize: 24)
                warningText.textColor = UIColor(hex6: 0xd3d3d3)
                warningText.frame = CGRect(x: 20, y: WiFiImageView.frame.height - WiFiImageView.frame.height * 0.6, width: UIScreen.main.bounds.width - 20 * 2, height: 100)
                warningText.textAlignment = .center
                self.view.addSubview(warningText)
            }
        case .wifi:
                warningText = UILabel()
                warningText.text = "已经登录啦"
                warningText.font = UIFont.systemFont(ofSize: 24)
                warningText.textColor = UIColor(hex6: 0xd3d3d3)
                warningText.frame = CGRect(x: 20, y: WiFiImageView.frame.height - WiFiImageView.frame.height * 0.6, width: UIScreen.main.bounds.width - 20 * 2, height: 100)
                warningText.textAlignment = .center
                self.view.addSubview(warningText)

                let heightForTextView = heightForView(text: "已经登录啦", fontsize: UIFont.systemFont(ofSize: 24), width: UIScreen.main.bounds.width - 20 * 2, xpos: 20) * 2.4

                // TODO: Auto-fill the accoutnTextField and passwordTextField if there's information in TWTUser.

                accountTextField = UITextField()
                accountTextField.frame = CGRect(x: 20, y: WiFiImageView.frame.height - WiFiImageView.frame.height * 0.6 + heightForTextView, width: UIScreen.main.bounds.width - 20 * 2, height: 30)
                accountTextField.placeholder = "请输入账号"
                accountTextField.keyboardType = .numberPad
                accountTextField.borderStyle = .roundedRect
                passwordTextField = UITextField()
                passwordTextField.frame = CGRect(x: 20, y: WiFiImageView.frame.height * 0.4 + 40 + heightForTextView, width: UIScreen.main.bounds.width - 20 * 2, height: 30)
                passwordTextField.placeholder = "请输入密码"
                passwordTextField.keyboardType = .default
                passwordTextField.borderStyle = .roundedRect
                passwordTextField.isSecureTextEntry = true
                self.view.addSubview(accountTextField)
                self.view.addSubview(passwordTextField)

                if let fooAccount = TwTUser.shared.WLANAccount, let fooPassword = TwTUser.shared.WLANPassword {
                    accountTextField.text = fooAccount
                    passwordTextField.text = fooPassword
                }

                // use loginButton as logoutButton because I don't wanna declare a button once more.
                loginButton = UIButton()
                loginButton.frame = CGRect(x: 20, y: WiFiImageView.frame.height * 0.4 + 40 + 30 + 20 + heightForTextView, width: UIScreen.main.bounds.width - 20 * 2, height: 40)
                loginButton.setTitle("注 销", for: .normal)
                loginButton.setTitleColor(.white, for: .normal)
                loginButton.isUserInteractionEnabled = true
                loginButton.backgroundColor = UIColor(hex6: 0x00a1e9)
                // to make button rounded rect
                loginButton.layer.borderColor = UIColor(hex6: 0x00a1e9).cgColor
                loginButton.layer.borderWidth = 2
                loginButton.layer.cornerRadius = 5
                loginButton.addTarget(self, action: #selector(logout), for: .touchUpInside)
                self.view.addSubview(loginButton)

                serviceButton = UIButton()
                serviceButton.setTitle("自服务", for: .normal)
                serviceButton.isUserInteractionEnabled = true
                serviceButton.backgroundColor = UIColor(hex6: 0xd3d3d3)
                serviceButton.layer.borderColor = UIColor(hex6: 0xd3d3d3).cgColor
                serviceButton.layer.borderWidth = 2
                serviceButton.layer.cornerRadius = 5
                serviceButton.addTarget(self, action: #selector(showService), for: .touchUpInside)
                self.view.addSubview(serviceButton)
                serviceButton.snp.makeConstraints { (make) -> Void in
                    make.left.equalTo(20)
                    make.right.equalTo(-20)
                    make.top.equalTo(loginButton.snp.bottom).offset(10)
                }

//            print("Network error, please check reachability")
//            warningText = UILabel()
//            warningText.text = "网络错误，请检查网络连接"
//            warningText.font = UIFont.systemFont(ofSize: 24)
//            warningText.textColor = UIColor(hex6: 0xd3d3d3)
//            warningText.frame = CGRect(x: 20, y: WiFiImageView.frame.height - WiFiImageView.frame.height * 0.6, width: UIScreen.main.bounds.width - 20 * 2, height: 100)
//            warningText.textAlignment = .center
//            self.view.addSubview(warningText)
        case .wwan:
            print("Device connected to cellular")
            warningText = UILabel()
            warningText.text = "请连接到 tjuwlan 或 tjuwlan-lib"
            warningText.font = UIFont.systemFont(ofSize: 24)
            warningText.textColor = UIColor(hex6: 0xd3d3d3)
            warningText.frame = CGRect(x: 20, y: WiFiImageView.frame.height - WiFiImageView.frame.height * 0.6, width: UIScreen.main.bounds.width - 20 * 2, height: 100)
            warningText.textAlignment = .center
            self.view.addSubview(warningText)
        }
    }
    
    @objc func login() {
        print("tring to login to TJUWLAN")
        
        if accountTextField.hasText && passwordTextField.hasText {

            WLANHelper.login(success: {
                SwiftMessages.showSuccessMessage(body: "登录成功", context: .view(self.view))
            }, failure: { msg in
                SwiftMessages.showErrorMessage(body: msg, context: .view(self.view))
            })

            return
            var loginInfo: [String: Any] = [String: Any]()
            loginInfo["action"] = "login"
            loginInfo["username"] = "\(accountTextField.text!)"
            loginInfo["password"] = "\(passwordTextField.text!)"
            loginInfo["ac_id"] = "25"
            loginInfo["user_ip"] = nil
            loginInfo["nas_ip"] = nil
            loginInfo["save_me"] = "1"
            loginInfo["ajax"] = "1"
            
            // try to configure timeout info, not working and deprecated
            /*
             let configuration = URLSessionConfiguration.default
             configuration.timeoutIntervalForRequest = 5
             let sessionManager = Alamofire.SessionManager(configuration: configuration)
             */
            
            Alamofire.request("http://202.113.5.133/include/auth_action.php", method: .post, parameters: loginInfo).responseString(completionHandler: { (dataResponse) in
                print(dataResponse)
                
                if let responseString = dataResponse.value {
                    if responseString.contains("login_ok") {
                        print("Successfully logged in")
                        self.updateUserInterface()
                    } else if responseString.contains("You are already online.") {
                        print("Already online")
                        let failAlert = UIAlertController(title: "登录失败", message: "已经在线啦", preferredStyle: .alert)
                        let okAction = UIAlertAction(title: "好的", style: .default, handler: { (result) in
                            print("OK.")
                        })
                        failAlert.addAction(okAction)
                        self.present(failAlert, animated: true, completion: nil)
                    } else if responseString.contains("Password is error") {
                        print("Wrong password")
                        let failAlert = UIAlertController(title: "登录失败", message: "密码错误", preferredStyle: .alert)
                        let okAction = UIAlertAction(title: "好的", style: .default, handler: { (result) in
                            print("OK.")
                        })
                        failAlert.addAction(okAction)
                        self.present(failAlert, animated: true, completion: nil)
                    } else if responseString.contains("INFO Error") {
                        print("Error")
                        let failAlert = UIAlertController(title: "登录失败", message: "可能是没有连接到 tjuwlan 噢", preferredStyle: .alert)
                        let okAction = UIAlertAction(title: "好的", style: .default, handler: { (result) in
                            print("OK.")
                        })
                        failAlert.addAction(okAction)
                        self.present(failAlert, animated: true, completion: nil)
                    } else if responseString.contains("User not found") {
                        print("User not found")
                        let failAlert = UIAlertController(title: "登录失败", message: "用户名错误", preferredStyle: .alert)
                        let okAction = UIAlertAction(title: "好的", style: .default, handler: { (result) in
                            print("OK.")
                        })
                        failAlert.addAction(okAction)
                        self.present(failAlert, animated: true, completion: nil)
                    }
                } else {
                    print("Connection error / timeout")
                    let failAlert = UIAlertController(title: "连接超时", message: "请检查网络连接", preferredStyle: .alert)
                    let okAction = UIAlertAction(title: "好的", style: .default, handler: { (result) in
                        print("OK.")
                    })
                    failAlert.addAction(okAction)
                    self.present(failAlert, animated: true, completion: nil)
                }
            })
            
            // SolaSessionManager can't cope with the APIs that response with strings.
            /*
             SolaSessionManager.solaSession(type: .post, baseURL: WLANLoginAPIs.rootURL, url: "", token: nil, parameters: loginInfo as? Dictionary<String, String>, success: { (dictionary) in
             print("Successfully posted.")
             }, failure: { (error) in
             print("Login failed.")
             let failAlert = UIAlertController(title: "登录失败", message: "用户名或密码错误", preferredStyle: .alert)
             let okAction = UIAlertAction(title: "好的", style: .default, handler: { (result) in
             print("OK.")
             })
             failAlert.addAction(okAction)
             self.present(failAlert, animated: true, completion: nil)
             })
             */
        } else {
            let infoNotProvidedAlert = UIAlertController(title: "请填写账号和密码", message: nil, preferredStyle: .alert)
            let okAction = UIAlertAction(title: "好的", style: .default, handler: { (result) in
                print("OK.")
            })
            infoNotProvidedAlert.addAction(okAction)
            self.present(infoNotProvidedAlert, animated: true, completion: nil)
        }
    }
    
    @objc func logout() {
        print("tring to logout from TJUWLAN")
        
        if accountTextField.hasText && passwordTextField.hasText {
            WLANHelper.logout(success: {
                SwiftMessages.showSuccessMessage(body: "注销成功", context: .view(self.view))
            }, failure: { msg in
                SwiftMessages.showErrorMessage(body: msg, context: .view(self.view))
            })

            return
            var logoutInfo: [String: Any] = [String: Any]()
            logoutInfo["action"] = "logout"
            logoutInfo["username"] = "\(accountTextField.text!)"
            logoutInfo["password"] = "\(passwordTextField.text!)"
            logoutInfo["ajax"] = "1"
            
            Alamofire.request("http://202.113.5.133/include/auth_action.php", method: .post, parameters: logoutInfo).responseString(completionHandler: { (dataResponse) in
                print(dataResponse)
                
                if let responseString = dataResponse.value {
                    if responseString.contains("ç½ç»å·²æ­å¼") {
                        self.updateUserInterface()
                    } else if responseString.contains("æ¨ä¼¼ä¹æªæ¾è¿æ¥å°ç½ç»") {
                        print("Unknown error")
                        let failAlert = UIAlertController(title: "未知错误", message: "请检查网络连接或账号密码拼写", preferredStyle: .alert)
                        let okAction = UIAlertAction(title: "好的", style: .default, handler: { (result) in
                            print("OK.")
                        })
                        failAlert.addAction(okAction)
                        self.present(failAlert, animated: true, completion: nil)
                    }
                }
            })
        } else {
            let infoNotProvidedAlert = UIAlertController(title: "请填写账号和密码", message: nil, preferredStyle: .alert)
            let okAction = UIAlertAction(title: "好的", style: .default, handler: { (result) in
                print("OK.")
            })
            infoNotProvidedAlert.addAction(okAction)
            self.present(infoNotProvidedAlert, animated: true, completion: nil)
        }
    }
    
    @objc func showService() {
        if let url = URL(string: "http://g.tju.edu.cn") {
            let vc = SFSafariViewController(url: url)
            present(vc, animated: true)
        }
    }
    
    func heightForView(text: String, fontsize: UIFont, width: CGFloat, xpos: CGFloat) -> CGFloat {
        let label:UILabel = UILabel(frame: CGRect(x: xpos, y: 0, width: width, height: CGFloat.greatestFiniteMagnitude))
        label.numberOfLines = 0
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.font = fontsize
        label.text = text
        
        label.sizeToFit()
        return label.frame.height
    }
}
