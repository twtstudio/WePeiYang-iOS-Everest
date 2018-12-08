//
//  LibraryPageTitleView.swift
//  WePeiYang
//
//  Created by 毛线 on 2018/10/25.
//  Copyright © 2018 twtstudio. All rights reserved.
//

import UIKit

protocol LibraryPageTitleViewDelegate: class {
    func libraryPageTitleView(titleView: LibraryPageTitleView, selectedIndex index: Int)
}

class LibraryPageTitleView: UIView {
    private let normalColor: (CGFloat, CGFloat, CGFloat) = (153, 153, 153)
    private let selectedColor: (CGFloat, CGFloat, CGFloat) = (176, 56, 112)
    private let scrollLineH: CGFloat = 2
    
    private var titles: [String]
    private var currentIndex: Int = 0
    weak var delegate: LibraryPageTitleViewDelegate?
    
    private lazy var titleLabel = [UILabel]()
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.scrollsToTop = false
        scrollView.bounces = false
        //设置scrollView内边距
        //        scrollView.contentInsetAdjustmentBehavior = .never
        scrollView.contentInset = .zero
        return scrollView
    }()
    
    private lazy var scrollLine: UIView = {
        let line = UIView()
        line.backgroundColor = LibraryMainViewController.darkPinkColor
        return line
    }()
    
    init(frame: CGRect, titles: [String]) {
        self.titles = titles
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension LibraryPageTitleView {
    private func setupUI() {
        addSubview(scrollView)
        scrollView.frame = bounds
        setupTitleLabels()
        setupButtomMenuAndScrollLine()
    }
    
    private func setupTitleLabels() {
        
        let labelW: CGFloat = frame.width / CGFloat(titles.count)
        let labelH: CGFloat = frame.height - scrollLineH
        let labelY: CGFloat = 0
        
        for (index, title) in titles.enumerated() {
            let label = UILabel()
            
            label.text = title
            label.tag = index
            label.font = UIFont.systemFont(ofSize: 16)
            label.textColor = UIColor(r: normalColor.0, g: normalColor.1, b: normalColor.2)
            label.textAlignment = .center
            
            let labelX: CGFloat = labelW * CGFloat(index)
            label.frame = CGRect(x: labelX, y: labelY, width: labelW, height: labelH)
            
            scrollView.addSubview(label)
            titleLabel.append(label)
            
            //给label添加手势
            label.isUserInteractionEnabled = true
            let tapGes = UITapGestureRecognizer(target: self, action: #selector(self.titleLabelClick))
            label.addGestureRecognizer(tapGes)
        }
    }
    
    private func setupButtomMenuAndScrollLine() {
        //添加底线
        let buttomLine = UIView()
        buttomLine.backgroundColor = UIColor.gray
        let lineH: CGFloat = 0.5
        buttomLine.frame = CGRect(x: 0, y: frame.height - lineH, width: frame.width, height: lineH)
        addSubview(buttomLine)
        
        //添加scrollLine
        guard let firstLabel = titleLabel.first else { return }
        firstLabel.textColor = LibraryMainViewController.darkPinkColor
        
        scrollView.addSubview(scrollLine)
        scrollLine.frame = CGRect(x: firstLabel.frame.origin.x, y: frame.height - scrollLineH, width: firstLabel.frame.width, height: scrollLineH)
    }
    
}

//监听label
extension LibraryPageTitleView {
    @objc private func titleLabelClick(tapGes: UITapGestureRecognizer) {
        //label改变颜色
        guard let currentLabel = tapGes.view as? UILabel else { return }
        let oldLabel = titleLabel[currentIndex]
        
        oldLabel.textColor = UIColor(r: normalColor.0, g: normalColor.1, b: normalColor.2)
        currentLabel.textColor = UIColor(r: selectedColor.0, g: selectedColor.1, b: selectedColor.2)
        
        currentIndex = currentLabel.tag
        
        //滚动条
        let scrollLineX = CGFloat(currentLabel.tag) * scrollLine.frame.width
        UIView.animate(withDuration: 0.15) {
            self.scrollLine.frame.origin.x = scrollLineX
        }
        
        //通知代理
        delegate?.libraryPageTitleView(titleView: self, selectedIndex: currentIndex)
    }
}

//外部可用方法
extension LibraryPageTitleView {
    @objc func setTitleWithProgress(progress: CGFloat, sourceIndex: Int, targetIndex: Int) {
        let sourceLabel = titleLabel[sourceIndex]
        let targetLabel = titleLabel[targetIndex]
        
        //处理滑块
        let moveAllX = targetLabel.frame.origin.x - sourceLabel.frame.origin.x
        let moveX = moveAllX * progress
        scrollLine.frame.origin.x = sourceLabel.frame.origin.x + moveX
        
        //颜色渐变
        let colorDelta = (selectedColor.0 - normalColor.0, selectedColor.1 - normalColor.1, selectedColor.2 - normalColor.2)
        sourceLabel.textColor = UIColor(r: selectedColor.0 - colorDelta.0 * progress, g: selectedColor.1 - colorDelta.1 * progress, b: selectedColor.2 - colorDelta.2 * progress)
        targetLabel.textColor = UIColor(r: normalColor.0 + colorDelta.0 * progress, g: normalColor.1 + colorDelta.1 * progress, b: normalColor.2 + colorDelta.2 * progress)
        
        //记录最新index
        currentIndex = targetIndex
    }
}

extension UIColor {
    convenience init(r: CGFloat, g: CGFloat, b: CGFloat) {
        self.init(red: r / 255.0, green: g / 255.0, blue: b / 255.0, alpha: 1.0)
    }
}
