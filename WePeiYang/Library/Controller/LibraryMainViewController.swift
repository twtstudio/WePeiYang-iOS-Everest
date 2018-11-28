//
//  LibraryMainViewController.swift
//  WePeiYang
//
//  Created by 毛线 on 2018/10/25.
//  Copyright © 2018 twtstudio. All rights reserved.
//

import UIKit

let statusH: CGFloat = UIApplication.shared.statusBarFrame.height
let navigationBarH: CGFloat = 44
let tabbarH: CGFloat = 44

class LibraryMainViewController: UIViewController {
    static let mainColor = UIColor(r: 238, g: 143, b: 174)
    static let darkPinkColor = UIColor(r: 167, g: 56, b: 112)
    static let bgColor = UIColor(r: 247, g: 247, b: 247)
    static let fontColor = UIColor(r: 102, g: 102, b: 102)
    static let fontDarkColor = UIColor(r: 51, g: 51, b: 51)
    static let fontGrayColor = UIColor(r: 153, g: 153, b: 153)
    
    private let screenW = UIScreen.main.bounds.width
    private let screenH = UIScreen.main.bounds.height
    private let titleViewH: CGFloat = UIScreen.main.bounds.height * 0.06
    
    private lazy var pageTitleView: LibraryPageTitleView = {[weak self] in
        let titleFrame = CGRect(x: 0, y: navigationBarH + statusH, width: screenW, height: titleViewH)
        //        let titles = ["已借阅", "借阅统计", "阅读板块"]
        let titleView = LibraryPageTitleView(frame: titleFrame, titles: BookCostant.moduleTitles)
        titleView.delegate = self
        return titleView
        }()
    
    private lazy var pageContentView: LibraryPageContentView = {[weak self] in
        //确定frame
        let contentH = screenH - statusH - titleViewH  - navigationBarH
        let contentFrame = CGRect(x: 0, y: statusH + navigationBarH + titleViewH, width: screenW, height: contentH)
        
        //确定子控制器
        var childVCs = [UIViewController]()
        childVCs.append(LibraryBorrowViewController())
        childVCs.append(LibraryListViewController())
        childVCs.append(LibraryReadViewController())
        
        let contentView = LibraryPageContentView(frame: contentFrame, childVCs: childVCs, parentVC: self)
        contentView.delegate = self
        return contentView
        }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        self.view.backgroundColor = LibraryMainViewController.bgColor
        hidesBottomBarWhenPushed = true
        
    }
    
    @objc func close() {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(color: LibraryMainViewController.mainColor), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.navigationBar.barStyle = .black
        
        self.navigationController?.navigationBar.tintColor = .white
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
    }
}

extension LibraryMainViewController {
    private func setupUI() {
        self.title = "图书馆"
        let titleLabel = UILabel(text: "图书馆")
        titleLabel.backgroundColor = UIColor.clear
        titleLabel.font = UIFont.boldSystemFont(ofSize: 18.0)
        titleLabel.textColor = UIColor.white
        titleLabel.sizeToFit()
        self.navigationItem.titleView = titleLabel
        
        if isModal {
            let image = UIImage(named: "ic_back")
            self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(close))
        }
        
        view.addSubview(pageTitleView)
        view.addSubview(pageContentView)
    }
}

//遵守PageTitleViewdelegate
extension LibraryMainViewController: LibraryPageTitleViewDelegate {
    func libraryPageTitleView(titleView: LibraryPageTitleView, selectedIndex index: Int) {
        pageContentView.setCurrentIndex(currentIndex: index)
    }
}

//遵守PageContentViewdelegate
extension LibraryMainViewController: LibraryPageContentViewDelegate {
    func libraryPageContentView(contentView: LibraryPageContentView, progress: CGFloat, sourceIndex: Int, targetIndex: Int) {
        pageTitleView.setTitleWithProgress(progress: progress, sourceIndex: sourceIndex, targetIndex: targetIndex)
    }
}
