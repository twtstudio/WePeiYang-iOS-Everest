//
//  NewsViewController.swift
//  WePeiYang
//
//  Created by Allen X on 5/11/17.
//  Copyright © 2017 twtstudio. All rights reserved.
//

import UIKit
import MJRefresh
import SafariServices

class NewsViewController: UIViewController {
    var homepage: HomePageTopModel? {
        didSet {
            if let homepage = homepage {
                bannerView.load(type: .server, imgs: homepage.data.carousel.map({ $0.pic }), descs: homepage.data.carousel.map({ $0.subject }))
            }
        }
    }
    var galleryList: [GalleryModel] = [] {
        didSet {
            self.galleryView.reloadData()
        }
    }
    var newsList: [NewsModel] = [] {
        didSet {
            self.tableView.reloadData()
        }
    }
    var category = 1
    var page = 1

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }

    private var newsHeaderView: NewsHeaderView!
    private var tableView: UITableView!
    private var bannerFooView: UIView = {
        let view = UIView(color: .white)
        view.layer.cornerRadius = 15
        view.layer.shadowRadius = 4
        view.layer.shadowOffset = CGSize(width: 0, height: 2)

        view.layer.shadowOpacity = 0.5
        return view
    }()

    private lazy var bannerView: BannerScrollView = {
        let bannerWidth: CGFloat = deviceWidth - 40
        let bannerHeight: CGFloat = 400
        let bannerView = BannerScrollView(frame: CGRect(x: 0, y: 0, width: bannerWidth, height: bannerHeight), type: .server, imgs: [], descs: [], defaultDotImage: UIImage(named: "defaultDot"), currentDotImage: UIImage(named: "currentDot"))
        bannerView.layer.cornerRadius = 15
        bannerView.layer.masksToBounds = true
        bannerView.descLabelHeight = 150
        bannerView.descLabelFont = UIFont.boldSystemFont(ofSize: 25)
        bannerView.descLabelTextAlignment = .left
        return bannerView
    }()

    private lazy var galleryView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 130, height: 200)
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 20
        return UICollectionView(frame: CGRect(x: 0, y: 55, width: view.width, height: 200), collectionViewLayout: layout)
    }()

    private lazy var infoCell: UITableViewCell = {
        let cell = UITableViewCell()
        // 在bannerBackView上添加一个“咨询”label 和轮播图
        let bannerBackView = UIView(frame: CGRect(x: 0, y: 0, width: deviceWidth, height: 450))

        let bannerWidth: CGFloat = deviceWidth - 40
        let bannerHeight: CGFloat = 400

        if isiPad {
            bannerBackView.width = deviceWidth * 4 / 5
            bannerView.width = bannerWidth * 4 / 5
        }
        cell.contentView.addSubview(bannerBackView)
        bannerBackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        let informationLabel = UILabel(text: "资讯", color: .black)
        informationLabel.font = UIFont.systemFont(ofSize: 20, weight: UIFont.Weight.heavy)
        informationLabel.textAlignment = .left
        bannerBackView.addSubview(informationLabel)
        informationLabel.snp.makeConstraints({ (make) in
            make.top.equalToSuperview().offset(10)
            make.left.equalToSuperview().offset(25)
            make.width.equalTo(100)
            make.height.equalTo(40)
        })

        bannerBackView.addSubview(bannerFooView)

        bannerFooView.snp.makeConstraints({ (make) in
            make.top.equalTo(informationLabel.snp.bottom).offset(20)
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
            make.bottom.equalToSuperview().offset(-10)
            make.height.equalTo(bannerHeight)
            make.width.equalTo(bannerWidth)
        })

        bannerView.delegate = self
        bannerFooView.addSubview(bannerView)

        cell.selectionStyle = .none
        return cell
    }()

    private lazy var newsTitleCell: UITableViewCell = {
        let cell = UITableViewCell()
        let titleLabel = UILabel(text: "新闻", color: .black)
        titleLabel.font = UIFont.systemFont(ofSize: 20, weight: UIFont.Weight.heavy)
        titleLabel.sizeToFit()
        titleLabel.textAlignment = .left
        cell.contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(10)
            make.left.equalToSuperview().offset(25)
            make.width.equalTo(100)
            make.height.equalTo(40)
            make.bottom.equalToSuperview()
        }
        cell.selectionStyle = .none
        return cell
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "资讯"
        view.backgroundColor = .white
        setupUI()
        setupData()
    }

    func setupData() {
        CacheManager.retreive("news/homepage.json", from: .caches, as: HomePageTopModel.self, success: { homepage in
            self.homepage = homepage
        })

        CacheManager.retreive("news/galleries.json", from: .caches, as: [GalleryModel].self, success: {  galleries in
            self.galleryList = galleries
        })

        CacheManager.retreive("news/news.json", from: .caches, as: NewsTopModel.self, success: {  newsList in
            self.newsList = newsList.data
        })
    }

    func setupUI() {
        self.automaticallyAdjustsScrollViewInsets = false
        newsHeaderView = NewsHeaderView(withTitle: "News")

        let statusBarHeight: CGFloat = UIScreen.main.bounds.height == 812 ? 44 : 20
        let tabBarHeight = self.tabBarController?.tabBar.height ?? 0

        // MARK: - init TableView
        if isiPad {
            tableView = UITableView(frame: CGRect(x: deviceWidth/10, y: statusBarHeight, width: deviceWidth*4/5, height: deviceHeight-statusBarHeight-tabBarHeight), style: .grouped)
        } else {
            tableView = UITableView(frame: CGRect(x: 0, y: statusBarHeight, width: deviceWidth, height: deviceHeight-statusBarHeight-tabBarHeight), style: .grouped)
        }

        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none

        tableView.estimatedRowHeight = 500
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.showsVerticalScrollIndicator = false

        tableView.backgroundColor = .white
        self.view.addSubview(tableView)

        // init refresh

        let header = MJRefreshNormalHeader(refreshingTarget: self, refreshingAction: #selector(headerRefresh))
        let footer = MJRefreshAutoNormalFooter(refreshingTarget: self, refreshingAction: #selector(footerLoadMore))

        tableView.mj_header = header
        tableView.mj_footer = footer
        tableView.reloadData()

        header?.beginRefreshing()
        loadCache()
    }

    func loadCache() {
        CacheManager.retreive("news/homepage.json", from: .caches, as: HomePageTopModel.self, success: { homepage in
            self.homepage = homepage
        })

        CacheManager.retreive("news/galleries.json", from: .caches, as: [GalleryModel].self, success: {  galleries in
            self.galleryList = galleries
        })

        CacheManager.retreive("news/news.json", from: .caches, as: NewsTopModel.self, success: {  newsList in
            self.newsList = newsList.data
        })
    }

    @objc func headerRefresh() {
        let group = DispatchGroup()

        group.enter()
        HomePageHelper.getHomepage(success: { homepage in
            CacheManager.store(object: homepage, in: .caches, as: "news/homepage.json")
            self.homepage = homepage
            group.leave()
        }, failure: { error in
            group.leave()
            SwiftMessages.showErrorMessage(body: error.localizedDescription)
        })

        group.enter()
        HomePageHelper.getGallery(success: { galleries in
            CacheManager.store(object: galleries, in: .caches, as: "news/galleries.json")
            self.galleryList = galleries
            group.leave()
        }, failure: { error in
            group.leave()
            SwiftMessages.showErrorMessage(body: error.localizedDescription)
        })

        group.enter()
        HomePageHelper.getNews(page: page, category: category, success: { newsList in
            CacheManager.store(object: newsList.data, in: .caches, as: "news/newsList.json")
            self.newsList = newsList.data
            group.leave()
        }, failure: { error in
            group.leave()
            SwiftMessages.showErrorMessage(body: error.localizedDescription)
        })

        group.notify(queue: .main, execute: {
            if self.tableView.mj_header.isRefreshing {
                self.tableView.mj_header.endRefreshing()
            }
        })
    }

    @objc func footerLoadMore() {
        let newCategory = category + 1
        if newCategory == 6 {
            category = 1
            page += 1
        } else {
            category = newCategory
        }

        self.tableView.mj_footer.beginRefreshing()
        HomePageHelper.getNews(page: page, category: category, success: { newsList in
            self.newsList += newsList.data
            self.tableView.reloadData()
            if self.tableView.mj_footer.isRefreshing {
                self.tableView.mj_footer.endRefreshing()
            }
        }, failure: { _ in
            if self.tableView.mj_footer.isRefreshing {
                self.tableView.mj_footer.endRefreshing()
                if newCategory == 6 {
                    self.category = 5
                    self.page -= 1
                } else {
                    self.category -= 1
                }
            }
        })
    }
}

// MARK: - 使用contentoffset使label文字大小变化
extension NewsViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let scrollViewY = scrollView.contentOffset.y
        if scrollViewY < 0 {
            self.newsHeaderView.navigationBarHiddenScrollByY(scrollViewY - 130)
        } else {
            self.newsHeaderView.viewScrolledByY(scrollViewY - 130)
        }
    }
}

