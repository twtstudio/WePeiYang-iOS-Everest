//
//  CalendarView.swift
//  WePeiYang
//
//  Created by 安宇 on 2020/3/23.
//  Copyright © 2020 twtstudio. All rights reserved.
//

import UIKit
import SnapKit

class CalendarView: UIView {
    
    private let screenW = UIScreen.main.bounds.width
    private let screenH = UIScreen.main.bounds.height
    private let headerViewId = "header"
    private let array = ["一", "二", "三", "四", "五", "六", "日"]
    private var calendar: Calendar = Calendar(identifier: .gregorian)
    private var comps = DateComponents()
    private var date: [Int] = []
//    private let comps =
    override init(frame: CGRect) {
        super.init(frame: frame)
        
//        layout()
//        self.backgroundColor = .blue
        self.backgroundColor = .white
//
        comps = calendar.dateComponents([.year, .month, .day, .hour, .weekday], from: Date())
        date.append(comps.year!)
        date.append(comps.month!)
        date.append(comps.day!)
        date.append(comps.weekday!)
//        date.append()
        DateHelper.year = comps.year!
        DateHelper.month = comps.month!
        setupCollectionView()
//        print(firstDayOfWeekInMonth(year: 2020, month: ))
    }
    
    
    func setupCollectionView() -> UICollectionView {
        let headerView = UIView()
        headerView.backgroundColor = UIColor(red: 0.42, green: 0.62, blue: 0.64, alpha: 1)
        self.addSubview(headerView)
        headerView.snp.makeConstraints { (make) in
            make.top.equalTo(0)
            make.width.equalToSuperview()
            make.height.equalTo(50)
            make.left.equalTo(0)
        }
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.itemSize = CGSize(width: (screenW - 160) / 7, height: 40)

        layout.headerReferenceSize = CGSize(width: self.bounds.width, height: 70)
        let collectionView: UICollectionView = UICollectionView(frame: CGRect(x: 30, y: 50, width: screenW - 160, height: 400), collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = .white
        collectionView.register(Test2CollectionViewCell.self, forCellWithReuseIdentifier: "id")
        collectionView.register(UICollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerViewId)
        self.addSubview(collectionView)
    
        return collectionView

    }
    
    func numberOfDaysInMonth(year: Int, month: Int) -> Int {
        return Calendar.current.range(of: .day, in: .month, for: self.getSelectDate(year: year, month: month))?.count ?? 0
    }
    func getSelectDate(year: Int, month: Int) -> Date {
        var dateComponents = DateComponents()
        dateComponents.year = year
        dateComponents.month = month
        let calendar = Calendar(identifier: .gregorian)
        return calendar.date(from: dateComponents)!
    }
    //获取目标月份第一天星期几
    func firstDayOfWeekInMonth(year: Int, month: Int) -> Int {
        return Calendar.current.ordinality(of: .day, in: .weekOfYear, for: self.getSelectDate(year: year, month: month))!
    }
    
    @objc func reload(button: UIButton) {
        switch button.tag {
        case 0:
            DateHelper.month = DateHelper.month > 1 ? DateHelper.month - 1 : 12
            DateHelper.year = DateHelper.month == 12 ? DateHelper.year - 1 : DateHelper.year
        default:
            DateHelper.month = DateHelper.month > 11 ? 1 : DateHelper.month + 1
            DateHelper.year = DateHelper.month == 1 ? DateHelper.year + 1 : DateHelper.year
        }
        setupCollectionView().reloadData()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension CalendarView: UICollectionViewDelegate {
    
}

extension CalendarView: UICollectionViewDelegateFlowLayout {
    
}

extension CalendarView: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            return 7
        } else {
            return 42
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "id", for: indexPath) as! Test2CollectionViewCell
        if indexPath.section == 0 {
            cell.label.text = array[indexPath.row]
        } else {
            var firstDayOfMonth = firstDayOfWeekInMonth(year: DateHelper.year, month: DateHelper.month)
            firstDayOfMonth = firstDayOfMonth == 1 ? 7 : firstDayOfMonth - 1
            let numOfTheMonth = numberOfDaysInMonth(year: DateHelper.year, month: DateHelper.month)
            let last = DateHelper.month > 1 ? DateHelper.month - 1 : 12
            let numOfLastMonth = numberOfDaysInMonth(year: DateHelper.year, month: last)
            var daysArray: [String] = []
            for i in 0..<firstDayOfMonth - 1 {
                daysArray.append(String(numOfLastMonth + i - firstDayOfMonth + 2))
            }
            for num in firstDayOfMonth-1...firstDayOfMonth + numOfTheMonth - 2 {
                daysArray.append(String(num - firstDayOfMonth + 2))
            }
            for i in firstDayOfMonth + numOfTheMonth - 1...41 {
                daysArray.append(String(i - (firstDayOfMonth + numOfTheMonth - 2)))
            }
            if indexPath.row < firstDayOfMonth - 1 {
                cell.label.textColor = .gray
            } else if indexPath.row < firstDayOfMonth + numOfTheMonth - 1 {
                cell.label.textColor = .black
            } else {
                cell.label.textColor = .gray
            }
            
            cell.label.text = daysArray[indexPath.row]
            
        }
//        MARK: 日历没写完，包括颜色
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets{
        return UIEdgeInsets(top: 5, left: 10, bottom: 5, right: 10)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        if section == 0 {
            return CGSize(width: self.bounds.width, height: 70)
        } else {
            return CGSize(width: self.bounds.width, height: 15)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! Test2CollectionViewCell
        if indexPath.section == 1 {
            cell.label.textColor = .white
            cell.backgroundV.isHidden = false
            let currentViewController = UIViewController.current()
            DateHelper.day = Int(cell.label.text!)!
            var week = 0
            for i in BOTHelper.month..<DateHelper.month {
                week += numberOfDaysInMonth(year: DateHelper.year, month: i)
            }
            week -= BOTHelper.day
            week += (DateHelper.day + 1)
//            第六周第六天 week = 41
            let day = week % 7 == 0 ? 7 : week % 7
            week = week % 7 == 0 ? week / 7 : 1 + week / 7
            
            ClassHelper.week = week
            ClassHelper.day = day
            RoomHelper.fit = 1
            ClassHelper.courseList = [Int]()
            currentViewController?.navigationController?.pushViewController(ClassroomCheckViewController(), animated: false)

        }
        //        MARK: 后续跳转和didselect
    }
            
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! Test2CollectionViewCell
        if indexPath.section == 1 {
            cell.label.textColor = .black
            cell.backgroundV.isHidden = true
            cell.contentView.backgroundColor = .white
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {

            if let header = collectionView.dequeueReusableSupplementaryView(ofKind:
                                                                                UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerViewId,
                                                      for: indexPath) as? UICollectionReusableView {
                
                //设置分组标题
    //            header.titleLabel.text = "上午"
                let leftButton = UIButton()
                let rightButton = UIButton()
                let dateLabel = UILabel()
                header.addSubview(leftButton)
                header.addSubview(rightButton)
                header.addSubview(dateLabel)

                leftButton.snp.makeConstraints { (make) in
                    make.left.equalTo(10)
                    make.top.equalTo(24)
                    make.width.equalTo(10)
                    make.height.equalTo(20)
                }
                leftButton.tag = 0
                leftButton.addTarget(self, action: #selector(reload(button: )), for: .touchUpInside)
                rightButton.snp.makeConstraints { (make) in
                    make.right.equalToSuperview().offset(-10)
                    make.top.equalTo(24)
                    make.width.equalTo(10)
                    make.height.equalTo(20)
                }
                rightButton.tag = 1
                rightButton.addTarget(self, action: #selector(reload(button: )), for: .touchUpInside)
                dateLabel.snp.makeConstraints { (make) in
                    make.centerX.equalToSuperview()
                    make.top.equalTo(25)
                    make.width.equalTo(200)
                    make.centerY.equalTo(leftButton.snp.centerY)
//                    make.height.equalTo(20)
                }

                
                let leftPath = UIBezierPath()
                leftPath.move(to: CGPoint(x: 10, y: 2))
                leftPath.addLine(to: CGPoint(x: 2, y: 10))
                leftPath.addLine(to: CGPoint(x: 10, y: 18))
                
                let rightPath = UIBezierPath()
                rightPath.move(to: CGPoint(x: 0, y: 2))
                rightPath.addLine(to: CGPoint(x: 8, y: 10))
                rightPath.addLine(to: CGPoint(x: 0, y: 18))
                
                
                let rightShapeLayer = CAShapeLayer()
                rightShapeLayer.path = rightPath.cgPath
                rightShapeLayer.strokeColor = UIColor(red: 0.42, green: 0.62, blue: 0.64, alpha: 1).cgColor
                rightShapeLayer.fillColor = UIColor.white.cgColor
                rightShapeLayer.lineWidth = 2
                rightButton.layer.addSublayer(rightShapeLayer)
                
                
                let leftShapeLayer = CAShapeLayer()
                leftShapeLayer.path = leftPath.cgPath
                leftShapeLayer.strokeColor = UIColor(red: 0.42, green: 0.62, blue: 0.64, alpha: 1).cgColor
                leftShapeLayer.fillColor = UIColor.white.cgColor
                leftShapeLayer.lineWidth = 2
                leftButton.layer.addSublayer(leftShapeLayer)
                
                
                dateLabel.text = String(DateHelper.year) + "年" + String(DateHelper.month) + "月"
                dateLabel.textColor = UIColor(red: 0.42, green: 0.62, blue: 0.64, alpha: 1)
                dateLabel.textAlignment = .center

                if indexPath.section == 0 {
                    return header
                } else {
//                    header.subviews.removeAll(keepingCapacity: false)
//                    语法知识太多了。。。真的是精通难啊
                    header.subviews.map {
                        $0.removeFromSuperview()
                    }
                    return header
                }

            }

        }
    
    
}

