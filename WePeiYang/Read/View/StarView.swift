//
//  StarView.swift
//  WePeiYang
//
//  Created by Allen X on 10/28/16.
//  Copyright © 2016 Qin Yubo. All rights reserved.
//


class StarView: UIView {
    
    
    private let star_grey = "star_grey"
    private let star_red = "star_red"
    private let star_half = "star_half"
    var starSize: CGFloat = 0
    
    dynamic var rating: Double = 0
    var stars: [UIButton] = []
    
    func loadStars() {
        self.addSubview(stars[0])
        stars[0].snp_makeConstraints {
            make in
            make.left.equalTo(self).offset(2)
            make.top.equalTo(self)
            make.bottom.equalTo(self)
        }
        for i in 1..<4 {
            self.addSubview(stars[i])
            stars[i].snp_makeConstraints {
                make in
                make.left.equalTo(self.stars[i-1].snp_right).offset(self.starSize/4.5)
                make.centerY.equalTo(self.stars[i-1])
            }
        }
        self.addSubview(stars[4])
        stars[4].snp_makeConstraints {
            make in
            make.left.equalTo(self.stars[3].snp_right).offset(self.starSize/4.5)
            make.centerY.equalTo(self.stars[3])
            make.right.equalTo(self).offset(-2)
        }
    }
    
    //    override func drawRect(rect: CGRect) {
    //        super.drawRect(rect)
    //        refresh()
    //    }
    
    convenience init(rating: Double, height: CGFloat, tappable: Bool) {
        self.init()
        self.rating = rating
        self.starSize = height
        //TODO: Add guard?
        
        //OH MY GOODNESS THIS IS A GIANT BUG OR SOMETHING? LIKE 5 POINTERS POINTED TO THE SAME OBJECT
        //stars = [UIImageView](count: 5, repeatedValue: UIImageView(imageName: star_grey, desiredSize: CGSize(width: height, height: height))!)
        
        for _ in 0..<5 {
            stars.append(UIButton(backgroundImageName: star_grey, desiredSize: CGSize(width: height, height: height))!)
        }
        
        
        for index in 0..<5 {
            stars[index].tag = index
        }
        
        if Int(rating) > 0 {
            for i in 0..<Int(rating) {
                var foo = UIImage(named: star_red)
                foo = UIImage.resizedImage(foo!, scaledToSize: CGSize(width: height, height: height))
                stars[i].setBackgroundImage(foo, forState: UIControlState.Normal)
            }
            if rating.rounded() - Double(Int(rating)) > 0 {
                var foo = UIImage(named: star_half)
                foo = UIImage.resizedImage(foo!, scaledToSize: CGSize(width: height, height: height))
                stars[Int(rating)].setBackgroundImage(foo, forState: UIControlState.Normal)
            }
        } else if rating.rounded() == 0.5 {
            var foo = UIImage(named: star_half)
            foo = UIImage.resizedImage(foo!, scaledToSize: CGSize(width: height, height: height))
            stars[0].setBackgroundImage(foo, forState: UIControlState.Normal)
        }
        
        loadStars()
        if tappable {
            assignGestures()
            //Below is a line of code which solves a crappy and weird bug.
            stars[Int(rating)-1].sendActionsForControlEvents(.TouchUpInside)
        }
    }
    
}


extension StarView {
    
    func starGetsTapped(sender: UIButton) {
        //log.word("hello")/
        self.rating = Double(sender.tag) + 1
        
        //TODO: Chained Animation of the stars
        //        let foo = self.stars[sender.tag].frame
        //        UIView.animateWithDuration(0.7, animations: {
        //            self.stars[sender.tag].frame = CGRect(x: foo.origin.x - 10, y: foo.origin.y - 10, width: foo.size.width * 2, height: foo.size.height * 2)
        //            }) { (_) in
        //                self.stars[sender.tag].frame = foo
        //                self.stars[sender.tag-1].frame = CGRect(x: foo.origin.x - 10, y: foo.origin.y - 10, width: foo.size.width * 2, height: foo.size.height * 2)
        //        }
        
        for i in 0...sender.tag {
            //stars[i] = UIButton(backgroundImageName: star_red, desiredSize: CGSize(width: tappedStar.bounds.width, height: tappedStar.bounds.height))!
            //log.any(stars[i].frame)/
            stars[i].setBackgroundImage(UIImage(named: star_red), forState: UIControlState.Normal)
            //log.any(stars[i].frame)/
        }
        if sender.tag < 4 {
            for i in (sender.tag+1)...4 {
                stars[i].setBackgroundImage(UIImage(named: star_grey), forState: UIControlState.Normal)
            }
        }
        
    }
    
    func assignGestures() {
        //let tap = UITapGestureRecognizer(target: self, action: #selector(self.starGetsTapped))
        for star in stars {
            star.addTarget(self, action: #selector(self.starGetsTapped(_:)), forControlEvents: .TouchUpInside)
            //            log.word("gestures assigned")/
        }
    }
    
    func animated() {
        UIView.animateWithDuration(0.7, animations: {
            self.frame = CGRect(x: 0, y: self.frame.height, width: self.frame.width, height: self.frame.height)
        }) { (_: Bool) in
            
            self.removeFromSuperview()
        }
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
