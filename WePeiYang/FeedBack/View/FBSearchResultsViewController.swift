//
//  FBSearchResultsViewController.swift
//  WePeiYang
//
//  Created by 于隆祎 on 2020/9/20.
//  Copyright © 2020 twtstudio. All rights reserved.
//
// FIXME: use api search re
import UIKit

class FBSearchResultsViewController: UITableViewController, UISearchBarDelegate {
     
     var questions = [FBQuestionModel]() {
          didSet {
               tableView.reloadData()
          }
     }
     
     let tableViewCellId = "feedBackQuestionTableViewCellID"
     
     override func viewDidLoad() {
          super.viewDidLoad()
          tableView.register(FBQuestionTableViewCell.self, forCellReuseIdentifier: tableViewCellId)
          tableView.separatorStyle = .none
          view.backgroundColor = UIColor(hex6: 0xf6f6f6)
          tableView.keyboardDismissMode = .onDrag
     }
}


extension FBSearchResultsViewController: UISearchResultsUpdating {
     func updateSearchResults(for searchController: UISearchController) {
          if let text = searchController.searchBar.text {
               FBQuestionHelper.searchQuestions(string: text, limits: 0) { (result) in
                    switch result {
                    case .success(let questions):
                         self.questions = questions
//                         if questions.count != 0 {
//                              self.questions += questions
//                         } else {
//                              self.tableView.mj_footer.endRefreshingWithNoMoreData()
//                         }
                    case .failure(let error):
                         print(error)
                    }
               }
          }
     }
}


//MARK: - Delegate
extension FBSearchResultsViewController {
     override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
          return questions.count
     }
     
     override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
          let cell = tableView.dequeueReusableCell(withIdentifier: tableViewCellId) as! FBQuestionTableViewCell
          cell.update(by: questions[indexPath.row])
          return cell
     }
     
     override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
          let lineCnt = ceilf(Float(questions[indexPath.row].tags!.reduce(0, { $0 + 3 + $1.name!.count })) / 18)
          return 150
               + 20 * CGFloat(lineCnt)
               + (questions[indexPath.row].datumDescription ?? "").getSuitableHeight(font: .systemFont(ofSize: 14), setWidth: SCREEN.width * 0.8, numbersOfLines: 2)
     }
     
     override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
          tableView.deselectRow(at: indexPath, animated: true)
          let VC = FeedBackDetailViewController()
          VC.questionOfthisPage = questions[indexPath.row]
          presentingViewController?.navigationController?.pushViewController(VC, animated: true)
          
     }
}
