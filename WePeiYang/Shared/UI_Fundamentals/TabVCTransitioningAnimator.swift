//
//  TabVCTransitioningAnimator.swift
//  WePeiYang
//
//  Created by Allen X on 5/12/17.
//  Copyright © 2017 twtstudio. All rights reserved.
//

import UIKit

class TabVCTransitioningAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.7
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        //Container View
        let inView = transitionContext.containerView
        
        let fromView = transitionContext.view(forKey: .from)
        fromView?.isUserInteractionEnabled = false
        
        let toView = transitionContext.view(forKey: .to)
        
        
        guard toView != nil else {
            print("Cannot make displaying transitioning animation because toView is nil")
            return
        }
        inView.addSubview(toView!)
        
//        UIView.animate(withDuration: <#T##TimeInterval#>, animations: <#T##() -> Void#>, completion: <#T##((Bool) -> Void)?##((Bool) -> Void)?##(Bool) -> Void#>)
        
    }
    
}
