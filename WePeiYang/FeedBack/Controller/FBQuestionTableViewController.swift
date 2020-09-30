//
//  FBQuestionTableViewController.swift
//  WePeiYang
//
//  Created by Zr埋 on 2020/9/30.
//  Copyright © 2020 twtstudio. All rights reserved.
//

import UIKit

class FBQuestionTableViewController: UITableViewController {
     
     enum QTType {
          case posted, thumbed
     }
     
     var type: QTType = .thumbed {
          didSet {
               QuestionHelper.getQuestions(type: (type == .thumbed ? .liked : .my)) { (result) in
                    switch result {
                    case .success(let questions):
                         self.questions = questions
                    case .failure(let err):
                         print(err)
                    }
               }
          }
     }

     var questions = [QuestionModel]() {
          didSet {
               tableView.reloadData()
          }
     }
     
     let tableViewCellId = "feedBackQuestionTableViewCellID"
     
     override func viewDidLoad() {
          super.viewDidLoad()
          tableView.register(FBQuestionTableViewCell.self, forCellReuseIdentifier: tableViewCellId)
          tableView.keyboardDismissMode = .onDrag
     }
}

//MARK: - Delegate
extension FBQuestionTableViewController {
     override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
          return questions.count
     }
     
     override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
          let cell = tableView.dequeueReusableCell(withIdentifier: tableViewCellId) as! FBQuestionTableViewCell
          cell.update(by: questions[indexPath.row])
          return cell
     }
     
     
     override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
          return 105 + (questions[indexPath.row].datumDescription ?? "").getSuitableHeight(font: .systemFont(ofSize: 14), setWidth: SCREEN.width * 0.8, numbersOfLines: 3)
     }
     
     override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
          tableView.deselectRow(at: indexPath, animated: true)
          if type == .posted {
               let alert = UIAlertController()
               let action1 = UIAlertAction(title: "取消", style: .cancel, handler: nil)
               let action2 = UIAlertAction(title: "查看", style: .default) { (_) in
                    let VC = FeedBackDetailViewController()
                    VC.questionOfthisPage = self.questions[indexPath.row]
                    self.navigationController?.pushViewController(VC, animated: true)
               }
               let action3 = UIAlertAction(title: "删除", style: .destructive) { (_) in
                    let alert = UIAlertController(title: "提示", message: "你正在删除这个提问\n是否真的删除?", preferredStyle: .alert)
                    let action1 = UIAlertAction(title: "取消", style: .cancel, handler: nil)
                    let action2 = UIAlertAction(title: "确定", style: .destructive) { (_) in
                         QuestionHelper.deleteMyQuestion(questionId: self.questions[indexPath.row].id ?? 0) { (result) in
                              switch result {
                              case .success(let str):
                                   SwiftMessages.showSuccessMessage(body: str)
                              case .failure(let err):
                                   print(err)
                              }
                         }
                         self.questions.remove(at: indexPath.row)
                    }
                    alert.addAction(action1)
                    alert.addAction(action2)
                    
                    self.present(alert, animated: true)
               }
               alert.addAction(action1)
               alert.addAction(action2)
               alert.addAction(action3)
               
               self.present(alert, animated: true)
          } else {
               let VC = FeedBackDetailViewController()
               VC.questionOfthisPage = questions[indexPath.row]
               navigationController?.pushViewController(VC, animated: true)
          }
     }
}

