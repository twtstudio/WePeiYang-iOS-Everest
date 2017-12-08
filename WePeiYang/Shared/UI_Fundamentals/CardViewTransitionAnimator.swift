//
//  CardViewTransitionAnimator.swift
//  WePeiYang
//
//  Created by Halcao on 2017/12/6.
//  Copyright © 2017年 twtstudio. All rights reserved.
//

import UIKit

class CardViewTransitionAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    fileprivate var isPresenting: Bool
    fileprivate var velocity = 0.7
    var originalFrame: CGRect
    
    init(isPresenting: Bool, originalFrame: CGRect) {
        self.isPresenting = isPresenting
        self.originalFrame = originalFrame
        super.init()
    }
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return velocity
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let toVC = transitionContext.viewController(forKey: .to)!
        let fromVC = transitionContext.viewController(forKey: .from)!
        let containerView = transitionContext.containerView
        containerView.backgroundColor = .white
        
        //        let toView = toVC.view!
        //        let fromView = fromVC.view!
        let toView = transitionContext.view(forKey: .to)!
        let fromView = transitionContext.view(forKey: .from)!
        
        if isPresenting {
            containerView.addSubview(toView)
            //            toView.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
            toView.frame = originalFrame
            UIView.animate(withDuration: velocity, delay: 0, usingSpringWithDamping: 0.9, initialSpringVelocity: 0, options: .allowAnimatedContent, animations: {
                //                toView.transform = CGAffineTransform(scaleX: 1, y: 1)
                toView.frame = transitionContext.finalFrame(for: toVC)
            }, completion: { isFinished in
                let wasCanceled = transitionContext.transitionWasCancelled
                transitionContext.completeTransition(!wasCanceled)
            })
        } else {
            //            containerView.addSubview(toView)
            containerView.insertSubview(toView, belowSubview: fromView)
            UIView.animate(withDuration: velocity, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0, options: .curveEaseOut, animations: {
//                fromView.alpha = 0
                fromView.frame = self.originalFrame
            }, completion: { isFinished in
                fromView.removeFromSuperview()
                let wasCanceled = transitionContext.transitionWasCancelled
                transitionContext.completeTransition(!wasCanceled)
            })
        }
    }
}

