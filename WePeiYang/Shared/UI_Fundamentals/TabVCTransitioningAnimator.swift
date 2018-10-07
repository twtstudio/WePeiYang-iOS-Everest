//
//  TabVCTransitioningAnimator.swift
//  WePeiYang
//
//  Created by Allen X on 5/12/17.
//  Copyright © 2017 twtstudio. All rights reserved.
//

import UIKit

enum TransitionDirection {
    case left
    case right
}

class TabVCTransitioningAnimator: NSObject, UIViewControllerAnimatedTransitioning {

    private var transitionDirection: TransitionDirection

    init(direction: TransitionDirection) {
        self.transitionDirection = direction
        super.init()
    }

    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.4
    }

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {

        //Container View
        let inView = transitionContext.containerView
        var translationX = inView.frame.width

        let fromView = transitionContext.view(forKey: .from)
        let toView = transitionContext.view(forKey: .to)

        translationX = transitionDirection == .left ? translationX : -translationX
        let fromViewTransform = CGAffineTransform(translationX: translationX, y: 0)
        let toViewTransform = CGAffineTransform(translationX: -translationX, y: 0)

        inView.addSubview(toView!)

        let duration = transitionDuration(using: transitionContext)

        toView?.transform = toViewTransform

        UIView.animate(withDuration: duration, delay: 0, usingSpringWithDamping: 0.9, initialSpringVelocity: 0, options: [.allowAnimatedContent, .curveEaseInOut], animations: {
            fromView?.transform = fromViewTransform
            toView?.transform = CGAffineTransform.identity
        }) { _ in
            fromView?.transform = CGAffineTransform.identity
            toView?.transform = CGAffineTransform.identity
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        }
    }

}
