//
//  PartyPersonalStatusViewController.swift
//  WePeiYang
//
//  Created by JinHongxu on 16/8/13.
//  Copyright © 2016年 Qin Yubo. All rights reserved.
//

import UIKit

class PartyPersonalStatusViewController: UIViewController, UIScrollViewDelegate {
    
    var mainScrollView = UIScrollView()
    
    var scrollView1 = UIScrollView()
    var scrollView2 = UIScrollView()
    
    var leftArrowView1 = UIImageView()
    var rightArrowView1 = UIImageView()
    var leftArrowView2 = UIImageView()
    var rightArrowView2 = UIImageView()
    
    
    // FIXME: 明天修！
    // 31 label array
    var labels = [PersonalStatusLabel]()
    var titles = ["递交入党申请书", "网上党校学习", "结业考试", "院级积极分子党校学习", "递交第一季度思想汇报", "递交第二季度思想汇报", "递交第三季度思想汇报", "递交第四季度思想汇报", "参加学习人申请小组", "被确认为积极分子", "团支部推优", "经支委会同意准备成为发展对象", "参加集中培训", "入党材料准备齐全", "支部向上级汇报", "党员发展公示", "填写入党志愿书", "召开发展大会，党支部表决", "党委谈话，审批", "成为预备党员", "完成预备党员党校学习", "递交第一季度个人小结", "递交第二季度个人小结", "递交第三季度个人小结", "递交第四季度个人小结", "参加党支部组织活动", "递交转正申请", "党员转正公示", "党员转正召开大会，表决通过", "党委审批", "成为中共正式党员"]
    
    var label1 = PersonalStatusLabel()
    var label2 = PersonalStatusLabel()
    var label3 = PersonalStatusLabel()
    var label4 = PersonalStatusLabel()
    var label5 = PersonalStatusLabel()
    var label6 = PersonalStatusLabel()
    var label7 = PersonalStatusLabel()
    var label8 = PersonalStatusLabel()
    var label9 = PersonalStatusLabel()
    var label10 = PersonalStatusLabel()
    var label11 = PersonalStatusLabel()
    var label12 = PersonalStatusLabel()
    var label13 = PersonalStatusLabel()
    var label14 = PersonalStatusLabel()
    var label15 = PersonalStatusLabel()
    var label16 = PersonalStatusLabel()
    var label17 = PersonalStatusLabel()
    var label18 = PersonalStatusLabel()
    var label19 = PersonalStatusLabel()
    var label20 = PersonalStatusLabel()
    var label21 = PersonalStatusLabel()
    var label22 = PersonalStatusLabel()
    var label23 = PersonalStatusLabel()
    var label24 = PersonalStatusLabel()
    var label25 = PersonalStatusLabel()
    var label26 = PersonalStatusLabel()
    var label27 = PersonalStatusLabel()
    var label28 = PersonalStatusLabel()
    var label29 = PersonalStatusLabel()
    var label30 = PersonalStatusLabel()
    var label31 = PersonalStatusLabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initUI()
        
        Applicant.sharedInstance.getPersonalStatus({
            self.updateUI()
        })
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.view.frame.size.width = (UIApplication.shared.keyWindow?.frame.size.width)!
        
        //NavigationBar 的文字
        self.navigationController!.navigationBar.tintColor = .white
        
        //titleLabel设置
        let titleLabel = UILabel(text: "个人状态", fontSize: 17)
        titleLabel.backgroundColor = .clear
        titleLabel.textAlignment = .center
        titleLabel.textColor = .white
        self.navigationItem.titleView = titleLabel;
        
