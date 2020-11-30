//
//  CardView.swift
//  WePeiYang
//
//  Created by Halcao on 2017/12/8.
//  Copyright © 2017年 twtstudio. All rights reserved.
//

import UIKit

@objc protocol CardViewDelegate: class {
    func cardIsTapped(card: CardView)
}

class CardView: UIView {
    weak var delegate: CardViewDelegate?

    /**
     Should card present detail view controller when tapped.
     */
    var shouldPresentDetail: Bool = false
    var shouldPushDetail: Bool = true
    /**
     Amount of blur for the card's shadow.
     */
    var shadowBlur: CGFloat = 8 { // 14
        didSet {
            self.layer.shadowRadius = shadowBlur
        }
    }
    /**
     Alpha of the card's shadow.
     */
    var shadowOpacity: Float = 0.3 { // 0.6
        didSet {
            self.layer.shadowOpacity = shadowOpacity
        }
    }
    /**
     Color of the card's shadow.
     */
    var shadowColor: UIColor = UIColor.gray {
        didSet {
            self.layer.shadowColor = shadowColor.cgColor
        }
    }
    /**
     Corner radius of the card.
     */
    var cardRadius: CGFloat = 20 {
        didSet {
            self.layer.cornerRadius = cardRadius
        }
    }

    /**
     If the card should display parallax effect.
     */
    public var hasParallax: Bool = true {
        didSet {
            if self.motionEffects.isEmpty && hasParallax { goParallax() } else if !hasParallax && !motionEffects.isEmpty { motionEffects.removeAll() }
        }
    }

    /**
     Color of the card's background.
     */
    override open var backgroundColor: UIColor? {
        didSet(new) {
            if let color = new {
                contentView.backgroundColor = color
                blankView.backgroundColor = color
            }
            if backgroundColor != UIColor.clear { backgroundColor = UIColor.clear }
        }
    }

    // Private properties
//    fileprivate var tap = UITapGestureRecognizer()
    weak var superVC: UIViewController?
    var detailVC: UIViewController.Type?
    var originalFrame = CGRect.zero
    let contentView = UIView()

    fileprivate let msgLabel = UILabel()
    let blankView = UIView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        initialize()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initialize()
    }

    func initialize() {
        self.addSubview(contentView)
        self.isUserInteractionEnabled = true
        backgroundColor = UIColor.white
        contentView.isUserInteractionEnabled = true
        if contentView.backgroundColor == nil {
            contentView.backgroundColor = UIColor.white
            super.backgroundColor = UIColor.clear
        }
        msgLabel.font = UIFont.preferredFont(forTextStyle: .body)
        msgLabel.textColor = .white
        msgLabel.textAlignment = .center
        blankView.backgroundColor = UIColor.white
        self.addSubview(msgLabel)
//        blankView.addSubview(msgLabel)
        self.addSubview(blankView)
        blankView.isHidden = true
    }

    func layout(rect: CGRect) {
        msgLabel.center = blankView.center
    }

    override func draw(_ rect: CGRect) {
        super.draw(rect)
        contentView.frame.origin = CGPoint.zero
        contentView.frame.size = rect.size

        blankView.frame = CGRect(x: 0, y: 50, width: rect.size.width, height: rect.size.height-50-cardRadius)
        msgLabel.center = blankView.center
//        msgLabel.center = contentView.center
//        msgLabel.y -= cardRadius*2
//        originalFrame = rect

        self.layer.shadowOpacity = shadowOpacity
        self.layer.shadowColor = shadowColor.cgColor
        self.layer.shadowOffset = CGSize.zero
        self.layer.shadowRadius = shadowBlur
        self.layer.cornerRadius = cardRadius

        contentView.layer.cornerRadius = self.layer.cornerRadius
        contentView.clipsToBounds = true

        self.layout(rect: rect)
    }

    open func refresh() {

    }

    func shouldPresent(_ viewController: UIViewController.Type, from superVC: UIViewController) {
        shouldPresentDetail = true
        shouldPushDetail = false
        self.superVC = superVC
        self.detailVC = viewController
    }

    func shouldPush(_ viewController: UIViewController.Type, from superVC: UIViewController) {
        shouldPresentDetail = false
        shouldPushDetail = true
        self.superVC = superVC
        self.detailVC = viewController
    }
    /**
     Parallax Effect
     */
    private func goParallax() {
        let amount = 20

        let horizontal = UIInterpolatingMotionEffect(keyPath: "center.x", type: .tiltAlongHorizontalAxis)
        horizontal.minimumRelativeValue = -amount
        horizontal.maximumRelativeValue = amount

        let vertical = UIInterpolatingMotionEffect(keyPath: "center.y", type: .tiltAlongVerticalAxis)
        vertical.minimumRelativeValue = -amount
        vertical.maximumRelativeValue = amount

        let group = UIMotionEffectGroup()
        group.motionEffects = [horizontal, vertical]
        self.addMotionEffect(group)
    }
}

