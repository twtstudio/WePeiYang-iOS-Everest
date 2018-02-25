//
//  RecommendedViewController.swift
//  WePeiYang
//
//  Created by JinHongxu on 2016/10/25.
//  Copyright © 2016年 Qin Yubo. All rights reserved.
//

import UIKit
import SafariServices

class RecommendedViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate, RecommendBookViewDelegate {
    
    
    let tableView = UITableView(frame: CGRect(x: 0, y: 108, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height-108) , style: .grouped)
    let sectionList = ["热门推荐", "热门书评", "阅读之星"]
    var headerScrollView = UIScrollView()
    let pageControl = UIPageControl()
    let loadingView = UIRefreshControl(frame: CGRect(x: UIScreen.main.bounds.width/2, y: UIScreen.main.bounds.height/2, width: 20, height: 20))
//    var loadingView = UIView()
    
//    let bannerList = ["http://www.twt.edu.cn/upload/banners/hheZnqd196Te76SDF9Ww.png", "http://www.twt.edu.cn/upload/banners/ZPQqmajzKOI3A6qE7gIR.png", "http://www.twt.edu.cn/upload/banners/gJjWSlAvkGjZmdbuFtXT.jpeg"]
    
    //var reviewList = [MyReview]()
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initUI()
        
        if !Recommender.shared.dataDidRefresh {
            initLoadingView()
        }
        Recommender.shared.getBannerList(success: refreshUI)
        Recommender.shared.getRecommendedList(success: refreshUI)
        Recommender.shared.getHotReviewList(success: refreshUI)
        Recommender.shared.getStarUserList(success: refreshUI)
        
        //initReviews(tableView.reloadData)
    }
    
    func initLoadingView() {
//        loadingView = UIView(frame: CGRect(x: 0, y: 108, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height-108))
        loadingView.backgroundColor = .white
//        view.addSubview(loadingView)
//        loadingView.beginRefreshing()
//        MsgDisplay.showLoading()
    }
    
    func refreshUI() {
        if Recommender.shared.finishFlag.isFinished() {
            Recommender.shared.dataDidRefresh = true
            Recommender.shared.finishFlag.reset()
//            loadingView.endRefreshing()
//            loadingView.removeFromSuperview()
//            MsgDisplay.dismiss()
        }
        tableView.reloadData()
    }
    
    func initReviews(success: () -> ()) {
        
//        for i in 0...3 {
//            let foo = MyReview()
//            foo.initWithDict(
//                [
//                    "content": "James while John had had had had had had had had had had had a better effect on the teacher",
//                    "rate": i,
//                    "like": i,
//                    "timestamp": 143315151,
//                    "book": [
//                        "title": "活着",
//                        "isbn": "ABS-131"
//                    ]
//                ])
//            reviewList.append(foo)
//        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func initUI() {
        
        
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedRowHeight = 44.0
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.separatorStyle = .none
    }
    
    
    //Table DataSource
    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionList.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        case 1:
            return Recommender.shared.reviewList.count
        case 2:
            return 1
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let cell = RecommendCell(model: Recommender.shared.recommendedList)
            for fooView in cell.fooView {
                fooView.delegate = self
            }
            return cell
        case 1:
            let cell = ReviewCell(model: Recommender.shared.reviewList[indexPath.row])
            return cell
        case 2:
            let cell = ReadStarCell(model: Recommender.shared.starList)
            return cell
        default:
            let cell = UITableViewCell()
            return cell
        }
        
    }
    
    //    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
    //        switch indexPath.section {
    //        case 0:
    //            return 200
    //        case 2:
    //            return 160
    //        default:
    //            return 0
    //        }
    //    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return UIScreen.main.bounds.width*0.375+32
        }
        return 16
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionList[section]
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 {
            let headerView = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.width*0.375+32))
            
            headerScrollView = UIScrollView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.width*0.375))
            
            headerView.addSubview(headerScrollView)
            headerView.addSubview(pageControl)
            
