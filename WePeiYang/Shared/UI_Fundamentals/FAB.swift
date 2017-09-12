//
//  FAB.swift
//  WePeiYang
//
//  Created by Allen X on 7/5/17.
//  Copyright © 2017 twtstudio. All rights reserved.
//

import UIKit

fileprivate var screenWidth = UIScreen.main.bounds.size.width
fileprivate var screenHeight = UIScreen.main.bounds.size.height

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
    public var edgePaddingX: CGFloat = 26
    public var edgePaddingY: CGFloat = 26
    
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
    
    fileprivate var contextViewSize: CGSize {
        return (containerView?.bounds.size)!
    }
    
    fileprivate var didAddOtherViews = false
    fileprivate var currentState: FABState = .collapsed
    
    fileprivate var parentViewController: UIViewController? {
        get {
            if let result = traverseResponderChainForViewController() {
                return result as? UIViewController
            }
            // actually this part won't be needed
            return nil
        }
    }
    
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
    
    public var cornerRadius: CGFloat {
        return buttonWidth / 2
    }
    
    
    
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
            _tintLayer.cornerRadius = buttonWidth/2.5
            _tintLayer.frame = CGRect(origin: origin, size: CGSize(width: buttonWidth/1.25, height: buttonHeight/1.25))
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
            layer.cornerRadius = cornerRadius
            layer.shadowOpacity = 0.5
            layer.shadowRadius = 6
            layer.shadowOffset = CGSize(width: 0, height: 7)
        }
        
        if mainAction != nil {
            add(for: .touchUpInside, (mainAction?.function)!)
            // TODO: finish this
        }
        

        for subAction in subActions {
            let button = UIButton()
            button.add(for: .touchUpInside, subAction.function)
            button.setTitle(subAction.name, for: .normal)
            button.titleLabel?.font = .systemFont(ofSize: 18)
            
            button.layer.cornerRadius = 4
            button.layer.backgroundColor = Metadata.Color.WPYAccentColor.cgColor
            button.layer.shadowOpacity = 0.35
            button.layer.shadowRadius = 6
            button.layer.shadowOffset = CGSize(width: 0, height: 7)
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
    
    // FIXME: this group animation is weird
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
                    subButton.layer.transform = CATransform3DMakeScale(0.2, 0.2, 0.2)
                    subButton.alpha = 0
                    
                }, completion: nil)
            }
        }
        
        currentState = .collapsed
    }
    
}

// MARK: Touch event handling
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

// MARK: Rectify method for some misuses
extension FAB {
    // Call this after you add FAB as a subview **ONLY** if you're having some frame issues (like it's not placed at the right_bottom of the screen)
    // Calling rectify() will solve the frame problem in most cases (no promise though)
    public func rectify() {
        let topVC = UIViewController.topViewController()
        if parentViewController != topVC {
            log.errorMessage("You're not adding your fab into a topmost view, which might lead to a wrong position for the fab")/
            
            if topVC is UITabBarController {
                removeFromSuperview()
                topVC?.view.addSubview(self)
                for subButton in subButtons {
                    subButton.removeFromSuperview()
                    topVC?.view.addSubview(subButton)
                }
                dimView.removeFromSuperview()
                topVC?.view.addSubview(dimView)
                log.errorMessage("FAB has rectified itself. Now your fab's superview has changed into the \(String(describing: topVC!))")/
                log.errorMessage("BTW, you should not add a FAB when there's a TabBar on the bottom of your screen")/
                return
            }
            
            if topVC is UINavigationController && !(parentViewController is UITableViewController) {
                let navHeight = parentViewController!.navigationController != nil ? parentViewController!.navigationController!.navigationBar.frame.size.height : 0
                let rectifyingHeight = UIApplication.shared.statusBarFrame.height + navHeight
                
                frame = CGRect(x: screenWidth-buttonWidth-edgePaddingX, y: screenHeight-buttonHeight-edgePaddingY-rectifyingHeight, width: buttonWidth, height: buttonHeight)
                let bottomLineAt = frame.origin.y
                for (index, subButton) in subButtons.enumerated() {
                    let width = subButton.bounds.size.width
                    let height = subButton.bounds.size.height
                    subButton.frame = CGRect(x: screenWidth-width-30, y: bottomLineAt-CGFloat(index+1)*(20+height), width: width, height: height)
                }
                log.errorMessage("FAB has rectified itself, its position has been elevated by \(rectifyingHeight) in the yAxis")/
                
                return
            }
        }
    }
}


extension FAB {
    fileprivate func setObserver() {
//        NotificationCenter.default.addObserver(self, selector: <#T##Selector#>, name: <#T##NSNotification.Name?#>, object: <#T##Any?#>)
    }
    
    override open func willMove(toSuperview newSuperview: UIView?) {
        if UIDeviceOrientationIsPortrait(.portrait) {
            frame = CGRect(x: screenWidth-buttonWidth-edgePaddingX, y: screenHeight-buttonHeight-edgePaddingY, width: buttonWidth, height: buttonHeight)
            let bottomLineAt = frame.origin.y
            // FIXME: fix this rotating animation
            plusSignLayer().transform = CATransform3DMakeRotation(2/3*CGFloat.pi, 0, 0, 1)
            layer.transform = CATransform3DMakeScale(0.2, 0.2, 0.2)
            
            
            for (index, subButton) in subButtons.enumerated() {
                let fooLabel = UILabel(text: (subButton.titleLabel?.text)!, fontSize: 18)
                let width = fooLabel.bounds.size.width + 8
                let height = fooLabel.bounds.size.height + 4
                subButton.frame = CGRect(x: screenWidth-width-30, y: bottomLineAt-CGFloat(index+1)*(20+height), width: width, height: height)
                subButton.layer.transform = CATransform3DMakeScale(0.2, 0.2, 0.2)
            }
        }
        
    }
    
    override open func didMoveToSuperview() {
        showUp()
    }
}


fileprivate extension UIResponder {
    func traverseResponderChainForViewController() -> UIResponder? {
        guard !(self is UIViewController) else {
            return self
        }
        
        if next is UIViewController {
            return next
        } else if next is UIView {
            return next?.traverseResponderChainForViewController()
        } else {
            return nil
        }
    }
}
