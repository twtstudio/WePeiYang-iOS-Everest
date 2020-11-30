//
//  FBReplyDetailTVController.swift
//  WePeiYang
//
//  Created by Zrzz on 2020/11/20.
//  Copyright © 2020 twtstudio. All rights reserved.
//

import UIKit

class FBReplyDetailTVController: UITableViewController {
    
    var replies: [FBCommentModel] = []
    var isOwner: Bool = false
    
    let replyCellID = "feedBackRDVCCell"
    
    convenience init(reply: FBCommentModel, isOwner: Bool) {
        self.init()
        self.replies = [reply]
        self.isOwner = isOwner
    }
    
    convenience init(replies: [FBCommentModel], isOwner: Bool) {
        self.init()
        self.replies = replies
        self.isOwner = isOwner
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "回复详情"
        view.backgroundColor = UIColor(hex6: 0xf6f6f6)
        tableView.register(FBReplyDetailTableViewCell.self, forCellReuseIdentifier: replyCellID)
        tableView.separatorStyle = .none
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return replies.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: replyCellID, for: indexPath) as! FBReplyDetailTableViewCell
        cell.update(comment: replies[indexPath.row])
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let str = (replies[indexPath.row].contain ?? "").htmlToAttributedString
        return 60 + str!.getSuitableHeight(font: .systemFont(ofSize: 14), setWidth: SCREEN.width * 0.8, numbersOfLines: 0)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if isOwner {
            let rateView = FBRateCommentView()
            var config = SwiftMessages.defaultConfig
            config.presentationStyle = .center
            config.duration = .forever
            config.dimMode = .blur(style: .dark, alpha: 1, interactive: true)
            config.presentationContext  = .window(windowLevel: .normal)
            SwiftMessages.show(config: config, view: rateView)
        } else {
            let alert = UIAlertController(title: "提示", message: "你不是该问题的提出者，\n无法进行评分", preferredStyle: .alert)
            let action1 = UIAlertAction(title: "好的", style: .default, handler: nil)
            alert.addAction(action1)
            
            self.present(alert, animated: true)
        }
    }
}
