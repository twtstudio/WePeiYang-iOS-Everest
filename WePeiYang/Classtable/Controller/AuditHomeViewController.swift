//
//  AuditHomeViewController.swift
//  WePeiYang
//
//  Created by JasonEWNL on 2018/11/14.
//  Copyright © 2018年 twtstudio. All rights reserved.
//

import UIKit

class AuditHomeViewController: UIViewController {
    private var tableView: UITableView!
    private var popularList: [PopularClassModel] = []
    private var isFold: Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        
        tableView = UITableView(frame: self.view.bounds, style: .grouped)
        tableView.delegate = self
        tableView.dataSource = self
        
        self.view.addSubview(tableView)
        
        
        ClasstableDataManager.getPopularList(success: { model in
            self.popularList = model.data
            self.tableView.reloadData()
        }, failure: { errStr in
            
        })
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
//        navigationController?.navigationBar.tintColor = UIColor(red: 0.14, green: 0.69, blue: 0.93, alpha: 1.00)
//        navigationController?.navigationBar.setBackgroundImage(UIImage(color: .white), for: UIBarMetrics.default)
//        navigationController?.navigationBar.shadowImage = UIImage()
//        navigationController?.setNavigationBarHidden(false, animated: animated)
//        self.navigationController?.navigationBar.barStyle = .default
  //      self.navigationController?.navigationBar.isTranslucent = false
        
        navigationItem.title = "蹭课"
        
        let auditBack = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
        navigationItem.backBarButtonItem = auditBack
    }
    
}

extension AuditHomeViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "热门课程"
        } else if section == 1 {
            return "我的蹭课"
        }
        return nil
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 40
        } else {
            return 30
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
       return nil
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if section == 0 {
            return 60
        } else {
            return 120
        }
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        if section == 0 {
            return UIView()
        } else {
            return UIView()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if isFold == true, indexPath.section == 0, indexPath.row == 3 {
            self.isFold = false
            self.tableView.reloadData()
        }
    }
}

extension AuditHomeViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            if self.isFold == true {
                return self.popularList.count == 0 ? 0 : 3 + 1
            } else {
                return self.popularList.count
            }
        } else {
            return 6
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            if isFold == true {
                if indexPath.row < 3 {
                    let cell = UITableViewCell(style: .default, reuseIdentifier: "CELL_default")
                    cell.textLabel?.text = self.popularList[indexPath.row].course.name
                    return cell
                } else {
                    let cell = UITableViewCell(style: .default, reuseIdentifier: "CELL_default")
                    cell.textLabel?.text = "展开热门课程"
                    cell.textLabel?.textColor = .red
                    return cell
                }
            } else {
                let cell = UITableViewCell(style: .default, reuseIdentifier: "CELL_default")
                cell.textLabel?.text = self.popularList[indexPath.row].course.name
                cell.imageView?.image = UIImage.resizedImage(image: UIImage(named: "readerAvatar0")!, scaledToSize: CGSize(width: 12, height: 12))
                return cell
            }
        } else {
            return UITableViewCell()
        }
    }
}
