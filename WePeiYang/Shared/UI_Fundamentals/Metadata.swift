//
//  Metadata.swift
//  WePeiYang
//
//  Created by Allen X on 3/16/17.
//  Copyright © 2017 twtstudio. All rights reserved.
//

import Foundation
import UIKit

struct Metadata {
    
    struct Color {
        
        // Global view background color including displayP3. Can be used on general views of some viewcontrollers
        // Hex = FFFFFF
        @available(iOS 10.0, *)
        static let GlobalViewBackgroundColorP3 = UIColor(displayP3Red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        static let GlobalViewBackgroundColor = UIColor(hue: 0.0, saturation: 0.0, brightness: 1.0, alpha: 1.0)
        
        // Global WePeiYang accent color including displayP3. Can be used on buttons, bars, etc
        // Hex = 00A1E9
        @available(iOS 10.0, *)
        static let WPYAccentColorP3 = UIColor(displayP3Red: 0, green: 161.0/255.0, blue: 233.0/255.0, alpha: 1.0)
        
        static let WPYAccentColor = UIColor(hue: 199.0/360.0, saturation: 1.0, brightness: 0.91, alpha: 1.0)
        
        
        // Global tabbar background color including displayP3. Can be used on tabbars
        // Hex = FFFFFF
        @available(iOS 10.0, *)
        static let GlobalTabBarBackgroundColorP3 = UIColor(displayP3Red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        
        static let GlobalTabBarBackgroundColor = UIColor(hue: 0.0, saturation: 0.0, brightness: 1.0, alpha: 1.0)
        
        
        // Color for important texts like titles
        // Hex = 333333
        @available(iOS 10.0, *)
        static let darkTextColorP3 = UIColor(displayP3Red: 51.0/255.0, green: 51.0/255.0, blue: 51.0/255.0, alpha: 1.0)
        
        static let darkTextColor = UIColor(hue: 0.0, saturation: 0.0, brightness: 0.2, alpha: 1.0)
        
        
        // Color for titlelabel in NavigationBars and else
        // Hex = FFFFFF
        @available(iOS 10.0, *)
        static let naviTextColorP3 = UIColor(displayP3Red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        
        static let naviTextColor = UIColor(hue: 0.0, saturation: 0.0, brightness: 1.0, alpha: 1.0)
        
        
        // Color for normal texts like some guiding words or paragraphs
        // Hex = 666666
        @available(iOS 10.0, *)
        static let normalTextColorP3 = UIColor(displayP3Red: 102.0/255.0, green: 102.0/255.0, blue: 102.0/255.0, alpha: 1.0)
        
        static let normalTextColor = UIColor(hue: 0.0, saturation: 0.0, brightness: 0.4, alpha: 1.0)
        
        
        // Color for secondary texts like "view more"
        // Hex = 999999
        @available(iOS 10.0, *)
        static let secondaryTextColorP3 = UIColor(displayP3Red: 153.0/255.0, green: 153.0/255.0, blue: 153.0/255.0, alpha: 1.0)
        
        static let secondaryTextColor = UIColor(hue: 0.0, saturation: 0.0, brightness: 0.6, alpha: 1.0)
        
        
        // Color for gray icons like the untapped(to-be-tapped) tab icons.
        // Hex = C8CCD3
        @available(iOS 10.0, *)
        static let grayIconColorP3 = UIColor(displayP3Red: 200.0/255.0, green: 204.0/255.0, blue: 211.0/255.0, alpha: 1.0)
        
        static let grayIconColor = UIColor(hue: 218.0/360.0, saturation: 0.05, brightness: 0.83, alpha: 1.0)
        
        
        // Color for split lines
        // Hex = D9D9D9
        @available(iOS 10.0, *)
        static let splitLineColorP3 = UIColor(displayP3Red: 217.0/255.0, green: 217.0/255.0, blue: 217.0/255.0, alpha: 1.0)
        
        static let splitLineColor = UIColor(hue: 0.0, saturation: 0.0, brightness: 0.85, alpha: 1.0)
        
        
        // Color for split blocks (thick lines)
        // Hex = EEEEEE
        @available(iOS 10.0, *)
        static let splitBlockColorP3 = UIColor(displayP3Red: 238.0/255.0, green: 238.0/255.0, blue: 238.0/255.0, alpha: 1.0)
        
        static let splitBlockColor = UIColor(hue: 0.0, saturation: 0.0, brightness: 0.93, alpha: 1.0)
        
        
        // Color for Assistive Elements
        
    }
    
    struct Font {
   
    }
    
    struct Size {
        
//        struct Screen {
//            
//            static let width = UIScreen.main.bounds.width
//            static let height = UIScreen.main.bounds.height
//        }
//        
//        struct Button {
//            static let
//        }
    }
    
    struct Time {
        
    }
}
