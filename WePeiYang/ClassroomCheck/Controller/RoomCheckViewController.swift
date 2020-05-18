//
//  RoomCheckViewController.swift
//  WePeiYang
//
//  Created by 安宇 on 2020/3/23.
//  Copyright © 2020 twtstudio. All rights reserved.
//

import UIKit
import SnapKit

class RoomCheckViewController: UIViewController {
    
    let id = "id"
    let headerViewId = "header"
    private var buildingList: BuildingList!
    private var collectionView: UICollectionView!
    private let screenW = UIScreen.main.bounds.width
    private let screenH = UIScreen.main.bounds.height
    private let titleViewH: CGFloat = UIScreen.main.bounds.height * 0.06
    private let navigationBarH: CGFloat = 44
    private let tabbarH: CGFloat = 44
    private var numDict: [String: Int] = ["0": 0, "1": 0, "2": 0, "3": 0, "4": 0, "5": 0, "6": 0]
    private var timer: Timer!
    private var numForAB: Int = 0
    private var isRefreshing: Bool = false
    private var refreshButton: UIButton!
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(true)
//
//
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationBar.barTintColor = UIColor(red: 0.42, green: 0.62, blue: 0.64, alpha: 1)
        navigationController?.setNavigationBarHidden(false, animated: true)
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor:UIColor.white]
        let leftButton =   UIButton(type: .system)
        leftButton.frame = CGRect(x:0, y:0, width:65, height:20)
        let image = UIImage.resizedImage(image: #imageLiteral(resourceName: "箭头"), scaledToSize: CGSize(width: 10, height: 18))
        leftButton.setImage(image, for: .normal)
        leftButton.setTitle("   自习室查询", for: .normal)
        leftButton.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .regular)
        leftButton.addTarget(self, action: #selector(pop), for: .touchUpInside)
        let leftBarBtn = UIBarButtonItem(customView: leftButton)
         
        //用于消除左边空隙，要不然按钮顶不到最前面
        let spacer = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: nil,
                                     action: nil)
        spacer.width = -10;
        navigationItem.leftBarButtonItems = [spacer, leftBarBtn]
        
        let tmpView = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
        refreshButton = UIButton(type: .custom)
        refreshButton.frame = CGRect(x: 0, y: 0, width: 20, height: 20)
        refreshButton.setImage(UIImage.resizedImage(image: #imageLiteral(resourceName: "刷新"), scaledToSize: CGSize(width: 20, height: 20)), for: .normal)
        refreshButton.addTarget(self, action: #selector(refreshData), for: .touchUpInside)
        tmpView.backgroundColor = .clear
        tmpView.addSubview(refreshButton)
        let rightButton = UIBarButtonItem.init(customView: tmpView)
        navigationItem.rightBarButtonItem = rightButton
//        setupUI()
        
        setupCollectionView()
    }
    
    func setupUI() {
        
        let locLabel = UILabel()
        let noticeView1 = NoticeView()
        let noticeView2 = NoticeView()
        let label3 = UILabel()
        
        self.view.addSubview(locLabel)
        locLabel.snp.makeConstraints { (make) in
            make.top.equalTo(UIApplication.shared.statusBarFrame.height + 44 + 20)
            make.height.equalTo(30)
            make.left.equalTo(50)
            make.width.equalTo(120)
        }
        locLabel.text = self.buildingList.data[PageHelper.pageNum].building
        locLabel.textColor = UIColor(red: 0.42, green: 0.62, blue: 0.64, alpha: 1)
        locLabel.font = UIFont.systemFont(ofSize: 20, weight: .regular)
        
        self.view.addSubview(noticeView2)
        noticeView2.snp.makeConstraints { (make) in
            make.top.equalTo(locLabel.snp.top)
//            make.left.equalTo(noticeView1.snp.right)
            make.right.equalToSuperview().offset(-50)
            make.width.equalTo(70)
            make.height.equalTo(13)
        }
        noticeView2.noticeView.backgroundColor = .white
        noticeView2.noticeLabel.text = "表示空闲"
        
        self.view.addSubview(noticeView1)
        noticeView1.snp.makeConstraints { (make) in
            make.top.equalTo(locLabel.snp.top)
        //            MARK: 位置
            make.right.equalTo(noticeView2.snp.left).offset(-10)
            make.width.equalTo(70)
            make.height.equalTo(13)
        }
        noticeView1.noticeView.backgroundColor = UIColor(red: 0.42, green: 0.62, blue: 0.64, alpha: 1)
        noticeView1.noticeLabel.text = "表示占用"
                
        
        
        self.view.addSubview(label3)
        label3.snp.makeConstraints { (make) in
            make.top.equalTo(noticeView1.snp.bottom).offset(7)
//            make.left.equalTo(noticeView1.snp.left).offset(-30)
            make.right.equalTo(noticeView2.snp.right)
            make.height.equalTo(15)
        }
//        MARK: 还要改时间
        if ClassHelper.courseList.count != 0 {
             label3.text = "选择的时间: 第" + String(ClassHelper.week) + "周-第" + String(ClassHelper.day) + "天-"
            for i in 0..<ClassHelper.courseList.count {
                label3.text! += "第" + String(ClassHelper.courseList[i]) + "节"
                if i != ClassHelper.courseList.count - 1 {
                    label3.text! += ","
                }
            }
        } else {
             label3.text = "选择的时间: 第" + String(ClassHelper.week) + "周-第" + String(ClassHelper.day) + "天"
        }
        
        label3.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        label3.textColor = UIColor(red: 0.42, green: 0.62, blue: 0.64, alpha: 1)
    }
    
    func setupCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.itemSize = CGSize(width: (screenW - 120) / 4, height: 38)
        layout.headerReferenceSize = CGSize(width: screenW, height: 65)
        layout.minimumInteritemSpacing = 0
        self.collectionView = UICollectionView(frame: CGRect(x: 40, y: UIApplication.shared.statusBarFrame.height + 105, width: screenW - 80, height: screenH - titleViewH - 85), collectionViewLayout: layout)
        
        self.collectionView.backgroundColor = .clear
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
//        取消滑动条
        self.collectionView.showsVerticalScrollIndicator = false
        self.collectionView.register(Test2CollectionViewCell.self, forCellWithReuseIdentifier: id)
    //        头部
        self.collectionView.register(UICollectionReusableView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: headerViewId)
        self.view.addSubview(self.collectionView)
        
        BuildingListHelper.getBuildingList(success: { buildingListData in
            self.buildingList = buildingListData
            if ClassHelper.flag == 1 {
                self.buildingList = DataHelper.buildingList
            }
            if self.buildingList.data[PageHelper.pageNum].buildingID == "1103" {
                for i in 0..<self.buildingList.data[PageHelper.pageNum + 1].classrooms.count {
                    let text = self.buildingList.data[PageHelper.pageNum + 1].classrooms[i].classroom
                    if String(text.substring(from: text.index(text.endIndex, offsetBy: -5)).prefix(1)) == "A" {
                        self.numForAB = self.numForAB + 1
                        let locChar = String(text.substring(from: text.index(text.endIndex, offsetBy: -3)).prefix(1))
                        self.numDict.updateValue(self.numDict[locChar]! + 1, forKey: locChar)
                    }
                }
            } else if self.buildingList.data[PageHelper.pageNum].buildingID == "1104" {
                for i in 0..<self.buildingList.data[PageHelper.pageNum].classrooms.count {
                    let text = self.buildingList.data[PageHelper.pageNum].classrooms[i].classroom
                    if String(text.substring(from: text.index(text.endIndex, offsetBy: -5)).prefix(1)) == "B" {
                        self.numForAB = self.numForAB + 1
                        let locChar = String(text.substring(from: text.index(text.endIndex, offsetBy: -3)).prefix(1))
                        self.numDict.updateValue(self.numDict[locChar]! + 1, forKey: locChar)
                    }
                    
                }
            } else {
                for i in 0..<self.buildingList.data[PageHelper.pageNum].classrooms.count {
                    let text = self.buildingList.data[PageHelper.pageNum].classrooms[i].classroom
                    let locChar = String(text.substring(from: text.index(text.endIndex, offsetBy: -3)).prefix(1))
                    
                    self.numDict.updateValue(self.numDict[locChar]! + 1, forKey: locChar)
                    
                }
            }
            self.collectionView.reloadData()
            self.setupUI()
        }) { _ in
            
        }
        
    }
    
    @objc func refreshData() {
        guard isRefreshing == false else {
            return
        }
    //存储再议
        self.numDict = ["0": 0, "1": 0, "2": 0, "3": 0, "4": 0, "5": 0, "6": 0]
        isRefreshing = true
        startRotating()
        BuildingListHelper.getBuildingList(success: { buildingListData in
            self.isRefreshing = false
            self.stopRotating()
            self.buildingList = buildingListData
            if ClassHelper.flag == 1 {
                self.buildingList = DataHelper.buildingList
            }
            if self.buildingList.data[PageHelper.pageNum].buildingID == "1103" {
                for i in 0..<self.buildingList.data[PageHelper.pageNum + 1].classrooms.count {
                    let text = self.buildingList.data[PageHelper.pageNum + 1].classrooms[i].classroom
                    if String(text.substring(from: text.index(text.endIndex, offsetBy: -5)).prefix(1)) == "A" {
                        self.numForAB = self.numForAB + 1
                        let locChar = String(text.substring(from: text.index(text.endIndex, offsetBy: -3)).prefix(1))
                        self.numDict.updateValue(self.numDict[locChar]! + 1, forKey: locChar)
                    }
                }
            } else if self.buildingList.data[PageHelper.pageNum].buildingID == "1104" {
                for i in 0..<self.buildingList.data[PageHelper.pageNum].classrooms.count {
                    let text = self.buildingList.data[PageHelper.pageNum].classrooms[i].classroom
                    if String(text.substring(from: text.index(text.endIndex, offsetBy: -5)).prefix(1)) == "B" {
                        self.numForAB = self.numForAB + 1
                        let locChar = String(text.substring(from: text.index(text.endIndex, offsetBy: -3)).prefix(1))
                        self.numDict.updateValue(self.numDict[locChar]! + 1, forKey: locChar)
                    }
                    
                }
            } else {
                for i in 0..<self.buildingList.data[PageHelper.pageNum].classrooms.count {
                    let text = self.buildingList.data[PageHelper.pageNum].classrooms[i].classroom
                    let locChar = String(text.substring(from: text.index(text.endIndex, offsetBy: -3)).prefix(1))
                    
                    self.numDict.updateValue(self.numDict[locChar]! + 1, forKey: locChar)
                    
                }
            }
            SwiftMessages.showSuccessMessage(body: "刷新成功")
            self.collectionView.reloadData()
            
        }) { _ in
            self.isRefreshing = false
            self.stopRotating()
        }



        }
        private func startRotating() {
            let rotationAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
            rotationAnimation.toValue = CGFloat.pi
            rotationAnimation.duration = 0.5
            rotationAnimation.isCumulative = true
            rotationAnimation.repeatCount = 1000
            refreshButton.layer.add(rotationAnimation, forKey: "rotationAnimation")
            

        }
        private func stopRotating() {
            refreshButton.layer.removeAllAnimations()
        }
    @objc func pop() {
        navigationController?.popViewController(animated: true)
    }
    
}

