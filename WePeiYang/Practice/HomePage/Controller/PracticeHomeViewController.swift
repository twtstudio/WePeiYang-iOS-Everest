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
    
    let userTableView = UITableView(frame: CGRect(), style: .grouped) // UserView()
    let UserViewCellTitle = ["练习历史", "我的错题", "我的收藏", "我的上传"]
    let UserViewCellIcon = [#imageLiteral(resourceName: "practiceHistory"), #imageLiteral(resourceName: "practiceWrong"), #imageLiteral(resourceName: "practiceCollection"), #imageLiteral(resourceName: "practiceUpload")]
    
    let homeView = HomeView()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
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
        homeView.frame = CGRect(x: 0, y: 0, width: deviceWidth, height: contentScrollView.frame.height)
        contentScrollView.addSubview(homeView)
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
            return UserViewCellTitle.count
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let row = indexPath.row
        
        switch tableView {
        
        // "我的" 视图 - 单元 //
        case userTableView:
            let cell = UITableViewCell(style: .default, reuseIdentifier: "UserViewCell")
            
            // 自定义系统默认 UITableViewCell 的 imageView 大小 //
            cell.imageView?.image = UserViewCellIcon[row]
            UIGraphicsBeginImageContextWithOptions(CGSize(width: 32, height: 32), false, UIScreen.main.scale)
            cell.imageView?.image?.draw(in: CGRect(x: 0, y: 0, width: 32, height: 32))
            cell.imageView?.image = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            
            cell.textLabel?.text = UserViewCellTitle[row]
            cell.accessoryType = .disclosureIndicator
            
            return cell
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
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch tableView {
            
        // "我的" 视图 - 头视图高度 //
        case userTableView:
            return section == 0 ? 300 : 0
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        switch tableView {
            
        // "我的" 视图 - 头视图 //
        case userTableView:
            if section != 0 { return nil }
            
            let userView = UserView()
            userView.userHeadView.sd_setImage(with: URL(string: TwTUser.shared.avatarURL ?? ""), placeholderImage: UIImage(named: "account_circle")!.with(color: .gray))

            if TwTUser.shared.token != nil {
                userView.userNameLabel.text = TwTUser.shared.username
                userView.userTitleLabel.text = "刷题小火箭" // 称号
                userView.practicedQuestionNumber.text = "1010" // 已练习题目数
                userView.practicedCourseNumber.text = "10" // 已练习科目数
                
                let correctRateText = NSMutableAttributedString(string: "正确率 98%") // 正确率
                correctRateText.addAttribute(.foregroundColor, value: UIColor.darkGray, range: NSMakeRange(0, 4))
                userView.correctRate.attributedText = correctRateText
            } else {
                userView.userNameLabel.text = "我的昵称"
                userView.userTitleLabel.text = "我的称号"
                userView.practicedQuestionNumber.text = "0"
                userView.practicedCourseNumber.text = "0"
                
                let correctRateText = NSMutableAttributedString(string: "正确率 0%")
                correctRateText.addAttribute(.foregroundColor, value: UIColor.darkGray, range: NSMakeRange(0, 4))
                userView.correctRate.attributedText = correctRateText
            }
            
            return userView
        default:
            return nil
        }
        
    }
    
}

extension UIColor {
    // 刷题蓝色 //
    static var practiceBlue: UIColor {
        return UIColor(red: 67.0/255.0, green: 170.0/255.0, blue: 250.0/255.0, alpha: 1.0)
    }
}
