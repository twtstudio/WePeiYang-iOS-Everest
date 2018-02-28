//
//  BicycleCardListViewController.swift
//  WePeiYang
//
//  Created by JinHongxu on 16/8/9.
//  Copyright © 2016年 Qin Yubo. All rights reserved.
//

import Foundation
import UIKit

class BicycleCardListViewController: UITableViewController, UIAlertViewDelegate {
    
    var choosenRow: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.tintColor = nil
        self.navigationItem.title = "选择绑定的卡片"
        
        //self.navigationController!.jz_navigationBarBackgroundAlpha = 1
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return BicycleUser.sharedInstance.cardList.count;
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell = tableView.dequeueReusableCell(withIdentifier: "UserCardCell")
        if cell == nil {
            cell = UITableViewCell(style: .subtitle, reuseIdentifier: "UserCardCell")
        }
        
        cell?.contentView.frame.size.height = 64
        cell?.textLabel?.text = "卡号："
        cell?.textLabel?.text = "最近记录：暂无"
        if let foo = BicycleUser.sharedInstance.cardList[indexPath.row].record {
            cell?.textLabel?.text = "卡号：\(BicycleUser.sharedInstance.cardList[indexPath.row].id!)"
            if let timeStampString = foo["arr_time"] as? String {
                
                //借了车，没还车
                if Int(timeStampString) == 0 {
                    if let devTimeStampString = foo["dev_time"] as? String {
                        cell?.detailTextLabel?.text = "最近记录：借车        时间：\(timeStampTransfer.stringFromTimeStampWithFormat(format: "yyyy-MM-dd HH:mm", timeStampString: devTimeStampString))"
                    }
                } else {
                    cell?.detailTextLabel?.text = "最近记录：还车        时间：\(timeStampTransfer.stringFromTimeStampWithFormat(format: "yyyy-MM-dd HH:mm", timeStampString: timeStampString))"
                }
            }
        }
        
        return cell!
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 64
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        choosenRow = indexPath.row
        let alertVC = UIAlertController(title: "提示", message: "确定绑定此卡?", preferredStyle: .alert)
        let confirmAction = UIAlertAction(title: "确定", style: .default, handler: { action in

        })
        let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)

        alertVC.addAction(confirmAction)
        alertVC.addAction(cancelAction)

//        let alert = UIAlertView(title: "提示", message: "确定绑定此卡？", delegate: self, cancelButtonTitle: "取消", otherButtonTitles: "确定")
        self.present(alertVC, animated: true, completion: nil)
//        alert.show()

        tableView.deselectRow(at: indexPath as IndexPath, animated: true)
        
    }

//    func alertView(_ alertView: UIAlertView, clickedButtonAt buttonIndex: Int) {
//
//        let choosenCard = BicycleUser.sharedInstance.cardList[choosenRow];
//
//        //坑：应该要先判断是哪个 alertView
//        guard buttonIndex != alertView.cancelButtonIndex else {
//            return
//        }
//
//        BicycleUser.sharedInstance.bindCard(id: choosenCard.id!, sign: choosenCard.sign!, doSomething: {
//
//            //pop 到BicycleServiceViewController
//            BicycleUser.sharedInstance.status = 1;//坑：毕竟这样不太稳妥
//            UserDefaults.standard.setValue(1, forKey: "BicycleStatus")
//            self.navigationController?.popViewController(animated: true)
//            self.navigationController?.popViewController(animated: true)
//
//            for vc in (self.navigationController?.viewControllers)! {
//                if let currentVC = vc as? BicycleServiceInfoController {
//                    currentVC.refreshInfo()
//                }
//            }
//        })
//    }

}

