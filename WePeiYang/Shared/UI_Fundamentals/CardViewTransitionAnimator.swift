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
    var cardImage: UIImage?
    
    init(isPresenting: Bool, originalFrame: CGRect, card: CardView? = nil) {
        self.isPresenting = isPresenting
        self.originalFrame = originalFrame
        self.originalFrame = card?.frame ?? originalFrame
        self.cardImage = card?.snapshot()
        super.init()
    }
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return velocity
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let fromVC = transitionContext.viewController(forKey: .from),
            let toVC = transitionContext.viewController(forKey: .to) else {
            return
        }
        if isPresenting {
            push(from: fromVC, to: toVC, using: transitionContext)
        } else {
            pop(from: fromVC, to: toVC, using: transitionContext)
        }
    }
    
    func push(from fromVC: UIViewController, to toVC: UIViewController, using transitionContext: UIViewControllerContextTransitioning) {
        guard let toView = transitionContext.view(forKey: .to) else {
            return
        }
        let imgView = UIImageView()
        imgView.frame = originalFrame
        imgView.image = cardImage
        imgView.alpha = 1
//        toView.addSubview(imgView)
//        toView.alpha = 0
        transitionContext.containerView.addSubview(imgView)
        
        UIView.animate(withDuration: velocity/2, delay: 0, usingSpringWithDamping: 0.75, initialSpringVelocity: 0.1, options: .curveEaseInOut, animations: {
            imgView.alpha = 1.0
            imgView.center = toView.center
//            toView.alpha = 1.0
        }, completion: { isFinished in
//            imgView.removeFromSuperview()
        })
        
        UIView.animate(withDuration: velocity/2, delay: velocity/2, usingSpringWithDamping: 0.75, initialSpringVelocity: 0.1, options: .curveEaseInOut, animations: {
            imgView.frame = toView.frame
        }, completion: { isFinished in
            imgView.removeFromSuperview()
            toVC.navigationController?.isNavigationBarHidden = false
            transitionContext.containerView.addSubview(toView)
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        })

    }

    func pop(from fromVC: UIViewController, to toVC: UIViewController, using transitionContext: UIViewControllerContextTransitioning) {
        guard let toView = transitionContext.view(forKey: .to) else {
            return
        }
        let imgView = UIImageView()
        imgView.frame = toView.frame
        imgView.image = cardImage
        imgView.alpha = 1
        //        toView.addSubview(imgView)
        //        toView.alpha = 0
        transitionContext.containerView.addSubview(imgView)
        
        UIView.animate(withDuration: velocity/2, delay: 0, usingSpringWithDamping: 0.75, initialSpringVelocity: 0.1, options: .curveEaseInOut, animations: {
            imgView.alpha = 1.0
            imgView.center = toView.center
            //            toView.alpha = 1.0
        }, completion: { isFinished in
            //            imgView.removeFromSuperview()
        })
        
        UIView.animate(withDuration: velocity/2, delay: velocity/2, usingSpringWithDamping: 0.75, initialSpringVelocity: 0.1, options: .curveEaseInOut, animations: {
            imgView.frame = self.originalFrame
        }, completion: { isFinished in
            imgView.removeFromSuperview()
            toVC.navigationController?.isNavigationBarHidden = true
            transitionContext.containerView.addSubview(toView)
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        })
        
    }
}

