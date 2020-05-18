//
//  ClassroomCheckViewController.swift
//  WePeiYang
//
//  Created by 安宇 on 2020/3/23.
//  Copyright © 2020 twtstudio. All rights reserved.
//

import UIKit
import SnapKit

class ClassroomCheckViewController: UIViewController {

    private var buildingList: BuildingList!
    let id = "id"
    private let screenW = UIScreen.main.bounds.width
    private let screenH = UIScreen.main.bounds.height
    private let titleViewH: CGFloat = UIScreen.main.bounds.height * 0.06
    private let statusH: CGFloat = UIApplication.shared.statusBarFrame.height
    private let navigationBarH: CGFloat = 44
    private let tabbarH: CGFloat = 44
    private var sli = [SlienceView]()
    private let calendarView = CalendarView()
    private let enshrineView = EnshrineView()
    private var list1 = [Building]()
    private var list2 = [Building]()
    private let transparencyButton = UIButton()
    private let calendar = Calendar.init(identifier: .gregorian)
    private var comps = DateComponents()
    private var collectionView: UICollectionView!
    private var isRefreshing: Bool = false
    private var refreshButton: UIButton!
    let grayView = UIView(frame: CGRect(x: 0, y: 44 + UIApplication.shared.statusBarFrame.height + UIScreen.main.bounds.height * 0.06 - 1.9, width: UIScreen.main.bounds.width / 3, height: UIScreen.main.bounds.height - (44 + UIApplication.shared.statusBarFrame.height + UIScreen.main.bounds.height * 0.06 - 1.9)))
    private lazy var pageTitleView: ClassRoomCheckPageTitleView = {[weak self] in
    let titleFrame = CGRect(x: 0, y: navigationBarH + statusH, width: screenW, height: titleViewH)
    
    let titleView = ClassRoomCheckPageTitleView(frame: titleFrame, titles: ["卫津路","时间选择","我的收藏"])
        titleView.delegate = self
        titleView.backgroundColor = .clear
        return titleView
    }()
    private lazy var pageContentView: ClassroomPageContentView = {[weak self] in
    //确定frame
        let contentH = screenH - statusH - titleViewH  - navigationBarH
        let contentFrame = CGRect(x: 0, y: statusH + navigationBarH + titleViewH, width: screenW, height: contentH)
    
    //确定子控制器
        var childVCs = [UIViewController]()
//        childVCs.append(())
        childVCs.append(CourseViewController())
        childVCs.append(CourseViewController())
    
        let contentView = ClassroomPageContentView(frame: contentFrame, childVCs: childVCs, parentVC: self)
        contentView.delegate = self
        return contentView
    }()
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        if ClassHelper.flag == 1 {
            self.list1.removeAll()
            self.list2.removeAll()
            for i in 0..<DataHelper.buildingList.data.count {
                if DataHelper.buildingList.data[i].campusID == "1" {
                    self.list1.append(DataHelper.buildingList.data[i])
                }
                if DataHelper.buildingList.data[i].campusID == "2" {
                    self.list2.append(DataHelper.buildingList.data[i])
                }
            }
            self.collectionView.reloadData()
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        
        setupCollectionView()
        
        setupUI()
        addSelectView()
        navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationBar.barTintColor = UIColor(red: 0.42, green: 0.62, blue: 0.64, alpha: 1)
        navigationController?.setNavigationBarHidden(false, animated: true)
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor:UIColor.white]
        let leftButton = UIButton(type: .system)
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
        
//        let rightButton = UIBarButtonItem(title: "", style: .plain, target: self, action: #selector(refreshData))
        
