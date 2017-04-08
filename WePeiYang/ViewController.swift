//
//  ViewController.swift
//  WePeiYang
//
//  Created by Allen X on 3/7/17.
//  Copyright © 2017 twtstudio. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        print(UIDevice.current.systemVersion)
        PhoneBook.checkVersion {
            
        }
//        TwTKeychain.shared.token = UserDefaults.standard.object(forKey: TOKEN_SAVE_KEY) as! String
//        
//        AccountManager.getToken(username: "nyz1500", password: "nyz1500chch6688", success: {
//            log.word("hi")/
//        }, failure: { error in
//            log.errorMessage("ho")/
//        })
//        AccountManager.checkToken(success: {
//            log.word("check ok!")/
//        }, failure: {
//            log.errorMessage("bind failed")/
//        })
//        AccountManager.unbindTju(tjuname: "3015204064", tjupwd: "nyz1500", success: {
//            log.word("unbind ok!")/
//        }, failure: {
//            log.errorMessage("unbind failed")/
//        })
//        
//        AccountManager.bindTju(tjuname: "3015204064", tjupwd: "nyz1500", success: {
//            log.word("bind ok!")/
//        }, failure: {
//            log.errorMessage("bind failed")/
//        })
//        
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

