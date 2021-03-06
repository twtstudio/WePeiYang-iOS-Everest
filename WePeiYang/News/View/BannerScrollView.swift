//
//  BannerScrollView.swift
//  WePeiYang
//
//  Created by Rick on 2018/2/8.
//  Copyright © 2018年 twtstudio. All rights reserved.
//

import UIKit

// MARK: - 滑动点击代理
@objc protocol BannerScrollViewDelegate {
    // 点击图片回调
    @objc optional func bannerScrollViewDidSelect(at index: Int, bannerScrollView: BannerScrollView)
    // 图片滚动回调
    @objc optional func bannerScrollViewDidScroll(to index: Int, bannerScrollView: BannerScrollView)
}

class BannerScrollView: UIView, PageControlAlimentProtocol, EndlessScrollProtocol {

    // MARK: 属性
    weak var delegate: BannerScrollViewDelegate!

    var outerPageControlFrame: CGRect? {
        didSet {
            setupPageControl()
        }
    }

    var descTextArray: [String]?
    var placeholderImage: UIImage?

    // BannerCell
    var descLabelFont: UIFont?
    var descLabelHeight: CGFloat?
    var descLabelTextColor: UIColor?
    var bottomViewBackgroundColor: UIColor?
    var imageContentModel: UIView.ContentMode?
    var descLabelTextAlignment: NSTextAlignment?

    var isAutoScroll: Bool = true {
        didSet {
            timer?.invalidate()
            timer = nil
            if isAutoScroll {
                setupTimer()
            }
        }
    }

    var isEndlessScroll: Bool = true {
        didSet {
            reloadData()
        }
    }

    var autoScrollInterval: Double = 5

    // pageControl
    var pageControlAliment: PageControlAliment = .CenterBottom
    var defaultPageDotImage: UIImage? {
        didSet {
            setupPageControl()
        }
    }

    var currentPageDotImage: UIImage? {
        didSet {
            setupPageControl()
        }
    }

    var pageControlPointSpace: CGFloat = 15 {
        didSet {
            setupPageControl()
        }
    }

    var showPageControl: Bool = true {
        didSet {
            setupPageControl()
        }
    }

    var currentDotColor: UIColor = #colorLiteral(red: 0.2588235438, green: 0.7568627596, blue: 0.9686274529, alpha: 1) {
        didSet {
            self.pageControl?.currentPageIndicatorTintColor = currentDotColor
        }
    }

    var otherDotColor: UIColor = UIColor.gray {
        didSet {
            self.pageControl?.pageIndicatorTintColor = otherDotColor
        }
    }

    // MARK: 外部方法
    func reloadData() {

        timer?.invalidate()
        timer = nil
        collectionView.reloadData()
        setupPageControl()

        if canChangeBannerCell {
            changeToFirstBannerCell(animated: false, collectionView: collectionView)
        }
        if isAutoScroll {
            setupTimer()
        }
        guard let pageControl = self.pageControl else {
            return
        }

        if showPageControl {
            if let outFrame = outerPageControlFrame {
                self.relayoutPageControl(pageControl: pageControl, outerFrame: outFrame)
            } else {
                self.relayoutPageControl(pageControl: pageControl)
            }
        }
    }

    // MARK: 内部属性
    fileprivate var proxy: Proxy!
    fileprivate var flowLayout: UICollectionViewFlowLayout!
    fileprivate var collectionView: UICollectionView!
    fileprivate let CellID = "BannerCell"
    fileprivate var pageControl: PageControl?
    fileprivate var isLoadOver = false

    var timer: Timer?
    let endlessScrollTimes: Int = 128

    fileprivate var imgsCount: Int {
        return isEndlessScroll ? (itemsInSection / endlessScrollTimes) : itemsInSection
    }

    var itemsInSection: Int {
        guard let imgs = proxy?.imgArray else {
            return 0
        }
        return isEndlessScroll ? (imgs.count * endlessScrollTimes) : imgs.count
    }

    fileprivate var firstItem: Int {
        return isEndlessScroll ? (itemsInSection / 2) : 0
    }

    fileprivate var canChangeBannerCell: Bool {
        guard itemsInSection != 0,
            collectionView != nil,
            flowLayout != nil else {
                return false
        }
        return true
    }

    fileprivate var indexOnPageControl: Int {
        var curIndex = Int((collectionView.contentOffset.x + flowLayout.itemSize.width * 0.5) / flowLayout.itemSize.width)
        curIndex = max(0, curIndex)
        return curIndex % imgsCount
    }

    // MARK: initialize
    init(frame: CGRect, type: ImgType, imgs: [String] = [], descs: [String] = [], defaultDotImage: UIImage? = nil, currentDotImage: UIImage? = nil, placeholderImage: UIImage? = nil) {

        super.init(frame: frame)
        setupCollectionView()

        flowLayout.itemSize = frame.size
        collectionView.frame = bounds
        collectionView.backgroundColor = .white

        defaultPageDotImage = defaultDotImage
        currentPageDotImage = currentDotImage
        self.placeholderImage = placeholderImage

        load(type: type, imgs: imgs, descs: descs)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setupCollectionView()
    }

    func load(type: ImgType, imgs: [String], descs: [String]) {
        proxy = Proxy(type: type, array: imgs)
        descTextArray = descs
        reloadData()
    }

    // MARK: layoutSubviews、willMove
    override func layoutSubviews() {
        super.layoutSubviews()

        collectionView.contentInset = .zero
        if !isLoadOver && canChangeBannerCell {
            changeToFirstBannerCell(animated: false, collectionView: collectionView)
        }

        guard let pageControl = self.pageControl else {
            return
        }

        if showPageControl {
            if let outFrame = outerPageControlFrame {
                self.relayoutPageControl(pageControl: pageControl, outerFrame: outFrame)
            } else {
                self.relayoutPageControl(pageControl: pageControl)
            }
        }
    }

    override func willMove(toSuperview newSuperview: UIView?) {
        super.willMove(toSuperview: newSuperview)
        guard newSuperview != nil else {
            timer?.invalidate()
            timer = nil
            return
        }
    }
}

