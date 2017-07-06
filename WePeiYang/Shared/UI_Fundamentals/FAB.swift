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

class FAB: UIButton {
    
    /*
     // Only override draw() if you perform custom drawing.
     // An empty implementation adversely affects performance during animation.
     override func draw(_ rect: CGRect) {
     // Drawing code
     }
     */

    
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
    
    // Different frames for different orientations and screen sizes
    private var buttonWidth: CGFloat = {
        return screenWidth > Metadata.Size.smallPhonePortraitWidth ? 80 : 60
    }()
    
    private var buttonHeight: CGFloat {
        get {
            return buttonWidth
        }
    }
    
    var buttonSize: CGSize {
        get {
            return CGSize(width: buttonWidth, height: buttonWidth)
        }
    }
    
    convenience init(mainAction: Action? = nil, subActions: [Action]) {
        self.init()
    
        backgroundColor = .red
    
        if UIDeviceOrientationIsPortrait(.portrait) {
            frame = CGRect(x: screenWidth-buttonWidth-30, y: screenHeight-buttonHeight-30, width: buttonWidth, height: buttonHeight)
            layer.cornerRadius = buttonWidth / 2
            layer.transform = CATransform3DMakeTranslation(0, (buttonHeight+40), 0)
        }
        
        
        popUp()
        
        if mainAction != nil {
            addFunction((mainAction?.function)!, for: .touchUpInside)
            // TODO: finish this
        }
        
        addTarget(self, action: #selector(expandOrCollapse), for: .touchUpInside)

        
        let bottomLineAt = frame.origin.y
        for (index, subAction) in subActions.enumerated() {
            let button = UIButton()
            button.addFunction(subAction.function, for: .touchUpInside)
            button.setTitle(subAction.name, for: .normal)
            
            
            // TODO: Change to Metadata.Font
            button.titleLabel?.font = .systemFont(ofSize: 18)
            
            let fooLabel = UILabel(text: subAction.name, fontSize: 18)
            let width = fooLabel.bounds.size.width + 8
            let height = fooLabel.bounds.size.height + 4

            button.frame = CGRect(x: screenWidth-width-30, y: bottomLineAt-CGFloat(index+1)*(6+height), width: width, height: height)
//            button.frame = CGRect(x: screenWidth-width-30, y: CGFloat(index+1)*(-6-height), width: width, height: height)
            button.layer.cornerRadius = 4
            button.backgroundColor = Metadata.Color.WPYAccentColor
            
            button.layer.transform = CATransform3DMakeTranslation(0, 6+height, 0)
            button.alpha = 0
            
            subButtons.append(button)
            
        }
        
        
        dimView = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height))
        dimView.backgroundColor = .black
        dimView.alpha = 0;
        
    }
    
    
    func popUp() {
        UIView.animate(withDuration: 0.8, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0, options: [.curveEaseIn], animations: {
            self.layer.transform = CATransform3DIdentity
        }) { flag in
            
        }
    }
    
    
    // may need to do scrollView watching?
    func dismissAnimated() {
        
    }
    

    // Expand the subButtons
    func expandOrCollapse() {
        
        switch currentState {
        case .collapsed:
            if !didAddOtherViews {
                containerView?.insertSubview(dimView, belowSubview: self)
                for subButton in subButtons {
                    containerView?.insertSubview(subButton, aboveSubview: dimView)
                    log.any(subButton.frame)/
                    log.word((subButton.titleLabel?.text)!)/
                }
                didAddOtherViews = true
            }
            
            UIView.animate(withDuration: 0.7) {
                self.dimView.alpha = 0.5
                for (index, subButton) in self.subButtons.enumerated() {
                    UIView.animate(withDuration: 0.6, delay: 0.1*(TimeInterval(index)+1), usingSpringWithDamping: 0.7, initialSpringVelocity: 0, options: [], animations: {
                        subButton.layer.transform = CATransform3DIdentity
                        subButton.alpha = 1
                    }, completion: nil)
                }
                
            }
            currentState = .expanded
            break
            
        case .expanded:
            UIView.animate(withDuration: 0.7) {
                self.dimView.alpha = 0
                
                for (index, subButton) in self.subButtons.enumerated() {
                    UIView.animate(withDuration: 0.6, delay: 0.1*(TimeInterval(index)+1), usingSpringWithDamping: 0.7, initialSpringVelocity: 0, options: [], animations: {
                        subButton.layer.transform = CATransform3DMakeTranslation(0, 6+subButton.bounds.size.height, 0)
                        subButton.alpha = 0
                        
                    }, completion: nil)
                }
            }
            
            currentState = .collapsed
        }

    }
    
    // Collapse the list the subButtons
    func collapse() {
        guard currentState == .expanded else {
            return
        }
        
        
        UIView.animate(withDuration: 0.7) {
            self.dimView.alpha = 0
            
            
            for (index, subButton) in self.subButtons.enumerated() {
                UIView.animate(withDuration: 0.6, delay: 0.1*(TimeInterval(index)+1), usingSpringWithDamping: 0.7, initialSpringVelocity: 0, options: [], animations: {
                    subButton.layer.transform = CATransform3DMakeTranslation(0, 6+subButton.bounds.size.height, 0)
                    subButton.alpha = 0
                    
                }, completion: nil)
            }
        }
        
        
        
        currentState = .collapsed
    }
    
}
