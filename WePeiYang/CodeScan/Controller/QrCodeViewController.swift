//
//  QRCodeAsPrivate.swift
//  WePeiYang
//
//  Created by 安宇 on 02/08/2019.
//  Copyright © 2019 twtstudio. All rights reserved.
//

import UIKit
import SnapKit

class QrCodeViewController: UIViewController {
    
    let myCode = QrCodeView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //导航栏
        view.backgroundColor = MyColor.ColorHex("#EFEFF4")
        navigationItem.title = "设置"

        navigationController?.navigationBar.tintColor = MyColor.ColorHex("#54B9F1")
        //        MARK:导航栏颜色
        
        navigationController?.navigationBar.barTintColor = .white
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black]
        navigationController?.setNavigationBarHidden(false, animated: true)
        let leftButton = UIBarButtonItem(title: "", style: .plain, target: self, action: #selector(pop))
        let image = UIImage(named:"1")!
        leftButton.image = UIImage.resizedImage(image: image, scaledToSize: CGSize(width: 10, height: 20))
        navigationItem.leftBarButtonItem = leftButton
        addImage()
        
    }
    func addImage() {
        self.view.addSubview(myCode)
        
        myCode.layer.cornerRadius = 12
        myCode.layer.masksToBounds = true
        
        myCode.layer.shadowOpacity = 0.3
        myCode.layer.shadowColor = UIColor.gray.cgColor
        myCode.layer.shadowRadius = 3
        myCode.layer.shadowOffset = CGSize(width: 0,height: 0.5)
        myCode.layer.masksToBounds = false
        
        myCode.image.image = UIImage(named: "test1")
        myCode.image.layer.cornerRadius = 12
        myCode.image.layer.masksToBounds = true
        
        myCode.name.text = "名字"
        myCode.name.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        
        myCode.id.text = "3018000000"
        myCode.id.font = UIFont.systemFont(ofSize: 15, weight: .light)
        myCode.codeImage.image = createQRForString(qrString: "Test", imageName: "test2")
        myCode.snp.makeConstraints { (make) in
            make.centerX.equalTo(UIScreen.main.bounds.width / 2)
            make.centerY.equalTo(UIScreen.main.bounds.height / 2 + 10)
            make.left.equalTo(45)
            make.height.equalTo(450)
        }
        myCode.codeImage.snp.makeConstraints { (make) in
            make.left.equalTo(self.myCode.snp.left).offset(30)
            make.centerX.equalTo(self.myCode.snp.centerX)
            make.top.equalTo(self.myCode.image.snp.bottom).offset(30)
            make.height.equalTo(self.myCode.codeImage.snp.width)
        }
        
    }
    @objc func pop() {
        navigationController?.popViewController(animated: true)
    }
    func createQRForString(qrString: String?, imageName: String?) -> UIImage? {
            if let detail = qrString {
                let detailData = detail.data(using: .utf8, allowLossyConversion: false)
                //创建一个二维码的滤镜？？？滤镜？？？
                let filter = CIFilter(name: "CIQRCodeGenerator")
                filter?.setValue(detailData, forKey: "inputMessage")
                filter?.setValue("H", forKey: "inputCorrectionLevel")
                let rCIImage = filter?.outputImage
    //            sureImage = self.convertUIImageToCIImage(uiImage: detail)
                //创建一个颜色滤镜，黑白色
                let colorFilter = CIFilter(name: "CIFalseColor")
                colorFilter?.setDefaults()
                
                colorFilter?.setValue(rCIImage, forKey: "inputImage")
                colorFilter?.setValue(CIColor(red: 0, green: 0, blue: 0), forKey: "inputColor0")
                colorFilter?.setValue(CIColor(red: 1, green: 1, blue: 1), forKey: "inputColor1")
                //返回二维码image
                let codeImage = UIImage(ciImage: ((colorFilter?.outputImage!.transformed(by: CGAffineTransform(scaleX: 5, y: 5)))!))
                //通常，二维码中间会放置想要表达意思的图片
                if let iconImage = UIImage(named: imageName!) {
                    let rect = CGRect(x:0, y:0, width:codeImage.size.width, height:codeImage.size.height)
                    UIGraphicsBeginImageContext(rect.size)
                    codeImage.draw(in: rect)
                    let avatarSize = CGSize(width:rect.size.width * 0.25, height:rect.size.height * 0.25)
                    let x = (rect.width - avatarSize.width) * 0.5
                    let y = (rect.height - avatarSize.height) * 0.5
                    iconImage.draw(in: CGRect(x:x, y:y, width:avatarSize.width, height:avatarSize.height))
                    let resultImage = UIGraphicsGetImageFromCurrentImageContext()
                    UIGraphicsEndImageContext()
                    return resultImage!
                }
                return codeImage
            }
            return nil
        }
}