extension CardView {
    func cellTapped() {
        self.delegate?.cardIsTapped(card: self)

        if let superVC = superVC,
            let detailVC = detailVC {
//            originalFrame = self.convert(self.bounds, to: superVC.view)
            if shouldPresentDetail {
                let detailVC = UINavigationController(rootViewController: detailVC.init())
                detailVC.transitioningDelegate = self
                detailVC.modalPresentationStyle = .fullScreen
                superVC.present(detailVC, animated: true, completion: nil)
            } else if shouldPushDetail {
                let detailVC = UINavigationController(rootViewController: detailVC.init())
                detailVC.hidesBottomBarWhenPushed = true
                superVC.navigationController?.delegate = self
                superVC.navigationController?.pushViewController(detailVC, animated: true)
            }
        } else {
            // TODO: reset animation
            // resetAnimated()
        }
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let superview = self.superview {
            originalFrame = superview.convert(self.frame, to: nil)
        }
        // TODO: tap animation
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        cellTapped()

    }
}

extension CardView: UIViewControllerTransitioningDelegate {
    public func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        let animator = CardViewTransitionAnimator(isPresenting: true, originalFrame: originalFrame, card: self)
        return animator
    }

    public func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        let animator = CardViewTransitionAnimator(isPresenting: false, originalFrame: originalFrame, card: self)
        return animator
    }
}

extension CardView: UINavigationControllerDelegate {

    func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationController.Operation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        let isPresenting = operation == .push ? true : false
//        fromVC.tabBarController?.tabBar.isHidden = true
        let animator = CardViewTransitionAnimator(isPresenting: isPresenting, originalFrame: originalFrame, card: self)
        return animator
    }
}

extension CardView {
    enum State {
        case loading(String, UIColor)
        case empty(String, UIColor)
        case data
        case failed(String, UIColor)
    }

    func setState(_ state: State) {
        switch state {
        case .data:
            blankView.isHidden = true
            self.sendSubviewToBack(blankView)
            self.sendSubviewToBack(msgLabel)
            return
        case .loading(let msg, let textColor):
            blankView.isHidden = false
            self.bringSubviewToFront(blankView)
            self.bringSubviewToFront(msgLabel)
            msgLabel.text = msg
            msgLabel.textColor = textColor
            msgLabel.sizeToFit()
            msgLabel.center = blankView.center
            if TwTUser.shared.token == nil {
                msgLabel.text = "请先登录"
                msgLabel.sizeToFit()
                return
            }
            return
        case .empty(let msg, let textColor):
            blankView.isHidden = false
            self.bringSubviewToFront(blankView)
            self.bringSubviewToFront(msgLabel)
            msgLabel.text = msg
            msgLabel.textColor = textColor
            msgLabel.sizeToFit()
            msgLabel.center = blankView.center
            return
        case .failed(let msg, let textColor):
            blankView.isHidden = false
            self.bringSubviewToFront(blankView)
            self.bringSubviewToFront(msgLabel)
            msgLabel.text = msg
            msgLabel.textColor = textColor
            msgLabel.sizeToFit()
            msgLabel.center = blankView.center
            return
//        default:
//            return
        }
    }
}
