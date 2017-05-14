//
//  NewsViewController.swift
//  WePeiYang
//
//  Created by Allen X on 5/11/17.
//  Copyright © 2017 twtstudio. All rights reserved.
//

import UIKit

class NewsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationController?.navigationBar.barStyle = .black
        navigationController?.navigationBar.barTintColor = Metadata.Color.WPYAccentColor
        //Changing NavigationBar Title color
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: Metadata.Color.naviTextColor]
        // This is for removing the dark shadows when transitioning
        navigationController?.navigationBar.isTranslucent = false
        
        navigationItem.title = "咨询"
        
        

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
