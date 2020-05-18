//
//  SaoMiaoViewController.swift
//  WePeiYang
//
//  Created by 安宇 on 22/08/2019.
//  Copyright © 2019 twtstudio. All rights reserved.
//

import UIKit

import AVFoundation

//import WebKit

class SaoMiaoViewController: UIViewController,AVCaptureMetadataOutputObjectsDelegate {
    
    var session:AVCaptureSession!
    var screenWidth : CGFloat!
    var screenHeight:CGFloat!
    //    var ScanView = UIView()
    var switchButton = UIButton()
    var prefixLabel = UILabel()
    let leftView = UIView()
    let rightView = UIView()
    let bottomView = UIView()
    let topView = UIView()
    let scanLine = UIImageView(frame: CGRect(x: UIScreen.main.bounds.width / 2 - 130, y: 200, width: 260, height: 5))
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(false)
//        避免pop时导航栏背景图片不为空
        navigationController?.navigationBar.setBackgroundImage(UIImage.init(), for: .default)
         navigationController?.navigationBar.shadowImage = UIImage.init()
        setView()
//
        setCamera()
        scanAction()
    }
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        view.backgroundColor = .white
        navigationItem.title = "扫码录入"
        navigationController?.navigationBar.tintColor = .white
//        navigationController?.navigationBar.setBackgroundImage(UIImage.init(), for: .default)
//        navigationController?.navigationBar.setsh

        //        MARK:导航栏颜色
//        navigationController?.navigationBar.barTintColor = MyColor.ColorHex("#54B9F1")
        navigationController?.setNavigationBarHidden(false, animated: true)
        
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
        navigationController?.navigationBar.isTranslucent = true
        
        let leftButton = UIBarButtonItem(title: "", style: .plain, target: self, action: #selector(pop))
        let image = UIImage(named:"3")!
        leftButton.image = UIImage.resizedImage(image: image, scaledToSize: CGSize(width: 10, height: 20))
        navigationItem.leftBarButtonItem = leftButton
        
        view.backgroundColor = .white
        view.addSubview(scanLine)
        scanLine.frame = CGRect(x: UIScreen.main.bounds.width / 2 - 130, y: 200, width: 260, height: 30)

        scanLine.image = UIImage(named: "5")
        screenWidth = self.view.bounds.width
        screenHeight = self.view.bounds.height
//        setView()
//
//        setCamera()
//        scanAction()
        let path = UIBezierPath.init()
        let p0 = CGPoint(x: screenWidth / 2 - 130, y: 200)
        let p1 = CGPoint(x: screenWidth / 2 - 130, y: 240)
        let p2 = CGPoint(x: screenWidth / 2 - 90, y: 200)
        
        let p3 = CGPoint(x: screenWidth / 2 + 130, y: 200)
        let p4 = CGPoint(x: screenWidth / 2 + 130, y: 240)
        let p5 = CGPoint(x: screenWidth / 2 + 90, y: 200)
        
        let p6 = CGPoint(x: screenWidth / 2 - 130, y: 460)
        let p7 = CGPoint(x: screenWidth / 2 - 90, y: 460)
        let p8 = CGPoint(x: screenWidth / 2 - 130, y: 420)
        
        let p9 = CGPoint(x: screenWidth / 2 + 130, y: 460)
        let p10 = CGPoint(x: screenWidth / 2 + 90, y: 460)
        let p11 = CGPoint(x: screenWidth / 2 + 130, y: 420)
        
        path.move(to: p1)
        path.addLine(to: p0)
        path.addLine(to: p2)
        
        path.move(to: p4)
        path.addLine(to: p3)
        path.addLine(to: p5)
        
        path.move(to: p7)
        path.addLine(to: p6)
        path.addLine(to: p8)
        
        path.move(to: p10)
        path.addLine(to: p9)
        path.addLine(to: p11)
        
        let lineLayer = CAShapeLayer.init()
        lineLayer.lineWidth = 3
        lineLayer.strokeColor = MyColor.ColorHex("#4A7C97")?.cgColor
        lineLayer.path = path.cgPath
        lineLayer.fillColor = UIColor.clear.cgColor
        self.view.layer.addSublayer(lineLayer)
        
    }
    @objc func pop() {
        navigationController?.navigationBar.setBackgroundImage(nil, for: .default)
        navigationController?.popViewController(animated: true)
    }
    //设置除了扫描区以外的视图
    
    func setView(){
        
       
        self.view.addSubview(leftView)
        leftView.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.6)
        leftView.snp.makeConstraints { (make) in
            make.top.equalTo(0)
            make.left.equalTo(0)
            make.height.equalTo(screenHeight)
            make.width.equalTo(screenWidth / 2 - 130)
        }
//        let leftView = UIView(frame: CGRect(x: 0, y: 0, width: screenWidth/2-100, height: screenHeight))
        
        self.view.addSubview(rightView)
//        let rightView = UIView(frame: CGRect(x: screenWidth/2+100, y: 0, width: screenWidth-(screenWidth/2+100), height: screenHeight))
        rightView.snp.makeConstraints { (make) in
            make.top.equalTo(0)
            make.left.equalTo(screenWidth / 2 + 130)
            make.height.equalTo(screenHeight)
            make.width.equalTo(self.leftView.snp.width)
        }
        rightView.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.6)
        
        
        
        self.view.addSubview(topView)
        topView.snp.makeConstraints { (make) in
            make.top.equalTo(0)
            make.left.equalTo(self.leftView.snp.right)
            make.right.equalTo(self.rightView.snp.left)
            make.height.equalTo(200)

        }
        topView.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.6)
