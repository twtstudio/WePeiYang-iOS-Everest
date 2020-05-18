//
//  HeaderView.swift
//  WePeiYang
//
//  Created by 安宇 on 2019/10/19.
//  Copyright © 2019 twtstudio. All rights reserved.
//

import UIKit

protocol CodePageTitleViewDelegate: class {
    func codePageTitleView(titleView: CodePageTitleView, selectedIndex index: Int)
}

class CodePageTitleView: UIView {
    private let normalColor: (CGFloat, CGFloat, CGFloat) = (153, 153, 153)
    private let selectedColor: (CGFloat, CGFloat, CGFloat) = (176, 56, 112)
    private let scrollLineH: CGFloat = 2
    
    private var titles: [String]
    var currentIndex: Int = 0
    weak var delegate: CodePageTitleViewDelegate?
    
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
        line.backgroundColor = MyColor.ColorHex("#54B9F1")
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

extension CodePageTitleView {
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
            label.layer.borderColor = UIColor.white.cgColor
            label.font = UIFont.systemFont(ofSize: 16)
            label.textColor = .black
            label.textAlignment = .center
            label.backgroundColor = .white
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
//        buttomLine.backgroundColor = UIColor.gray
        let lineH: CGFloat = 0.5
        buttomLine.frame = CGRect(x: 0, y: frame.height - lineH, width: frame.width, height: lineH)
        buttomLine.backgroundColor = .white
        addSubview(buttomLine)
        
        //添加scrollLine
        guard let firstLabel = titleLabel.first else { return }
        firstLabel.textColor = MyColor.ColorHex("#54B9F1")
        
        scrollView.addSubview(scrollLine)
        scrollLine.frame = CGRect(x: firstLabel.frame.origin.x, y: frame.height - scrollLineH, width: firstLabel.frame.width, height: scrollLineH)
    }
    
}

//监听label
extension CodePageTitleView {
    @objc private func titleLabelClick(tapGes: UITapGestureRecognizer) {
        //label改变颜色
        guard let currentLabel = tapGes.view as? UILabel else { return }
        let oldLabel = titleLabel[currentIndex]
//        Rank.current = currentIndex
//        print(currentIndex)
        oldLabel.textColor = .black
        currentLabel.textColor = MyColor.ColorHex("#54B9F1")
        currentIndex = currentLabel.tag
        
        //滚动条
        let scrollLineX = CGFloat(currentLabel.tag) * scrollLine.frame.width
        UIView.animate(withDuration: 0.15) {
            self.scrollLine.frame.origin.x = scrollLineX
        }
        
        //通知代理
        delegate?.codePageTitleView(titleView: self, selectedIndex: currentIndex)
    }
}

//外部可用方法
extension CodePageTitleView {
    @objc func setTitleWithProgress(progress: CGFloat, sourceIndex: Int, targetIndex: Int) {
        let sourceLabel = titleLabel[sourceIndex]
        let targetLabel = titleLabel[targetIndex]
        
        //处理滑块
        let moveAllX = targetLabel.frame.origin.x - sourceLabel.frame.origin.x
        let moveX = moveAllX * progress
        scrollLine.frame.origin.x = sourceLabel.frame.origin.x + moveX
        
        //颜色渐变
//        let colorDelta = (selectedColor.0 - normalColor.0, selectedColor.1 - normalColor.1, selectedColor.2 - normalColor.2)
        sourceLabel.textColor = .black
        targetLabel.textColor = MyColor.ColorHex("#54B9F1")
        
        //记录最新index
        currentIndex = targetIndex
    }
}
