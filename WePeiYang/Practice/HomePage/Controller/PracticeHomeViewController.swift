//
//  PracticeHomeViewController.swift
//  WePeiYang
//
//  Created by JasonEWNL on 2018/7/13.
//  Copyright © 2018年 twtstudio. All rights reserved.
//

import UIKit
import SDWebImage
import PopupDialog
import SwiftMessages

// MARK: UIViewController
class PracticeHomeViewController: UIViewController {
    
    /* 用户模型 */
    var practiceStudent: PracticeStudentModel!
    
    /* 顶部切换视图 */
    let headView = HeadView()
    
    /* 底层滑动视图 */
    let contentScrollView = UIScrollView()
    
    /* "我的" 视图 */
    let userTableView = UITableView(frame: CGRect(), style: .grouped)
    let UserViewCellTitles = ["练习历史", "我的错题", "我的收藏", "我的上传"]
    let UserViewCellIcons = [#imageLiteral(resourceName: "practiceHistory"), #imageLiteral(resourceName: "practiceWrong"), #imageLiteral(resourceName: "practiceCollection"), #imageLiteral(resourceName: "practiceUpload")]
    // "我的" 顶部个人信息 //
    let userView = UserView()
    
    /* "题库" 视图 */
    let homeTableView = UITableView(frame: CGRect(), style: .grouped)
    let HomeHeaderTitles = ["党课", "形政", "网课", "其他"]
    let HomeHeaderIcons = [#imageLiteral(resourceName: "practicePartyCourse"), #imageLiteral(resourceName: "practiceSituationAndPolicy"), #imageLiteral(resourceName: "practiceOnlineCourse"), #imageLiteral(resourceName: "practiceOther")]
    // "我的" 顶部课程信息 //
    let homeCollectionView = UICollectionView(frame: CGRect(x: 0, y: 0, width: deviceWidth, height: 150), collectionViewLayout: UICollectionViewFlowLayout())
    let HomeViewCellStyles: [HomeViewCellStyle] = [.quickSelect, .latestInformation, .currentPractice]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white

        /* 用户模型 */
        PracticeStudentHelper.getStudent(success: { practiceStudent in
            self.practiceStudent = practiceStudent
            self.userTableView.reloadData()
            self.homeTableView.reloadData()
        }) { error in }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        /* 导航栏 */
        navigationController?.setNavigationBarHidden(false, animated: true)
        navigationController?.navigationBar.barStyle = .black
        
        navigationController?.navigationBar.setBackgroundImage(UIImage(color: .practiceBlue), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.tintColor = .white
        let barHeight = (navigationController?.navigationBar.frame.origin.y)! + (navigationController?.navigationBar.frame.size.height)!
        
        /* 标题 */
        let titleLabel = UILabel(text: "天外天刷题")
        titleLabel.font = UIFont.boldSystemFont(ofSize: 21)
        titleLabel.textColor = .white
        titleLabel.sizeToFit()
        navigationItem.titleView = titleLabel
        
        /* 返回 */
        let practiceBack = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
        navigationItem.backBarButtonItem = practiceBack
        
        /* 搜索 */
        let practiceSearch = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(self.practiceSearch))
        navigationItem.rightBarButtonItem = practiceSearch
        
        /* 顶部视图 */
        headView.frame = CGRect(x: 0, y: 0, width: deviceWidth, height: 64)
        headView.userOptionButton.addTarget(self, action: #selector(optionButtonClick), for: .touchUpInside)
        headView.homeOptionButton.addTarget(self, action: #selector(optionButtonClick), for: .touchUpInside)
        headView.userOptionButton.isEnabled = !PracticeFigure.isAtRight // 滑动视图在左 -> "我的" 不可用
        headView.homeOptionButton.isEnabled = PracticeFigure.isAtRight // 滑动视图在右 -> "题库" 可用
        if !PracticeFigure.isAtRight { headView.underLine.frame.origin.x = deviceWidth / 6 } // 白色指示条默认在右, 非默认则调整位置
        self.view.addSubview(headView)
        // 额外视图 //
        let additionalView = UIView(frame: CGRect(x: 0, y: -barHeight, width: deviceWidth, height: barHeight))
        additionalView.backgroundColor = .practiceBlue
        headView.addSubview(additionalView)

        /* 滑动视图 */
        contentScrollView.frame = CGRect(x: 0, y: headView.frame.size.height, width: deviceWidth, height: deviceHeight - barHeight - headView.frame.height)
        contentScrollView.delegate = self
        
        contentScrollView.contentSize = CGSize(width: 2 * deviceWidth, height: contentScrollView.frame.height)
        if PracticeFigure.isAtRight { contentScrollView.contentOffset = CGPoint(x: deviceWidth, y: 0) } // 滑动视图默认在右, 非默认则为系统初试位置
        
        contentScrollView.showsHorizontalScrollIndicator = false
        contentScrollView.showsVerticalScrollIndicator = false
        contentScrollView.isPagingEnabled = true
        
        self.view.addSubview(contentScrollView)
        
        /* "我的" 视图 */
        userTableView.frame = CGRect(x: deviceWidth, y: 0, width: deviceWidth, height: contentScrollView.frame.height)
        userTableView.backgroundColor = .clear
        userTableView.showsVerticalScrollIndicator = false
        userTableView.delegate = self
        userTableView.dataSource = self
        contentScrollView.addSubview(userTableView)
        
        /* "题库" 视图 */
        homeTableView.frame = CGRect(x: 0, y: 0, width: deviceWidth, height: contentScrollView.frame.height)
        homeTableView.backgroundColor = .clear
        homeTableView.showsVerticalScrollIndicator = false
        homeTableView.separatorColor = .clear
        homeTableView.delegate = self
        homeTableView.dataSource = self
        contentScrollView.addSubview(homeTableView)
    }
    
    // 点击按钮切换, 改变白色指示条位置与按钮可用状态 //
    @objc func optionButtonClick(button: UIButton) {
        button.setBounceAnimation()
        UIView.animate(withDuration: 0.25) {
            var tempX = self.headView.underLine.frame.origin.x
            switch button {
            case self.headView.userOptionButton:
                tempX += deviceWidth / 2
                self.contentScrollView.contentOffset = CGPoint(x: deviceWidth, y: 0)
                PracticeFigure.isAtRight = true
            case self.headView.homeOptionButton:
                tempX -= deviceWidth / 2
                self.contentScrollView.contentOffset = CGPoint(x: 0, y: 0)
                PracticeFigure.isAtRight = false
            default:
                break
            }
            (self.headView.userOptionButton.isEnabled, self.headView.homeOptionButton.isEnabled) = (self.headView.homeOptionButton.isEnabled, self.headView.userOptionButton.isEnabled)
            self.headView.underLine.frame.origin.x = tempX
        }
    }
    
    // 进入搜索界面 //
    @objc func practiceSearch() {
        // TODO: 进入搜索界面
        // self.navigationController?.pushViewController(<#T##viewController: UIViewController##UIViewController#>, animated: true)
    }
    
}

// MARK: - UIScrollView
/* 滑动视图代理 */
extension PracticeHomeViewController: UIScrollViewDelegate {
    
    // 正在滑动时, 动态改变白色指示条位置 //
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        headView.underLine.frame.origin.x = deviceWidth / 6 + deviceWidth / 2 * (self.contentScrollView.contentOffset.x / deviceWidth)
    }
    
    // 结束滑动时, 判断位置刷新按钮可用状态 //
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if headView.underLine.center.x < deviceWidth / 2 {
            (self.headView.userOptionButton.isEnabled, self.headView.homeOptionButton.isEnabled) = (true, false)
            PracticeFigure.isAtRight = false
        } else {
            (self.headView.userOptionButton.isEnabled, self.headView.homeOptionButton.isEnabled) = (false, true)
            PracticeFigure.isAtRight = true
        }
    }
    
}

// MARK: - UITableView
/* 表单视图数据 */
extension PracticeHomeViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch tableView {
        