        navigationItem.rightBarButtonItem = rightButton
        view.backgroundColor = .white
        
//        refreshButton.frame = self.navigationController?.view.convert(rightButton.fr, to: <#T##UIView?#>)
        comps = calendar.dateComponents([.month, .day, .hour, .minute], from: Date())
        DateHelper.day = comps.day!
        var week = 0
        for i in BOTHelper.month..<comps.month! {
            week += numberOfDaysInMonth(year: DateHelper.year, month: i)
        }
        week -= BOTHelper.day
        week += (DateHelper.day + 1)
//            第六周第六天 week = 41
        let day = week % 7 == 0 ? 7 : week % 7
        week = week % 7 == 0 ? week / 7 : 1 + week / 7
        if RoomHelper.fit != 1 {
            ClassHelper.week = week
            ClassHelper.day = day
        }
        
        
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
    func addSelectView() {
        view.addSubview(transparencyButton)
        view.addSubview(calendarView)
        view.addSubview(enshrineView)
        
        //        MARK: 先去掉了
        //        view.addSubview(grayView)
        //        MARK: 不会改了
                
        //        grayView.backgroundColor = .gray
        transparencyButton.frame = CGRect(x: 0, y: statusH + navigationBarH + titleViewH, width: screenH, height: screenH)
        transparencyButton.backgroundColor = .clear
        transparencyButton.addTarget(self, action: #selector(hide), for: .touchUpInside)
        transparencyButton.isUserInteractionEnabled = false
        calendarView.frame = CGRect(x: 50, y: 180, width: screenW - 100, height: screenH - 280)
        let corners: UIRectCorner = [.topLeft, .topRight]
        let path = UIBezierPath(roundedRect: calendarView.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: 10, height: 10))
        let maskLayer = CAShapeLayer()
        maskLayer.path = path.cgPath
        maskLayer.frame = calendarView.bounds
        calendarView.layer.mask = maskLayer
        calendarView.isHidden = true
        calendarView.isUserInteractionEnabled = true
                
        enshrineView.snp.makeConstraints { (make) in
            make.top.equalTo(navigationBarH + statusH + titleViewH - 1.9)
            make.left.equalTo(screenW / 3)
            make.right.equalToSuperview()
            make.height.equalTo(screenH - navigationBarH - statusH - titleViewH)
        }
        enshrineView.isHidden = true
        enshrineView.vanishButton.addTarget(self, action: #selector(re), for: .touchUpInside)
                
        for i in 0..<2 {
            let SView = SlienceView(frame: CGRect(x: pageTitleView.titleLabel[i].frame.minX + 23, y: navigationBarH + statusH + titleViewH - 20, width: pageTitleView.titleLabel[i].frame.width - 46, height: 75))
            view.addSubview(SView)
            SView.isHidden = true
            sli.append(SView)
            if i == 0 {
                SView.button1.setTitle("卫津路", for: .normal)
            SView.button2.setTitle("北洋园", for: .normal)
        //                MARK: 刷新校区数据
            SView.button1.addTarget(self, action: #selector(select(button:)), for: .touchUpInside)
            SView.button1.tag = 2
            SView.button2.addTarget(self, action: #selector(select(button:)), for: .touchUpInside)
            SView.button2.tag = 3
        } else {
            SView.button1.setTitle("日期选择", for: .normal)
            SView.button1.tag = 0
            SView.button1.addTarget(self, action: #selector(select(button:)), for: .touchUpInside)

            SView.button2.setTitle("节次选择", for: .normal)
            SView.button2.tag = 1
            SView.button2.addTarget(self, action: #selector(select(button:)), for: .touchUpInside)
        }
        pageTitleView.inviButton[i].addTarget(self, action: #selector(appear(button:)), for: .touchUpInside)
    }
    }
    private func setupUI() {
        
        view.backgroundColor = .white
        view.addSubview(pageTitleView)
        
        let tapGes = UITapGestureRecognizer(target: self, action: #selector(titleLabelClick))
        pageTitleView.titleLabel[2].isUserInteractionEnabled = true
        pageTitleView.titleLabel[2].addGestureRecognizer(tapGes)
        
    }
    
    @objc func refreshData() {
        guard isRefreshing == false else {
            return
        }
//存储再议
        isRefreshing = true
        startRotating()
        BuildingListHelper.getBuildingList(success: { buildingListData in
            self.isRefreshing = false
            self.stopRotating()
            self.list1.removeAll()
            self.list2.removeAll()
            DataHelper.buildingList = buildingListData
            for i in 0..<DataHelper.buildingList.data.count {
                if DataHelper.buildingList.data[i].campusID == "1" {
                    self.list1.append(DataHelper.buildingList.data[i])
                }
                if DataHelper.buildingList.data[i].campusID == "2" {
                    self.list2.append(DataHelper.buildingList.data[i])
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
    @objc func back() {
        navigationController?.popViewController(animated: true)
    }
    @objc func hide() {
        if calendarView.isHidden == false {
            calendarView.isHidden = true
            view.backgroundColor = .white
            transparencyButton.isUserInteractionEnabled = false
        }
    }
    @objc func re() {
        self.enshrineView.isHidden = true
        view.backgroundColor = .white
    }
    
    @objc func titleLabelClick(tapGes: UITapGestureRecognizer) {
        
//        MARK: 背景颜色要改
        enshrineView.reload()
        self.enshrineView.isHidden = false
        view.backgroundColor = .lightGray

    }
    @objc func appear(button: UIButton) {
//        两个不能同时被点击还没写
        sli[button.tag].isHidden = !(sli[button.tag].isHidden)
    }
    @objc func select(button: UIButton) {
        switch button.tag {
        case 0:
            calendarView.isHidden = false
            transparencyButton.isUserInteractionEnabled = true
            sli[1].isHidden = true
            self.view.backgroundColor = UIColor(red: 0.76, green: 0.78, blue: 0.79, alpha: 1)
        case 1:
            navigationController?.pushViewController(CourseViewController(), animated: true)
            sli[0].isHidden = true
            sli[1].isHidden = true
        case 2:
            CampusHelper.campusId = "1"
            self.list1.removeAll()
            self.list2.removeAll()
            view.subviews.map( {(subview: AnyObject) -> AnyObject in
                if subview.isKind(of: UICollectionView.self) {
                    subview.removeFromSuperview()
                }
                if subview.isKind(of: SlienceView.self) {
                    subview.removeFromSuperview()
                }
                if subview.isKind(of: CalendarView.self) {
                    subview.removeFromSuperview()
                }
                if subview.isKind(of: EnshrineView.self) {
                    subview.removeFromSuperview()
                }
                return subview
            })
//            view.subviews.map {
//                $0.removeFromSuperview()
//            }
            setupCollectionView().reloadData()
            self.sli.removeAll()
            self.addSelectView()
            pageTitleView.titleLabel[0].text = button.titleLabel?.text
        default:
            CampusHelper.campusId = "2"
            self.list1.removeAll()
            self.list2.removeAll()
            pageTitleView.titleLabel[0].text = button.titleLabel?.text
            view.subviews.map( {(subview: AnyObject) -> AnyObject in
                if subview.isKind(of: UICollectionView.self) {
                    subview.removeFromSuperview()
                }
                if subview.isKind(of: SlienceView.self) {
                    subview.removeFromSuperview()
                }
                if subview.isKind(of: CalendarView.self) {
                    subview.removeFromSuperview()
                }
                if subview.isKind(of: EnshrineView.self) {
                    subview.removeFromSuperview()
                }
                return subview
            })
            setupCollectionView().reloadData()
            self.sli.removeAll()
            self.addSelectView()

        }
    }
    
    

    
    func setupCollectionView() -> UICollectionView {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 30
        layout.minimumInteritemSpacing = 0
        layout.itemSize = CGSize(width: (screenW - 100) / 3, height: 80)
//        MARK: 原来y是150
        collectionView = UICollectionView(frame: CGRect(x: 30, y: 130, width: screenW - 60, height: screenH), collectionViewLayout: layout)
        collectionView.frame.origin.y = navigationBarH + statusH + titleViewH + 20
        self.view.addSubview(collectionView)
//        collectionView.snp.makeConstraints { (make) in
//            make.left.equalTo(30)
//            make.centerX.equalToSuperview()
//            make.centerY.equalToSuperview().offset(-100)
//            make.height.equalToSuperview()
//        }
        collectionView.collectionViewLayout = layout
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = .clear
        collectionView.register(TestCollectionViewCell.self, forCellWithReuseIdentifier: id)
        
        
        BuildingListHelper.getBuildingList(success: { buildingListData in
            self.list1.removeAll()
            self.list2.removeAll()
            DataHelper.buildingList = buildingListData
            for i in 0..<DataHelper.buildingList.data.count {
                if DataHelper.buildingList.data[i].campusID == "1" {
                    self.list1.append(DataHelper.buildingList.data[i])
                }
                if DataHelper.buildingList.data[i].campusID == "2" {
                    self.list2.append(DataHelper.buildingList.data[i])
                }
            }
            self.collectionView.reloadData()
        }) { _ in
            
        }
        return collectionView
    }


}

//遵守PageTitleViewdelegate
extension ClassroomCheckViewController: ClassRoomCheckPageTitleViewDelegate {
    func classroomCheckPageTitleView(titleView: ClassRoomCheckPageTitleView, selectedIndex index: Int) {
        pageContentView.setCurrentIndex(currentIndex: index)
    }
}

//遵守PageContentViewdelegate
extension ClassroomCheckViewController: ClassroomPageContentViewDelegate {
    
    func classroomPageContentView(contentView: ClassroomPageContentView, progress: CGFloat, sourceIndex: Int, targetIndex: Int) {
        pageTitleView.setTitleWithProgress(progress: progress, sourceIndex: sourceIndex, targetIndex: targetIndex)
    }
}

extension ClassroomCheckViewController: UICollectionViewDelegate {
    
}

extension ClassroomCheckViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if DataHelper.buildingList == nil {
            return 0
        }
        if CampusHelper.campusId == "1" {
            return self.list1.count
        }
        if CampusHelper.campusId == "2" {
            return self.list2.count
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: id, for: indexPath) as! TestCollectionViewCell
        cell.imageView.image = #imageLiteral(resourceName: "教学楼")
        cell.label.text = ""
        if CampusHelper.campusId == "1" {
            cell.label.text = self.list1[indexPath.row].building
        }
        if CampusHelper.campusId == "2" {
            cell.label.text = self.list2[indexPath.row].building
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! TestCollectionViewCell
        if CampusHelper.campusId == "1" {
            PageHelper.pageNum = indexPath.row
        }
        if CampusHelper.campusId == "2" {
            PageHelper.pageNum = indexPath.row + self.list1.count
        }
        ClassroomHelper.buildingId = cell.label.text!
        navigationController?.pushViewController(RoomCheckViewController(), animated: true)
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets{
        return UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
    }
    
}

extension UIViewController {
    class func current(base: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
        if let nav = base as? UINavigationController {
            return current(base: nav.visibleViewController)
        }
        if let tab = base as? UITabBarController {
            return current(base: tab.selectedViewController)
        }
        if let presented = base?.presentedViewController {
            return current(base: presented)
        }
        return base
    }
}

