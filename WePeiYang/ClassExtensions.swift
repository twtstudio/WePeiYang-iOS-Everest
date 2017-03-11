//
//  ClassExtensions.swift
//  WePeiYang
//
//  Created by Allen X on 3/11/17.
//  Copyright © 2017 twtstudio. All rights reserved.
//

/**
 This file wraps all universal extensions of class for convenience
 */



import UIKit


extension UILabel {
    convenience init(text: String, color: UIColor) {
        self.init()
        self.text = text
        textColor = color
        self.sizeToFit()
    }
    
    convenience init(text: String?) {
        self.init()
        self.text = text
        self.sizeToFit()
    }
    
    convenience init(text: String, fontSize: CGFloat) {
        self.init()
        self.text = text
        self.font = UIFont.boldSystemFont(ofSize: fontSize)
        self.sizeToFit()
    }
}



extension UIView {
    convenience init(color: UIColor) {
        self.init()
        backgroundColor = color
    }
}



extension UIImage {
    
    static func resizedImage(image: UIImage, scaledToSize newSize: CGSize) -> UIImage{
        UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0);
        image.draw(in: CGRect(x: 0.0, y: 0, width: newSize.width, height: newSize.height))
        let newImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return newImage
    }
    
    
    static func resizedImageKeepingRatio(image: UIImage, scaledToWidth newWidth: CGFloat) -> UIImage {
        let scaleRatio = newWidth / image.size.width
        let newHeight = image.size.height * scaleRatio
        let foo = UIImage.resizedImage(image: image, scaledToSize: CGSize(width: newWidth, height: newHeight))
        return foo
    }
    
    static func resizedImageKeepingRatio(image: UIImage, scaledToHeight newHeight: CGFloat) -> UIImage {
        let scaleRatio = newHeight / image.size.height
        let newWidth = image.size.width * scaleRatio
        let foo = UIImage.resizedImage(image: image, scaledToSize: CGSize(width: newWidth, height: newHeight))
        return foo
    }
    
    func rgb(atPos pos: CGPoint) -> (red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat) {
        
        let pixelData = self.cgImage!.dataProvider!.data
        let data: UnsafePointer<UInt8> = CFDataGetBytePtr(pixelData)
        
        let pixelInfo: Int = ((Int(self.size.width) * Int(pos.y)) + Int(pos.x)) * 4
        
        let r = CGFloat(data[pixelInfo]) / CGFloat(255.0)
        let g = CGFloat(data[pixelInfo+1]) / CGFloat(255.0)
        let b = CGFloat(data[pixelInfo+2]) / CGFloat(255.0)
        let a = CGFloat(data[pixelInfo+3]) / CGFloat(255.0)
        
        return (r, g, b, a)
    }
    
    
    func smartAvgRGB() -> (red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat) {
        //[TODO]: Add smart rgb Filter
        
        //Naïve Algorithm. Squareroot: Weight for a specific RGB value is value^(-1/3)
        let thumbnail = UIImage.resizedImage(image: self, scaledToSize: CGSize(width: 100, height: 100))
        var r: CGFloat = 0.0
        var g: CGFloat = 0.0
        var b: CGFloat = 0.0
        var a: CGFloat = 0.0
        for i in 0..<100 {
            for j in 0..<100 {
                let point = CGPoint(x: i, y: j)
                let rgbOfThisPoint = thumbnail.rgb(atPos: point)
                
                r += (pow(rgbOfThisPoint.red, 1/3))/10000
                g += (pow(rgbOfThisPoint.green, 1/3))/10000
                b += (pow(rgbOfThisPoint.blue, 1/3))/10000
                a += rgbOfThisPoint.alpha/10000
            }
        }
        
        //print(r*255, g*255, b*255, a)
        return (r, g, b, a)
    }
    
}




extension UIImageView {
    convenience init?(imageName: String, desiredSize: CGSize) {
        guard var foo = UIImage(named: imageName) else {
            return nil
        }
        foo = UIImage.resizedImage(image: foo, scaledToSize: desiredSize)
        self.init()
        image = foo
    }
}




extension UIButton {
    convenience init(title: String) {
        self.init()
        setTitle(title, for: .normal)
        titleLabel?.sizeToFit()
    }
    
    
    convenience init?(backgroundImageName: String, desiredSize: CGSize) {
        guard var foo = UIImage(named: backgroundImageName) else {
            return nil
        }
        foo = UIImage.resizedImage(image: foo, scaledToSize: desiredSize)
        self.init()
        setBackgroundImage(foo, for: .normal)
    }
}

