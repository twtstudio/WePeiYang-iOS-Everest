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
        let attrString = NSAttributedString(string: title, attributes: [NSAttributedStringKey.font: UIFont.flexibleSystemFont(ofSize: 16, weight: UIFont.Weight.black), NSAttributedStringKey.foregroundColor: UIColor.white])

        setAttributedTitle(attrString, for: .normal)
        titleLabel?.sizeToFit()
        self.sizeToFit()
//        let size = attrString.boundingRect(with: CGSize(width: CGFloat.infinity, height: 50), options: .usesLineFragmentOrigin, context: nil).size
//        width = size.width + 25
//        height = size.height + 5

        width += 25
        height += 5
//        self.setNeedsLayout()
//        self.layoutIfNeeded()
//        self.setNeedsUpdateConstraints()
//        self.updateConstraintsIfNeeded()
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

