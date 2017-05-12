//
//  ViewController.swift
//  WePeiYang
//
//  Created by Allen X on 3/7/17.
//  Copyright © 2017 twtstudio. All rights reserved.
//

import UIKit
import SnapKit

fileprivate let navOffset = 64 // (navigationBarHeight + statusBarHeight)

class ViewController: UIViewController {
    
    
//    static func generateCardView() -> CardView {
//        
//    }

    // The below override will not be called if current viewcontroller is controlled by a UINavigationController
    // We should do self.navigationController.navigationBar.barStyle = UIBarStyleBlack
    //    override var preferredStatusBarStyle: UIStatusBarStyle {
    //        return .lightContent
    //    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationController?.navigationBar.barStyle = .black
        navigationController?.navigationBar.barTintColor = Metadata.Color.WPYAccentColor
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: Metadata.Color.naviTextColor]
        
        navigationItem.title = "常用"
                
        let btn1 = SpringButton(title: "Hola", titleColor: .white, backgroundColor: Metadata.Color.WPYAccentColor)
        view.backgroundColor = .white
        if #available(iOS 10.0, *) {
            let btn2 = SpringButton(title: "HolaP3", titleColor: .white, backgroundColor: Metadata.Color.WPYAccentColorP3)
            
            view.addSubview(btn1)
            view.addSubview(btn2)
            
            btn1.snp.makeConstraints {
                make in
                make.top.equalTo(view).offset(navOffset + 10)
                make.centerX.equalTo(view)
            }
            
            btn2.snp.makeConstraints {
                make in
                make.top.equalTo(btn1.snp.bottom).offset(30)
                make.centerX.equalTo(view)
            }
            
            
        } else {
            
        }
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

