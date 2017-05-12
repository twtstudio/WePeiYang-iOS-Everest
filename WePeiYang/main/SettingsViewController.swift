//
//  SettingsViewController.swift
//  WePeiYang
//
//  Created by Allen X on 5/11/17.
//  Copyright © 2017 twtstudio. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.navigationBar.barStyle = .black
        navigationController?.navigationBar.barTintColor = Metadata.Color.WPYAccentColor
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: Metadata.Color.naviTextColor]
        
        navigationItem.title = "设置"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = Metadata.Color.GlobalViewBackgroundColor
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
