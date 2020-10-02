//
//  FeedBackMainViewController.swift
//  WePeiYang
//
//  Created by 于隆祎 on 2020/9/14.
//  Copyright © 2020 twtstudio. All rights reserved.
//

import UIKit
import SnapKit
import MJRefresh
import Floaty

let SCREEN = UIScreen.main.bounds



class FeedBackMainViewController: UIViewController {
     // MARK: - UI
     
     var searchController: UISearchController!
     
     var tableView: UITableView!
     
     var tagCollectionView: FBTagCollectionView!
     
//     var tableViewOffset: CGFloat = 0
//     var headerViewOffset: CGFloat = 0 {
//          didSet {
//               self.tagSelectedCollectionView.transform = CGAffineTransform.init(translationX: 0, y: headerViewOffset)
//               self.tagWillSeletedCollectionView.transform = CGAffineTransform.init(translationX: 0, y: headerViewOffset)
//          }
//     }
     
     
     // MARK: - Data
     var selectedTags = [TagModel]() {
          didSet {
               tagCollectionView.tagSelectedCollectionView.reloadData()
               tableView.mj_header.beginRefreshing()
          }
     }
     var willSelectedTags = [TagModel]() {
          didSet {
               tagCollectionView.tagWillSeletedCollectionView.reloadData()
          }
     }
     var questions = [QuestionModel]() {
          didSet {
               tableView.reloadData()
               if self.tableView.mj_footer.isRefreshing {
                    self.tableView.mj_footer.endRefreshing()
               }
          }
     }
     
     var curPage = 1 {
          didSet {
               if curPage != 1 {
                    tableView.mj_footer.beginRefreshing()
                    QuestionHelper.searchQuestions(tags: selectedTags.map{ $0.id ?? 0 }.filter{ $0 != 0 }, string: "", limits: 10, page: curPage) { (result) in
                         switch result {
                         case .success(let questions):
                              if questions.count != 0 {
                                   self.questions += questions
                              } else {
                                   self.tableView.mj_footer.endRefreshingWithNoMoreData()
                              }
                         case .failure(let error):
                              print(error)
                         }
                    }
               }
          }
     }
     
     private let collectionViewCellId = "feedBackCollectionViewCellID"
     private let tableViewCellId = "feedBackQuestionTableViewCellID"
     
     override func viewDidLoad() {
          super.viewDidLoad()
          
          self.view.backgroundColor = UIColor.white
          setUp()
          
          tableView.mj_header.beginRefreshing()
          loadData()
     }
     
     override func viewWillLayoutSubviews() {
          super.viewWillLayoutSubviews()
          
          tagCollectionView.addShadow(.black, sRadius: 5, sOpacity: 0.2, offset: (0, 4))
     }
}


