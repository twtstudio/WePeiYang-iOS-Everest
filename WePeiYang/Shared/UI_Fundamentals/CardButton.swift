//
//  CardButton.swift
//  WePeiYang
//
//  Created by Halcao on 2018/2/4.
//  Copyright © 2018年 twtstudio. All rights reserved.
//

import UIKit

class CardButton: UIButton {
    var tapAction: ((CardButton) -> ())?

    init() {
        super.init(frame: .zero)
        alpha = 0.8
        self.addTarget(self, action: #selector(tapped(sender:)), for: .touchUpInside)
    }

    func setTitle(_ title: String) {
        self.backgroundColor = UIColor(red:0.99, green:0.19, blue:0.35, alpha:1.00)
        let attrString = NSAttributedString(string: title, attributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 16, weight: UIFont.Weight.black), NSAttributedStringKey.foregroundColor: UIColor.white])

        setAttributedTitle(attrString, for: .normal)
        titleLabel?.sizeToFit()
        self.sizeToFit()
        width += 20
        height += 5
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func draw(_ rect: CGRect) {
        super.draw(rect)
        self.layer.cornerRadius = self.layer.bounds.height/2
        self.clipsToBounds = true
    }

    @objc func tapped(sender: CardButton) {
//        UIView.animate(withDuration: 0.15, delay: 0, usingSpringWithDamping: 0.1, initialSpringVelocity: 0, options: [.allowUserInteraction, .curveEaseInOut], animations: {
//            self.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
//        }, completion: { isFinished in
//
//        })
//        UIView.animate(withDuration: 0.05, delay: 0.15, usingSpringWithDamping: 0.7, initialSpringVelocity: 0, options: [.allowUserInteraction, .curveEaseInOut], animations: {
//            self.transform = CGAffineTransform.identity
//        }, completion: { isFinished in
//            self.tapAction?(sender)
//        })

        UIView.animate(withDuration: 0.1, delay: 0, options: [.allowUserInteraction, .curveEaseIn], animations: {
            self.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        }, completion: { isFinished in
        })

        UIView.animate(withDuration: 0.1, delay: 0.1, options: [.allowUserInteraction, .curveEaseOut], animations: {
            self.transform = CGAffineTransform.identity
        }, completion: { isFinished in
            self.tapAction?(sender)
        })
    }
}

