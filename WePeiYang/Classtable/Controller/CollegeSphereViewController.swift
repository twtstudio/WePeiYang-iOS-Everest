//
//  CollegeSphereViewController.swift
//  WePeiYang
//
//  Created by Tigris on 4/12/18.
//  Copyright © 2018 twtstudio. All rights reserved.
//

import UIKit

class CollegeSphereViewController: UIViewController {
    let sphereView = DBSphereView()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        sphereView.frame = self.view.bounds
        self.view.addSubview(sphereView)
        loadCache()
        load()
    }
    
    func loadCache() {
        
    }
    
    func load() {
        ClasstableDataManager.getCollegeList(success: { list in
            
//            let buttons = list.map { model in
//                let button = UIButton(frame: CGRect(x: 0, y: 0, width: 60, height: 20))
//                button.setTitle(model.collegeName, for: .normal)
//                self.sphereView.addSubview(button)
//            }
//            self.sphereView.setCloudTags((buttons as? NSArray as! [Any]))
        }, failure: { errMsg in
            SwiftMessages.showErrorMessage(body: errMsg)
        })
    }
}