// MARK: - UI
extension FeedBackMainViewController: UISearchControllerDelegate {
     private func setUp() {
          
//          navigationController?.isNavigationBarHidden = false
//          navigationController?.navigationBar.isTranslucent = false
          view.backgroundColor = .white
          
          navigationItem.title = "校务平台"
          self.navigationController?.setNavigationBarHidden(false, animated: true)
          self.navigationController?.navigationBar.setBackgroundImage(UIImage(color: UIColor(hex6: 0x00a1e9)), for: UIBarMetrics.default)
          //        self.navigationController?.navigationBar.barTintColor = UIColor(hex6: 0x00a1e9)
          self.navigationController?.navigationBar.titleTextAttributes =
              [NSAttributedString.Key.foregroundColor: UIColor.white]
          self.navigationController?.navigationBar.tintColor = UIColor.white
          
          let resultsTableViewController = FBSearchResultsViewController()
          searchController = UISearchController(searchResultsController: resultsTableViewController)
          searchController.delegate = self
          searchController.searchResultsUpdater = resultsTableViewController
          definesPresentationContext = true
          if let textfield = searchController.searchBar.value(forKey: "searchField") as? UITextField {
//               textfield.backgroundColor = .white
//               textfield.attributedPlaceholder = NSAttributedString(string: "搜索问题", attributes: [NSAttributedString.Key.foregroundColor: UIColor.black])
               textfield.attributedPlaceholder = NSAttributedString(string: "搜索问题", attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
               if let leftView = textfield.leftView as? UIImageView {
                    leftView.image = leftView.image?.withRenderingMode(.alwaysTemplate)
//                    leftView.tintColor = UIColor(hex6: 0x00a1e9)
                    leftView.tintColor = .white
               }
          }
          searchController.searchBar.delegate = resultsTableViewController
          searchController.hidesNavigationBarDuringPresentation = false
          searchController.searchBar.placeholder = "搜索问题"
          searchController.searchBar.sizeToFit()
          
          navigationItem.titleView = searchController.searchBar
          navigationItem.rightBarButtonItem = UIBarButtonItem(title: "   ", style: .plain, target: nil, action: nil)
          
          let naviHeight = navigationController?.navigationBar.frame.maxY ?? 0
          tagCollectionView = FBTagCollectionView(frame: .zero, itemSize: CGSize(width: 200, height: 25))
          view.addSubview(tagCollectionView)
          tagCollectionView.snp.makeConstraints { (make) in
               make.height.equalTo(65)
               make.width.equalTo(SCREEN.width)
               make.top.equalTo(view).offset(naviHeight + 10)
          }
          
          tableView = UITableView()
          tableView.showsVerticalScrollIndicator = false
          tableView.backgroundColor = UIColor(hex6: 0xf6f6f6)
          tableView.separatorStyle = .none
          tableView.register(FBQuestionTableViewCell.self, forCellReuseIdentifier: tableViewCellId)
          tableView.delegate = self
          tableView.dataSource = self
          self.view.addSubview(tableView)
          tableView.snp.makeConstraints{(make) in
               make.width.equalTo(SCREEN.width)
               make.top.equalTo(tagCollectionView.snp.bottom)
               make.bottom.equalTo(view)
          }
          
          
          let header = MJRefreshNormalHeader(refreshingTarget: self, refreshingAction: #selector(headerRefresh))
          let footer = MJRefreshAutoNormalFooter(refreshingTarget: self, refreshingAction: #selector(footerLoadMore))
          
          header?.setTitle("刷新中", for: .refreshing)
          header?.setTitle("", for: .idle)
          header?.setTitle("松开以刷新", for: .pulling)
          header?.lastUpdatedTimeText = { date in
               let df = DateFormatter()
               df.dateFormat = "MM月dd日 HH:mm"
               return df.string(from: header?.lastUpdatedTime ?? Date())
          }
          
          footer?.setTitle("没有下文了", for: .noMoreData)
          footer?.setTitle("加载中", for: .refreshing)
     
          tableView.mj_header = header
          tableView.mj_footer = footer
          
          // use floaty module
          let floaty = Floaty()
          floaty.buttonColor = UIColor(hex6: 0x00a1e9)
          floaty.plusColor = .white
          floaty.addItem("个人中心", icon: UIImage(named: "feedback_user")) { (_) in
               let vc = FBUserViewController()
               self.navigationController?.pushViewController(vc, animated: true)
          }
          floaty.addItem("添加问题", icon: UIImage(named: "feedback_add_question")) { (_) in
               let addVC = NewFeedBackViewController()
               addVC.selectedTags = self.selectedTags
               addVC.willSelectedTags = self.willSelectedTags
               self.present(addVC, animated: true, completion: nil)
          }
          view.addSubview(floaty)
          
          view.bringSubviewToFront(tagCollectionView)
          
     }
}

// MARK: - TableView Delegate & cell

extension FeedBackMainViewController: UITableViewDataSource, UITableViewDelegate {
     
     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
          return questions.count
     }
     
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
          let cell = tableView.dequeueReusableCell(withIdentifier: tableViewCellId) as! FBQuestionTableViewCell
          cell.update(by: questions[indexPath.row])
          return cell
     }
     
     
     func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
          return 145 + (questions[indexPath.row].datumDescription ?? "").getSuitableHeight(font: .systemFont(ofSize: 14), setWidth: SCREEN.width * 0.8, numbersOfLines: 2)
     }
     
