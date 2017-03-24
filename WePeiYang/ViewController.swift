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
        super.viewDidLoad()
        AccountManager.getToken(username: "nyz1500", password: "nyz1500chch6688", success: {
            AccountManager.bindTju(tjuname: "30150204064", tjupwd: "nyz1", success: {
                print("yoo")
            }, failure: {
                print("failed")
            })
        }, failure: { error in
            log.error(error)/
            print("already failed")
        })
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

