//
//  BannerProxy.swift
//  WePeiYang
//
//  Created by Rick on 2018/2/8.
//  Copyright © 2018年 twtstudio. All rights reserved.
//

import UIKit

// MARK: 数据

// 图片资源
enum ImgSource {
    case server(url: URL)
    case local(name: String)
}

// 图片类型
enum ImgType: Int {
    case server = 0     // default
    case local = 1
}

struct Proxy {
    var imgType: ImgType = .server
    var imgArray: [ImgSource] = [ImgSource]()

    subscript (index: Int) -> ImgSource {
        return imgArray[index]
    }

    // 构造方法
    init(type: ImgType, array: [String]) {
        imgType = type
        if imgType == .server {
            imgArray = array.map { urlStr in
                if let url = URL(string: urlStr) {
                    return ImgSource.server(url: url)
                }
                return ImgSource.local(name: "placeholder")
            }
        } else {
            imgArray = array.map { name in
                return ImgSource.local(name: name)
            }
        }
    }
}

// MARK: pageControl
private let PageControlMargin: CGFloat = 15
private let PageControlPointWidth: CGFloat = 4

enum PageControlAliment {
    case CenterBottom
    case RightBottom
    case LeftBottom
}

protocol PageControlAlimentProtocol {
    var pageControlAliment: PageControlAliment { get set }
    var pageControlPointSpace: CGFloat { get set }
    func relayoutPageControl(pageControl: PageControl)
    func relayoutPageControl(pageControl: PageControl, outerFrame: CGRect)
}

extension PageControlAlimentProtocol where Self: UIView {
    func relayoutPageControl(pageControl: PageControl) {
        if pageControl.isHidden == false {
            // MARK: - pageControl的高度 在这里改
            let pageH: CGFloat = 30
            let pageY = bounds.height - pageH
            let pageW = pageControl.pageSize.width
            var pageX: CGFloat = 0

            switch self.pageControlAliment {
            case .CenterBottom:
                pageX = CGFloat(self.bounds.width / 2) - pageW * 0.5
            case .RightBottom:
                pageX = bounds.width - pageW - PageControlMargin
            case .LeftBottom:
                pageX = bounds.origin.x + PageControlMargin
            }
            pageControl.frame = CGRect(x: pageX, y: pageY, width: pageW, height: pageH)
        }
    }

    func relayoutPageControl(pageControl: PageControl, outerFrame: CGRect) {
        if pageControl.isHidden == false {
            pageControl.frame = CGRect(x: outerFrame.origin.x, y: outerFrame.origin.y, width: pageControl.pageSize.width, height: pageControl.pageSize.height)
        }
    }
}

// MARK: 无限轮播
protocol EndlessScrollProtocol {

    var isAutoScroll: Bool { get set }
    var autoScrollInterval: Double { get set }
    var timer: Timer? { get set }
    var isEndlessScroll: Bool { get set }
    var endlessScrollTimes: Int { get }
    var itemsInSection: Int { get }
    func setupTimer()
    func changeToFirstBannerCell(animated: Bool, collectionView: UICollectionView)
}

extension EndlessScrollProtocol where Self: UIView {
    func changeBannerCell(collectionView: UICollectionView) {
        guard itemsInSection != 0 else {
            return
        }

        let flowLayout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        let curItem = Int(collectionView.contentOffset.x / flowLayout.itemSize.width)
        if curItem == itemsInSection - 1 {
            let animated = isEndlessScroll ? false : true
            changeToFirstBannerCell(animated: animated, collectionView: collectionView)
        } else {
            let indexPath = IndexPath(item: curItem + 1, section: 0)
            collectionView.scrollToItem(at: indexPath, at: .init(rawValue: 0), animated: true)
        }
    }

    func changeToFirstBannerCell(animated: Bool, collectionView: UICollectionView) {
        guard itemsInSection != 0 else {
            return
        }

        let firstItem = isEndlessScroll ? (itemsInSection / 2) : 0
        let indexPath = IndexPath(item: firstItem, section: 0)
        collectionView.scrollToItem(at: indexPath, at: .init(rawValue: 0), animated: animated)
    }
}
