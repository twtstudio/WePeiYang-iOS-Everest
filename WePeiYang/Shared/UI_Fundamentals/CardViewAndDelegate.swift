//
//  CardViewAndDelegate.swift
//  WePeiYang
//
//  Created by Allen X on 3/21/17.
//  Copyright © 2017 twtstudio. All rights reserved.
//

import Foundation
import UIKit

protocol HasCardView {
    
    
    static var card: CardView { get }
    
    static func generateCardView() -> CardView
    
    
}

public protocol CardViewDelegete: class, NSObjectProtocol {
    
    func cardWillRefresh()
    func cardDidRefresh()
}

public class CardView: UIView {
    
    
    //var foo: UITableViewDelegate
    
    func drawRect(rect: CGRect) {
        
        // Set this property to true to optimize the rendering of the View
        // But when setting isOpaque = true, we need to draw every inch of the view with non-transparent elements
        isOpaque = true

        
    }
    
    convenience init() {
        self.init()
    }
    
    
}

////extension of UIViewController to add a property
//extension UIViewController {
//    static func generateCardView() -> CardView {
//        
//    }
//
//    static var card: CardView {
//        get {
//            return generateCardView()
//        }
//        set {
//            
//        }
//    }
//
//    private struct fooPropertyStruct {
//        static var card: CardView? = nil
//    }
//    
//}
