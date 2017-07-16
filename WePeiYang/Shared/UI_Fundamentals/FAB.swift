//
//  FAB.swift
//  WePeiYang
//
//  Created by Allen X on 7/5/17.
//  Copyright © 2017 twtstudio. All rights reserved.
//

import UIKit

private let screenWidth = UIScreen.main.bounds.size.width
private let screenHeight = UIScreen.main.bounds.size.height

private enum FABState {
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
    
    private var mainButton: UIButton!
    private var dimView: UIView!
    private var subButtons: [UIButton] = []
    private var currentState: FABState = .collapsed
    
    private var containerView: UIView? {
        get {
            return superview
        }
    }
    
    private var didAddOtherViews = false
    
    // Different button size for different orientations and screen sizes
    public var buttonWidth: CGFloat = {
        return screenWidth > Metadata.Size.smallPhonePortraitWidth ? 80 : 60
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
    private var titleLabelFont: UIFont = {
        return screenWidth > Metadata.Size.smallPhonePortraitWidth ? UIFont.systemFont(ofSize: 42) : UIFont.systemFont(ofSize: 32)
    }()
    
    
    convenience init(mainAction: Action? = nil, subActions: [Action]) {
        self.init()
        setTitle("+", for: .normal)
//        titleLabel?.baselineAdjustment = .none
        contentVerticalAlignment = .top
        contentHorizontalAlignment = .center
        titleEdgeInsets = UIEdgeInsets(top: 10, left: 0, bottom: 0, right: 0)
        titleLabel?.font = titleLabelFont
        backgroundColor = .red
    
        if UIDeviceOrientationIsPortrait(.portrait) {
            frame = CGRect(x: screenWidth-buttonWidth-30, y: screenHeight-buttonHeight-30, width: buttonWidth, height: buttonHeight)
            layer.cornerRadius = buttonWidth / 2
            layer.shadowOpacity = 0.5
            layer.shadowRadius = 6
            layer.shadowOffset = CGSize(width: 0, height: 0)
            
            
            // FIXME: fix this rotating animation
            // Seems two animations cannot be performed simultaneously
            // Gotta find a way out because the rotating animation is important
//            layer.transform = CATransform3DMakeRotation(2/3*CGFloat.pi, 0, 0, 1)
            layer.transform = CATransform3DMakeScale(0.2, 0.2, 0.2)
            
            
        }
        
        
        showUp()
        
        if mainAction != nil {
            add(for: .touchUpInside, (mainAction?.function)!)
            // TODO: finish this
        }
        
        addTarget(self, action: #selector(expandOrCollapse), for: .touchUpInside)

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
        }) { flag in
            
        }
    }
    
    
    // may need to do scrollView watching?
    public func dismiss(animated: Bool) {
        if animated {
            expandOrCollapse()
        } else {
            
        }
    }
    

    // Expand the subButtons
    internal func expandOrCollapse() {
        switch currentState {
        case .collapsed:
            expand()
            break
            
        case .expanded:
            collapse()
        }

    }
    
    internal func expand() {
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
                self.layer.transform = CATransform3DMakeRotation(0.25*CGFloat.pi, 0, 0, 1)
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
    internal func collapse() {
        
        guard currentState == .expanded else {
            return
        }
        
        UIView.animate(withDuration: 0.3) {
            self.dimView.alpha = 0
            
            UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0, options: [.curveEaseIn], animations: {
                self.layer.transform = CATransform3DIdentity
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