     func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
          tableView.deselectRow(at: indexPath, animated: true)
          let vc = FeedBackDetailViewController()
          vc.questionOfthisPage = questions[indexPath.row]
          navigationController?.pushViewController(vc, animated: true)
     }
     
//     func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
//          tableViewOffset = scrollView.contentOffset.y
//     }
//
//     func scrollViewDidScroll(_ scrollView: UIScrollView) {
//          let dy = scrollView.contentOffset.y - tableViewOffset
//          if dy > 0 && dy < 100 && headerViewOffset > -100 {
//               headerViewOffset = 0 - dy
//          } else if dy > -150 && dy < -50 && headerViewOffset < 0 {
//               headerViewOffset = -(150 + dy)
//          }
//     }
//
//     func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
//          let dy = scrollView.contentOffset.y - tableViewOffset
//          if headerViewOffset > -100 {
//               headerViewOffset = dy >= 100 ? -100 : 0 - dy
//          } else if headerViewOffset < 0 {
//               headerViewOffset = dy <= -150 ? 0 : -(150 + dy)
//          }
//     }
}


// MARK: - CollectionView Delegate&Datasource

extension FeedBackMainViewController: UICollectionViewDataSource, UICollectionViewDelegate {
     func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
          return collectionView.tag == 0 ? selectedTags.count : willSelectedTags.count
     }
     
     func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
          let cell = collectionView.dequeueReusableCell(withReuseIdentifier: collectionViewCellId, for: indexPath) as! FBTagCollectionViewCell
          cell.update(by: collectionView.tag == 0 ? selectedTags[indexPath.row] : willSelectedTags[indexPath.row], selected: collectionView.tag == 0)
          return cell
     }
     
     func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
          if collectionView.tag == 0 {
               willSelectedTags = selectedTags[indexPath.row].children ?? []
               selectedTags = Array(selectedTags[0...indexPath.row])
          } else {
               selectedTags.append(willSelectedTags[indexPath.row])
               willSelectedTags = selectedTags.last!.children ?? []
          }
     }
}

// MARK: - Data Control
extension FeedBackMainViewController {
     private func loadData() {
          TagsHelper.tagGet { (results) in
               switch results {
               case .success(let tags):
                    self.selectedTags = [TagModel(id: nil, name: "天津大学", children: tags)]
                    self.willSelectedTags = tags
                    self.tagCollectionView.addDelegate(delegate: self, dataSource: self)
               case .failure(let error):
                    print(error)
               }
          }
          
          UserHelper.userIdGet { (result) in
               switch result {
               case .success(let uid):
                    TwTUser.shared.feedbackID = uid
                    TwTUser.shared.save()
               case .failure(let error):
                    print(error)
               }
          }
     }
}

// MARK: - Button Methods
extension FeedBackMainViewController {
     @objc func addToggle() {
          let addVC = NewFeedBackViewController()
          addVC.selectedTags = self.selectedTags
          addVC.willSelectedTags = self.willSelectedTags
          self.present(addVC, animated: true, completion: nil)
     }
     @objc func headerRefresh() {
          if tableView.numberOfRows(inSection: 0) != 0 {
               tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
          }
          
          QuestionHelper.searchQuestions(tags: selectedTags.map{ $0.id ?? 0 }.filter{ $0 != 0 }, string: "", limits: 10, page: 1) { (result) in
               switch result {
               case .success(let questions):
                    self.questions = questions
                    self.curPage = 1
                    if self.tableView.mj_header.isRefreshing {
                         self.tableView.mj_header.endRefreshing()
                    }
               case .failure(let error):
                    print(error)
               }
          }
     }
     
     @objc func footerLoadMore() {
          curPage += 1
     }
}

