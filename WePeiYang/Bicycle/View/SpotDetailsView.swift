//
//  SpotDetailsView.swift
//  MapKitImplementAgain
//
//  Created by Allen X on 7/14/16.
//  Copyright © 2016 twtstudio. All rights reserved.
//

import MapKit
import UIKit
import SnapKit

let bicycleGreen = UIColor(colorLiteralRed: 39.0/255.0, green: 174.0/255.0, blue: 27.0/255.0, alpha: 0.8)

//let bigiPhoneWidth: CGFloat = 414.0
let deviceWidth = UIScreen.main.bounds.size.width
let deviceHeight = UIScreen.main.bounds.size.height

class SpotDetailsView: UIView {
    
    init(positionsAvailable: String, spotName:String, distanceFromUser: CLLocationDistance?, status: ParkingSpot.Status?) {
        
        let positionsAvailableLabel = UILabel(text: positionsAvailable)
        let spotNameLabel = UILabel(text: spotName)
        let distanceFromUserLabel: UILabel
        let bicycleIconView = UIImageView(imageName: "ic_bike", desiredSize: CGSize(width: 20, height: 20))
        let roundedStatusView = UIView()
        
        
        
        if let foo = distanceFromUser {
            let distanceWithoutFloatingPoint: Double = Double(Int(foo))
            if distanceWithoutFloatingPoint >= 1000 {
                distanceFromUserLabel = UILabel(text: "它距我 \(distanceWithoutFloatingPoint/1000)Km", color: .gray)
            } else {
                distanceFromUserLabel = UILabel(text: "它距我 \(distanceWithoutFloatingPoint)m", color: .gray)
            }
        } else {
            distanceFromUserLabel = UILabel(text: "无法定位计算距离", color: .gray)
        }
        
        if status != nil {
            switch status! {
            case .online:
                roundedStatusView.backgroundColor = bicycleGreen
            case .offline:
                roundedStatusView.backgroundColor = .gray
            case .dunno:
                roundedStatusView.backgroundColor = .yellow
            }
        }
        
        if deviceWidth < bigiPhoneWidth {
            
            super.init(frame:CGRect(x: 10 , y: deviceHeight - 83, width: deviceWidth - 20, height: 88))
            
            self.layer.cornerRadius = 8
            self.layer.masksToBounds = false
            
            /*
             let shadowPath = UIBezierPath(rect: bounds)
             self.layer.shadowColor = UIColor(colorLiteralRed: 236.0/255.0, green: 236.0/255.0, blue: 236.0/255.0, alpha: 1.0).CGColor
             
             self.layer.shadowOffset = CGSize(width: 0, height: 1.0)
             self.layer.shadowOpacity = 0.8
             self.layer.shadowPath = shadowPath.CGPath
             self.layer.shadowRadius = 4
             */
            
            self.backgroundColor = UIColor.clear
            let blurEffect = UIBlurEffect(style: .light)
            let blurEffectView = UIVisualEffectView(effect: blurEffect)
            blurEffectView.frame = self.bounds
            blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            blurEffectView.layer.cornerRadius = 8
            //blurEffectView.contentView.layer.cornerRadius = 8
            for view in blurEffectView.subviews {
                view.layer.cornerRadius = 8
            }
            
            
            
            //self.backgroundColor = UIColor.clearColor()
            blurEffectView.addSubview(bicycleIconView!)
            blurEffectView.addSubview(positionsAvailableLabel)
            blurEffectView.addSubview(spotNameLabel)
            blurEffectView.addSubview(roundedStatusView)
            blurEffectView.addSubview(distanceFromUserLabel)
            self.addSubview(blurEffectView)
            self.clipsToBounds = true
            
            
            //set constraint
            bicycleIconView!.snp.makeConstraints {
                make in
                make.top.equalTo(self).offset(20)
                make.left.equalTo(self).offset(10)
            }
            
            positionsAvailableLabel.snp.makeConstraints {
                make in
                make.top.equalTo(self).offset(20)
                make.left.equalTo(bicycleIconView!.snp.right).offset(10)
                
            }
            
            
            spotNameLabel.snp.makeConstraints {
                make in
                make.top.equalTo(self).offset(20)
                make.left.equalTo(positionsAvailableLabel.snp.right).offset(15)
                
            }
            
            roundedStatusView.snp.makeConstraints {
                make in
                make.left.equalTo(spotNameLabel.snp.right).offset(8)
                make.centerY.equalTo(spotNameLabel)
                make.width.height.equalTo(14)
            }
            roundedStatusView.layer.cornerRadius = 7
            
            distanceFromUserLabel.snp.makeConstraints {
                make in
                make.top.equalTo(positionsAvailableLabel.snp.bottom).offset(10)
                make.left.equalTo(self).offset(10)
                
            }
            
        } else {
            
            super.init(frame:CGRect(x: 10 , y: deviceHeight - 73, width: deviceWidth - 20, height: 88))
            
            self.layer.cornerRadius = 8
            self.layer.masksToBounds = false
            
            /*
             let shadowPath = UIBezierPath(rect: bounds)
             self.layer.shadowColor = UIColor.blackColor().CGColor
             self.layer.shadowOffset = CGSize(width: 0, height: 1.0)
             self.layer.shadowOpacity = 0.8
             self.layer.shadowPath = shadowPath.CGPath
             self.layer.shadowRadius = 4*/
            
            
            self.backgroundColor = UIColor.clear
            let blurEffect = UIBlurEffect(style: .light)
            let blurEffectView = UIVisualEffectView(effect: blurEffect)
            blurEffectView.frame = self.bounds
            blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            blurEffectView.layer.cornerRadius = 8
            //blurEffectView.contentView.layer.cornerRadius = 8
            for view in blurEffectView.subviews {
                view.layer.cornerRadius = 8
            }
            
            
            //self.backgroundColor = UIColor.clearColor()
            blurEffectView.addSubview(bicycleIconView!)
            blurEffectView.addSubview(positionsAvailableLabel)
            blurEffectView.addSubview(spotNameLabel)
            blurEffectView.addSubview(roundedStatusView)
            blurEffectView.addSubview(distanceFromUserLabel)
            self.addSubview(blurEffectView)
            self.clipsToBounds = true
            
            
            positionsAvailableLabel.font = positionsAvailableLabel.font.withSize(16)
            spotNameLabel.font = spotNameLabel.font.withSize(16)
            distanceFromUserLabel.font = distanceFromUserLabel.font.withSize(16)
            
            //set constraint
            bicycleIconView!.snp.makeConstraints {
                make in
                make.top.equalTo(self).offset(28)
                make.left.equalTo(self).offset(10)
            }
            
            positionsAvailableLabel.snp.makeConstraints {
                make in
                make.top.equalTo(self).offset(28)
                make.left.equalTo(bicycleIconView!.snp.right).offset(10)
                
            }
            
            spotNameLabel.snp.makeConstraints {
                make in
                make.top.equalTo(self).offset(28)
                make.left.equalTo(positionsAvailableLabel.snp.right).offset(10)
                
            }
            
            roundedStatusView.snp.makeConstraints {
                make in
                make.centerY.equalTo(spotNameLabel)
                make.left.equalTo(spotNameLabel.snp.right).offset(5)
                make.width.height.equalTo(14)
            }
            roundedStatusView.layer.cornerRadius = 7
            
            distanceFromUserLabel.snp.makeConstraints {
                make in
                make.top.equalTo(self).offset(28)
                make.right.equalTo(self).offset(-10)
                
            }
            
        }
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}




