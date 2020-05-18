//
//  TitleView.swift
//  WePeiYang
//
//  Created by 安宇 on 2020/3/23.
//  Copyright © 2020 twtstudio. All rights reserved.
//

import UIKit

class Flag {
    static var id = 0
}

protocol ClassRoomCheckPageTitleViewDelegate: class {
    func classroomCheckPageTitleView(titleView: ClassRoomCheckPageTitleView, selectedIndex index: Int)
}

class ClassRoomCheckPageTitleView: UIView {
    private let normalColor: (CGFloat, CGFloat, CGFloat) = (153, 153, 153)
    private let selectedColor: (CGFloat, CGFloat, CGFloat) = (176, 56, 112)
    private let scrollLineH: CGFloat = 2
    
    private var titles: [String]
    var currentIndex: Int = 0
    weak var delegate: ClassRoomCheckPageTitleViewDelegate?
    
    public lazy var titleLabel = [UILabel]()
    public lazy var inviButton = [UIButton]()
    private lazy var lineView = [UIView]()
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
    
    public lazy var scrollLine: UIView = {
        let line = UIView()
        line.backgroundColor = UIColor(red: 0.42, green: 0.62, blue: 0.64, alpha: 1)
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

extension ClassRoomCheckPageTitleView {
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
            let button = UIButton()
            let line = UIView()
            
            label.text = title
            label.tag = index
            label.layer.borderColor = UIColor.white.cgColor
            label.font = UIFont.systemFont(ofSize: 16)
            label.textColor = UIColor(red: 0.42, green: 0.62, blue: 0.64, alpha: 1)
            label.textAlignment = .center
            label.backgroundColor = .white
            let labelX: CGFloat = labelW * CGFloat(index)
            label.frame = CGRect(x: labelX, y: labelY, width: labelW, height: labelH)
//
//            button.snp.makeConstraints { (make) in
//                make.width.equalTo(7)
//                make.height.equalTo(7)
//                make.right.equalTo(labelW + labelX - 41)
//                make.bottom.equalTo(labelY + labelH - 13)
//            }
            if index == 0 {
                
                button.frame = CGRect(x: labelW + labelX - 34, y: labelY + labelH - 20, width: 7, height: 7)
            } else {
                button.frame = CGRect(x: labelW + labelX - 27, y: labelY + labelH - 20, width: 7, height: 7)
            }
            button.tag = index
            
//            layer设置
            
            let path = UIBezierPath()
            path.move(to: CGPoint(x: 0, y: 7))
            path.addLine(to: CGPoint(x: 7, y: 7))
            path.addLine(to: CGPoint(x: 7, y: 0))
            let shapeLayer = CAShapeLayer()
            shapeLayer.path = path.cgPath
            shapeLayer.fillColor = UIColor(red: 0.42, green: 0.62, blue: 0.64, alpha: 1).cgColor
            shapeLayer.lineWidth = 0.5
            button.layer.addSublayer(shapeLayer)
            
            line.backgroundColor = UIColor(red: 0.42, green: 0.62, blue: 0.64, alpha: 0.3)
            
            
            
            scrollView.addSubview(label)
            
            
            titleLabel.append(label)
            inviButton.append(button)
            
            if index != 2 {
                scrollView.addSubview(button)
                line.frame = CGRect(x: labelW + labelX - 1, y: labelY + labelH - 33, width: 1, height: 26)
            }
            scrollView.addSubview(line)
            lineView.append(line)

            
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
        buttomLine.backgroundColor = UIColor(red: 0.42, green: 0.62, blue: 0.64, alpha: 1)
        addSubview(buttomLine)
        
//        MARK: 改了下面第一个label颜色
        //添加scrollLine
        guard let firstLabel = titleLabel.first else { return }
        firstLabel.textColor = UIColor(red: 0.42, green: 0.62, blue: 0.64, alpha: 1)
        
//        scrollView.addSubview(scrollLine)
        scrollLine.frame = CGRect(x: firstLabel.frame.origin.x, y: frame.height - scrollLineH, width: firstLabel.frame.width, height: scrollLineH)
    }
    
}

//监听label
extension ClassRoomCheckPageTitleView {
    @objc private func titleLabelClick(tapGes: UITapGestureRecognizer) {
        //label改变颜色
        guard let currentLabel = tapGes.view as? UILabel else { return }
        let oldLabel = titleLabel[currentIndex]
//        Rank.current = currentIndex
//        print(currentIndex)
        oldLabel.textColor = UIColor(red: 0.42, green: 0.62, blue: 0.64, alpha: 1)
        currentLabel.textColor = UIColor(red: 0.42, green: 0.62, blue: 0.64, alpha: 1)
        currentIndex = currentLabel.tag
        
        //滚动条
        let scrollLineX = CGFloat(currentLabel.tag) * scrollLine.frame.width
        UIView.animate(withDuration: 0.15) {
            self.scrollLine.frame.origin.x = scrollLineX
        }
        
        //通知代理
        delegate?.classroomCheckPageTitleView(titleView: self, selectedIndex: currentIndex)
    }
}

//监听label
extension ClassRoomCheckPageTitleView {
    @objc private func buttonClick(tapGes: UITapGestureRecognizer) {
        //label改变颜色
        guard let currentLabel = tapGes.view as? UILabel else { return }
        let oldLabel = titleLabel[currentIndex]
//        Rank.current = currentIndex
//        print(currentIndex)
        oldLabel.textColor = .black
        currentLabel.textColor = .red
        currentIndex = currentLabel.tag
        
        //滚动条
        let scrollLineX = CGFloat(currentLabel.tag) * scrollLine.frame.width
        UIView.animate(withDuration: 0.15) {
            self.scrollLine.frame.origin.x = scrollLineX
        }
        
        //通知代理
        delegate?.classroomCheckPageTitleView(titleView: self, selectedIndex: currentIndex)
    }
}

//外部可用方法
extension ClassRoomCheckPageTitleView {
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
        targetLabel.textColor = .red
        
        //记录最新index
        currentIndex = targetIndex
    }
}