        // "我的" 视图 - 单元个数 //
        case userTableView:
            return UserViewCellTitles.count
            
        // "题库" 视图 - 单元个数 //
        case homeTableView:
            return HomeViewCellStyles.count
            
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let row = indexPath.row
        
        switch tableView {
        
        // "我的" 视图 - 单元 //
        case userTableView:
            let userViewCell = UITableViewCell()
            
            // 自定义系统默认 UITableViewCell 的 imageView 大小 //
            userViewCell.imageView?.image = UserViewCellIcons[row]
            UIGraphicsBeginImageContextWithOptions(CGSize(width: 32, height: 32), false, UIScreen.main.scale)
            userViewCell.imageView?.image?.draw(in: CGRect(x: 0, y: 0, width: 32, height: 32))
            userViewCell.imageView?.image = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            
            userViewCell.textLabel?.text = UserViewCellTitles[row]
            userViewCell.accessoryType = .disclosureIndicator
            
            return userViewCell
            
        // "题库" 视图 - 单元 //
        case homeTableView:
            if practiceStudent == nil { return UITableViewCell() }
            
            let homeViewCell = HomeViewCell(byModel: practiceStudent, withStyle: HomeViewCellStyles[row])
            
            homeViewCell.selectionStyle = .none
            
            switch row {
            case 0:
                for bubbleButton in homeViewCell.bubbleButtonArray {
                    bubbleButton.addTarget(self, action: #selector(clickQuickSelect), for: .touchUpInside)
                }
            case 2:
                homeViewCell.continueBubbleButton.addTarget(self, action: #selector(clickContinueCurrent), for: .touchUpInside)
            default:
                break
            }
            
            return homeViewCell
        
        default:
            return UITableViewCell()
        }
    }
    
    @objc func clickQuickSelect(button: UIButton) {
        let course = practiceStudent.data.qSelect[button.tag]
        PracticeFigure.courseID = String(course.id)
        
        let warningCard = PopupDialog(title: course.courseName, message: "请选择练习模式", buttonAlignment: .horizontal, transitionStyle: .zoomIn)
        let leftButton = PracticePopupDialogButton(title: "顺序练习", dismissOnTap: true) {
            PracticeFigure.practiceType = "0"
            // TODO: 进入顺序练习
            // self.navigationController?.pushViewController(<#T##viewController: UIViewController##UIViewController#>, animated: true)
        }
        let rightButton = PracticePopupDialogButton(title: "模拟考试", dismissOnTap: true) {
            PracticeFigure.practiceType = "1"
            // TODO: 进入模拟考试
            // self.navigationController?.pushViewController(<#T##viewController: UIViewController##UIViewController#>, animated: true)
        }
        warningCard.addButtons([leftButton, rightButton])
        self.present(warningCard, animated: true, completion: nil)
    }
    
    @objc func clickContinueCurrent(button: UIButton) {
        let studentData = practiceStudent.data
        PracticeFigure.practiceType = "0"
        PracticeFigure.courseID = studentData.currentCourseID
        // TODO: 进入当前练习
        // self.navigationController?.pushViewController(<#T##viewController: UIViewController##UIViewController#>, animated: true)
    }
    
}

/* 表单视图代理 */
extension PracticeHomeViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch tableView {
            
