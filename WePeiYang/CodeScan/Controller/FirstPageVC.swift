//
//  FirstPageVC.swift
//  WePeiYang
//
//  Created by 安宇 on 2019/10/19.
//  Copyright © 2019 twtstudio. All rights reserved.
//

import UIKit

private let statusH: CGFloat = UIApplication.shared.statusBarFrame.height
private let navigationBarH: CGFloat = 44
private let tabbarH: CGFloat = 44

struct Rank {
    var current: Int = 0
}

class CLibraryMainViewController: UIViewController {
    static let mainColor = UIColor(r: 238, g: 143, b: 174)
    static let darkPinkColor = UIColor(r: 167, g: 56, b: 112)
    static let bgColor = UIColor(r: 247, g: 247, b: 247)
    static let fontColor = UIColor(r: 102, g: 102, b: 102)
    static let fontDarkColor = UIColor(r: 51, g: 51, b: 51)
    static let fontGrayColor = UIColor(r: 153, g: 153, b: 153)
    
    private let screenW = UIScreen.main.bounds.width
    private let screenH = UIScreen.main.bounds.height
    private let titleViewH: CGFloat = UIScreen.main.bounds.height * 0.06
    
    private lazy var pageTitleView: CodePageTitleView = {[weak self] in
        let titleFrame = CGRect(x: 0, y: navigationBarH + statusH, width: screenW, height: titleViewH)
        let titleView = CodePageTitleView(frame: titleFrame, titles: ["管理","已参加","未参加"])
        titleView.delegate = self
        titleView.backgroundColor = .clear
        return titleView
        }()
    
    private lazy var pageContentView: LibraryPageContentView = {[weak self] in
        //确定frame
        let contentH = screenH - statusH - titleViewH  - navigationBarH
        let contentFrame = CGRect(x: 0, y: statusH + navigationBarH + titleViewH, width: screenW, height: contentH)
        
        //确定子控制器
        var childVCs = [UIViewController]()
        childVCs.append(ActivitiesViewController())
        childVCs.append(TmpViewController())
        childVCs.append(TmpViewController())
        
        let contentView = LibraryPageContentView(frame: contentFrame, childVCs: childVCs, parentVC: self)
        contentView.delegate = self
        return contentView
        }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        setupUI()
        self.view.backgroundColor = CLibraryMainViewController.bgColor
        hidesBottomBarWhenPushed = true
        
    }
    
    @objc func close() {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
    }
}

extension CLibraryMainViewController {
    private func setupUI() {
        self.title = "活动"

        if isModal {
            let image = UIImage(named: "ic_back")
            self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(close))
        }
        
        view.addSubview(pageTitleView)
        view.addSubview(pageContentView)
    }
}

//遵守PageTitleViewdelegate
extension CLibraryMainViewController: CodePageTitleViewDelegate {
    func codePageTitleView(titleView: CodePageTitleView, selectedIndex index: Int) {
        pageContentView.setCurrentIndex(currentIndex: index)
    }
}

//遵守PageContentViewdelegate
extension CLibraryMainViewController: LibraryPageContentViewDelegate {
    func libraryPageContentView(contentView: LibraryPageContentView, progress: CGFloat, sourceIndex: Int, targetIndex: Int) {
        pageTitleView.setTitleWithProgress(progress: progress, sourceIndex: sourceIndex, targetIndex: targetIndex)
    }
}
