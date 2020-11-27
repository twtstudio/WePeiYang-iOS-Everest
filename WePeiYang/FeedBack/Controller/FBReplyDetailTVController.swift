//
//  FBReplyDetailTVController.swift
//  WePeiYang
//
//  Created by Zrzz on 2020/11/20.
//  Copyright © 2020 twtstudio. All rights reserved.
//

import UIKit

class FBReplyDetailTVController: UITableViewController {
     
     var replys: [CommentModel] = []
     let replyCellID = "feedBackDVCRCell"
     
     convenience init(reply: CommentModel) {
          self.init()
          replys = [reply]
     }
     
     convenience init(replys: [CommentModel]) {
          self.init()
          self.replys = replys
     }
     
     override func viewDidLoad() {
          super.viewDidLoad()
          tableView.register(FBReplyTableViewCell.self, forCellReuseIdentifier: replyCellID)
          tableView.separatorStyle = .none
          
     }
     
     override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
          return replys.count
     }
     
     override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
          let cell = tableView.dequeueReusableCell(withIdentifier: replyCellID, for: indexPath) as! FBReplyTableViewCell
          cell.update(comment: replys[indexPath.row], isFull: true)
          return cell
     }
     
     override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
          let str = (replys[indexPath.row].contain ?? "").htmlToAttributedString
          return 60 + str!.getSuitableHeight(font: .systemFont(ofSize: 14), setWidth: SCREEN.width * 0.8, numbersOfLines: 0)
     }
}