        //NavigationBar 的背景，使用了View
//        self.navigationController!.jz_navigationBarBackgroundAlpha = 0;
        let bgView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.navigationController!.navigationBar.frame.size.height+UIApplication.shared.statusBarFrame.size.height))
        
        bgView.backgroundColor = .partyRed
        self.view.addSubview(bgView)
        
        //改变 statusBar 颜色
        UIApplication.shared.setStatusBarStyle(.lightContent, animated: true)
        
        //改变背景颜色
        mainScrollView.backgroundColor = UIColor(colorLiteralRed: 0.95, green: 0.95, blue: 0.95, alpha: 1)
    }
        
    //MARK: 劳资真的要死了，劳资已经疯了
    //TODO: 重构成数组,循环
    //疯狂烧性能 (?)
    func initUI() {

        
        self.view.addSubview(mainScrollView)
        mainScrollView.snp.makeConstraints {
            make in
            make.left.equalTo(view)
            make.right.equalTo(view)
            make.bottom.equalTo(view)
            make.top.equalTo(view)
        }
        
        mainScrollView.contentSize = CGSize(width:(UIApplication.shared.keyWindow?.frame.size.width)!, height: 944)
        print("aa\(mainScrollView.frame.size.width)")
        /*let scrollView1 = UIScrollView(frame: CGRectMake(-287.5, 48, 932, 164))
        mainScrollView.addSubview(scrollView1)
        let scrollView2 = UIScrollView(frame: CGRectMake(-287.5, 572, 932, 164))
        mainScrollView.addSubview(scrollView2)*/
        //print((UIApplication.shared.keyWindow?.frame.size.width)!)
        
        //MARK: 这样做不太好，用了奇怪的数，其实也不是很奇怪啦
        let strangeNumber = (932-(UIApplication.shared.keyWindow?.frame.size.width)!)/2.0
        

        scrollView1 = UIScrollView()
        scrollView1.contentSize = CGSize(width: 932, height: 164)
        
        scrollView1.setContentOffset(CGPoint(x: strangeNumber, y: 0), animated: true)
        scrollView1.delegate = self
        mainScrollView.addSubview(scrollView1)
        scrollView2 = UIScrollView()
        scrollView2.contentSize = CGSize(width: 932, height: 164)
        scrollView2.setContentOffset(CGPoint(x: strangeNumber, y: 0), animated: true)
        scrollView2.delegate = self
        mainScrollView.addSubview(scrollView2)
        
        
        leftArrowView1 = UIImageView(imageName: "ic_arrow_left", desiredSize: CGSize(width: 30, height: 30))!
        leftArrowView1.alpha = 0.4
        mainScrollView.addSubview(leftArrowView1)
        rightArrowView1 = UIImageView(imageName: "ic_arrow_right", desiredSize: CGSize(width: 30, height: 30))!
        rightArrowView1.alpha = 0.4
        mainScrollView.addSubview(rightArrowView1)
        leftArrowView2 = UIImageView(imageName: "ic_arrow_left", desiredSize: CGSize(width: 30, height: 30))!
        leftArrowView2.alpha = 0.4
        mainScrollView.addSubview(leftArrowView2)
        rightArrowView2 = UIImageView(imageName: "ic_arrow_right", desiredSize: CGSize(width: 30, height: 30))!
        rightArrowView2.alpha = 0.4
        mainScrollView.addSubview(rightArrowView2)
    
//        for i in 0..<11 {
//            let label = PersonalStatusLabel(title: titles[], status: 0)
//        }
        
        label1 = PersonalStatusLabel(title: "递交入党申请书", status: 0)
        mainScrollView.addSubview(label1)
        label2 = PersonalStatusLabel(title: "网上党校学习", status: 0)
        scrollView1.addSubview(label2)
        label3 = PersonalStatusLabel(title: "结业考试", status: 0)
        scrollView1.addSubview(label3)
        label4 = PersonalStatusLabel(title: "院级积极分子党校学习", status: 0)
        scrollView1.addSubview(label4)
        label5 = PersonalStatusLabel(title: "递交第一季度思想汇报", status: 0)
        scrollView1.addSubview(label5)
        label6 = PersonalStatusLabel(title: "递交第二季度思想汇报", status: 0)
        scrollView1.addSubview(label6)
        label7 = PersonalStatusLabel(title: "递交第三季度思想汇报", status: 0)
        scrollView1.addSubview(label7)
        label8 = PersonalStatusLabel(title: "递交第四季度思想汇报", status: 0)
        scrollView1.addSubview(label8)
        label9 = PersonalStatusLabel(title: "参加学习人申请小组", status: 0)
        scrollView1.addSubview(label9)
        label10 = PersonalStatusLabel(title: "被确认为积极分子", status: 0)
        scrollView1.addSubview(label10)
        label11 = PersonalStatusLabel(title: "团支部推优", status: 0)
        scrollView1.addSubview(label11)
        
        
        label12 = PersonalStatusLabel(title: "经支委会同意准备成为发展对象", status: 0)
        mainScrollView.addSubview(label12)
        label13 = PersonalStatusLabel(title: "参加集中培训", status: 0)
        mainScrollView.addSubview(label13)
        label14 = PersonalStatusLabel(title: "入党材料准备齐全", status: 0)
        mainScrollView.addSubview(label14)
        label15 = PersonalStatusLabel(title: "支部向上级汇报", status: 0)
        mainScrollView.addSubview(label15)
        label16 = PersonalStatusLabel(title: "党员发展公示", status: 0)
        mainScrollView.addSubview(label16)
        label17 = PersonalStatusLabel(title: "填写入党志愿书", status: 0)
        mainScrollView.addSubview(label17)
        label18 = PersonalStatusLabel(title: "召开发展大会，党支部表决", status: 0)
        mainScrollView.addSubview(label18)
        label19 = PersonalStatusLabel(title: "党委谈话，审批", status: 0)
        mainScrollView.addSubview(label19)
        label20 = PersonalStatusLabel(title: "成为预备党员", status: 0)
        mainScrollView.addSubview(label20)
        label21 = PersonalStatusLabel(title: "完成预备党员党校学习", status: 0)
        scrollView2.addSubview(label21)
        label22 = PersonalStatusLabel(title: "递交第一季度个人小结", status: 0)
        scrollView2.addSubview(label22)
        label23 = PersonalStatusLabel(title: "递交第二季度个人小结", status: 0)
        scrollView2.addSubview(label23)
        label24 = PersonalStatusLabel(title: "递交第三季度个人小结", status: 0)
        scrollView2.addSubview(label24)
        label25 = PersonalStatusLabel(title: "递交第四季度个人小结", status: 0)
        scrollView2.addSubview(label25)
        label26 = PersonalStatusLabel(title: "参加党支部组织活动", status: 0)
        scrollView2.addSubview(label26)
        label27 = PersonalStatusLabel(title: "递交转正申请", status: 0)
        mainScrollView.addSubview(label27)
        label28 = PersonalStatusLabel(title: "党员转正公示", status: 0)
        mainScrollView.addSubview(label28)
        label29 = PersonalStatusLabel(title: "党员转正召开大会，表决通过", status: 0)
        mainScrollView.addSubview(label29)
        label30 = PersonalStatusLabel(title: "党委审批", status: 0)
        mainScrollView.addSubview(label30)
        label31 = PersonalStatusLabel(title: "成为中共正式党员", status: 0)
        mainScrollView.addSubview(label31)
        
        
        leftArrowView1.snp.makeConstraints {
            make in
            make.centerY.equalTo(scrollView1.snp.centerY)
            //make.right.equalTo(mainScrollView)
            make.left.equalTo(view).offset(8)
        }
        
        rightArrowView1.snp.makeConstraints {
            make in
            make.centerY.equalTo(scrollView1.snp.centerY)
            make.right.equalTo(view).offset(-8)
        }
        
        leftArrowView2.snp.makeConstraints {
            make in
            make.centerY.equalTo(scrollView2.snp.centerY)
            //make.right.equalTo(mainScrollView)
            make.left.equalTo(view).offset(8)
        }
        
        rightArrowView2.snp.makeConstraints {
            make in
            make.centerY.equalTo(scrollView2.snp.centerY)
            make.right.equalTo(view).offset(-8)
        }
        
        scrollView1.snp.makeConstraints {
            make in
            make.centerX.equalTo(mainScrollView)
            make.top.equalTo(label1.snp.bottom).offset(8)
            make.width.equalTo(mainScrollView)
            make.height.equalTo(164)
        }
        scrollView2.snp.makeConstraints {
            make in
            make.centerX.equalTo(mainScrollView)
            make.top.equalTo(label20.snp.bottom).offset(8)
            make.width.equalTo(mainScrollView)
            make.height.equalTo(164)
        }
        
        
        label1.snp.makeConstraints {
            make in
            make.centerX.equalTo(mainScrollView)
            make.width.equalTo(300)
            make.height.equalTo(30)
            make.top.equalTo(mainScrollView.snp.top).offset(8)
            
        }
        label2.snp.makeConstraints {
            make in
            make.width.equalTo(300)
            make.height.equalTo(30)
            make.right.equalTo(label5.snp.left).offset(-8)
            make.top.equalTo(scrollView1.snp.top).offset(8)

        }
        label3.snp.makeConstraints {
            make in
            make.width.equalTo(300)
            make.height.equalTo(30)
            make.right.equalTo(label5.snp.left).offset(-8)
            make.top.equalTo(label2.snp.bottom).offset(8)
        }
        label4.snp.makeConstraints {
            make in
            make.width.equalTo(300)
            make.height.equalTo(30)
            make.right.equalTo(label5.snp.left).offset(-8)
            make.top.equalTo(label3.snp.bottom).offset(8)
        }
        label5.snp.makeConstraints {
            make in
            make.width.equalTo(300)
            make.height.equalTo(30)
            make.centerX.equalTo(scrollView1).offset(strangeNumber)
            make.top.equalTo(scrollView1.snp.top).offset(8)
        }
        label6.snp.makeConstraints {
            make in
            make.width.equalTo(300)
            make.height.equalTo(30)
            make.centerX.equalTo(scrollView1).offset(strangeNumber)
            make.top.equalTo(label5.snp.bottom).offset(8)
        }
        label7.snp.makeConstraints {
            make in
            make.width.equalTo(300)
            make.height.equalTo(30)
            make.centerX.equalTo(scrollView1).offset(strangeNumber)
            make.top.equalTo(label6.snp.bottom).offset(8)
        }
        label8.snp.makeConstraints {
            make in
            make.width.equalTo(300)
            make.height.equalTo(30)
            make.centerX.equalTo(scrollView1).offset(strangeNumber)
            make.top.equalTo(label7.snp.bottom).offset(8)
        }
        label9.snp.makeConstraints {
            make in
            make.width.equalTo(300)
            make.height.equalTo(30)
            make.top.equalTo(scrollView1.snp.top).offset(8)
            make.left.equalTo(label5.snp.right).offset(8)
        }
        label10.snp.makeConstraints {
            make in
            make.width.equalTo(146)
            make.height.equalTo(30)
            make.top.equalTo(label9.snp.bottom).offset(8)
            make.left.equalTo(label5.snp.right).offset(8)
        }
        label11.snp.makeConstraints {
            make in
            make.width.equalTo(146)
            make.height.equalTo(30)
            make.top.equalTo(label9.snp.bottom).offset(8)
            make.left.equalTo(label10.snp.right).offset(8)
        }
        label12.snp.makeConstraints {
            make in
            make.centerX.equalTo(mainScrollView)
            make.width.equalTo(300)
            make.height.equalTo(30)
            make.top.equalTo(scrollView1.snp.bottom).offset(8)
        }
        label13.snp.makeConstraints {
            make in
            make.centerX.equalTo(mainScrollView)
            make.width.equalTo(300)
            make.height.equalTo(30)
            make.top.equalTo(label12.snp.bottom).offset(8)
        }
        label14.snp.makeConstraints {
            make in
            make.centerX.equalTo(mainScrollView)
            make.width.equalTo(300)
            make.height.equalTo(30)
            make.top.equalTo(label13.snp.bottom).offset(8)
            
        }
        label15.snp.makeConstraints {
            make in
            make.centerX.equalTo(mainScrollView)
            make.width.equalTo(300)
            make.height.equalTo(30)
            make.top.equalTo(label14.snp.bottom).offset(8)

            
        }
        label16.snp.makeConstraints {
            make in
            make.centerX.equalTo(mainScrollView)
            make.width.equalTo(300)
            make.height.equalTo(30)
            make.top.equalTo(label15.snp.bottom).offset(8)
            

        }
        label17.snp.makeConstraints {
            make in
            make.centerX.equalTo(mainScrollView)
            make.width.equalTo(300)
            make.height.equalTo(30)
            make.top.equalTo(label16.snp.bottom).offset(8)
            

        }
        label18.snp.makeConstraints {
            make in
            make.centerX.equalTo(mainScrollView)
            make.width.equalTo(300)
            make.height.equalTo(30)
            make.top.equalTo(label17.snp.bottom).offset(8)
            

        }
        label19.snp.makeConstraints {
            make in
            make.centerX.equalTo(mainScrollView)
            make.width.equalTo(300)
            make.height.equalTo(30)
            make.top.equalTo(label18.snp.bottom).offset(8)

        }
        label20.snp.makeConstraints {
            make in
            make.centerX.equalTo(mainScrollView)
            make.width.equalTo(300)
            make.height.equalTo(30)
            make.top.equalTo(label19.snp.bottom).offset(8)
            

        }
        label21.snp.makeConstraints {
            make in
            make.width.equalTo(300)
            make.height.equalTo(30)
            make.centerY.equalTo(scrollView2)
            make.right.equalTo(label22.snp.left).offset(-8)
            
        }
        label22.snp.makeConstraints {
            make in
            make.width.equalTo(300)
            make.height.equalTo(30)
            make.centerX.equalTo(scrollView2).offset(strangeNumber)
            make.top.equalTo(scrollView2.snp.top).offset(8)
            
        }
        label23.snp.makeConstraints {
            make in
            make.width.equalTo(300)
            make.height.equalTo(30)
            make.centerX.equalTo(scrollView2).offset(strangeNumber)
            make.top.equalTo(label22.snp.bottom).offset(8)
            
        }
        label24.snp.makeConstraints {
            make in
            make.width.equalTo(300)
            make.height.equalTo(30)
            make.centerX.equalTo(scrollView2).offset(strangeNumber)
            make.top.equalTo(label23.snp.bottom).offset(8)
            
        }
        label25.snp.makeConstraints {
            make in
            make.width.equalTo(300)
            make.height.equalTo(30)
            make.centerX.equalTo(scrollView2).offset(strangeNumber)
            make.top.equalTo(label24.snp.bottom).offset(8)
            
        }
        label26.snp.makeConstraints {
            make in
            make.width.equalTo(300)
            make.height.equalTo(30)
            make.centerY.equalTo(scrollView2)
            make.left.equalTo(label22.snp.right).offset(8)
        }
        label27.snp.makeConstraints {
            make in
            make.centerX.equalTo(mainScrollView)
            make.width.equalTo(300)
            make.height.equalTo(30)
            make.top.equalTo(scrollView2.snp.bottom).offset(8)

        }
        label28.snp.makeConstraints {
            make in
            make.centerX.equalTo(mainScrollView)
            make.width.equalTo(300)
            make.height.equalTo(30)
            make.top.equalTo(label27.snp.bottom).offset(8)

        }
        label29.snp.makeConstraints {
            make in
            make.centerX.equalTo(mainScrollView)
            make.width.equalTo(300)
            make.height.equalTo(30)
            make.top.equalTo(label28.snp.bottom).offset(8)

        }
        label30.snp.makeConstraints {
            make in
            make.centerX.equalTo(mainScrollView)
            make.width.equalTo(300)
            make.height.equalTo(30)
            make.top.equalTo(label29.snp.bottom).offset(8)

        }
        label31.snp.makeConstraints {
            make in
            make.centerX.equalTo(mainScrollView)
            make.width.equalTo(300)
            make.height.equalTo(30)
            make.top.equalTo(label30.snp.bottom).offset(8)

        }
        
    }
    
    func updateUI() {
        //print(Applicant.sharedInstance.personalStatus)
        
        var dict = Applicant.sharedInstance.personalStatus[0]
        label1.status = dict["status"] as? Int
        label1.showStatus()
        dict = Applicant.sharedInstance.personalStatus[1]
        label2.status = dict["status"] as? Int
        label2.showStatus()
        dict = Applicant.sharedInstance.personalStatus[2]
        label3.status = dict["status"] as? Int
        label3.showStatus()
        dict = Applicant.sharedInstance.personalStatus[3]
        label4.status = dict["status"] as? Int
        label4.showStatus()
        dict = Applicant.sharedInstance.personalStatus[4]
        label5.status = dict["status"] as? Int
        label5.showStatus()
        dict = Applicant.sharedInstance.personalStatus[5]
        label6.status = dict["status"] as? Int
        label6.showStatus()
        dict = Applicant.sharedInstance.personalStatus[6]
        label7.status = dict["status"] as? Int
        label7.showStatus()
        dict = Applicant.sharedInstance.personalStatus[7]
        label8.status = dict["status"] as? Int
        label8.showStatus()
        dict = Applicant.sharedInstance.personalStatus[8]
        label9.status = dict["status"] as? Int
        label9.showStatus()
        dict = Applicant.sharedInstance.personalStatus[9]
        label10.status = dict["status"] as? Int
        label10.showStatus()
        dict = Applicant.sharedInstance.personalStatus[10]
        label11.status = dict["status"] as? Int
        label11.showStatus()
        dict = Applicant.sharedInstance.personalStatus[11]
        label12.status = dict["status"] as? Int
        label12.showStatus()
        dict = Applicant.sharedInstance.personalStatus[12]
        label13.status = dict["status"] as? Int
        label13.showStatus()
        dict = Applicant.sharedInstance.personalStatus[13]
        label14.status = dict["status"] as? Int
        label14.showStatus()
        dict = Applicant.sharedInstance.personalStatus[14]
        label15.status = dict["status"] as? Int
        label15.showStatus()
        dict = Applicant.sharedInstance.personalStatus[15]
        label16.status = dict["status"] as? Int
        label16.showStatus()
        dict = Applicant.sharedInstance.personalStatus[16]
        label17.status = dict["status"] as? Int
        label17.showStatus()
        dict = Applicant.sharedInstance.personalStatus[17]
        label18.status = dict["status"] as? Int
        label18.showStatus()
        dict = Applicant.sharedInstance.personalStatus[18]
        label19.status = dict["status"] as? Int
        label19.showStatus()
        dict = Applicant.sharedInstance.personalStatus[19]
        label20.status = dict["status"] as? Int
        label20.showStatus()
        dict = Applicant.sharedInstance.personalStatus[20]
        label21.status = dict["status"] as? Int
        label21.showStatus()
        dict = Applicant.sharedInstance.personalStatus[21]
        label22.status = dict["status"] as? Int
        label22.showStatus()
        dict = Applicant.sharedInstance.personalStatus[22]
        label23.status = dict["status"] as? Int
        label23.showStatus()
        dict = Applicant.sharedInstance.personalStatus[23]
        label24.status = dict["status"] as? Int
        label24.showStatus()
        dict = Applicant.sharedInstance.personalStatus[24]
        label25.status = dict["status"] as? Int
        label25.showStatus()
        dict = Applicant.sharedInstance.personalStatus[25]
        label26.status = dict["status"] as? Int
        label26.showStatus()
        dict = Applicant.sharedInstance.personalStatus[26]
        label27.status = dict["status"] as? Int
        label27.showStatus()
        dict = Applicant.sharedInstance.personalStatus[27]
        label28.status = dict["status"] as? Int
        label28.showStatus()
        dict = Applicant.sharedInstance.personalStatus[28]
        label29.status = dict["status"] as? Int
        label29.showStatus()
        dict = Applicant.sharedInstance.personalStatus[29]
        label30.status = dict["status"] as? Int
        label30.showStatus()
        dict = Applicant.sharedInstance.personalStatus[30]
        label31.status = dict["status"] as? Int
        label31.showStatus()
        
        
        
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard scrollView == scrollView1 || scrollView == scrollView2 else {
            return
        }
        
        if scrollView == scrollView1 {
            UIView.animate(withDuration: 0.3, animations: {
                self.leftArrowView1.alpha = 0
                self.rightArrowView1.alpha = 0
            })
            if scrollView.contentOffset.x <= 0 {
                UIView.animate(withDuration: 0.3, animations: {
                    self.rightArrowView1.alpha = 0.4
                })
            
            }
            if scrollView.contentOffset.x >= 557 {
                UIView.animate(withDuration: 0.3, animations: {
                    self.leftArrowView1.alpha = 0.4
                })
            }
        }
        
        if scrollView == scrollView2 {
            UIView.animate(withDuration: 0.3, animations: {
                self.leftArrowView2.alpha = 0
                self.rightArrowView2.alpha = 0
            })
            if scrollView.contentOffset.x <= 0 {
                UIView.animate(withDuration: 0.3, animations: {
                    self.rightArrowView2.alpha = 0.4
                })
                
            }
            if scrollView.contentOffset.x >= 557 {
                UIView.animate(withDuration: 0.3, animations: {
                    self.leftArrowView2.alpha = 0.4
                })
            }
        }
    }
    
}