extension NewsViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3 + newsList.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: UITableViewCell
        switch indexPath.row {
        case 0:
            cell = infoCell
        case 1:
            cell = UITableViewCell()
//            cell = galleryCell
        case 2:
            cell = newsTitleCell
        case var row where row > 2 && row - 3 < newsList.count:
            row = row - 3
            let news = newsList[row]
            if URL(string: news.pic) != nil {
                cell = tableView.dequeueReusableCell(withIdentifier: "news-right") ??
                    NewsTableViewCell(style: .default, reuseIdentifier: "news-right", imageStyle: .right)
            } else {
                cell = tableView.dequeueReusableCell(withIdentifier: "news-none") ??
                    NewsTableViewCell(style: .default, reuseIdentifier: "news-none", imageStyle: .none)
            }

            if let cell = cell as? NewsTableViewCell {
                cell.titleLabel.text = news.subject

                let HTMLString: String = news.summary
                if let data = HTMLString.data(using: .unicode),
                    let attributedString = try? NSAttributedString(data: data, options: [NSAttributedString.DocumentReadingOptionKey.documentType: NSAttributedString.DocumentType.html], documentAttributes: nil) {
                    cell.detailLabel.attributedText = attributedString
                } else {
                    cell.detailLabel.text = news.summary.replacingOccurrences(of: "&nbsp;", with: "")
                }

                cell.descLabel.text = "阅读: \(news.visitcount) 评论: \(news.comments)"
                cell.imgView.sd_setImage(with: URL(string: news.pic), placeholderImage: UIImage(named: "logo_old") ?? UIImage(), options: [], completed: nil)
                cell.imgView.sd_setIndicatorStyle(.gray)
                cell.imgView.sd_setShowActivityIndicatorView(true)
            }
        default:
            fatalError()
        }
        cell.setNeedsLayout()
        cell.layoutIfNeeded()
        return cell
    }
}

extension NewsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 {
            return newsHeaderView
        }
        return nil
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 75
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard indexPath.row > 2 else {
            return
        }
        let row = indexPath.row - 3
        tableView.deselectRow(at: indexPath, animated: true)
        let news = newsList[row]
        let newsVC = NewsDetailViewController(index: String(news.index))
        newsVC.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(newsVC, animated: true)
    }
}

extension NewsViewController: BannerScrollViewDelegate {
    func bannerScrollViewDidSelect(at index: Int, bannerScrollView: BannerScrollView) {
        if let homepage = self.homepage {
            let newsIndex = homepage.data.carousel[index].index
            let newsVC = NewsDetailViewController(index: String(newsIndex))
            newsVC.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(newsVC, animated: true)
            // self.navigationController?.pushViewController(detailVC, animated: true)
        }
    }
}
