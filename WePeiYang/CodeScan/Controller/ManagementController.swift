//
//  ManagementController.swift
//  WePeiYang
//
//  Created by 安宇 on 2019/9/27.
//  Copyright © 2019 twtstudio. All rights reserved.
//

import UIKit
import SnapKit

class ManagementController: UIViewController {
    
    let ManagementTableView = UITableView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height), style: .grouped)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        navigationItem.title = "活动"
        navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationBar.setBackgroundImage(nil, for: .default)
        navigationController?.navigationBar.barTintColor = MyColor.ColorHex("#54B9F1")
        navigationController?.setNavigationBarHidden(false, animated: true)
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
        let leftButton = UIBarButtonItem(title: "", style: .plain, target: self, action: #selector(pop))
        let image = UIImage(named:"3")!
        leftButton.image = UIImage.resizedImage(image: image, scaledToSize: CGSize(width: 10, height: 20))
        //        let buttonImage = UIImage(named:"cocktail_dog")?.withRenderingMode(.alwaysOriginal)
        navigationItem.leftBarButtonItem = leftButton
        
        
    }
    @objc func pop() {
        
    }
}
extension ManagementController: UITableViewDelegate {
    
}
extension ManagementController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 {
//            自定义头视图
            return UIView()
        } else {
            return nil
        }
    }
    
    
}
