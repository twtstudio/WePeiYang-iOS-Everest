//
//  SpringButton.swift
//  WePeiYang
//
//  Created by Allen X on 3/11/17.
//  Copyright © 2017 twtstudio. All rights reserved.
//

import Foundation
import UIKit

class SpringButton: UIButton {
    
    var minimumScale: CGFloat = 0.95
    var pressSpringDamping: CGFloat = 0.4
    var releaseSpringDamping: CGFloat = 0.35
    var pressSpringDuration = 0.4
    var releaseSpringDuration = 0.5
    
    init() {
        super.init(frame: CGRect.zero)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        UIView.animate(withDuration: pressSpringDuration, delay: 0, usingSpringWithDamping: pressSpringDamping, initialSpringVelocity: 0, options: [.curveLinear, .allowUserInteraction], animations: {
            self.transform = CGAffineTransform(scaleX: self.minimumScale, y: self.minimumScale)
        }, completion: nil)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        UIView.animate(withDuration: releaseSpringDuration, delay: 0, options: [.curveLinear, .allowUserInteraction], animations: {
            self.transform = CGAffineTransform.identity
        }, completion: nil)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        let location = touches.first!.location(in: self)
        if bounds.contains(location) {
            UIView.animate(withDuration: releaseSpringDuration, delay: 0, options: [.curveLinear, .allowUserInteraction], animations: {
                self.transform = CGAffineTransform.identity
            }, completion: nil)
        }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesCancelled(touches, with: event)
        UIView.animate(withDuration: releaseSpringDuration, delay: 0, options: [.curveLinear, .allowUserInteraction], animations: {
            self.transform = CGAffineTransform.identity
        }, completion: nil)
    }
    
    convenience init(title: String, titleColor: UIColor, backgroundColor: UIColor) {
        self.init()
        setTitle(title, for: .normal)
        setTitleColor(titleColor, for: .normal)
        self.backgroundColor = backgroundColor
        sizeToFit()
    }
    
    
}

extension SpringButton: ThemeChanging {
    // TODO: Conforming to Protocol ThemeChanging
    func changeInto(theme: Theme) {
        
    }
}
