//
//  BookDetailViewControllerTempView.swift
//  WePeiYang
//
//  Created by Allen X on 11/3/16.
//  Copyright © 2016 Qin Yubo. All rights reserved.
//

import UIKit

class BookDetailViewControllerTempView: UIView {
    override func willRemoveSubview(_ subview: UIView) {
        if let _ = subview as? RateView, let _ = subview as? UIVisualEffectView {
            // FIXME: ????????? ALWAYS FAIL
//            UIViewController.current.
        }
    }
//    override func removeFromSuperview() {
//        
//    }
//    
//    override func willRemoveSubview(subview: UIView) {
//        if subview.isKindOfClass(RateView) || subview.isKindOfClass(UIVisualEffectView) {
//            UIViewController.currentViewController().navigationItem.setHidesBackButton(false, animated: true)
//        }
//    }
}
