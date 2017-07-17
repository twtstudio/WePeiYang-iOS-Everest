//
//  FAB.swift
//  WePeiYang
//
//  Created by Allen X on 7/5/17.
//  Copyright © 2017 twtstudio. All rights reserved.
//

import UIKit

fileprivate let screenWidth = UIScreen.main.bounds.size.width
fileprivate let screenHeight = UIScreen.main.bounds.size.height

fileprivate enum FABState {
    case expanded
    case collapsed
}

open class FAB: UIButton {

    
    // Because usually a FAB is added as a subview of one of the top-most view like navigationController.view or tabBarController.view
    // You'll need to dismiss the FAB otherwise it'll appear forever as long as you're in the navigation stack
    // Setting this property to true makes the FAB aware of its context and know when it should go or appear after you add it as a subview
    // Setting this property to false makes the FAB not aware of its context so you should call FAB.dismiss(animated: Bool) and FAB.showUp() manually
    // Default being true
    public var contextAware: Bool = true
    
    fileprivate var mainButton: UIButton!
    fileprivate var dimView: UIView!
    fileprivate var subButtons: [UIButton] = []
    fileprivate var _plusSignBezierPath: UIBezierPath!
    fileprivate var _plusSignLayer: CAShapeLayer!
    fileprivate var _tintLayer: CAShapeLayer!
    
    fileprivate var containerView: UIView? {
        get {
            return superview
        }
    }
    
    fileprivate var didAddOtherViews = false
    fileprivate var currentState: FABState = .collapsed
    
    // Different button size for different orientations and screen sizes
    public var buttonWidth: CGFloat = {
        return screenWidth > Metadata.Size.smallPhonePortraitWidth ? 76 : 56
    }()
    
    public var buttonHeight: CGFloat {
        get {
            return buttonWidth
        }
    }
    
    public var buttonSize: CGSize {
        get {
            return CGSize(width: buttonWidth, height: buttonWidth)
        }
    }
    
    // Different font size for different screen sizes
    fileprivate var titleLabelFont: UIFont = {
        return screenWidth > Metadata.Size.smallPhonePortraitWidth ? UIFont.systemFont(ofSize: 42) : UIFont.systemFont(ofSize: 32)
    }()
    
    fileprivate func plusSignBezierPath() -> UIBezierPath {
        if _plusSignBezierPath == nil {
            _plusSignBezierPath = UIBezierPath()
            _plusSignBezierPath.move(to: CGPoint(x: buttonWidth/2, y: buttonHeight/3))
            _plusSignBezierPath.addLine(to: CGPoint(x: buttonWidth/2, y: buttonHeight - buttonHeight/3))
            _plusSignBezierPath.move(to: CGPoint(x: buttonWidth/3, y: buttonHeight/2))
            _plusSignBezierPath.addLine(to: CGPoint(x: buttonWidth - buttonWidth/3, y: buttonHeight/2))
        }
        
        return _plusSignBezierPath
    }
    
    fileprivate func plusSignLayer() -> CAShapeLayer {
        if _plusSignLayer == nil {
            _plusSignLayer = CAShapeLayer()
            _plusSignLayer.frame = CGRect(x: 0, y: 0, width: buttonWidth, height: buttonHeight)
            _plusSignLayer.lineCap = kCALineCapRound
            _plusSignLayer.strokeColor = UIColor.white.cgColor
            _plusSignLayer.lineWidth = 2.0
            _plusSignLayer.path = plusSignBezierPath().cgPath
        }
        
        return _plusSignLayer
    }
    
    fileprivate func tintLayer(origin: CGPoint) -> CAShapeLayer {
        if _tintLayer == nil {
            _tintLayer = CAShapeLayer()
            _tintLayer.cornerRadius = buttonWidth/4
            _tintLayer.frame = CGRect(origin: origin, size: CGSize(width: buttonWidth/2, height: buttonHeight/2))
            _tintLayer.backgroundColor = UIColor.white.withAlphaComponent(0.2).cgColor
            
        } else {
            _tintLayer.position = origin
        }
    
        return _tintLayer
    }
    