// MARK: - 代理&方法
extension BannerScrollView {
    func setupTimer() {
        timer = Timer(timeInterval: autoScrollInterval, target: self, selector: #selector(autoChangeBannerCell), userInfo: nil, repeats: true)
        RunLoop.main.add(timer!, forMode: RunLoop.Mode.common)
    }

    @objc func autoChangeBannerCell() {
        if canChangeBannerCell {
            changeBannerCell(collectionView: collectionView)
        }
    }

    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        timer?.invalidate()
    }

    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if isAutoScroll {
            setupTimer()
        }
    }

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        scrollViewDidEndScrollingAnimation(scrollView)
    }

    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        guard canChangeBannerCell else {
            return
        }
        delegate?.bannerScrollViewDidScroll?(to: indexOnPageControl, bannerScrollView: self)

        if indexOnPageControl >= firstItem {
            isLoadOver = true
        }
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard canChangeBannerCell else {
            return
        }
        pageControl?.currentPage = indexOnPageControl
    }
}

// MARK: - pageControl
extension BannerScrollView {
    fileprivate func setupPageControl() {
        pageControl?.removeFromSuperview()
        if showPageControl {
            pageControl = PageControl(frame: CGRect.zero, currentImage: currentPageDotImage, defaultImage: defaultPageDotImage)
            pageControl?.numberOfPages = imgsCount
            pageControl?.hidesForSinglePage = true
            pageControl?.currentPageIndicatorTintColor = self.currentDotColor
            pageControl?.pageIndicatorTintColor = self.otherDotColor
            pageControl?.isUserInteractionEnabled = false
            pageControl?.pointSpace = pageControlPointSpace

            if outerPageControlFrame != nil {
                superview?.addSubview(pageControl!)
            } else {
                addSubview(pageControl!)
            }
        }
    }
}

// MARK: - BannerCell
extension BannerScrollView: UICollectionViewDelegate, UICollectionViewDataSource {
    fileprivate func setupCollectionView() {
        flowLayout = UICollectionViewFlowLayout()
        flowLayout.itemSize = frame.size
        flowLayout.minimumLineSpacing = 0
        flowLayout.scrollDirection = .horizontal

        collectionView = UICollectionView(frame: bounds, collectionViewLayout: flowLayout)
        collectionView.register(BannerCell.self, forCellWithReuseIdentifier: CellID)
        collectionView.isPagingEnabled = true
        collectionView.bounces = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.delegate = self
        collectionView.dataSource = self
        addSubview(collectionView)
    }

    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return itemsInSection
    }

    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let curIndex = indexPath.item % imgsCount
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CellID, for: indexPath) as! BannerCell
        cell.placeholderImage = placeholderImage
        cell.imgSource = proxy[curIndex]
        if let curDescText = descTextArray?[curIndex] {
            cell.descText = curDescText
        } else {
            cell.descText = ""
        }

        if descTextArray != nil {
            cell.imageContentModel = imageContentModel ?? cell.imageContentModel
            cell.descLabelFont = descLabelFont ?? cell.descLabelFont
            cell.descLabelTextColor = descLabelTextColor ?? cell.descLabelTextColor
            cell.bottomViewlHeight = descLabelHeight ?? cell.bottomViewlHeight
            cell.descLabelTextAlignment = descLabelTextAlignment ?? cell.descLabelTextAlignment
            cell.bottomViewBackgroundColor = bottomViewBackgroundColor ?? cell.bottomViewBackgroundColor
        }
        return cell
    }

    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.bannerScrollViewDidSelect?(at: indexOnPageControl, bannerScrollView: self)
    }
}
