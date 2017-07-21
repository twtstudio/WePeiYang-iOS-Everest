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
        if subview is RateView || subview is UIVisualEffectView {
            UIViewController.current?.navigationItem.setHidesBackButton(false, animated: true)
        }
    }
}
