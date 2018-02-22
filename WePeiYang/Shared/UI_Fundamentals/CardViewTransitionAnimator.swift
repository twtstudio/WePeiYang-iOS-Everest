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
    fileprivate var velocity = 0.85
    var originalFrame: CGRect
    var cardImage: UIImage?
    
    init(isPresenting: Bool, originalFrame: CGRect, card: CardView? = nil) {
        self.isPresenting = isPresenting
        self.originalFrame = originalFrame
//        self.originalFrame = card?.frame ?? originalFrame
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
//        let container = transitionContext.containerView
//
//        var toView: UIView
//        var fromView: UIView
//        if let to = transitionContext.view(forKey: .to),
//            let from = transitionContext.view(forKey: .from) {
//            toView = to
//            fromView = from
//        } else {
//            toView = toVC.view!
//            fromView = fromVC.view!
//        }
//
//        let toFrame = transitionContext.initialFrame(for: toVC)
//        let fromFrame = transitionContext.initialFrame(for: fromVC)
//
//        container.addSubview(toView)
////        container.addSubview(fromView)
//
        if isPresenting {
//            container.bringSubview(toFront: toView)
//            toView.height = toView.width
//            UIView.animate(withDuration: velocity/2, animations: {
//                toView.height = toFrame.height
//            })
//
//            UIView.animate(withDuration: velocity/2, delay: velocity/2, options: UIViewAnimationOptions.curveEaseInOut, animations: {
//
//            }, completion: { _ in
//                transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
//            })
            push(from: fromVC, to: toVC, using: transitionContext)
        } else {


            pop(from: fromVC, to: toVC, using: transitionContext)
        }
    }


    func push1(from fromVC: UIViewController, to toVC: UIViewController, using transitionContext: UIViewControllerContextTransitioning) {
        guard let toView = transitionContext.view(forKey: .to) else {
            return
        }

        let blankView = UIView(frame: toView.frame)
        blankView.backgroundColor = .white

        let imgView = UIImageView(frame: originalFrame)
        imgView.image = cardImage
//        imgView.alpha = 1
//        toView.addSubview(imgView)
//        toView.alpha = 0
//        transitionContext.containerView.addSubview(toView)
        transitionContext.containerView.addSubview(blankView)
        transitionContext.containerView.addSubview(imgView)

        UIView.animate(withDuration: velocity/2, delay: 0, usingSpringWithDamping: 0.75, initialSpringVelocity: 0.1, options: .curveEaseInOut, animations: {
//            imgView.alpha = 1.0
            imgView.center = toView.center
//            toView.alpha = 1.0
        }, completion: { isFinished in
//            blankView.removeFromSuperview()
//            imgView.removeFromSuperview()

            UIView.animate(withDuration: self.velocity/2, delay: self.velocity/2, usingSpringWithDamping: 0.75, initialSpringVelocity: 0.1, options: .curveEaseInOut, animations: {
                imgView.frame = toView.frame
            }, completion: { isFinished in
                imgView.removeFromSuperview()
                blankView.removeFromSuperview()
                //            toVC.navigationController?.isNavigationBarHidden = false
                transitionContext.containerView.addSubview(toView)
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
            })
        })
    }

    func push(from fromVC: UIViewController, to toVC: UIViewController, using transitionContext: UIViewControllerContextTransitioning) {
        guard let toView = transitionContext.view(forKey: .to) else {
            return
        }

        let blankView = UIView(frame: toView.frame)
        blankView.backgroundColor = .black
        let imgView = fromVC.view.snapshotView(afterScreenUpdates: false)!
        let frontView = UIView(frame: originalFrame)
        frontView.backgroundColor = .white

        transitionContext.containerView.addSubview(blankView)
        transitionContext.containerView.addSubview(imgView)
        transitionContext.containerView.addSubview(frontView)

        UIView.animate(withDuration: velocity/2, delay: 0, usingSpringWithDamping: 0.75, initialSpringVelocity: 0.1, options: .curveEaseInOut, animations: {
            //            imgView.alpha = 1.0
            imgView.center = toView.center
            imgView.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
            imgView.alpha = 0.8
            //            toView.alpha = 1.0
        }, completion: { isFinished in
            //            blankView.removeFromSuperview()
            //            imgView.removeFromSuperview()
        })

        UIView.animate(withDuration: self.velocity/2, delay: self.velocity/2, usingSpringWithDamping: 0.75, initialSpringVelocity: 0.1, options: .curveEaseInOut, animations: {
            frontView.frame = toView.frame
        }, completion: { isFinished in
            frontView.removeFromSuperview()
            imgView.removeFromSuperview()
            blankView.removeFromSuperview()
            //            toVC.navigationController?.isNavigationBarHidden = false
            transitionContext.containerView.addSubview(toView)
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        })
    }

    func pop(from fromVC: UIViewController, to toVC: UIViewController, using transitionContext: UIViewControllerContextTransitioning) {
        guard let toView = transitionContext.view(forKey: .to) else {
            return
        }

        let blankView = UIView(frame: toView.frame)
        blankView.backgroundColor = .black
        let imgView = toView.snapshotView(afterScreenUpdates: true)!
        let frontView = fromVC.view.snapshotView(afterScreenUpdates: false)!

        transitionContext.containerView.addSubview(blankView)
        transitionContext.containerView.addSubview(imgView)
        transitionContext.containerView.addSubview(frontView)

        imgView.center = toView.center
        imgView.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
        imgView.alpha = 0.8

        UIView.animate(withDuration: velocity/2, delay: 0, options: .curveEaseOut, animations: {
            frontView.y += frontView.height
        }, completion: { isFinished in

        })
//        UIView.animate(withDuration: velocity/2, delay: 0, usingSpringWithDamping: 0.75, initialSpringVelocity: 0.1, options: .curveEaseInOut, animations: {
//            frontView.y += frontView.height
////            frontView.frame = self.originalFrame
//            //            imgView.alpha = 1.0
//            //            toView.alpha = 1.0
//        }, completion: { isFinished in
////            frontView.image = self.cardImage
////            frontView.removeFromSuperview()
//
//            //            blankView.removeFromSuperview()
//            //            imgView.removeFromSuperview()
//        })


//        UIView.animate(withDuration: velocity/2, delay: velocity/2, options: UIViewAnimationOptions., animations: {
//            imgView.center = toView.center
//            imgView.transform = CGAffineTransform.identity
//            imgView.alpha = 1
//        }, completion: { isFinished in
//            imgView.removeFromSuperview()
//            blankView.removeFromSuperview()
//            //            toVC.navigationController?.isNavigationBarHidden = false
//            transitionContext.containerView.addSubview(toView)
//            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
//        })

        UIView.animate(withDuration: self.velocity/2, delay: self.velocity/2, usingSpringWithDamping: 0.7, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
            imgView.center = toView.center
            imgView.transform = CGAffineTransform.identity
            imgView.alpha = 1
            //            frontView.frame = toView.frame
        }, completion: { isFinished in
            //            frontView.removeFromSuperview()
            imgView.removeFromSuperview()
            blankView.removeFromSuperview()
            //            toVC.navigationController?.isNavigationBarHidden = false
            transitionContext.containerView.addSubview(toView)
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        })

    }


    func pop1(from fromVC: UIViewController, to toVC: UIViewController, using transitionContext: UIViewControllerContextTransitioning) {
        guard let toView = transitionContext.view(forKey: .to) else {
            return
        }
        let blankView = UIView(frame: toView.frame)
        blankView.backgroundColor = .white

        let imgView = UIImageView()
        imgView.frame = toView.frame
        imgView.image = cardImage
//        imgView.alpha = 1
        //        toView.addSubview(imgView)
        //        toView.alpha = 0
        transitionContext.containerView.addSubview(blankView)
        transitionContext.containerView.addSubview(imgView)
        
        UIView.animate(withDuration: velocity/2, delay: 0, usingSpringWithDamping: 0.75, initialSpringVelocity: 0.1, options: .curveEaseInOut, animations: {
//            imgView.alpha = 1.0
            imgView.frame = self.originalFrame
            imgView.center = toView.center
            //            toView.alpha = 1.0
        }, completion: { isFinished in
            //            imgView.removeFromSuperview()
        })
        
        UIView.animate(withDuration: velocity/2, delay: velocity/2, usingSpringWithDamping: 0.75, initialSpringVelocity: 0.1, options: .curveEaseInOut, animations: {
            imgView.frame = self.originalFrame
        }, completion: { isFinished in
            blankView.removeFromSuperview()
            imgView.removeFromSuperview()
//            toVC.navigationController?.isNavigationBarHidden = true
            transitionContext.containerView.addSubview(toView)
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        })
        
    }
}

