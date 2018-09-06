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

        // Material Colors
        static let fluentColors = [UIColor(red: 255.0/255.0, green: 185.0/255.0, blue: 0.0/255.0, alpha: 1),
                                   UIColor(red: 231.0/255.0, green: 72.0/255.0, blue: 86.0/255.0, alpha: 1),
                                   UIColor(red: 0.0/255.0, green: 120.0/255.0, blue: 215.0/255.0, alpha: 1),
                                   UIColor(red: 0.0/255.0, green: 153.0/255.0, blue: 188.0/255.0, alpha: 1),
                                   UIColor(red: 122.0/255.0, green: 117.0/255.0, blue: 116.0/255.0, alpha: 1),
                                   UIColor(red: 118.0/255.0, green: 118.0/255.0, blue: 118.0/255.0, alpha: 1),
                                   UIColor(red: 255.0/255.0, green: 140.0/255.0, blue: 0.0/255.0, alpha: 1),
                                   UIColor(red: 232.0/255.0, green: 17.0/255.0, blue: 35.0/255.0, alpha: 1),
                                   UIColor(red: 0.0/255.0, green: 99.0/255.0, blue: 177.0/255.0, alpha: 1),
                                   UIColor(red: 45.0/255.0, green: 125.0/255.0, blue: 154.0/255.0, alpha: 1),
                                   UIColor(red: 93.0/255.0, green: 90.0/255.0, blue: 88.0/255.0, alpha: 1),
                                   UIColor(red: 76.0/255.0, green: 74.0/255.0, blue: 72.0/255.0, alpha: 1),
                                   UIColor(red: 247.0/255.0, green: 99.0/255.0, blue: 12.0/255.0, alpha: 1),
                                   UIColor(red: 234.0/255.0, green: 0.0/255.0, blue: 94.0/255.0, alpha: 1),
                                   UIColor(red: 142.0/255.0, green: 140.0/255.0, blue: 216.0/255.0, alpha: 1),
                                   UIColor(red: 0.0/255.0, green: 183.0/255.0, blue: 195.0/255.0, alpha: 1),
                                   UIColor(red: 104.0/255.0, green: 118.0/255.0, blue: 138.0/255.0, alpha: 1),
                                   UIColor(red: 105.0/255.0, green: 121.0/255.0, blue: 126.0/255.0, alpha: 1),
                                   UIColor(red: 202.0/255.0, green: 80.0/255.0, blue: 16.0/255.0, alpha: 1),
                                   UIColor(red: 195.0/255.0, green: 0.0/255.0, blue: 82.0/255.0, alpha: 1),
                                   UIColor(red: 107.0/255.0, green: 105.0/255.0, blue: 214.0/255.0, alpha: 1),
                                   UIColor(red: 3.0/255.0, green: 131.0/255.0, blue: 135.0/255.0, alpha: 1),
                                   UIColor(red: 81.0/255.0, green: 92.0/255.0, blue: 107.0/255.0, alpha: 1),
                                   UIColor(red: 74.0/255.0, green: 84.0/255.0, blue: 89.0/255.0, alpha: 1),
                                   UIColor(red: 218.0/255.0, green: 59.0/255.0, blue: 1.0/255.0, alpha: 1),
                                   UIColor(red: 227.0/255.0, green: 0.0/255.0, blue: 140.0/255.0, alpha: 1),
                                   UIColor(red: 135.0/255.0, green: 100.0/255.0, blue: 184.0/255.0, alpha: 1),
                                   UIColor(red: 0.0/255.0, green: 178.0/255.0, blue: 148.0/255.0, alpha: 1),
                                   UIColor(red: 86.0/255.0, green: 124.0/255.0, blue: 115.0/255.0, alpha: 1),
                                   UIColor(red: 100.0/255.0, green: 124.0/255.0, blue: 100.0/255.0, alpha: 1),
                                   UIColor(red: 239.0/255.0, green: 105.0/255.0, blue: 80.0/255.0, alpha: 1),
                                   UIColor(red: 191.0/255.0, green: 0.0/255.0, blue: 119.0/255.0, alpha: 1),
                                   UIColor(red: 116.0/255.0, green: 77.0/255.0, blue: 169.0/255.0, alpha: 1),
                                   UIColor(red: 1.0/255.0, green: 133.0/255.0, blue: 116.0/255.0, alpha: 1),
                                   UIColor(red: 72.0/255.0, green: 104.0/255.0, blue: 96.0/255.0, alpha: 1),
                                   UIColor(red: 82.0/255.0, green: 94.0/255.0, blue: 84.0/255.0, alpha: 1),
                                   UIColor(red: 209.0/255.0, green: 52.0/255.0, blue: 56.0/255.0, alpha: 1),
                                   UIColor(red: 194.0/255.0, green: 57.0/255.0, blue: 179.0/255.0, alpha: 1),
                                   UIColor(red: 177.0/255.0, green: 70.0/255.0, blue: 194.0/255.0, alpha: 1),
                                   UIColor(red: 0.0/255.0, green: 204.0/255.0, blue: 106.0/255.0, alpha: 1),
                                   UIColor(red: 73.0/255.0, green: 130.0/255.0, blue: 5.0/255.0, alpha: 1),
                                   UIColor(red: 132.0/255.0, green: 117.0/255.0, blue: 69.0/255.0, alpha: 1),
                                   UIColor(red: 255.0/255.0, green: 67.0/255.0, blue: 67.0/255.0, alpha: 1),
                                   UIColor(red: 154.0/255.0, green: 0.0/255.0, blue: 137.0/255.0, alpha: 1),
                                   UIColor(red: 136.0/255.0, green: 23.0/255.0, blue: 152.0/255.0, alpha: 1),
                                   UIColor(red: 16.0/255.0, green: 137.0/255.0, blue: 62.0/255.0, alpha: 1),
                                   UIColor(red: 16.0/255.0, green: 124.0/255.0, blue: 16.0/255.0, alpha: 1),
                                   UIColor(red: 126.0/255.0, green: 115.0/255.0, blue: 95.0/255.0, alpha: 1)]
    }

    struct Font {

    }

    struct Size {

//        struct Screen {
//n//            static let width = UIScreen.main.bounds.width
//            static let height = UIScreen.main.bounds.height
//        }
//n//        struct Button {
//            static let
//        }
        static let bigPhonePortraitWidth: CGFloat = 414
        static let smallPhonePortraitWidth: CGFloat = 375
    }

    struct Time {

    }
}
