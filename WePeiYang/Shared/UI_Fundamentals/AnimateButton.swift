//
//  AnimateButton.swift
//  WePeiYang
//
//  Created by Halcao on 2018/3/11.
//  Copyright © 2018年 twtstudio. All rights reserved.
//

import UIKit

class AnimateButton: CardButton {

    let shrinkDuration: CFTimeInterval = 0.1
    let shrinkCurve = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
    let expandCurve = CAMediaTimingFunction(controlPoints: 0.95, 0.02, 1, 0.05)

    func shrink() {
        let shrinkAnim = CABasicAnimation(keyPath: "bounds.size.width")
        shrinkAnim.fromValue = frame.width
        shrinkAnim.toValue = frame.height
        shrinkAnim.duration = shrinkDuration
//        shrinkAnim.timingFunction = shrinkCurve
        shrinkAnim.fillMode = kCAFillModeForwards
        shrinkAnim.isRemovedOnCompletion = false
        layer.add(shrinkAnim, forKey: shrinkAnim.keyPath)
    }

    func expand() {
        let expandAnim = CABasicAnimation(keyPath: "transform.scale")
        expandAnim.fromValue = 1.0
        expandAnim.toValue = 26.0
        expandAnim.timingFunction = expandCurve
        expandAnim.duration = 0.3
//        expandAnim.delegate = self
        expandAnim.fillMode = kCAFillModeForwards
        expandAnim.isRemovedOnCompletion = false
        layer.add(expandAnim, forKey: expandAnim.keyPath)
    }

}

//extension AnimateButton: CAAnimationDelegate {
//    open func startFinishAnimation(_ delay: TimeInterval, completion:(()->())?) {
////        Timer.schedule(delay: delay) { timer in
//            self.didEndFinishAnimation = completion
//            self.expand()
//            self.spiner.stopAnimation()
////        }
//    }
//
//    public func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
//        let a = anim as! CABasicAnimation
//        if a.keyPath == "transform.scale" {
//            didEndFinishAnimation?()
////            Timer.schedule(delay: 1) { timer in
//                self.returnToOriginalState()
////            }
//        }
//    }
//}

