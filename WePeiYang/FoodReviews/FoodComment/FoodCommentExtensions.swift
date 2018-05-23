//
//  Extension.swift
//  Comment
//
//  Created by yuting jiang on 2018/4/17.
//  Copyright © 2018年 yuting jiang. All rights reserved.
//

import UIKit
import Foundation

extension UIButton {
    func setWidth(withTitle title: String) -> Int {
        return title.count * Int(UIScreen.main.bounds.width) * 16 / 414 + Int(UIScreen.main.bounds.width) * 26 / 414
    }
}

extension UITableView {
    /*
     弹出一个静态的cell，无须注册重用，例如:
     let cell: GrayLineTableViewCell = tableView.mm_dequeueStaticCell(indexPath)
     即可返回一个类型为GrayLineTableViewCell的对象
     
     - parameter indexPath: cell对应的indexPath
     - returns: 该indexPath对应的cell
     */
    func mm_dequeueStaticCell<T: UITableViewCell>(indexPath: NSIndexPath) -> T {
        let reuseIdentifier = "staticCellReuseIdentifier - \(indexPath.description)"
        if let cell = self.dequeueReusableCell(withIdentifier: reuseIdentifier) as? T {
            return cell
        }else {
            let cell = T(style: .default, reuseIdentifier: reuseIdentifier)
            return cell
        }
    }
}