//        let topView = UIView(frame: CGRect(x: screenWidth/2-100, y: 0, width: 200, height: 200))
        self.view.addSubview(bottomView)
        bottomView.snp.makeConstraints { (make) in
            make.left.equalTo(self.leftView.snp.right)
            make.right.equalTo(self.rightView.snp.left)
            make.top.equalTo(self.topView.snp.bottom).offset(260)
            make.height.equalTo(screenHeight - 460)
        }
        bottomView.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.6)
        
        bottomView.addSubview(prefixLabel)
        prefixLabel.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(20)
            make.height.equalTo(20)
            make.left.equalToSuperview().offset(10)
            make.right.equalToSuperview().offset(-10)
        }
        prefixLabel.text = "将二维码放入框内，即可自动扫码"
        prefixLabel.backgroundColor = .clear
        prefixLabel.textColor = .white
        prefixLabel.textAlignment = .center
        prefixLabel.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        
        bottomView.addSubview(switchButton)
        switchButton.snp.makeConstraints { (make) in
            make.right.equalToSuperview().offset(-30)
            make.top.equalToSuperview().offset(130)
            make.left.equalToSuperview().offset(30)
            make.height.equalTo(20)
        }
        switchButton.setTitle("学号录入", for: .normal)
        switchButton.backgroundColor = .clear
//        switchButton.set
        switchButton.setTitleColor(MyColor.ColorHex("#54B9F1"), for: .normal)
        switchButton.addTarget(self, action: #selector(switchPage), for: .touchUpInside)
        
        
        
    }
    func scanAction() {
        let anim = scanLine.layer.animation(forKey: "translationAnimation")
        if (anim != nil) {
            //将动画的时间偏移量作为暂停时的时间点
            let pauseTime = scanLine.layer.timeOffset
            let beginTime = CACurrentMediaTime() - pauseTime
            ///便宜时间清零
            scanLine.layer.timeOffset = 0.0
            //设置动画开始时间
            scanLine.layer.beginTime = beginTime
            scanLine.layer.speed = 1.1
        } else {
            
            let scanViewH = 230

            let scanAnim = CABasicAnimation()
            scanAnim.keyPath = "transform.translation.y"
            scanAnim.byValue = [scanViewH]
            scanAnim.duration = 3
            scanAnim.repeatCount = MAXFLOAT
            scanLine.layer.add(scanAnim, forKey: "translationAnimation")
            
        }
    }
    @objc func switchPage() {
        navigationController?.pushViewController(IdLoginViewController(), animated: true)
    }
    
    
    func setCamera(){
        //获取摄像设备
        guard let device = AVCaptureDevice.default(for: AVMediaType.video) else {
            return
        }
        do {
            //创建输入流
            let input =  try AVCaptureDeviceInput(device: device)
            //创建输出流
            let output = AVCaptureMetadataOutput()
            //设置会话
            session = AVCaptureSession()
            //连接输入输出
            if session.canAddInput(input){
                session.addInput(input)
            }
            if session.canAddOutput(output){
                session.addOutput(output)
            //设置输出流代理，从接收端收到的所有元数据都会被传送到delegate方法，所有delegate方法均在queue中执行
                output.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
                //设置扫描二维码类型
                output.metadataObjectTypes = [ AVMetadataObject.ObjectType.qr]
                //扫描区域
                //rectOfInterest 属性中x和y互换，width和height互换。
                output.rectOfInterest = CGRect(x: 100/screenHeight, y: (screenWidth/2-100)/screenWidth, width: 2300/screenHeight, height: 2300/screenWidth)
                
            }
            //捕捉图层
            let previewLayer = AVCaptureVideoPreviewLayer(session: session)
            previewLayer.videoGravity = .resizeAspectFill
            previewLayer.frame = self.view.layer.bounds
            self.view.layer.insertSublayer(previewLayer, at: 0)
            //持续对焦
            if device.isFocusModeSupported(.continuousAutoFocus){
                try  input.device.lockForConfiguration()
                input.device.focusMode = .continuousAutoFocus
                input.device.unlockForConfiguration()
            }
            session.startRunning()
        } catch  {
            
        }
    }
    @objc func nextStep() {
        //        这个要判断是不是学号吧
        self.dismiss(animated: true, completion: nil)
//        self.login
        print("下一步操作")
    }
    @objc func cancel() {
        self.dismiss(animated: true, completion: nil)
    }
    //扫描完成的代理
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        
        session?.stopRunning()
        if let metadataObject = metadataObjects.first {
            let readableObject = metadataObject as! AVMetadataMachineReadableCodeObject
            let str = readableObject.stringValue!
            //            let url = URL(string: str)
            //
            //            //用网页打开扫描的信息
            //
            //            if #available(iOS 10, *){
            //
            //                UIApplication.shared.open(url!, options: [:], completionHandler: nil)
            //
            //            }else{
            //
            //                UIApplication.shared.openURL(url!)
            //
            //            }
            let alertController = UIAlertController(title: "\n\n\n\n\n\n\n", message: nil, preferredStyle: .alert)
            
            let backgroundImage = AlertView()
            //            FIXME:改
            //            backgroundImage.id.text = "学号获取后再改"
            //            backgroundImage.name.text = "姓名"
            backgroundImage.id.text = "二维码返回的学号"
            backgroundImage.name.text = "名字"
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
    
}