        // "我的" 视图 - 单元高度 //
        case userTableView:
            return 44
            
        // "题库" 视图 - 单元高度 //
        case homeTableView:
            if practiceStudent == nil { return 0 }
            return HomeViewCell(byModel: practiceStudent, withStyle: HomeViewCellStyles[indexPath.row]).cellHeight
            
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch tableView {
            
        // "我的" 视图 - 头视图高度 //
        case userTableView:
            return section == 0 ? 300 : 0
            
        // "题库" 视图 - 头视图高度 //
        case homeTableView:
            return section == 0 ? 128 : 0
        
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        switch tableView {
            
        // "我的" 视图 - 头视图 //
        case userTableView:
            if section != 0 { return nil }
            
            if let practiceStudent = practiceStudent {
                userView.userHeadView.sd_setImage(with: URL(string: practiceStudent.data.avatarURL), placeholderImage: UIImage(named: "account_circle")!.with(color: .gray)) // 头像
                userView.userNameLabel.text = practiceStudent.data.twtName // 昵称
                userView.userTitleLabel.text = practiceStudent.data.titleName // 称号
                userView.practicedQuestionNumber.text = practiceStudent.data.doneCount // 已练习题目数
                userView.practicedCourseNumber.text = "\(practiceStudent.data.courseCount)" // 已练习科目数
                
                let correctRateString = String(Int(100 - Double(practiceStudent.data.errorCount)! / Double(practiceStudent.data.doneCount)! * 100))
                let correctRateText = NSMutableAttributedString(string: "正确率 \(correctRateString)%") // 使用富文本改变字体
                correctRateText.addAttribute(.foregroundColor, value: UIColor.darkGray, range: NSMakeRange(0, 4))
                userView.correctRate.attributedText = correctRateText // 正确率
            } else {
                userView.userHeadView.image = #imageLiteral(resourceName: "ic_account_circle")
                userView.userNameLabel.text = "我的昵称"
                userView.userTitleLabel.text = "我的称号"
                userView.practicedQuestionNumber.text = "0"
                userView.practicedCourseNumber.text = "0"
                
                let correctRateText = NSMutableAttributedString(string: "正确率 0%")
                correctRateText.addAttribute(.foregroundColor, value: UIColor.darkGray, range: NSMakeRange(0, 4))
                userView.correctRate.attributedText = correctRateText
            }
            
            return userView
        
        // "题库" 视图 - 头视图 //
        case homeTableView:
            if section != 0 { return nil }
            
            homeCollectionView.delegate = self
            homeCollectionView.dataSource = self
            
            return homeCollectionView
            
        default:
            return nil
        }
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        switch tableView {
            
        // "我的" 视图 - 底视图 //
        case userTableView:
            if section != 0 { return nil }
            
            let mottoLabel = UILabel(text: "\nPractice Makes Perfect.\n— Jason C.\n", color: .darkGray)
            mottoLabel.font = UIFont(name: "Zapfino", size: 16) // "Bradley Hand" "Chalkboard SE"
            mottoLabel.textAlignment = .center
            mottoLabel.numberOfLines = 0
            mottoLabel.frame = CGRect(x: 0, y: 0, width: deviceWidth, height: 0)
            
            return mottoLabel
           
        // "题库" 视图 - 底视图 //
        case homeTableView:
            return nil
            
        default:
            return nil
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let row = indexPath.row
        
        if tableView == homeTableView { return }
        
        switch row {
        case 0:
            // 练习历史 //
            self.navigationController?.pushViewController(PracticeHistoryViewController(), animated: true)
        case 1:
            // 我的错题 //
            self.navigationController?.pushViewController(PracticeWrongViewController(), animated: true)
        case 2:
            // 我的收藏 //
            self.navigationController?.pushViewController(PracticeCollectionViewController(), animated: true)
        case 3:
            // 我的上传 //
            self.navigationController?.pushViewController(PracticeUploadViewController(), animated: true)
        default:
            return
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}

// MARK: - UICollectionView
/* 集合视图数据 */
extension PracticeHomeViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return HomeHeaderTitles.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let row = indexPath.row
        
        collectionView.backgroundColor = .clear
        collectionView.register(HomeHeaderCell.self, forCellWithReuseIdentifier: "homeHeaderCell")
        
        let homeHeaderCell = collectionView.dequeueReusableCell(withReuseIdentifier: "homeHeaderCell", for: indexPath) as! HomeHeaderCell
        
        homeHeaderCell.classImage.image = HomeHeaderIcons[row]
        homeHeaderCell.className.text = HomeHeaderTitles[row]
        
        if row == 2 { // 居然是长方形的图标也太难为强迫症了吧
            homeHeaderCell.classImage.frame.size.width += 10
            homeHeaderCell.classImage.frame.origin.x -= 5
        }
        
        return homeHeaderCell
    }
    
}

/* 集合视图代理和布局 */
extension PracticeHomeViewController: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (deviceWidth - 100) / 4, height: 80)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 27, left: 20, bottom: 20, right: 20)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.cellForItem(at: indexPath)?.setBounceAnimation()
        let row = indexPath.row
        
