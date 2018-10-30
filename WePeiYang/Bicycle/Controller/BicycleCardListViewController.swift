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
        return BicycleUser.sharedInstance.cardList.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        var cell = tableView.dequeueReusableCell(withIdentifier: "UserCardCell") ?? UITableViewCell(style: .subtitle, reuseIdentifier: "UserCardCell")

        cell.contentView.frame.size.height = 64
        cell.textLabel?.text = "卡号："
        cell.textLabel?.text = "最近记录：暂无"
        if let foo = BicycleUser.sharedInstance.cardList[indexPath.row].record {
            cell.textLabel?.text = "卡号：\(BicycleUser.sharedInstance.cardList[indexPath.row].id ?? "")"
            if let timeStampString = foo["arr_time"] as? String {

                //借了车，没还车
                if Int(timeStampString) == 0 {
                    if let devTimeStampString = foo["dev_time"] as? String {
                        cell.detailTextLabel?.text = "最近记录：借车        时间：\(timeStampTransfer.stringFromTimeStampWithFormat(format: "yyyy-MM-dd HH:mm", timeStampString: devTimeStampString))"
                    }
                } else {
                    cell.detailTextLabel?.text = "最近记录：还车        时间：\(timeStampTransfer.stringFromTimeStampWithFormat(format: "yyyy-MM-dd HH:mm", timeStampString: timeStampString))"
                }
            }
        }

        return cell
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 64
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        choosenRow = indexPath.row
        let choosenCard = BicycleUser.sharedInstance.cardList[choosenRow]

        let alertVC = UIAlertController(title: "提示", message: "确定绑定此卡?", preferredStyle: .alert)
        let confirmAction = UIAlertAction(title: "确定", style: .default, handler: { _ in
            guard let id = choosenCard.id,
                let sign = choosenCard.sign else {
                    return
            }
            BicycleUser.sharedInstance.bindCard(id: id, sign: sign, doSomething: {
                BicycleUser.sharedInstance.status = 1;//坑：毕竟这样不太稳妥
//                UserDefaults.standard.setValue(1, forKey: "BicycleStatus")
                TwTUser.shared.bicycleBindingState = true
                TwTUser.shared.save()
            }, failure: { _ in
                SwiftMessages.showErrorMessage(body: "绑定失败")
            })
        })
        let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)

        alertVC.addAction(confirmAction)
        alertVC.addAction(cancelAction)

//        let alert = UIAlertView(title: "提示", message: "确定绑定此卡？", delegate: self, cancelButtonTitle: "取消", otherButtonTitles: "确定")
        self.present(alertVC, animated: true, completion: nil)
//        alert.show()

        tableView.deselectRow(at: indexPath as IndexPath, animated: true)

    }
}
