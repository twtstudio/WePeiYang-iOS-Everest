//
//  BicycleBindingViewController.swift
//  WePeiYang
//
//  Created by Tigris on 30/11/2017.
//  Copyright © 2017 twtstudio. All rights reserved.
//

import UIKit

class BicycleBindingViewController: UIViewController {
    
    var IDCardNumberTextField: UITextField!
    var passwordTextField: UITextField!
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
        logoImage = UIImage(named: "bicycleBinding")
        let imageRatio: CGFloat = logoImage.size.width / logoImage.size.height
        let imageViewWidth: CGFloat = UIScreen.main.bounds.width * 0.5
        logoImageView = UIImageView.init(image: logoImage)
        logoImageView.frame = CGRect(center: CGPoint(x: self.view.center.x, y: self.view.frame.size.height*1.0/5.0), size: CGSize(width: imageViewWidth, height: imageViewWidth / imageRatio))
        self.view.addSubview(logoImageView)
        title = "绑定自行车账号"

        let textFieldWidth: CGFloat = 250
        IDCardNumberTextField = UITextField()
        IDCardNumberTextField.frame = CGRect(center: CGPoint(x: self.view.center.x, y: self.view.frame.size.height*2.0/5.0), size: CGSize(width: textFieldWidth, height: 40))
        IDCardNumberTextField.placeholder = "请输入身份证号"
        IDCardNumberTextField.keyboardType = .numberPad
        IDCardNumberTextField.borderStyle = .roundedRect
        IDCardNumberTextField.clearButtonMode = .always
        IDCardNumberTextField.autocapitalizationType = .none
        self.view.addSubview(IDCardNumberTextField)
        
        /*
        passwordTextField = UITextField()
        passwordTextField.frame = CGRect(center: CGPoint(x: self.view.center.x, y: IDCardNumberTextField.frame.origin.y + IDCardNumberTextField.frame.size.height + 30), size: CGSize(width: textFieldWidth, height: 40))
        passwordTextField.placeholder = "请输入密码"
        passwordTextField.keyboardType = .default
        passwordTextField.borderStyle = .roundedRect
        passwordTextField.isSecureTextEntry = true
        passwordTextField.clearButtonMode = .always
        self.view.addSubview(passwordTextField)
        */
        
        bindButton = UIButton()
        bindButton.frame = CGRect(x: (self.view.frame.size.width-textFieldWidth)/2, y: IDCardNumberTextField.frame.origin.y + IDCardNumberTextField.frame.height + 20, width: textFieldWidth, height: 38)
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
        
        dismissButton = UIButton(frame: CGRect(x: self.view.frame.width, y: bindButton.y + bindButton.height + 20, width: 30, height: 20))
        dismissButton.titleLabel?.font = UIFont.systemFont(ofSize: 13)
        dismissButton.setTitleColor(UIColor.gray, for: .normal)
        dismissButton.setTitle("暂不绑定", for: .normal)
        dismissButton.sizeToFit()
        dismissButton.center = CGPoint(x: self.view.center.x, y: bindButton.y + bindButton.height + 20)
        dismissButton.addTarget(self, action: #selector(dismissBinding), for: .touchUpInside)
        self.view.addSubview(dismissButton)
        
        self.view.backgroundColor = .white
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func bind() {
        
    }
    
    @objc func dismissBinding() {
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