        switch row {
        // case 0, 2:
            // TODO: 进入党课 / 网课课程列表
            // self.navigationController?.pushViewController(<#T##viewController: UIViewController##UIViewController#>, animated: true)
        case 1:
            PracticeFigure.courseID = "1"
            let warningCard = PopupDialog(title: "形式与政策", message: "请选择练习模式", buttonAlignment: .horizontal, transitionStyle: .zoomIn)
            let leftButton = PracticePopupDialogButton(title: "顺序练习", dismissOnTap: true) {
                PracticeFigure.practiceType = "0"
                // TODO: 进入顺序练习
                // self.navigationController?.pushViewController(<#T##viewController: UIViewController##UIViewController#>, animated: true)
            }
            let rightButton = PracticePopupDialogButton(title: "模拟考试", dismissOnTap: true) {
                PracticeFigure.practiceType = "1"
                // TODO: 进入模拟考试
                // self.navigationController?.pushViewController(<#T##viewController: UIViewController##UIViewController#>, animated: true)
            }
            warningCard.addButtons([leftButton, rightButton])
            self.present(warningCard, animated: true, completion: nil)
        case 3:
            SwiftMessages.showWarningMessage(body: "功能完善中\n敬请期待嘤")
        default:
            return
        }
    }
    
}

extension UIColor {
    // 刷题蓝色 //
    static var practiceBlue: UIColor {
        return UIColor(red: 67.0/255.0, green: 170.0/255.0, blue: 250.0/255.0, alpha: 1.0)
    }
    // 刷题红色 //
    static var practiceRed: UIColor {
        return UIColor(red: 252.0/255.0, green: 35.0/255.0, blue: 43.0/255.0, alpha: 1.0)
    }
}

extension UIView {
    // 弹簧动画 //
    func setBounceAnimation(withDuration duration: TimeInterval = 0.1, scale: CGFloat = 0.8, _ animations: @escaping (Bool) -> Void = {_ in }) {
        UIView.animate(withDuration: duration, delay: 0, options: [.allowUserInteraction, .curveEaseIn],
                       animations: { self.transform = CGAffineTransform(scaleX: scale, y: scale) },
                       completion: { isFinished in })
        UIView.animate(withDuration: duration, delay: duration, options: [.allowUserInteraction, .curveEaseIn],
                       animations: { self.transform = CGAffineTransform.identity },
                       completion: { animations }())
    }
}

/* 采用 PopupDialog 的专用按钮 */
class PracticePopupDialogButton: PopupDialogButton {
    override func setupView() {
        defaultTitleColor = .practiceBlue
        super.setupView()
    }
}