extension RoomCheckViewController: UICollectionViewDelegate {
    
}

extension RoomCheckViewController: UICollectionViewDelegateFlowLayout {
    
}

extension RoomCheckViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        if self.buildingList == nil {
            return 0
        }
//        var cnt = 0
//        for (key, value) in numDict {
//            if value != 0 {
//                cnt += 1
//            }
//        }
        return 5
    }
        
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if self.buildingList == nil {
            return 0
        }
        
        return self.numDict[String(section + 1)]!
        
    }
    
//    func estima
        
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: id, for: indexPath) as! Test2CollectionViewCell
            
//            cell补充内容
        
        
        cell.contentView.layer.cornerRadius = 3
        cell.contentView.layer.borderWidth = 1
        cell.contentView.layer.borderColor = UIColor(red: 0.42, green: 0.62, blue: 0.64, alpha: 1).cgColor
        cell.contentView.layer.masksToBounds = true
//我真的傻逼
        var loc = 0
        for i in 0..<indexPath.section {
            loc = loc + (self.numDict[String(i + 1)]!)
            
        }
        if buildingList.data[PageHelper.pageNum].buildingID == "1103" {
            let text: String = buildingList.data[PageHelper.pageNum + 1].classrooms[indexPath.row + loc].classroom
//            cell.label.text = text.substring(from: "abc".endIndex)
            cell.label.text = String(text.substring(from: text.index(text.endIndex, offsetBy: -3)).prefix(3))
            cell.tagLabel.text = buildingList.data[PageHelper.pageNum + 1].classrooms[indexPath.row + loc].classroomID
            if Int(buildingList.data[PageHelper.pageNum + 1].classrooms[indexPath.row + loc].capacity)! >= 120 {
                cell.sizeLabel.text = "L"
            } else if Int(buildingList.data[PageHelper.pageNum + 1].classrooms[indexPath.row + loc].capacity)! >= 80 {
                cell.sizeLabel.text = "M"
            } else {
                cell.sizeLabel.text = "S"
            }
        } else if buildingList.data[PageHelper.pageNum].buildingID == "1104" {
            let text: String = buildingList.data[PageHelper.pageNum].classrooms[self.numForAB + indexPath.row + loc].classroom
            cell.label.text = String(text.substring(from: text.index(text.endIndex, offsetBy: -3)).prefix(3))
            cell.tagLabel.text = buildingList.data[PageHelper.pageNum].classrooms[self.numForAB + indexPath.row + loc].classroomID
            if Int(buildingList.data[PageHelper.pageNum].classrooms[self.numForAB + indexPath.row + loc].capacity)! >= 120 {
                cell.sizeLabel.text = "L"
            } else if Int(buildingList.data[PageHelper.pageNum].classrooms[self.numForAB + indexPath.row + loc].capacity)! >= 80 {
                cell.sizeLabel.text = "M"
            } else {
                cell.sizeLabel.text = "S"
            }
        } else {
            let text: String = buildingList.data[PageHelper.pageNum].classrooms[indexPath.row + loc].classroom
            cell.label.text = String(text.substring(from: text.index(text.endIndex, offsetBy: -3)).prefix(3))
            if buildingList.data[PageHelper.pageNum].buildingID == "1093" {
                if String(text.substring(from: text.index(text.endIndex, offsetBy: -5)).prefix(1)) == "A" {
                    cell.label.text = "A" + String(text.substring(from: text.index(text.endIndex, offsetBy: -3)).prefix(3))
                } else {
                    cell.label.text = "B" + String(text.substring(from: text.index(text.endIndex, offsetBy: -3)).prefix(3))
                }
            }
            cell.tagLabel.text = buildingList.data[PageHelper.pageNum].classrooms[indexPath.row + loc].classroomID
            if Int(buildingList.data[PageHelper.pageNum].classrooms[indexPath.row + loc].capacity)! >= 120 {
                cell.sizeLabel.text = "L"
            } else if Int(buildingList.data[PageHelper.pageNum].classrooms[indexPath.row + loc].capacity)! >= 80 {
                cell.sizeLabel.text = "M"
            } else {
                cell.sizeLabel.text = "S"
            }
        }

        
        return cell
    }
        
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
                
        if let header = collectionView.dequeueReusableSupplementaryView(ofKind:
                    UICollectionElementKindSectionHeader, withReuseIdentifier: headerViewId,
                                                          for: indexPath) as? UICollectionReusableView {
            header.subviews.map {
                $0.removeFromSuperview()
            }
            header.backgroundColor = .white
            let titleLabel = UILabel()
            let bottomLine = UIView()
            header.addSubview(titleLabel)
            header.addSubview(bottomLine)
                    
            bottomLine.snp.makeConstraints { (make) in
            //                make.top.equalTo(titleLabel.snp.bottom).offset(-0.3)
                make.bottom.equalToSuperview().offset(-14)
                make.width.equalTo(screenW - 90)
                make.left.equalTo(0)
                make.height.equalTo(0.5)
            }
                titleLabel.snp.makeConstraints { (make) in
                make.left.equalTo(13)
                make.bottom.equalTo(bottomLine.snp.top)
                make.width.equalTo(100)
                make.height.equalTo(25)
            }
                    
            if indexPath.section == 0 {
                titleLabel.text = "一层"
            }
            if indexPath.section == 1 {
                titleLabel.text = "二层"
            }
            if indexPath.section == 2 {
                titleLabel.text = "三层"
            }
            if indexPath.section == 3 {
                titleLabel.text = "四层"
            }
            if indexPath.section == 4 {
                titleLabel.text = "五层"
            }
            
            titleLabel.textColor = UIColor(red: 0.42, green: 0.62, blue: 0.64, alpha: 1)
            bottomLine.backgroundColor = UIColor(red: 0.42, green: 0.62, blue: 0.64, alpha: 0.8)
            
            if self.buildingList == nil {
                
                header.subviews.map {
                    $0.removeFromSuperview()
                }
//                header.frame.height = 0
            }
            return header
        }

    }
        
