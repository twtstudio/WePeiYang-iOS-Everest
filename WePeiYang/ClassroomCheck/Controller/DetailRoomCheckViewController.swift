//
//  DetailRoomCheckViewController.swift
//  WePeiYang
//
//  Created by 安宇 on 2020/3/23.
//  Copyright © 2020 twtstudio. All rights reserved.
//

import UIKit

class DetailRoomCheckViewController: UIViewController {
    
    private let screenW = UIScreen.main.bounds.width
    private let screenH = UIScreen.main.bounds.height
    private let titleViewH: CGFloat = UIScreen.main.bounds.height * 0.06
    private let statusH: CGFloat = UIApplication.shared.statusBarFrame.height
    private let navigationBarH: CGFloat = 44
    private let tabbarH: CGFloat = 44
    private var isRefreshing: Bool = false
    private var refreshButton: UIButton!
    let cellId = "cell"
    let headerId = "header"
    let heartView = UIButton()
    private var collectionView: UICollectionView!
    private var classArray: [[Int]]!
    private let dateArray = ["月","Mon","Tue","Wed","Thu","Fri","1~2","3~4","5~6","7~8","9~10","11~12"]
    private let courseView = UILabel()
    private let headerView = ClassesHeaderView()
    private var classroomWeekInfo: ClassroomWeekInfo!
    let calendar = Calendar.init(identifier: .gregorian)
    private var comps = DateComponents()
    private var courseNum = 0
    private var timer = Timer()
    private var another = Timer()
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
        timer = Timer.scheduledTimer(timeInterval: 3, target: self, selector: #selector(getTime), userInfo: nil, repeats: true)
        setupView()
        setupCollectionView()
        getClassroomWeekInfo()
    }
    @objc func getTime(loc: Int) {
        comps = calendar.dateComponents([.month, .day, .hour, .minute], from: Date())
        if comps.hour! < 8 {
            
        } else if comps.hour! == 9 || (comps.minute! <= 5 && comps.hour! == 10) || (comps.hour! == 8 && comps.minute! >= 30) {
            courseNum = 1
        } else if comps.hour! == 11 || (comps.minute! == 0 && comps.hour! == 12) || (comps.hour! == 10 && comps.minute! >= 25) {
            courseNum = 2
        } else if comps.hour! == 14 || (comps.minute! <= 5 && comps.hour! == 15) || (comps.hour! == 13 && comps.minute! >= 30) {
            courseNum = 3
        } else if comps.hour! == 16 || (comps.minute! <= 0 && comps.hour! == 17) || (comps.hour! == 15 && comps.minute! >= 25) {
            courseNum = 4
        } else if comps.hour! == 19 || (comps.minute! <= 5 && comps.hour! == 20) || (comps.hour! == 18 && comps.minute! >= 30) {
            courseNum = 5
        } else if comps.hour! == 21 || (comps.minute! <= 0 && comps.hour! == 22) || (comps.hour! == 20 && comps.minute! >= 30) {
            courseNum = 6
        } else {
            
        }
    }
    func setupView() {
        view.addSubview(headerView)
        
        headerView.snp.makeConstraints { (make) in
            make.top.equalTo(UIApplication.shared.statusBarFrame.height + 45)
            make.left.equalTo(16)
            make.centerX.equalToSuperview()
            make.height.equalTo(35)
        }
        comps = calendar.dateComponents([.month, .day, .hour, .minute], from: Date())
        headerView.timeLabel.text = String(comps.month!)  + "月" + String(comps.day!) + "日" + String(comps.hour!) + ":" + String(comps.minute!)
        self.another = Timer.scheduledTimer(timeInterval: 30, target: self, selector: #selector(self.getCurrentTime), userInfo: nil, repeats: true)
        
//        headerView.noticeView2.frame.maxY = screenW - 38
        headerView.layer.cornerRadius = 10
        headerView.layer.shadowOffset = CGSize(width: 0, height: 0)
        headerView.layer.shadowOpacity = 0.3
        headerView.layer.shadowColor = UIColor.gray.cgColor
        headerView.backgroundColor = .white
    }
    @objc func getCurrentTime() {
        headerView.timeLabel.text = String(comps.month!)  + "月" + String(comps.day!) + "日" + String(comps.hour!) + ":" + String(comps.minute!)
    }
    
    func setupCollectionView() {
        let bgView = UIView(frame: CGRect(x: 16, y: UIApplication.shared.statusBarFrame.height + 80, width: screenW - 32, height: screenH - 140))
        self.view.addSubview(bgView)
        bgView.backgroundColor = UIColor(red: 0.42, green: 0.62, blue: 0.64, alpha: 1)
//        bgView.isUserInteractionEnabled = true
        
        let locLabel = UILabel()
        bgView.addSubview(locLabel)
        locLabel.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.left.equalTo(16)
//            make.width.equalTo(150)
            make.height.equalTo(40)
        }
        locLabel.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        locLabel.textColor = .white
        locLabel.text = ClassroomHelper.buildingId + ClassroomHelper.classroomName + " " + ClassroomHelper.size
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.itemSize = CGSize(width: (screenW - 70) / 6, height: (screenH - 200) / 7)
        layout.headerReferenceSize = CGSize(width: screenW, height: 50)
        collectionView = UICollectionView(frame: CGRect(x: 16, y: -10, width: screenW - 70, height: screenH - 100), collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = .clear
    //        collectionView.heder
        collectionView.register(Test2CollectionViewCell.self, forCellWithReuseIdentifier: cellId)
    //        头部
        collectionView.register(UICollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerId)
        bgView.addSubview(collectionView)
        
        
        bgView.addSubview(heartView)
        heartView.snp.makeConstraints { (make) in
            make.centerY.equalTo(locLabel.snp.centerY)
            make.left.equalTo(locLabel.snp.right).offset(10)
            make.width.equalTo(20)
            make.height.equalTo(heartView.snp.width)
        }
        heartView.setImage(#imageLiteral(resourceName: "grey_heart"), for: .normal)
        heartView.setImage(#imageLiteral(resourceName: "收藏"), for: .selected)
        heartView.isSelected = false
        for collection in DataHelper.collectionList {
            if collection.classroomID == ClassroomHelper.classroomId {
                heartView.isSelected = true
            }
        }
        
        heartView.addTarget(self, action: #selector(changeCollection), for: .touchUpInside)
                
        let cancelButton = UIButton()
        //        bgView.superview?.addSubview(cancelButton)
        //        bgView.addSubview(cancelButton)
        self.view.addSubview(cancelButton)
        cancelButton.snp.makeConstraints { (make) in
            make.top.equalTo(heartView.snp.top)
            make.right.equalToSuperview().offset(-38)
            make.height.equalTo(heartView.snp.width)
            make.width.equalTo(cancelButton.snp.height)
        }
        cancelButton.setImage(#imageLiteral(resourceName: "关闭"), for: .normal)
        cancelButton.addTarget(self, action: #selector(pop), for: .touchUpInside)
        
        self.view.addSubview(courseView)
        courseView.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(-5)
            make.width.equalTo(300)
            make.height.equalTo(60)
        }
        courseView.layer.cornerRadius = 20
        courseView.layer.shadowOffset = CGSize(width: 5, height: 5)
        courseView.layer.shadowOpacity = 0.8
        courseView.layer.shadowColor = UIColor.gray.cgColor
        courseView.backgroundColor = .white

        courseView.textAlignment = .center
        courseView.text = "32教406 教育心理学 8:30-10:05"
        courseView.textColor = UIColor(red: 0.68, green: 0.68, blue: 0.68, alpha:1)
        courseView.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        courseView.isHidden = true
//        self.view.addSubview(collectionView)
    }
    @objc func refreshData() {
        guard isRefreshing == false else {
            return
        }
    //存储再议
        isRefreshing = true
        startRotating()
        ClassroomWeekInfoHelper.getClassroomWeekInfoList(success: { (classroomWeekInfo) in
            self.isRefreshing = false
            self.stopRotating()
            self.classroomWeekInfo = classroomWeekInfo
            self.classArray = [[Int]]()
            for i in 0..<classroomWeekInfo.data.count {
                var array = [Int]()
                let data = classroomWeekInfo.data[String(i + 1)]!
                for j in 1...data.count / 2 {
                    array.append(Int(String(data.prefix(2 * j - 1).suffix(1)))!)
                }
                self.classArray.append(array)
            }
            SwiftMessages.showSuccessMessage(body: "刷新成功")
            self.collectionView.reloadData()
            
        }) { (_) in
//            MARK: 起始周要设置好吧，不能是零
            //            如果没选周啥的
            for _ in 0..<7 {
                var array = [Int]()
                for _ in 0..<6 {
                    array.append(0)
                }
                self.classArray.append(array)
            }
            self.isRefreshing = false
            self.stopRotating()
        }
        
//            BuildingListHelper.getBuildingList(success: { buildingListData in
//                self.isRefreshing = false
//                self.stopRotating()
//                
//                SwiftMessages.showSuccessMessage(body: "刷新成功")
//                self.collectionView.reloadData()
//            }) { _ in
//                self.isRefreshing = false
//                self.stopRotating()
//            }


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
    @objc func changeCollection() {
        
        if heartView.isSelected == false {
            AddCollectionHelper.addCollection(success: { (AddCollectionData) in
                
            }) { (_) in
                
            }
        } else {
            CancelCollectionHelper.cancelCollection(success: { (CancelCollectionData) in
                
            }) { (_) in
                
            }
        }
        heartView.isSelected = !heartView.isSelected
        
        
    }
    
    
    @objc func pop() {
        navigationController?.popViewController(animated: true)
    }
    func getClassroomWeekInfo() {
        ClassroomWeekInfoHelper.getClassroomWeekInfoList(success: { (classroomWeekInfo) in
            self.classroomWeekInfo = classroomWeekInfo
            self.classArray = [[Int]]()
            for i in 0..<classroomWeekInfo.data.count {
                var array = [Int]()
                let data = classroomWeekInfo.data[String(i + 1)]!
                for j in 1...data.count / 2 {
                    array.append(Int(String(data.prefix(2 * j - 1).suffix(1)))!)
                }
                self.classArray.append(array)
            }
            self.collectionView.reloadData()
        }) { (_) in
//            MARK: 起始周要设置好吧，不能是零
//            如果没选周啥的
            for _ in 0..<7 {
                var array = [Int]()
                for _ in 0..<6 {
                    array.append(0)
                }
                self.classArray.append(array)
            }
        }
        
    }
}

extension DetailRoomCheckViewController: UICollectionViewDelegate {
    
}

extension DetailRoomCheckViewController: UICollectionViewDelegateFlowLayout {
    
}

extension DetailRoomCheckViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 42
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! Test2CollectionViewCell
        cell.contentView.layer.borderWidth = 0.5
        cell.contentView.layer.borderColor = UIColor(red: 0.42, green: 0.62, blue: 0.64, alpha: 1).cgColor
        cell.contentView.layer.masksToBounds = true
        cell.backgroundColor = .white
        if indexPath.row < 6 {
            cell.label.text = dateArray[indexPath.row]
            if indexPath.row == 0 {
                cell.label.text = String(DateHelper.month) + dateArray[indexPath.row]
            }
            
        } else if (indexPath.row % 6 == 0) {
            cell.label.text = dateArray[(indexPath.row / 6) + 5]
        } else {
            if self.classArray != nil {
                if indexPath.row % 6 == 1 {
                    cell.label.text = String(self.classArray[0][indexPath.row / 6 - 1])
                    
                } else if indexPath.row % 6 == 2 {
                    cell.label.text = String(self.classArray[1][indexPath.row / 6 - 1])
                } else if indexPath.row % 6 == 3 {
                    cell.label.text = String(self.classArray[2][indexPath.row / 6 - 1])
                } else if indexPath.row % 6 == 4 {
                    cell.label.text = String(self.classArray[3][indexPath.row / 6 - 1])
                } else if indexPath.row % 6 == 5 {
                    cell.label.text = String(self.classArray[4][indexPath.row / 6 - 1])
                }
                
                if cell.label.text == "1" {
                    cell.backgroundColor = UIColor(red: 0.42, green: 0.62, blue: 0.64, alpha: 1)
                    cell.contentView.layer.borderColor = UIColor.white.cgColor
                }
                if courseNum != 0 && ClassHelper.day <= 5 && indexPath.row == (ClassHelper.day + 6 * courseNum) {
                    cell.contentView.layer.borderColor = UIColor.blue.cgColor
                    cell.label.text = "Now"
                }
            }
            if cell.label.text != "Now" {
                cell.label.text = ""
            }
            
        }
        
        cell.label.font = UIFont.italicSystemFont(ofSize: 18)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        MARK: 怎么获取课程名称？
//        let cell = collectionView.cellForItem(at: indexPath) as! Test2CollectionViewCell
//        if(indexPath.row > 6 && indexPath.row % 6 != 0) {
//            print(indexPath.row)
////            cell.label.text = "Now"
//            courseView.isHidden = false
//            cell.backgroundColor = UIColor(red: 0.42, green: 0.62, blue: 0.64, alpha: 1)
//            cell.contentView.layer.borderColor = UIColor.red.cgColor
//        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! Test2CollectionViewCell
        if(indexPath.row > 6 && indexPath.row % 6 != 0) {
            cell.label.text = ""
            courseView.isHidden = true
            cell.backgroundColor = .white
            cell.contentView.layer.borderColor = UIColor(red: 0.42, green: 0.62, blue: 0.64, alpha: 1).cgColor
        }
        
    }
    
}

