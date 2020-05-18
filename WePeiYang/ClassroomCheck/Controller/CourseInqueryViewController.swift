//
//  CourseInqueryViewController.swift
//  WePeiYang
//
//  Created by 安宇 on 2020/3/23.
//  Copyright © 2020 twtstudio. All rights reserved.
//

import UIKit
import SnapKit

class CourseViewController: UIViewController {
    
    let id = "id"
    let idd = "idd"
    private let screenW = UIScreen.main.bounds.width
    private let screenH = UIScreen.main.bounds.height
    private let titleViewH: CGFloat = UIScreen.main.bounds.height * 0.06
    private let statusH: CGFloat = UIApplication.shared.statusBarFrame.height
    private let navigationBarH: CGFloat = 44
    private let tabbarH: CGFloat = 44
    private var isRefreshing: Bool = false
    private var refreshButton: UIButton!
    private var collectionView: UICollectionView!
    private lazy var flagLine: UIView = {
        let line = UIView()
        line.backgroundColor = UIColor(red: 0.42, green: 0.62, blue: 0.64, alpha: 0.3)
        return line
    }()
    
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
        leftButton.addTarget(self, action: #selector(back), for: .touchUpInside)
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
        setupCollectionView()
        setupUI()
    }
    
    func setupUI() {
        let selectedLabel = UILabel()
        let makeSureButton = UIButton()
        let noticeView1 = NoticeView()
        let noticeView2 = NoticeView()
        
        selectedLabel.text = "节次选择"
        selectedLabel.font = UIFont.systemFont(ofSize: 20, weight: .regular)
        selectedLabel.textColor = UIColor(red: 107/255.0, green: 157/255.0, blue: 163/255.0, alpha: 1)
        self.view.addSubview(selectedLabel)
        selectedLabel.snp.makeConstraints { (make) in
            make.top.equalTo(statusH + titleViewH + 4)
            make.centerX.equalTo(screenW / 2)
            make.height.equalTo(36)
        }
        
        self.view.addSubview(flagLine)
        flagLine.snp.makeConstraints { (make) in
            make.top.equalTo(selectedLabel.snp.bottom).offset(8)
            make.width.equalTo(screenW)
            make.left.equalTo(0)
            make.height.equalTo(0.5)
        }
        
        self.view.addSubview(makeSureButton)
        makeSureButton.snp.makeConstraints { (make) in
            make.bottom.equalTo(screenH).offset(-80)
            make.height.equalTo(40)
            make.left.equalTo(50)
            make.centerX.equalTo(screenW / 2)
        }
        makeSureButton.setTitle("确定", for: .normal)
        makeSureButton.backgroundColor = UIColor(red: 0.42, green: 0.62, blue: 0.64, alpha: 1)
        makeSureButton.titleLabel?.textColor = .white
        makeSureButton.layer.cornerRadius = 3
        makeSureButton.layer.masksToBounds = true
        makeSureButton.addTarget(self, action: #selector(push), for: .touchUpInside)
        self.view.addSubview(noticeView2)
        noticeView2.snp.makeConstraints { (make) in
            make.bottom.equalTo(screenH).offset(-30)
        //            make.left.equalTo(noticeView1.snp.right)
            make.right.equalTo(makeSureButton.snp.right)
            make.width.equalTo(70)
            make.height.equalTo(20)
        }
        noticeView2.noticeView.backgroundColor = .white
        noticeView2.noticeLabel.text = "表示未选"
        
        self.view.addSubview(noticeView1)
        noticeView1.snp.makeConstraints { (make) in
            make.bottom.equalTo(screenH).offset(-30)
//            MARK: 位置
            make.right.equalTo(noticeView2.snp.left).offset(-10)
            make.width.equalTo(70)
            make.height.equalTo(20)
        }
        noticeView1.noticeView.backgroundColor = UIColor(red: 0.42, green: 0.62, blue: 0.64, alpha: 1)
        noticeView1.noticeLabel.text = "表示选中"
        
        
        
    }
    func setupCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 6
        layout.itemSize = CGSize(width: (screenW - 140) / 2, height: 42)
//        下一句不加就没头部视图
        layout.headerReferenceSize = CGSize(width: screenW, height: 50)
        collectionView = UICollectionView(frame: CGRect(x: 50, y: titleViewH + 94, width: screenW - 100, height: screenH - 200), collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = .clear
//        collectionView.heder
        collectionView.register(Test2CollectionViewCell.self, forCellWithReuseIdentifier: id)
//        头部
        collectionView.register(UICollectionReusableView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: idd)
        collectionView.allowsMultipleSelection = true
        self.view.addSubview(collectionView)
    }
    @objc func refreshData() {
//        guard isRefreshing == false else {
//            return
//        }
//    //存储再议
//        isRefreshing = true
//        startRotating()
//        collectionView = nil
//        setupCollectionView()
//        stopRotating()

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
    @objc func back() {
        navigationController?.popViewController(animated: true)
    }
    @objc func push() {
        RoomHelper.fit = 2
        if ClassHelper.courseList.count != 0 {
//            BuildingListDataHelper.buildingList = nil
            var myBuildingModel = [BuildingList]()
            var re: BuildingList!
            
//            var result = [Building]()
            for i in 0..<ClassHelper.courseList.count {
                ClassHelper.course = i
                BuildingListHelper.getBuildingList(success: { buildingListData in
                    DataHelper.buildingList = buildingListData
                    myBuildingModel.append(buildingListData)
                    
                    if i == 0 {
                        re = buildingListData
                    } else {
                        re = self.Combine(fir: re!, sec: buildingListData)
                    }
                    
//                    MARK: 多选就离谱
                    
                    if i == ClassHelper.courseList.count - 1 {
                        DataHelper.buildingList = re!
                        self.navigationController?.popViewController(animated: true)
                        ClassHelper.flag = 1
                    }
                    
                }) { _ in
                    
                }
                
            }
            
        } else {
            
        }
        
    }
    
}

extension CourseViewController: UICollectionViewDelegate {
    func Combine(fir: BuildingList, sec: BuildingList) -> BuildingList {
//        理论上应该可以吧
//        var re = BuildingList.init(errorCode: 0, message: "success", data: nil)
        var result = [Building]()
        var t1 = fir.data
        var t2 = sec.data
        for i in 0..<t1.count {
            for j in 0..<t2.count {
                if t1[i].buildingID == t2[j].buildingID {
                    var tempClassroom = [Classroom]()
                    
                    for item1 in t1[i].classrooms {
                        for item2 in t2[j].classrooms {
                            if item1.classroomID == item2.classroomID {
                                tempClassroom.append(item1)
                            }
                        }
                    }
                    var tempBuilding = Building.init(buildingID: t1[i].buildingID, building: t1[i].building, campusID: t1[i].campusID, areaID: t1[i].areaID, classrooms: tempClassroom)
                    if tempClassroom.count != 0 {
                        result.append(tempBuilding)
                    }
                    
                }
            }
        }
        var re = BuildingList.init(errorCode: 0, message: "success", data: result)
        return re
    }
}

extension CourseViewController: UICollectionViewDelegateFlowLayout {
    
}

extension CourseViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: id, for: indexPath) as! Test2CollectionViewCell
        cell.label.text = "第\(indexPath.row + 1)节"
        cell.label.textColor = UIColor(red: 0.42, green: 0.62, blue: 0.64,alpha: 1)
        cell.contentView.layer.cornerRadius = 3
        cell.contentView.layer.borderWidth = 1
        cell.contentView.layer.borderColor = UIColor(red: 0.42, green: 0.62, blue: 0.64,alpha: 1).cgColor
        cell.contentView.layer.masksToBounds = true
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        if let header = collectionView.dequeueReusableSupplementaryView(ofKind:
            UICollectionElementKindSectionHeader, withReuseIdentifier: idd,
                                                  for: indexPath) as? UICollectionReusableView {
            //设置分组标题
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
                titleLabel.text = "上午"
            } else if indexPath.section == 1 {
                titleLabel.text = "下午"
            } else {
                titleLabel.text = "晚上"
            }
            
            titleLabel.font = UIFont.systemFont(ofSize: 17, weight: .regular)
            titleLabel.textColor = UIColor(red: 0.42, green: 0.62, blue: 0.64,alpha: 1)
            bottomLine.backgroundColor = UIColor(red: 0.42, green: 0.62, blue: 0.64,alpha: 0.8)
            
            return header
        }

    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize{
        
        return CGSize(width: screenW - 100, height: 50)
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets{
        return UIEdgeInsets(top: 0, left: 2, bottom: 0, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! Test2CollectionViewCell
        
        cell.label.textColor = .white
        cell.contentView.backgroundColor = UIColor(red: 0.42, green: 0.62, blue: 0.64,alpha: 1)
        ClassHelper.courseList.append(Int(indexPath.section * 4 + indexPath.row + 1))
//        MARK: 后续跳转和didselect
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! Test2CollectionViewCell
        cell.label.textColor = UIColor(red: 0.42, green: 0.62, blue: 0.64,alpha: 1)
        cell.contentView.backgroundColor = .white
        ClassHelper.courseList.removeAll(where: {$0 == Int(indexPath.section * 4 + indexPath.row + 1)})
        
    }
}
