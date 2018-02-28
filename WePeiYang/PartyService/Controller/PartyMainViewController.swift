//
//  PartyMainViewController.swift
//  WePeiYang
//
//  Created by Allen X on 8/9/16.
//  Copyright © 2016 Qin Yubo. All rights reserved.
//

import UIKit
import SnapKit
import IGIdenticon

class PartyMainViewController: UIViewController {

    //let personalStatusButton = UIButton(title: "查看个人进度")
    
    let functionList = ["查看个人状态", "考试报名", "课程列表", "成绩查询", "递交文件"]
    /*
    let functionList = [["icon": "考试报名", "desc": "考试报名"],
                        ["icon": "课程列表", "desc": "课程列表"],
                        ["icon": "成绩查询", "desc": "成绩查询"]]
    */
    let titleLabel = UILabel(text: "党建生活", color: .white)
    //let headerView = UIView(color: partyRed)
    let headerView = UIView(color: .partyRed)
    var headerWaveView = WXWaveView()
    
    let anAvatar = UIImageView()
    let avatarBackGround = UIView()
    
    let functionTableView = UITableView()
    
    //FIXME: 如果直接使用 Applicant.sharedInstance.realName! 会直接 found nil
    /*var aNameLabel: UILabel = {
        guard let foo = Applicant.sharedInstance.realName else {
            return UILabel(text: "获取姓名失败", color: )
        }
        return UILabel(text: foo, color: )
    }()*/
    
    var aNameLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //personalStatusButton.addTarget(self, action: #selector(PartyMainViewController.personalStatusButtonTapped(_:)), for: .touchUpInside)

        functionTableView.delegate = self
        functionTableView.dataSource = self
        functionTableView.tableFooterView = UIView()
        
        titleLabel.font = UIFont.boldSystemFont(ofSize: 20.0)
        navigationItem.titleView = titleLabel
        
        
        //随机头像
        if let randomNumber = UserDefaults.standard.object(forKey: "PartyAvatarNumber") as? Int {
            let imageGenerator = GitHubIdenticon()
//            let imageGenerator = IGImageGenerator(imageProducer: IGSimpleIdenticon(), hashFunction: IGJenkinsHashFromData)
//            anAvatar.image = imageGenerator.imageFromUInt32(UInt32(randomNumber), size: CGSize(width: 88, height: 88))
            anAvatar.image = imageGenerator.icon(from: UInt32(randomNumber), size: CGSize(width: 88, height: 88))
        } else {
            let imageGenerator = GitHubIdenticon()

//            let imageGenerator = IGImageGenerator(imageProducer: IGSimpleIdenticon(), hashFunction: IGJenkinsHashFromData)
            let fooNum = arc4random()
            anAvatar.image = imageGenerator.icon(from: fooNum, size: CGSize(width: 88, height: 88))
            UserDefaults.standard.set(NSNumber(value: fooNum as UInt32), forKey: "PartyAvatarNumber")
        }
        
        anAvatar.isUserInteractionEnabled = true
        anAvatar.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(PartyMainViewController.changeAvatar)))
        
        anAvatar.clipsToBounds = true
        anAvatar.layer.cornerRadius = 44
        for subview in anAvatar.subviews {
            subview.layer.cornerRadius = 44
        }
        
        avatarBackGround.layer.cornerRadius = 48
        avatarBackGround.backgroundColor = UIColor.white
        
        /*
        let shadowPath = UIBezierPath(rect: avatarBackGround.bounds)
        avatarBackGround.layer.masksToBounds = false
        avatarBackGround.layer.shadowColor = .black.CGColor
        avatarBackGround.layer.shadowOffset = CGSizeMake(0.0, 5.0)
        avatarBackGround.layer.shadowOpacity = 0.5
        avatarBackGround.layer.shadowPath = shadowPath.CGPath
        */
        
        if let foo = UserDefaults.standard.object(forKey: "studentName") as? String {
            aNameLabel = UILabel(text: foo, color: .white)
        } else {
            aNameLabel = UILabel(text: "获取姓名失败", color: .white)
        }
        aNameLabel.font = UIFont.boldSystemFont(ofSize: 18)

        //headerView.layer.shadowOffset = CGSizeMake(0, 4);
        //headerView.layer.shadowRadius = 5;
        //headerView.layer.shadowOpacity = 0.5;
        headerView.isUserInteractionEnabled = true
        
        computeLayout()
        wave()
        
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(animated)
            self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
            self.navigationController?.navigationBar.shadowImage = UIImage()
            self.navigationController?.navigationBar.isTranslucent = true
            self.navigationController?.navigationBar.barStyle = .default
//        self.navigationController?.jz_navigationBarBackgroundAlpha = 0
        self.navigationController?.navigationBar.tintColor = UIColor.white
        navigationController?.navigationBar.barStyle = .black
//        UIApplication.shared.setStatusBarStyle(.lightContent, animated: true)

        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
