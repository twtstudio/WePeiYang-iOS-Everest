//
//  ThemeChanging.swift
//  WePeiYang
//
//  Created by Allen X on 3/16/17.
//  Copyright © 2017 twtstudio. All rights reserved.
//

import Foundation

enum WPYTheme: String {
    case night
    
    // more to be designed
}

protocol ThemeChanging {
    
    // Requires every conforming type to have an instance method of the theme changing
    func changeInto(theme: WPYTheme)
}
