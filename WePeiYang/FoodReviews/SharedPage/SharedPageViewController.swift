////
////  ViewController.swift
////  MySharePage
////
////  Created by 曹茳 on 2018/4/15.
////  Copyright © 2018年 TWT Studio. All rights reserved.
////
//
//import UIKit
//
//class SharedPageViewController: UIViewController {
//
//    var foodImage: UIImageView! // 食物图片
//    var qrCode: UIImageView! // 二维码
//
//    override func viewDidLoad() {
//
//        let xw = view.frame.size.width
//        let yh = view.frame.size.height
//
//        // print(xw) // iPhone X -> 375
//        // print(yh) // iPhone X -> 812
//
//        super.viewDidLoad()
//        // Do any additional setup after loading the view, typically from a nib.
//
//        // 设置状态栏颜色
//        UIApplication.shared.statusBarStyle = .lightContent // 白色
//
//        // 设置背景颜色
//        let topColor = UIColor(displayP3Red: 252/255, green: 117/255, blue: 29/255, alpha: 1) // 橙黄
//        let buttomColor = UIColor(displayP3Red: 234/255, green: 85/255, blue: 46/255, alpha: 1) // 橙红
//        let grandientColors = [topColor.cgColor, buttomColor.cgColor]
//
//        let grandientLocations: [NSNumber] = [0.0, 1.0]
//
//        let grandientLayer = CAGradientLayer() // 渐变一下
//        grandientLayer.colors = grandientColors
//        grandientLayer.locations = grandientLocations
//
//        grandientLayer.frame = self.view.frame
//        self.view.layer.insertSublayer(grandientLayer, at: 0)
//
//        // 标题
//        // let headName = UILabel(frame: CGRect(x: 0, y: yh/24, width: xw, height: 60))
//        let headName = UILabel(frame: CGRect(x: 0, y: yh/24, width: xw, height: yh*3/40))
//        headName.text = "竹园餐厅-水煮鱼"
//        headName.textColor = UIColor.white
//        // headName.font = UIFont.boldSystemFont(ofSize: 24)
//        headName.font = UIFont.boldSystemFont(ofSize: yh*3/100)
//        headName.textAlignment = NSTextAlignment.center
//        self.view.addSubview(headName)
//
//        // 上面的白底
//        let topBackground = UIView(frame: CGRect(x: xw/32, y: yh/8, width: xw*15/16, height: yh/2))
//        topBackground.backgroundColor = UIColor.white
//        topBackground.layer.cornerRadius = topBackground.frame.width/24
//        topBackground.layer.shadowColor = UIColor.darkGray.cgColor
//        topBackground.layer.shadowOpacity = 1
//        topBackground.layer.shadowOffset = CGSize(width: 0, height: 0)
//        self.view.addSubview(topBackground)
//
//        // 食物图片
//        foodImage = UIImageView(image: #imageLiteral(resourceName: "水煮鱼.jpg"))
//        foodImage.frame = CGRect(x: xw/32, y: yh/8, width: xw*15/16, height: yh*3/10)
//        // 设置独立圆角(不可用)
//        /*
//         foodImage.addCorner(roundingCorners: UIRectCorner.topLeft, cornerSize: CGSize(width: foodImage.frame.width/24, height: foodImage.frame.width/24))
//         foodImage.addCorner(roundingCorners: UIRectCorner.topRight, cornerSize: CGSize(width: foodImage.frame.width/24, height: foodImage.frame.width/24))
//         */
//        // 设置独立圆角(可用)
//        foodImage.corner(byRoundingCorners: [UIRectCorner.topLeft, UIRectCorner.topRight], radii: foodImage.frame.width/24)
//        self.view.addSubview(foodImage)
//
//        // 食物名称
//        // let foodName = UILabel(frame: CGRect(x: xw/12, y: yh*21/50+10, width: xw/4, height: 40))
//        let foodName = UILabel(frame: CGRect(x: xw/12, y: yh*11/25, width: xw/4, height: yh/20))
//        foodName.text = "水煮鱼"
//        foodName.textColor = UIColor.darkGray
//        // foodName.font = UIFont.boldSystemFont(ofSize: 24)
//        foodName.font = UIFont.boldSystemFont(ofSize: yh*3/100)
//        foodName.textAlignment = NSTextAlignment.left
//        self.view.addSubview(foodName)
//
//        // 食物铭牌
//        let foodPlate = UILabel(frame: CGRect(x: xw/3, y: yh*11/25+yh/160, width: xw/5, height: yh*3/80))
//        foodPlate.text = "服务好"
//        foodPlate.textColor = UIColor.init(displayP3Red: 243/255, green: 101/255, blue: 38/255, alpha: 1)
//        foodPlate.layer.cornerRadius = foodPlate.frame.width/10
//        foodPlate.layer.borderColor = UIColor.init(displayP3Red: 243/255, green: 101/255, blue: 38/255, alpha: 1).cgColor
//        foodPlate.layer.borderWidth = 1
//        // foodPlate.font = UIFont.boldSystemFont(ofSize: 16)
//        foodPlate.font = UIFont.boldSystemFont(ofSize: yh*1/50)
//        foodPlate.textAlignment = NSTextAlignment.center
//        self.view.addSubview(foodPlate)
//
//        // 食物所在食堂
//        // let foodLocation = UILabel(frame: CGRect(x: xw/12, y: yh*21/50+50, width: xw*7/12, height: 30))
//        let foodLocation = UILabel(frame: CGRect(x: xw/12, y: yh*11/25+yh/20, width: xw*7/12, height: yh*3/80))
//        foodLocation.text = "竹园餐厅(学四)二层①窗口"
//        foodLocation.textColor = UIColor.gray
//        // foodLocation.font = UIFont.boldSystemFont(ofSize: 16)
//        foodLocation.font = UIFont.boldSystemFont(ofSize: yh*1/50)
//        foodLocation.textAlignment = NSTextAlignment.left
//        self.view.addSubview(foodLocation)
//
//        // 食物评分
//        // let foodScore = UILabel(frame: CGRect(x: xw/12, y: yh*21/50+80, width: xw*7/12, height: 30))
//        let foodScore = UILabel(frame: CGRect(x: xw/12, y: yh*11/25+yh/20+yh*3/80, width: xw*7/12, height: yh*3/80))
//        foodScore.text = "综合评分:            "
//        foodScore.textColor = UIColor.gray
//        // foodScore.font = UIFont.boldSystemFont(ofSize: 16)
//        foodScore.font = UIFont.boldSystemFont(ofSize: yh*1/50)
//        foodScore.textAlignment = NSTextAlignment.left
//        self.view.addSubview(foodScore)
//
//        // let favorite1 = UIButton(frame: CGRect(x: xw/3, y: yh*11/25+yh/20+yh*3/80, width: yh*3/80, height: yh*3/80))
//        let favorite1 = UIButton(frame: CGRect(x: xw*3/10, y: yh*11/25+yh/20+yh*3/80+yh*1/160, width: yh*1/40, height: yh*1/40))
//        favorite1.setImage(#imageLiteral(resourceName: "icon_心_n.png"), for: .normal)
//        favorite1.setImage(#imageLiteral(resourceName: "icon_心_s.png"), for: .highlighted)
//        self.view.addSubview(favorite1)
//
//        let favorite2 = UIButton(frame: CGRect(x: xw*3/10+yh*3/100, y: yh*11/25+yh/20+yh*3/80+yh*1/160, width: yh*1/40, height: yh*1/40))
//        favorite2.setImage(#imageLiteral(resourceName: "icon_心_n.png"), for: .normal)
//        favorite2.setImage(#imageLiteral(resourceName: "icon_心_s.png"), for: .highlighted)
//        self.view.addSubview(favorite2)
//
//        let favorite3 = UIButton(frame: CGRect(x: xw*3/10+yh*2*3/100, y: yh*11/25+yh/20+yh*3/80+yh*1/160, width: yh*1/40, height: yh*1/40))
//        favorite3.setImage(#imageLiteral(resourceName: "icon_心_n.png"), for: .normal)
//        favorite3.setImage(#imageLiteral(resourceName: "icon_心_s.png"), for: .highlighted)
//        self.view.addSubview(favorite3)
//
//        let favorite4 = UIButton(frame: CGRect(x: xw*3/10+yh*3*3/100, y: yh*11/25+yh/20+yh*3/80+yh*1/160, width: yh*1/40, height: yh*1/40))
//        favorite4.setImage(#imageLiteral(resourceName: "icon_心_n.png"), for: .normal)
//        favorite4.setImage(#imageLiteral(resourceName: "icon_心_s.png"), for: .highlighted)
//        self.view.addSubview(favorite4)
//
//        let favorite5 = UIButton(frame: CGRect(x: xw*3/10+yh*4*3/100, y: yh*11/25+yh/20+yh*3/80+yh*1/160, width: yh*1/40, height: yh*1/40))
//        favorite5.setImage(#imageLiteral(resourceName: "icon_心_n.png"), for: .normal)
//        favorite5.setImage(#imageLiteral(resourceName: "icon_心_s.png"), for: .highlighted)
//        self.view.addSubview(favorite5)
//
//        // 食物供应时间
//        // let foodTime = UILabel(frame: CGRect(x: xw/12, y: yh*21/50+110, width: xw*7/12, height: 30))
//        let foodTime = UILabel(frame: CGRect(x: xw/12, y: yh*11/25+yh/20+yh*6/80, width: xw*7/12, height: yh*3/80))
//        foodTime.text = "供应时间: 12:00-20:00"
//        foodTime.textColor = UIColor.gray
//        // foodTime.font = UIFont.boldSystemFont(ofSize: 16)
//        foodTime.font = UIFont.boldSystemFont(ofSize: yh*1/50)
//        foodTime.textAlignment = NSTextAlignment.left
//        self.view.addSubview(foodTime)
//
//        // 食物价格
//        // let foodPrice = UILabel(frame: CGRect(x: xw*2/3, y: yh*21/50+50, width: xw/4, height: 60))
//        let foodPrice = UILabel(frame: CGRect(x: xw*2/3, y: yh*11/25+yh/20, width: xw/4, height: yh*6/80))
//        foodPrice.text = "￥12"
//        foodPrice.textColor = UIColor.init(displayP3Red: 243/255, green: 101/255, blue: 38/255, alpha: 1)
//        // foodPrice.font = UIFont.boldSystemFont(ofSize: 36)
//        foodPrice.font = UIFont.boldSystemFont(ofSize: yh*9/200)
//        foodPrice.textAlignment = NSTextAlignment.center
//        self.view.addSubview(foodPrice)
//
//        // 下面的白底
//        let buttomBackground = UIView(frame: CGRect(x: xw/32, y: yh*2/3, width: xw*15/16, height: yh/6))
//        buttomBackground.backgroundColor = UIColor.white
//        buttomBackground.layer.cornerRadius = buttomBackground.frame.width/24
//        buttomBackground.layer.shadowColor = UIColor.darkGray.cgColor
//        buttomBackground.layer.shadowOpacity = 1
//        buttomBackground.layer.shadowOffset = CGSize(width: 0, height: 0)
//        self.view.addSubview(buttomBackground)
//
//        // 二维码
//        qrCode = UIImageView(image: #imageLiteral(resourceName: "天外天.png"))
//        // qrCode.frame = CGRect(x: xw/12, y: yh*2/3+xw/12-xw/32, width: yh/6-xw/6+xw/16, height: yh/6-xw/6+xw/16)
//        qrCode.frame = CGRect(x: xw/20, y: yh*2/3+xw/20-xw/32, width: yh/6-xw/10+xw/16, height: yh/6-xw/10+xw/16)
//        self.view.addSubview(qrCode)
//
//        // 二维码信息
//        let qrInfo = UILabel(frame: CGRect(x: xw/20+yh/6-xw/10+xw/16, y: yh*2/3+xw/20-xw/32, width: xw*15/16-xw/20-yh/6+xw/10-xw/16, height: yh/6-xw/10+xw/16))
//        qrInfo.text = "扫描二维码查看更多信息\n\n天外天-好吃"
//        qrInfo.numberOfLines = 3
//        qrInfo.textColor = UIColor.darkGray
//        // qrInfo.font = UIFont.boldSystemFont(ofSize: 18)
//        qrInfo.font = UIFont.boldSystemFont(ofSize: yh*9/400)
//        qrInfo.textAlignment = NSTextAlignment.center
//        self.view.addSubview(qrInfo)
//
//        // 声明
//        let copyright = UILabel(frame: CGRect(x: 0, y: yh*11/12, width: xw, height: 40))
//        copyright.text = "Powered by TWTStudio"
//        copyright.textColor = UIColor.white
//        // copyright.font = UIFont.boldSystemFont(ofSize: 18)
//        copyright.font = UIFont.boldSystemFont(ofSize: yh*9/400)
//        copyright.textAlignment = NSTextAlignment.center
//        self.view.addSubview(copyright)
//
//    }
//
//    override func didReceiveMemoryWarning() {
//        super.didReceiveMemoryWarning()
//        // Dispose of any resources that can be recreated.
//    }
//
//
//}
//
//extension UIView {
//
//    // 设置独立圆角(不可用)
//    /*
//     func addCorner(roundingCorners: UIRectCorner, cornerSize: CGSize) {
//     let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: roundingCorners, cornerRadii: cornerSize)
//     let cornerLayer = CAShapeLayer()
//     cornerLayer.frame = bounds
//     cornerLayer.path = path.cgPath
//
//     layer.mask = cornerLayer
//     }
//     */
//
//    // 设置独立圆角(可用)
//    func corner(byRoundingCorners corners: UIRectCorner, radii: CGFloat) {
//        let maskPath = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radii, height: radii))
//        let maskLayer = CAShapeLayer()
//        maskLayer.frame = self.bounds
//        maskLayer.path = maskPath.cgPath
//        self.layer.mask = maskLayer
//    }
//
//}
