//
//  FAB.swift
//  WePeiYang
//
//  Created by Allen X on 7/5/17.
//  Copyright © 2017 twtstudio. All rights reserved.
//

import UIKit



class FAB: UIButton {
    
    /*
     // Only override draw() if you perform custom drawing.
     // An empty implementation adversely affects performance during animation.
     override func draw(_ rect: CGRect) {
     // Drawing code
     }
     */
    
    private var subButtons: [UIButton] = []
    
    convenience init(mainAction: Action? = nil, subActions: [Action]) {
        self.init()
        
        if mainAction != nil {
            addFunction((mainAction?.function)!, for: .touchUpInside)
            // TODO: finish this
        }
        
        for subAction in subActions {
            let button = UIButton()
            button.addFunction(subAction.function, for: .touchUpInside)
            
        }
        
        
    }

    // Expand the subButtons
    func expand() {
        
        let dimView = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height))
        dimView.backgroundColor = .black
        dimView.alpha = 0;
        superview?.insertSubview(dimView, belowSubview: self)
        UIView.animate(withDuration: 0.7) {
            dimView.alpha = 0.5
        }
        
        for subButton in subButtons {
            
        }
    }
    
    // Collapse the list the subButtons
    func collapse() {
        
    }
    
}
