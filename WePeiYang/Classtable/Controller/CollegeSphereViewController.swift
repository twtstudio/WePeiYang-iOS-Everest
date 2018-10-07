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

        self.view.backgroundColor = .white
        sphereView.frame = self.view.bounds
        sphereView.y = self.view.height * 0.15
        self.view.addSubview(sphereView)
        loadCache()
        load()
    }

    func loadCache() {

    }

    func load() {
        ClasstableDataManager.getCollegeList(success: { list in
            let count = list.count
            var collegeList = [UIButton]()
            for i in 0..<count {
                let button = UIButton()
                button.frame = CGRect(x: 0, y: 0, width: 60, height: 20)
                button.center = self.sphereView.center
                button.setTitle(list[i].collegeName, for: .normal)
                button.setTitleColor(Metadata.Color.fluentColors[i % Metadata.Color.fluentColors.count], for: .normal)
                button.titleLabel?.font = UIFont.systemFont(ofSize: 24)
                button.sizeToFit()
                button.addTarget(self, action: #selector(self.buttonPressed), for: .touchUpInside)
                collegeList.append(button)
                self.sphereView.addSubview(button)
            }
            self.sphereView.setCloudTags(collegeList)
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

    @objc func buttonPressed() {
        let sphereVC = CourseListViewController()
        self.navigationController?.pushViewController(sphereVC, animated: true)
    }
}
