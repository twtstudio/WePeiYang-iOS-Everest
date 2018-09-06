////
////  CardViewAndDelegate.swift
////  WePeiYang
////
////  Created by Allen X on 3/21/17.
////  Copyright © 2017 twtstudio. All rights reserved.
////
//
//import Foundation
//import UIKit
//
//protocol HasCardView {
//n//n//    static var card: CardView { get }
//n//    static func generateCardView() -> CardView
//n//n//}
//
//public protocol CardViewDelegete: class, NSObjectProtocol {
//n//    func cardWillRefresh()
//    func cardDidRefresh()
//}
//
//public class CardView: UIView {
//n//n//    //var foo: UITableViewDelegate
//n//    func drawRect(rect: CGRect) {
//n//        // Set this property to true to optimize the rendering of the View
//        // But when setting isOpaque = true, we need to draw every inch of the view with non-transparent elements
//        isOpaque = true
//
//n//    }
//n//    convenience init() {
//        self.init()
//    }
//n//n//}
//
//////extension of UIViewController to add a property
////extension UIViewController {
////    static func generateCardView() -> CardView {
////n////    }
////
////    static var card: CardView {
////        get {
////            return generateCardView()
////        }
////        set {
////n////        }
////    }
////
////    private struct fooPropertyStruct {
////        static var card: CardView? = nil
////    }
////n////}
