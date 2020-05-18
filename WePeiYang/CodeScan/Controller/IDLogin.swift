//
//  IDLogin.swift
//  WePeiYang
//
//  Created by 安宇 on 03/08/2019.
//  Copyright © 2019 twtstudio. All rights reserved.
//

import UIKit
import SnapKit

class IdLoginViewController: UIViewController {
    
    private let idTextField = UITextField()
    private let loginButton = UIButton()
    private let changeButton = UIButton()
    private let button = UIButton(type: .custom)
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        navigationItem.title = "学号录入"
        navigationController?.navigationBar.setBackgroundImage(nil, for: .default)
        
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
        navigationController?.navigationBar.tintColor = .white
        
        navigationController?.navigationBar.barTintColor = MyColor.ColorHex("#54B9F1")
        navigationController?.setNavigationBarHidden(false, animated: true)
        //        FIXME:左面按钮的背景图片要改
        let leftButton = UIBarButtonItem(title: "", style: .plain, target: self, action: #selector(pop))
        let image = UIImage(named:"3")!
        leftButton.image = UIImage.resizedImage(image: image, scaledToSize: CGSize(width: 10, height: 20))
        navigationItem.leftBarButtonItem = leftButton
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        navigationItem.title = "学号录入"
        navigationController?.navigationBar.setBackgroundImage(nil, for: .default)
        
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
        navigationController?.navigationBar.tintColor = .white
        
        navigationController?.navigationBar.barTintColor = MyColor.ColorHex("#54B9F1")
        navigationController?.setNavigationBarHidden(false, animated: true)
        //        FIXME:左面按钮的背景图片要改
        let leftButton = UIBarButtonItem(title: "", style: .plain, target: self, action: #selector(pop))
        let image = UIImage(named:"3")!
        leftButton.image = UIImage.resizedImage(image: image, scaledToSize: CGSize(width: 10, height: 20))
        navigationItem.leftBarButtonItem = leftButton
//        弹出框
        
        
        
        view.addSubview(loginButton)
        loginButton.snp.makeConstraints { (make) in
            make.centerY.equalTo(UIScreen.main.bounds.height / 2 + 40)
            make.centerX.equalTo(UIScreen.main.bounds.width / 2)
            make.width.equalTo(100)
            make.height.equalTo(30)
        }
        loginButton.backgroundColor = .white
        loginButton.setTitle("录入", for: .normal)
        loginButton.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .light)
        loginButton.setTitleColor(.black, for: .normal)
        loginButton.titleLabel?.textAlignment = .center
        //设置圆角
        loginButton.layer.masksToBounds = true
        loginButton.layer.cornerRadius = 15
        loginButton.addTarget(self, action: #selector(makeSure), for: .touchUpInside)
        //设置阴影
        loginButton.layer.shadowOpacity = 0.3
        loginButton.layer.shadowColor = UIColor.gray.cgColor
        loginButton.layer.shadowRadius = 3
        loginButton.layer.shadowOffset = CGSize(width: 0,height: 0.5)
        loginButton.layer.masksToBounds = false
        
        view.addSubview(changeButton)
        changeButton.snp.makeConstraints { (make) in
            make.top.equalTo(self.loginButton.snp.bottom).offset(20)
            make.centerX.equalTo(UIScreen.main.bounds.width / 2)
            make.width.equalTo(100)
            make.height.equalTo(30)
        }
        changeButton.backgroundColor = .white
        changeButton.setTitle("扫码录入", for: .normal)
        changeButton.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .light)
        changeButton.setTitleColor(.black, for: .normal)
        changeButton.titleLabel?.textAlignment = .center
        //设置圆角
        changeButton.layer.masksToBounds = true
        changeButton.layer.cornerRadius = 15
        changeButton.addTarget(self, action: #selector(change), for: .touchUpInside)
        //设置阴影
        changeButton.layer.shadowOpacity = 0.3
        changeButton.layer.shadowColor = UIColor.gray.cgColor
        changeButton.layer.shadowRadius = 3
        changeButton.layer.shadowOffset = CGSize(width: 0,height: 0.5)
        changeButton.layer.masksToBounds = false
        
        view.addSubview(idTextField)
        idTextField.becomeFirstResponder()
        idTextField.keyboardType = .numberPad
        idTextField.snp.makeConstraints { (make) in
            make.top.equalTo(self.loginButton.snp.top).offset(-100)
            make.centerX.equalTo(UIScreen.main.bounds.width / 2)
            make.left.equalTo(30)
            make.width.equalTo(UIScreen.main.bounds.width - 2 * 30)
        }
        idTextField.layer.masksToBounds = true
//        idTextField.layer.cornerRadius = 30
        //placeholder的字体还有大小能不能改
        idTextField.leftView = UIView.init(frame: CGRect(x: 0, y: 0, width: 8, height: 0))
        idTextField.leftViewMode = .always

//        idTextField.
    
        idTextField.placeholder = "输入学号"
        //设置阴影
        idTextField.borderStyle = .roundedRect
        idTextField.layer.shadowOpacity = 0.3
        idTextField.layer.shadowColor = UIColor.gray.cgColor
        idTextField.layer.shadowRadius = 3
        idTextField.layer.shadowOffset = CGSize(width: 0,height: 0.5)
        idTextField.layer.masksToBounds = false
//
        
        
        
    }
    @objc func pop() {
        navigationController?.popViewController(animated: true)
    }
    @objc func change() {
        navigationController?.pushViewController(SaoMiaoViewController(), animated: true)
    }
    @objc func makeSure() {
        //        MARK:这个东西textfield是不是空
        print("1")
        let text = self.idTextField.text! as NSString
//        let temp = [text, stringByTrimmingCharactersInSet:[NSCharacterSetwhitespaceCharacterSet]]
        if text.length != 0 && textField(textField: self.idTextField, replacementString: self.idTextField.text!){
            //button的有关信息改变
            loginButton.backgroundColor = MyColor.ColorHex("#54B9F1")
            loginButton.titleLabel?.textColor = .white
            //设置alertviewcontroller
            let alertController = UIAlertController(title: "\n\n\n\n\n\n\n", message: nil, preferredStyle: .alert)

            let backgroundImage = AlertView()
//            FIXME:改
//            backgroundImage.id.text = "学号获取后再改"
//            backgroundImage.name.text = "姓名"
            backgroundImage.id.text = self.idTextField.text!
            backgroundImage.name.text = "姓名"
            let okButton = UIButton()
            let cancelButton = UIButton()
            alertController.view.addSubview(okButton)
            alertController.view.addSubview(cancelButton)
            alertController.view.addSubview(backgroundImage)
//            覆盖掉，避免子视图上的button被遮盖不被触发
            okButton.snp.makeConstraints { (make) in
                make.edges.equalTo(backgroundImage.okButton)
            }
            cancelButton.snp.makeConstraints { (make) in
                make.edges.equalTo(backgroundImage.cancelButton)
            }
            okButton.addTarget(self, action: #selector(nextStep), for: .touchUpInside)
            cancelButton.addTarget(self, action: #selector(cancel), for: .touchUpInside)

            self.present(alertController, animated: true, completion: nil)
        }
    }
    @objc func nextStep() {
//        这个要判断是不是学号吧
        loginButton.backgroundColor = .white
        loginButton.titleLabel?.textColor = .black
        self.dismiss(animated: true, completion: nil)
        print("下一步操作")
    }
    @objc func cancel() {
        loginButton.backgroundColor = .white
        loginButton.titleLabel?.textColor = .black
        self.dismiss(animated: true, completion: nil)
    }
    func textField(textField: UITextField, replacementString string: String) -> Bool {
        //限制只能输入数字，不能输入特殊字符
        let length = string.lengthOfBytes(using: String.Encoding.utf8)
        for loopIndex in 0..<length {
            let char = (string as NSString).character(at: loopIndex)
            if char < 48 { return false }
            if char > 57 { return false }
        }
        //限制长度
        //    let proposeLength = (textField.text?.lengthOfBytesUsingEncoding(NSUTF8StringEncoding))! - range.length + string.lengthOfBytesUsingEncoding(NSUTF8StringEncoding)
        //    if proposeLength > 11 { return false }
        return true
    }
}