//            headerScrollView.snp.makeConstraints {
//                make in
//                make.top.equalTo(headerView)
//                make.left.equalTo(headerView)
//                make.right.equalTo(headerView)
//                make.bottom.equalTo(headerView).offset(-32)
//            }
            
            pageControl.snp.makeConstraints {
                make in
                make.centerX.equalTo(headerScrollView)
                make.bottom.equalTo(headerScrollView)
            }
            
            //设置scrollView的内容总尺寸
            headerScrollView.contentSize = CGSize(width: CGFloat(UIScreen.main.bounds.width)*CGFloat(Recommender.shared.bannerList.count), height: UIScreen.main.bounds.width*0.375)
            //关闭滚动条显示
            headerScrollView.showsHorizontalScrollIndicator = false
            headerScrollView.showsVerticalScrollIndicator = false
            headerScrollView.scrollsToTop = false
            //无弹性
            headerScrollView.bounces = false
            //协议代理，在本类中处理滚动事件
            headerScrollView.delegate = self
            //滚动时只能停留到某一页
            headerScrollView.isPagingEnabled = true
            //添加页面到滚动面板里
            for (seq, banner) in Recommender.shared.bannerList.enumerated() {
                let imageView = UIImageView()
                imageView.sd_setImage(with: URL(string: banner.image), completed: nil)
                imageView.frame = CGRect(x: CGFloat(seq)*UIScreen.main.bounds.width, y: 0,
                                         width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.width*0.375)
                imageView.isUserInteractionEnabled = true
                imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(pushWebPage)))
                headerScrollView.addSubview(imageView)
            }
            
            //页控件属性
            pageControl.backgroundColor = .clear
            pageControl.numberOfPages = Recommender.shared.bannerList.count
            pageControl.currentPage = 0
            //设置页控件点击事件
            pageControl.addTarget(self, action: #selector(pageChanged(sender:)), for: .valueChanged)
            
            let fooLabel = UILabel(text: "热门推荐")
            fooLabel.textColor = .gray
            fooLabel.font = UIFont(name: "Arial", size: 13)
            headerView.addSubview(fooLabel)
            
            fooLabel.snp.makeConstraints {
                make in
                make.top.equalTo(headerScrollView.snp.bottom).offset(10)
                make.left.equalTo(headerView).offset(14)
            }
            
            return headerView
        } else {
            return nil
        }
    }
    
    //Table View Delegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 1 {
            let detailVC = BookDetailViewController(bookID: "\(Recommender.shared.reviewList[indexPath.row].bookID)")
            self.navigationController?.pushViewController(detailVC, animated: true)

            print("Push Detail View Controller, bookID: \(Recommender.shared.reviewList[indexPath.row].bookID)")
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //UIScrollViewDelegate方法，每次滚动结束后调用
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        //通过scrollView内容的偏移计算当前显示的是第几页
        let page = Int(scrollView.contentOffset.x / scrollView.frame.size.width)
        //设置pageController的当前页
        pageControl.currentPage = page
    }
    
    //点击页控件时事件处理
    @objc func pageChanged(sender: UIPageControl) {
        //根据点击的页数，计算scrollView需要显示的偏移量
        var frame = headerScrollView.frame
        frame.origin.x = frame.size.width * CGFloat(sender.currentPage)
        frame.origin.y = 0
        //展现当前页面内容
        headerScrollView.scrollRectToVisible(frame, animated:true)
    }
    
    func pushDetailViewController(bookID: String) {
        let detailVC = BookDetailViewController(bookID: bookID)
        self.navigationController?.pushViewController(detailVC, animated: true)
//        self.navigationController?.navigationBarHidden = true
        print("Push Detail View Controller, bookID: \(bookID)")
    }
    
    @objc func pushWebPage() {
        if #available(iOS 9.0, *) {
            let url = URL(string: Recommender.shared.bannerList[pageControl.currentPage].url)!
            let safariController = SFSafariViewController(url: url, entersReaderIfAvailable: true)
            self.present(safariController, animated: true, completion: nil)
//            presentViewController(safariController, animated: true, completion: nil)
        } else {
            if let url = URL(string: Recommender.shared.bannerList[pageControl.currentPage].url) {
                let safariVC = SFSafariViewController(url: url)
                self.navigationController?.pushViewController(safariVC, animated: true)
            }
            // FIXME: web app
//            let webController = WebAppViewController(address: Recommender.shared.bannerList[pageControl.currentPage].url)
//            self.navigationController?.pushViewController(webController, animated: true)
//            self.jz_navigationBarBackgroundAlpha = 0
        }
    }

    
}



