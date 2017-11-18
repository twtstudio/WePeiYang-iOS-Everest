//
//  ComplaintStarView.swift
//  WePeiYang
//
//  Created by 赵家琛 on 2017/9/5.
//  Copyright © 2017年 twtstudio. All rights reserved.
//

import UIKit


class ComplaintStarView: UIView {
    
    
    let star_gray = "star"
    let star_yellow = "star的副本"
    
    var starSize: CGFloat = 0
    
    dynamic var rating: Double = 0
    var stars: [UIButton] = []
    var `default`: Int = 0 {
        didSet {
            stars[`default`-1].sendActions(for: .touchUpInside)
        }
    }
    
    func loadStars() {
        self.addSubview(stars[0])
        stars[0].snp.makeConstraints {
            make in
            make.left.equalTo(self).offset(2)
            make.top.equalTo(self)
            make.bottom.equalTo(self)
        }
        for i in 1..<4 {
            self.addSubview(stars[i])
            stars[i].snp.makeConstraints {
                make in
                make.left.equalTo(self.stars[i-1].snp.right).offset(self.starSize/4.5)
                make.centerY.equalTo(self.stars[i-1])
            }
        }
        self.addSubview(stars[4])
        stars[4].snp.makeConstraints {
            make in
            make.left.equalTo(self.stars[3].snp.right).offset(self.starSize/4.5)
            make.centerY.equalTo(self.stars[3])
            make.right.equalTo(self).offset(-2)
        }
    }
    
    
    convenience init(rating: Double, height: CGFloat, tappable: Bool) {
        self.init()
        self.rating = rating
        self.starSize = height
        
        
        for _ in 0..<5 {
            stars.append(UIButton(backgroundImageName: star_gray, desiredSize: CGSize(width: height, height: height))!)
        }
        
        
        for index in 0..<5 {
            stars[index].tag = index
        }
        
            for i in 0..<Int(rating) {
                var foo = UIImage(named: star_yellow)
                foo = UIImage.resizedImage(image: foo!, scaledToSize: CGSize(width: height, height: height))
                stars[i].setBackgroundImage(foo, for: .normal)
            }
        
        loadStars()
        if tappable {
            assignGestures()
            //Below is a line of code which solves a crappy and weird bug.
            stars[Int(rating)-1].sendActions(for: .touchUpInside)
        }
    }
    
}


extension ComplaintStarView {
    
    func starGetsTapped(sender: UIButton) {
        
        self.rating = Double(sender.tag) + 1
        
        for i in 0...sender.tag {
            stars[i].setBackgroundImage(UIImage(named: star_yellow), for: .normal)
        }
        
        if sender.tag < 4 {
            for i in (sender.tag+1)...4 {
                stars[i].setBackgroundImage(UIImage(named: star_gray), for: .normal)
            }
        }
        
    }
    
    func assignGestures() {
        for star in stars {
            star.addTarget(self, action: #selector(self.starGetsTapped(sender:)), for: .touchUpInside)
        }
    }
    
    func animated() {
        UIView.animate(withDuration: 0.7, animations: {
            self.frame = CGRect(x: 0, y: self.frame.height, width: self.frame.width, height: self.frame.height)
        }, completion: { _ in
            self.removeFromSuperview()
        })
    }
}


private extension Double {
    func rounded() -> Double {
        if self - Double(Int(self)) > 0.0 && self - Double(Int(self)) < 0.25 {
            return Double(Int(self))
        } else if self - Double(Int(self)) >= 0.25 && self - Double(Int(self)) < 0.75 {
            return Double(Int(self)) + 0.5
        } else if self - Double(Int(self)) >= 0.75 {
            return Double(Int(self)) + 1.0
        }
        return self
    }
}
