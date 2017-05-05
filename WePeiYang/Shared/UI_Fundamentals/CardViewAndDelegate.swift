//
//  CardViewAndDelegate.swift
//  WePeiYang
//
//  Created by Allen X on 3/21/17.
//  Copyright © 2017 twtstudio. All rights reserved.
//

import Foundation
import UIKit

protocol CardViewDelegate {
    var card: CardView { get set }
    
    
    
    
}

public class CardView: UIView {
    
    func drawRect(rect: CGRect) {
        
        // Set this property to true to optimize the rendering of the View
        // But when setting isOpaque = true, we need to draw every inch of the view with non-transparent elements
        isOpaque = true
        
        
        
        
    }
    
}
