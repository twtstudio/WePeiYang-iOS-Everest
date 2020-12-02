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
            FBQuestionHelper.getQuestions(type: (type == .thumbed ? .liked : .my)) { (result) in
                switch result {
                    case .success(let questions):
                        self.questions = questions
                    case .failure(let err):
                        print(err)
                }
            }
        }
    }
    
    var questions = [FBQuestionModel]() {
        didSet {
            tableView.reloadData()
        }
    }
    
    let tableViewCellId = "feedBackQuestionTableViewCellID"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.backgroundColor = UIColor(hex6: 0xf6f6f6)
        tableView.register(FBQuestionTableViewCell.self, forCellReuseIdentifier: tableViewCellId)
        tableView.keyboardDismissMode = .onDrag
        tableView.separatorStyle = .none
    }
}

//MARK: - Delegate
extension FBQuestionTableViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return questions.isEmpty ? 1 : questions.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if questions.isEmpty {
            let cell = UITableViewCell()
            cell.textLabel?.text = type == .thumbed ? "你还没有点赞过问题哦" : "你还没有发布过问题哦"
            cell.textLabel?.textAlignment = .center
            cell.backgroundColor = UIColor(hex6: 0xf6f6f6)
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: tableViewCellId) as! FBQuestionTableViewCell
            cell.update(by: questions[indexPath.row])
            return cell
        }
    }
    
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if questions.isEmpty {
            return 60
        } else {
            let lineCnt = ceilf(Float(questions[indexPath.row].tags!.reduce(0, { $0 + 3 + $1.name!.count })) / 18)
            return 150
                + 20 * CGFloat(lineCnt)
                + (questions[indexPath.row].datumDescription ?? "").getSuitableHeight(font: .systemFont(ofSize: 14), setWidth: SCREEN.width * 0.8, numbersOfLines: 2)
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard !questions.isEmpty else { return }
        
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
                    FBQuestionHelper.deleteMyQuestion(questionId: self.questions[indexPath.row].id ?? 0) { (result) in
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
            // for iPad
            if let popover = alert.popoverPresentationController {
                popover.sourceView = tableView.cellForRow(at: indexPath)
                popover.sourceRect = tableView.cellForRow(at: indexPath)?.frame ?? CGRect(x: 0, y: 0, width: 1, height: 1)
                popover.permittedArrowDirections = .any
            }
            self.present(alert, animated: true)
        } else {
            let VC = FeedBackDetailViewController()
            var question = questions[indexPath.row]
            question.isLiked = true // 这里接口没有处理
            VC.questionOfthisPage = question
            navigationController?.pushViewController(VC, animated: true)
        }
    }
}

