//
//  BicycleServiceNotificationController.swift
//  WePeiYang
//
//  Created by JinHongxu on 16/7/11.
//  Copyright © 2016年 Qin Yubo. All rights reserved.
//

import Foundation
import MJRefresh
import UIKit

class BicycleServiceNotificationController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet var tableView: UITableView!
    
    //iOS 8 fucking bug
    init(){
        super.init(nibName: "BicycleServiceNotificationController", bundle: nil)
        //print("haha")
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        self.tableView.mj_header = MJRefreshNormalHeader(refreshingBlock: {
            self.refreshData()
        })
        
        //self.tableView.mj_header.beginRefreshing()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func refreshData() {
        
        NotificationList.sharedInstance.getList(doSomething: {
            self.tableView.reloadSections(NSIndexSet(index: 0) as IndexSet, with: UITableViewRowAnimation.bottom)
            NotificationList.sharedInstance.didGetNewNotification = false;
            self.tableView.mj_header.endRefreshing()
        })
    }
    
    
    //UITableViewDataSource
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return NotificationList.sharedInstance.list.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell = tableView.dequeueReusableCell(withIdentifier: "BicycleNotificationCell")
        
        if cell == nil {
            cell = UITableViewCell(style: .subtitle, reuseIdentifier: "BicycleNotificationCell")
        }
        
        cell?.textLabel?.text = NotificationList.sharedInstance.list[indexPath.row].title
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        cell?.detailTextLabel?.text = dateFormatter.string(from: NotificationList.sharedInstance.list[indexPath.row].timeStamp as Date)
        cell?.detailTextLabel?.textColor = UIColor.lightGray
        
        return cell!
    }
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let detailVC = BicycleNotificationDetailViewController(nibName: "BicycleNotificationDetailViewController", bundle: nil)
        detailVC.notificationTitle = NotificationList.sharedInstance.list[indexPath.row].title
        detailVC.notificationContent = NotificationList.sharedInstance.list[indexPath.row].content
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        detailVC.time = dateFormatter.string(from: NotificationList.sharedInstance.list[indexPath.row].timeStamp as Date)
        
        self.navigationController?.pushViewController(detailVC, animated: true)
        
        tableView.deselectRow(at: indexPath as IndexPath, animated: true)
    }
    
}

