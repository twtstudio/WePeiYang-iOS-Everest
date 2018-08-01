//
//  PracticeHomeViewController.swift
//  WePeiYang
//
//  Created by JasonEWNL on 2018/7/13.
//  Copyright © 2018年 twtstudio. All rights reserved.
//

import UIKit

class PracticeHomeViewController: UIViewController {
    
    let headView = HeadView()
    
    let contentScrollView = UIScrollView()
    
    let userTableView = UITableView(frame: CGRect(), style: .grouped)
    let UserViewCellTitles = ["练习历史", "我的错题", "我的收藏", "我的上传"]
    let UserViewCellIcons = [#imageLiteral(resourceName: "practiceHistory"), #imageLiteral(resourceName: "practiceWrong"), #imageLiteral(resourceName: "practiceCollection"), #imageLiteral(resourceName: "practiceUpload")]
    let userView = UserView()
    
    let homeTableView = UITableView(frame: CGRect(), style: .grouped)
    let HomeHeaderTitles = ["党课", "形政", "网课", "其他"]
    let HomeHeaderIcons = [#imageLiteral(resourceName: "practicePartyCourse"), #imageLiteral(resourceName: "practiceSituationAndPolicy"), #imageLiteral(resourceName: "practiceOnlineCourse"), #imageLiteral(resourceName: "practiceOther")]
    let homeCollectionView = UICollectionView(frame: CGRect(x: 0, y: 0, width: deviceWidth, height: 150), collectionViewLayout: UICollectionViewFlowLayout())
    let HomeViewCellStyles: [HomeViewCellStyle] = [.quickSelect, .latestInformation, .currentPractice]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
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
        let barHeight = (navigationController?.navigationBar.y)! + (navigationController?.navigationBar.height)!
        
        /* 标题 */
        let titleLabel = UILabel(text: "天外天刷题")
        titleLabel.font = UIFont.boldSystemFont(ofSize: 21)
        titleLabel.textColor = .white
        titleLabel.sizeToFit()
        navigationItem.titleView = titleLabel
        
        /* 搜索 */
        let practiceSearch = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(self.practiceSearch))
        navigationItem.rightBarButtonItem = practiceSearch
        
        /* 顶部视图 */
        headView.frame = CGRect(x: 0, y: -1/3, width: deviceWidth, height: 64)
        headView.userOptionButton.addTarget(self, action: #selector(optionButtonClick), for: .touchUpInside)
        headView.homeOptionButton.addTarget(self, action: #selector(optionButtonClick), for: .touchUpInside)
        headView.userOptionButton.isEnabled = false
        headView.homeOptionButton.isEnabled = true
        self.view.addSubview(headView)

        /* 滑动视图 */
        contentScrollView.frame = CGRect(x: 0, y: headView.frame.size.height, width: deviceWidth, height: deviceHeight - barHeight - headView.frame.height)
        contentScrollView.delegate = self
        
        contentScrollView.contentSize = CGSize(width: 2 * deviceWidth, height: contentScrollView.frame.height)
        contentScrollView.contentOffset = CGPoint(x: deviceWidth, y: 0)
        
        contentScrollView.showsHorizontalScrollIndicator = false
        contentScrollView.showsVerticalScrollIndicator = false
        contentScrollView.isPagingEnabled = true
        
        self.view.addSubview(contentScrollView)
        
        /* "我的" 视图 */
        userTableView.frame = CGRect(x: deviceWidth, y: 0, width: deviceWidth, height: contentScrollView.frame.height)
        userTableView.backgroundColor = .clear
        userTableView.delegate = self
        userTableView.dataSource = self
        contentScrollView.addSubview(userTableView)
        
        /* "题库" 视图 */
        homeTableView.frame = CGRect(x: 0, y: 0, width: deviceWidth, height: contentScrollView.frame.height)
        homeTableView.backgroundColor = .clear
        homeTableView.separatorColor = .clear
        homeTableView.delegate = self
        homeTableView.dataSource = self
        contentScrollView.addSubview(homeTableView)
    }
    
    // 点击按钮切换, 改变白色指示条位置与按钮可用状态 //
    @objc func optionButtonClick(button: UIButton) {
        UIView.animate(withDuration: 0.25) {
            var tempX = self.headView.underLine.frame.origin.x
            switch button {
            case self.headView.userOptionButton:
                tempX += deviceWidth / 2
                self.contentScrollView.contentOffset = CGPoint(x: deviceWidth, y: 0)
            case self.headView.homeOptionButton:
                tempX -= deviceWidth / 2
                self.contentScrollView.contentOffset = CGPoint(x: 0, y: 0)
            default:
                break
            }
            (self.headView.userOptionButton.isEnabled, self.headView.homeOptionButton.isEnabled) = (self.headView.homeOptionButton.isEnabled, self.headView.userOptionButton.isEnabled)
            self.headView.underLine.frame.origin.x = tempX
        }
    }
    
    // 进入搜索界面 //
    @objc func practiceSearch() {
        
    }
    
}

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
        } else {
            (self.headView.userOptionButton.isEnabled, self.headView.homeOptionButton.isEnabled) = (false, true)
        }
    }
    
}

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
            // let cell = UITableViewCell(style: .default, reuseIdentifier: "UserViewCell")
            
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
            let homeViewCell = HomeViewCell(withStyle: HomeViewCellStyles[row])
            return homeViewCell
        
        default:
            return UITableViewCell()
        }
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
            return HomeViewCell(withStyle: HomeViewCellStyles[indexPath.row]).cellHeight
        
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
            
            userView.userHeadView.sd_setImage(with: URL(string: TwTUser.shared.avatarURL ?? ""), placeholderImage: UIImage(named: "account_circle")!.with(color: .gray))

            if TwTUser.shared.token != nil { // 已登录
                userView.userNameLabel.text = TwTUser.shared.username
                userView.userTitleLabel.text = "刷题飞人" // 称号
                userView.practicedQuestionNumber.text = "1010" // 已练习题目数
                userView.practicedCourseNumber.text = "10" // 已练习科目数
                
                let correctRateText = NSMutableAttributedString(string: "正确率 98%") // 正确率 (使用富文本改变字体)
                correctRateText.addAttribute(.foregroundColor, value: UIColor.darkGray, range: NSMakeRange(0, 4))
                userView.correctRate.attributedText = correctRateText
            } else { // 未登录
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let row = indexPath.row
        
        switch row {
        case 0:
            // 练习历史 //
            // self.navigationController?.pushViewController(<#T##viewController: UIViewController##UIViewController#>, animated: true)
            return
        case 1:
            // 我的错题 //
            // self.navigationController?.pushViewController(<#T##viewController: UIViewController##UIViewController#>, animated: true)
            return
        case 2:
            // 我的收藏 //
            // self.navigationController?.pushViewController(<#T##viewController: UIViewController##UIViewController#>, animated: true)
            return
        case 3:
            // 我的上传 //
            // self.navigationController?.pushViewController(<#T##viewController: UIViewController##UIViewController#>, animated: true)
            return
        default:
            return
        }
    }
    
}

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
        
        homeHeaderCell.courseImage.image = HomeHeaderIcons[row]
        homeHeaderCell.courseName.text = HomeHeaderTitles[row]
        
        if row == 2 { // 居然是长方形的图标
            homeHeaderCell.courseImage.frame.size.width += 10
            homeHeaderCell.courseImage.frame.origin.x -= 5
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
        // <#code#>
    }
    
}

extension UIColor {
    // 刷题蓝色 //
    static var practiceBlue: UIColor {
        return UIColor(red: 67.0/255.0, green: 170.0/255.0, blue: 250.0/255.0, alpha: 1.0)
    }
}