//    func
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize{
        if section == 0 {
            return CGSize(width: screenW - 100, height: 0)
        }
        return CGSize(width: screenW - 100, height: 50)
    }
        
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,insetForSectionAtIndex section: Int) -> UIEdgeInsets{
        return UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)
    }
        
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! Test2CollectionViewCell
                
        cell.label.textColor = .white
        cell.sizeLabel.textColor = .white
        cell.contentView.backgroundColor = UIColor(red: 0.42, green: 0.62, blue: 0.64,alpha: 1)
        ClassroomHelper.classroomId = cell.tagLabel.text!
        ClassroomHelper.classroomName = cell.label.text!
        ClassroomHelper.size = cell.sizeLabel.text!
        navigationController?.pushViewController(DetailRoomCheckViewController(), animated: true)
        //        MARK: 后续跳转和didselect
        UIView.animate(withDuration: 0.25) {
            cell.label.textColor = UIColor(red: 0.42, green: 0.62, blue: 0.64,alpha: 1)
            cell.sizeLabel.textColor = UIColor(red: 0.42, green: 0.62, blue: 0.64, alpha: 0.75)
            cell.contentView.backgroundColor = .white
        }
        
    }
            
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! Test2CollectionViewCell
        cell.label.textColor = UIColor(red: 0.42, green: 0.62, blue: 0.64,alpha: 1)
        cell.contentView.backgroundColor = .white
    }
    
}