    convenience init(mainAction: Action? = nil, subActions: [Action]) {
        self.init()

        layer.addSublayer(plusSignLayer())
        backgroundColor = .red
    
        if UIDeviceOrientationIsPortrait(.portrait) {
            frame = CGRect(x: screenWidth-buttonWidth-30, y: screenHeight-buttonHeight-30, width: buttonWidth, height: buttonHeight)
            layer.cornerRadius = buttonWidth / 2
            layer.shadowOpacity = 0.5
            layer.shadowRadius = 6
            layer.shadowOffset = CGSize(width: 0, height: 7)
            
            
            // FIXME: fix this rotating animation
            // Seems two animations cannot be performed simultaneously
            // Gotta find a way out because the rotating animation is important
            plusSignLayer().transform = CATransform3DMakeRotation(2/3*CGFloat.pi, 0, 0, 1)
            layer.transform = CATransform3DMakeScale(0.2, 0.2, 0.2)
            
            
        }
        
        
        showUp()
        
        if mainAction != nil {
            add(for: .touchUpInside, (mainAction?.function)!)
            // TODO: finish this
        }
        
//        addTarget(self, action: #selector(expandOrCollapse), for: .touchUpInside)

        let bottomLineAt = frame.origin.y
        for (index, subAction) in subActions.enumerated() {
            let button = UIButton()
            button.add(for: .touchUpInside, subAction.function)
            button.setTitle(subAction.name, for: .normal)
            
            // TODO: Change to Metadata.Font
            button.titleLabel?.font = .systemFont(ofSize: 18)
            
            let fooLabel = UILabel(text: subAction.name, fontSize: 18)
            let width = fooLabel.bounds.size.width + 8
            let height = fooLabel.bounds.size.height + 4

            button.frame = CGRect(x: screenWidth-width-30, y: bottomLineAt-CGFloat(index+1)*(20+height), width: width, height: height)
            button.layer.cornerRadius = 4
            button.layer.backgroundColor = Metadata.Color.WPYAccentColor.cgColor
            button.layer.shadowOpacity = 0.35
            button.layer.shadowRadius = 6
            button.layer.shadowOffset = CGSize(width: 0, height: 7)
            button.layer.transform = CATransform3DMakeScale(0.4, 0.4, 0.4)
            button.alpha = 0
            
            subButtons.append(button)
        }
        
        
        dimView = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height))
        dimView.backgroundColor = .white
        dimView.alpha = 0;
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(collapse))
        let swipeGestureDown = UISwipeGestureRecognizer(target: self, action: #selector(collapse))
        swipeGestureDown.direction = .down
        let swipeGestureUp = UISwipeGestureRecognizer(target: self, action: #selector(collapse))
        swipeGestureUp.direction = .up
        dimView.addGestureRecognizer(tapGesture)
        dimView.addGestureRecognizer(swipeGestureUp)
        dimView.addGestureRecognizer(swipeGestureDown)
        
    }
    
    
    public func showUp() {
        UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0, options: [.curveEaseIn], animations: {
            self.layer.transform = CATransform3DIdentity
            self.plusSignLayer().transform = CATransform3DIdentity
        }) { flag in
            
        }
        
//        Timer.scheduledTimer(timeInterval: 0, target: self, selector: #selector(spinScaleAnim), userInfo: nil, repeats: false)
        
    }
    
    @objc fileprivate func spinScaleAnim() {
        let spinAnim = CASpringAnimation(keyPath: "transform.rotation.z")
        spinAnim.fromValue = CGFloat.pi * 270 / 360
        spinAnim.toValue = 0
        spinAnim.damping = 0.7
        let scaleAnim = CASpringAnimation(keyPath: "transform.scale")
//        scaleAnim.fromValue = 0.2
        scaleAnim.toValue = 1
        scaleAnim.damping = 0.7
        let animGroup = CAAnimationGroup()
        animGroup.animations = [spinAnim, scaleAnim]
        animGroup.beginTime = 0
        animGroup.duration = 0.8
        animGroup.isRemovedOnCompletion = false
        
        layer.add(animGroup, forKey: nil)
        
    }
    
    public func dismissAnimated() {
        collapse()
        UIView.animate(withDuration: 0.7, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0, options: [.curveEaseOut], animations: {
            self.layer.transform = CATransform3DMakeScale(0.2, 0.2, 0.2)
            self.plusSignLayer().transform = CATransform3DMakeRotation(270/360*CGFloat.pi, 0, 0, 1)
            
            self.alpha = 0
        }, completion: nil)
    }
    
    // may need to do scrollView watching?
    public func dismiss(animated: Bool) {
        if animated {
            expandOrCollapse()
            UIView.animate(withDuration: 0.7, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0, options: [.curveEaseOut], animations: {
                self.layer.transform = CATransform3DMakeScale(0.2, 0.2, 0.2)
                self.plusSignLayer().transform = CATransform3DMakeRotation(270/360*CGFloat.pi, 0, 0, 1)
                self.alpha = 0
                
            }, completion: nil)
        } else {
            
        }
    }
    

    @objc fileprivate func expandOrCollapse() {
        switch currentState {
        case .collapsed:
            expand()
            break
            
        case .expanded:
            collapse()
        }

    }
    
    // Expand the subButtons
    @objc fileprivate func expand() {
        if !didAddOtherViews {
            containerView?.insertSubview(dimView, belowSubview: self)
            for subButton in subButtons {
                containerView?.insertSubview(subButton, aboveSubview: dimView)
            }
            didAddOtherViews = true
        }
        
        UIView.animate(withDuration: 0.3) {
            self.dimView.alpha = 0.9
            
            UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0, options: [.curveEaseIn], animations: {
                self.plusSignLayer().transform = CATransform3DMakeRotation(0.25*CGFloat.pi, 0, 0, 1)
            }, completion: nil)
            
            for (index, subButton) in self.subButtons.enumerated() {
                UIView.animate(withDuration: 0.24, delay: 0.04*TimeInterval(index), usingSpringWithDamping: 0.7, initialSpringVelocity: 0, options: [], animations: {
                    subButton.layer.transform = CATransform3DIdentity
                    subButton.alpha = 1
                }, completion: nil)
            }
            
        }
        currentState = .expanded
    }
    
    // Collapse the list the subButtons
    @objc fileprivate func collapse() {
        
        guard currentState == .expanded else {
            return
        }
        
        UIView.animate(withDuration: 0.3) {
            self.dimView.alpha = 0
            
            UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0, options: [.curveEaseIn], animations: {
                self.plusSignLayer().transform = CATransform3DIdentity
            }, completion: nil)
            
            for (index, subButton) in self.subButtons.reversed().enumerated() {
                UIView.animate(withDuration: 0.35, delay: 0.04*TimeInterval(index), usingSpringWithDamping: 0.7, initialSpringVelocity: 0, options: [], animations: {
                    subButton.layer.transform = CATransform3DMakeScale(0.4, 0.4, 0.4)
                    subButton.alpha = 0
                    
                }, completion: nil)
            }
        }
        
        currentState = .collapsed
    }
    
}

extension FAB {
    override open func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        if touches.count == 1 && touches.first?.tapCount == 1 && touches.first?.location(in: self) != nil {
            CATransaction.begin()
            CATransaction.setDisableActions(true)
            layer.addSublayer(tintLayer(origin: (touches.first?.location(in: self))!))
            CATransaction.commit()
        }
    }
    
    override open func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        _tintLayer.removeFromSuperlayer()
        if touches.count == 1 && touches.first?.tapCount == 1 && touches.first?.location(in: self) != nil {
            expandOrCollapse()
        }
    }
}