//        UIApplication.shared.setStatusBarStyle(.default, animated: true)
        navigationController?.navigationBar.barStyle = .default
        guard Applicant.sharedInstance.realName != nil else {
            //log.word("not found")/
            return
        }
    }
    
    

    /*

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}


//MARK: TableView Delegate Methods
extension PartyMainViewController: UITableViewDelegate, UITableViewDataSource {
    
    //TODO: functionTableView delegate methods
    //TODO: all sorts of functions: SignUp | CourseList | ScoreInfoList | NotificationList
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return functionList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return FunctionListTableViewCell(iconName: "partyBtn", desc: functionList[indexPath.row])
        //return FunctionListTableViewCell(iconName: functionList[indexPath.row]["icon"], desc: functionList[indexPath.row]["desc"])
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.row == 0 {
            let personalStatusVC = PartyPersonalStatusViewController()
            navigationController?.show(personalStatusVC, sender: nil)
        }
        
        //考试报名
        if indexPath.row == 1 {
            let signupVC = PartySignUpViewController()
            navigationController?.show(signupVC, sender: nil)
        }
        
        //党课学习
        if indexPath.row == 2 {
            let courseVC = PartyCoursesViewController()
            navigationController?.show(courseVC, sender: nil)
        }
        
        //成绩查询
        if indexPath.row == 3 {
            let personalStatusVC = PartyScoreViewController()
            navigationController?.show(personalStatusVC, sender: nil)

        }
        
        //递交文件
        if indexPath.row == 4 {
            let partyHandInVC = PartyHandInViewController(nibName: "PartyHandInViewController", bundle: nil)
            navigationController?.show(partyHandInVC, sender: nil)
        }
        
        tableView.deselectRow(at: indexPath, animated: true)

    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 2
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: (UIApplication.shared.keyWindow?.frame.size.width)!, height: 2))
        
        return footerView
    }
}

//MARK: Snapkit Layout
extension PartyMainViewController {
    
    func computeLayout() {
        
        
        headerView.addSubview(avatarBackGround)
        avatarBackGround.snp.makeConstraints {
            make in
            make.centerX.equalTo(headerView)
            make.centerY.equalTo(headerView.snp.centerY).offset(16)
            make.width.height.equalTo(96)
        }
        
        headerView.addSubview(anAvatar)
        anAvatar.snp.makeConstraints {
            make in
            make.centerX.equalTo(headerView)
            make.centerY.equalTo(avatarBackGround)
            make.width.height.equalTo(88)
        }
        
        headerView.addSubview(aNameLabel)
        aNameLabel.snp.makeConstraints {
            make in
            make.top.equalTo(anAvatar.snp.bottom).offset(12)
            make.centerX.equalTo(headerView.snp.centerX)
        }
        
        
        
        //headerView.addSubview(personalStatusButton)
        /*personalStatusButton.snp.makeConstraints {
            make in
            make.centerY.equalTo(anAvatar)
            make.left.equalTo(anAvatar.snp.right).offset(5)
        }*/
        
    
        
        view.addSubview(headerView)
        headerView.snp.makeConstraints {
            make in
            make.top.equalTo(view)
            make.left.equalTo(view)
            make.right.equalTo(view)
            make.bottom.equalTo(aNameLabel.snp.bottom).offset(20)
        }
        
        //self.headerWaveView = WXWaveView.addToView(headerView, withFrame: CGRect(x: 0, y: headerView.bounds.height - 10, width: headerView.bounds.width, height: 10))
        
        
        //self.functionTableView.tableHeaderView = headerView
        view.addSubview(functionTableView)
        functionTableView.snp.makeConstraints{
            make in
            make.top.equalTo(headerView.snp.bottom)
            make.left.equalTo(view)
            make.right.equalTo(view)
            make.bottom.equalTo(view)
        }
        
        headerView.addSubview(headerWaveView)
        headerWaveView.snp.makeConstraints {
            make in
            make.left.equalTo(view)
            make.right.equalTo(view)
            make.top.equalTo(functionTableView.snp.top).offset(-10)
            make.height.equalTo(10)
        }
        //log.any(CGRectGetHeight(functionTableView.frame))/
        
    }
}

//MARK: Tapped functions
extension PartyMainViewController {
    /*func personalStatusButtonTapped(sender: UIButton!) {

        let personalStatusVC = PartyPersonalStatusViewController()
        navigationController?.showViewController(personalStatusVC, sender: nil)

    }*/
    
    func wave() {

        self.headerWaveView.waveColor = .partyRed
        self.headerWaveView.waveTime = 0.0
        self.headerWaveView.wave()
        
    }
    
    @objc func changeAvatar() {
        
        UIView.animate(withDuration: 0.3, animations: {
            self.anAvatar.alpha = 0
            }, completion: { flag in
                
//                let imageGenerator = IGImageGenerator(imageProducer: IGSimpleIdenticon(), hashFunction: IGJenkinsHashFromData)
                let imageGenerator = GitHubIdenticon()
                let fooNum = arc4random()
                self.anAvatar.image = imageGenerator.icon(from: fooNum, size: CGSize(width: 88, height: 88))
//                    imageGenerator.icon(from: fooNum, size: CGSize(width: 88, height: 88))
                self.anAvatar.alpha = 1
                UserDefaults.standard.set(NSNumber(value: fooNum as UInt32), forKey: "PartyAvatarNumber")
        })
        
    }
}


extension UIColor {
    static var partyRed: UIColor {
        return UIColor(red: 240.0/255.0, green: 22.0/255.0, blue: 22.0/255.0, alpha: 1.0)
    }
}

// This class uses gloabl extensions  below.
/*
extension UILabel {
    convenience init(text: String, color: UIColor) {
        self.init()
        self.text = text
        textColor = color
        self.sizeToFit()
    }
}

extension UIView {
    convenience init(color: UIColor) {
        self.init()
        backgroundColor = color
    }
}

extension UIButton {
    convenience init(title: String) {
        self.init()
        setTitle(title, forState: .Normal)
        titleLabel?.sizeToFit()
    }
}
*/
