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
    
//    var tagCollectionView: UICollectionView!
    var tagSelectionView: SelectionView!
    
    // MARK: - Data
    var availableTags = [
        FBTagModel(id: 0, name: "教务处", children: nil),
        FBTagModel(id: 0, name: "后保部", children: nil),
        FBTagModel(id: 0, name: "场馆中心", children: nil),
        FBTagModel(id: 0, name: "其他", children: nil),
    ] {
        didSet {
            tagSelectionView.updateData(data: availableTags.map { $0.name ?? "" })
            tableView.mj_header.beginRefreshing()
        }
    }
    // means no tag is selected
    var selectedTag: Int = -1 {
        didSet {
            self.tableView.mj_header.beginRefreshing()
        }
    }
    
    var questions = [FBQuestionModel]() {
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
                FBQuestionHelper.searchQuestions(tags: selectedTag == -1 ?
                                                    [] :
                                                    [availableTags[selectedTag].id ?? 0],
                                                 string: "", limits: 10, page: curPage) { (result) in
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
        
        NotificationCenter.default.addObserver(self, selector: #selector(headerRefresh), name: Notification.Name(rawValue: FB_NOTIFICATIONFLAG_HAD_SEND_QUESTION), object: nil)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        tagSelectionView.addShadow(.black, sRadius: 5, sOpacity: 0.2, offset: (0, 4))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // 这里设置下顶部栏颜色
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(color: UIColor.feedBackBlue), for: UIBarMetrics.default)
        //        self.navigationController?.navigationBar.barTintColor = UIColor.feedBackBlue
        self.navigationController?.navigationBar.titleTextAttributes =
            [NSAttributedString.Key.foregroundColor: UIColor.white]
        self.navigationController?.navigationBar.tintColor = UIColor.white
        super.viewWillAppear(animated)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
}


// MARK: - UI
extension FeedBackMainViewController: UISearchControllerDelegate {
    private func setUp() {
        
//        self.navigationController?.navigationBar.isTranslucent = false
        hidesBottomBarWhenPushed = true
        view.backgroundColor = .white
        
        navigationItem.title = "校务平台"
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(color: UIColor.feedBackBlue), for: UIBarMetrics.default)
        //        self.navigationController?.navigationBar.barTintColor = UIColor.feedBackBlue
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
                //                    leftView.tintColor = UIColor.feedBackBlue
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
        let layout = UICollectionViewFlowLayout()
        
        layout.estimatedItemSize = CGSize(width: 200, height: 30)
        layout.minimumInteritemSpacing = 10
        layout.scrollDirection = .horizontal
//        tagCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
//        tagCollectionView.contentInset = UIEdgeInsets(top: 0, left: 10, bottom: 2.5, right: 10)
//        tagCollectionView.backgroundColor = .white
//        tagCollectionView.delegate = self
//        tagCollectionView.dataSource = self
//        tagCollectionView.register(FBTagCollectionViewCell.self, forCellWithReuseIdentifier: collectionViewCellId)
        tagSelectionView = SelectionView(data: availableTags.map{ $0.name ?? "" }, collectionViewLayout: layout)
        tagSelectionView.contentInset = UIEdgeInsets(top: 0, left: 10, bottom: 2.5, right: 10)
        tagSelectionView.allowsCancelSelection = true
        tagSelectionView.addCallBack { (idx) in
            self.selectedTag = idx
        }
        view.addSubview(tagSelectionView)
        tagSelectionView.snp.makeConstraints { (make) in
            make.height.equalTo(35)
            make.width.equalTo(SCREEN.width)
            make.centerX.equalToSuperview()
            make.top.equalTo(view).offset(naviHeight + 15)
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
            make.top.equalTo(tagSelectionView.snp.bottom)
            make.bottom.equalTo(view)
        }
        
        
        let header = MJRefreshNormalHeader(refreshingTarget: self, refreshingAction: #selector(headerRefresh))
        let footer = MJRefreshAutoNormalFooter(refreshingTarget: self, refreshingAction: #selector(footerLoadMore))
        
        header?.setTitle("刷新中￣ω￣=", for: .refreshing)
        header?.setTitle("", for: .idle)
        header?.setTitle("松开以刷新", for: .pulling)
        header?.lastUpdatedTimeText = { date in
            let df = DateFormatter()
            df.dateFormat = "MM月dd日 HH:mm"
            return df.string(from: header?.lastUpdatedTime ?? Date())
        }
        
        footer?.setTitle("没有更多问题了哦~", for: .noMoreData)
        footer?.setTitle("加载中￣ω￣=", for: .refreshing)
        footer?.setTitle("上滑以刷新更多☆´∀｀☆", for: .idle)
        
        tableView.mj_header = header
        tableView.mj_footer = footer
        
        view.bringSubviewToFront(tagSelectionView) // 不然阴影会被遮住
        // 这里有一点，Floaty的阴影来自于在自己的视图下加上阴影层，如果把tagCollectionView放到下面
        // 即放到`view.addSubview(floaty)`的后面，则在第一次点击时，tagCollectionView仍然是在上方的
        
        // use floaty module
        let floaty = Floaty()
//        floaty.buttonColor = UIColor(hex6: 0x00a1e9)
        floaty.buttonColor = UIColor.feedBackBlue
        floaty.plusColor = .white
        floaty.addItem("个人中心", icon: UIImage(named: "feedback_user")) { (_) in
            let vc = FBUserViewController()
            self.navigationController?.pushViewController(vc, animated: true)
        }
        floaty.addItem("添加问题", icon: UIImage(named: "feedback_add_question")) { (_) in
            let addVC = FBNewQuestionViewController()
            addVC.availableTags = self.availableTags
            self.present(addVC, animated: true, completion: nil)
        }
        view.addSubview(floaty)
    }
    
    
}

// MARK: - TableView Delegate & cell

extension FeedBackMainViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        10
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return questions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: tableViewCellId) as! FBQuestionTableViewCell
        cell.update(by: questions[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let lineCnt = ceilf(Float(questions[indexPath.row].tags!.reduce(0, { $0 + 3 + $1.name!.count })) / 18)
        return 130
            + 25 * CGFloat(lineCnt)
            + (questions[indexPath.row].datumDescription ?? "").getSuitableHeight(font: .systemFont(ofSize: 14), setWidth: SCREEN.width * 0.8, numbersOfLines: 3)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let vc = FeedBackDetailViewController()
        vc.questionOfthisPage = questions[indexPath.row]
        navigationController?.pushViewController(vc, animated: true)
    }
}


// MARK: - Data Control
extension FeedBackMainViewController {
    private func loadData() {
        FBTagsHelper.tagGet { (results) in
            switch results {
                case .success(let tags):
                    if tags.count == 1 {
                        self.availableTags = tags[0].children ?? []
                    }
                case .failure(let error):
                    print(error)
            }
        }
        
        FBUserHelper.userIdGet { (result) in
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
        let addVC = FBNewQuestionViewController()
        //          addVC.selectedTags = self.selectedTags
        //          addVC.willSelectedTags = self.willSelectedTags
        self.present(addVC, animated: true, completion: nil)
    }
    @objc func headerRefresh() {
        if tableView.numberOfRows(inSection: 0) != 0 {
            tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
        }
        
        FBQuestionHelper.searchQuestions(tags: selectedTag == -1 ?
                                            [] :
                                            [availableTags[selectedTag].id ?? 0],
                                         string: "", limits: 10, page: 1) { (result) in
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

