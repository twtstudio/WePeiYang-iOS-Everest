//
//  RecruitmentInfoViewController.swift
//  WePeiYang
//
//  Created by 王春杉 on 2019/2/13.
//  Copyright © 2019 twtstudio. All rights reserved.
//  ok

import UIKit
import Alamofire
import MJRefresh

class RecruitmentInfoViewController: UIViewController {
    
    var recruitmentTableView: UITableView!
    var recruitmentInfo = RecruitInfo()
    let footer = MJRefreshAutoNormalFooter()
    var importantNum: Int = 0
    var commenNum: Int = 10
    var currentPage: Int = 1
    
    override func loadView() {
        super.loadView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 使用Alamofire 加载 DetailMusic
        let RecruitmentUrl = "http://job.api.twtstudio.com/api/recruit/index?type=0&page=1"
        JobFireUrl.url = RecruitmentUrl
        Page.url = RecruitmentUrl
        JobFireHelper.getJobFire(success: { announcement in
            self.importantNum = (announcement.data?.important?.count)!
            self.commenNum = (announcement.data?.common?.count)!
            RecruitInfo.pageCountOfType0 = (announcement.data?.pageCount)!
            self.recruitmentInfo.page = Int(announcement.data!.page!)!
            self.recruitmentInfo.type = (announcement.data?.type)!
            for i in 0..<self.importantNum {
                
                self.recruitmentInfo.imporant.append(Imporant())
                self.recruitmentInfo.imporant[i].id = String((announcement.data?.important![i].id)!)
                self.recruitmentInfo.imporant[i].date = (announcement.data?.important![i].date)!
                self.recruitmentInfo.imporant[i].title = (announcement.data?.important![i].title)!
                self.recruitmentInfo.imporant[i].click = (announcement.data?.important![i].click)!
            }
            for i in 0..<self.commenNum {
                self.recruitmentInfo.commons.append(Commons())
                self.recruitmentInfo.commons[i].id = String((announcement.data?.common![i].id)!)
                self.recruitmentInfo.commons[i].date = (announcement.data?.common![i].date)!
                self.recruitmentInfo.commons[i].title = (announcement.data?.common![i].title)!
                self.recruitmentInfo.commons[i].click = (announcement.data?.common![i].click)!
            }
            self.setTableView()
        }) { _ in
            
        }
        

        
        
    }
    func setTableView() {
        recruitmentTableView = UITableView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height), style: .plain)
        recruitmentTableView.separatorStyle = .none  // 去掉系统分割线
        view.addSubview(recruitmentTableView)
        recruitmentTableView.delegate = self
        recruitmentTableView.dataSource = self
        
        // MARK: - 上拉加载相关设置
        footer.setRefreshingTarget(self, refreshingAction: #selector(RecruitmentInfoViewController.footerLoad))
        // 是否自动加载（默认为true，即表格滑到底部就自动加载）
        footer.isAutomaticallyRefresh = false
        self.recruitmentTableView.mj_footer = footer
    }
    
    @objc func footerLoad() {
        print("上拉加载")
        currentPage += 1
        
        let RecruitmentUrl = "http://job.api.twtstudio.com/api/recruit/index?type=0&page=\(currentPage)"
        JobFireUrl.url = RecruitmentUrl
        JobFireHelper.getJobFire(success: { announcement in
            for i in 0..<10 {
                self.recruitmentInfo.commons.append(Commons())
                self.recruitmentInfo.commons[i+self.commenNum].id = String((announcement.data?.common![i].id)!)
                self.recruitmentInfo.commons[i+self.commenNum].date = (announcement.data?.common![i].date)!
                self.recruitmentInfo.commons[i+self.commenNum].title = (announcement.data?.common![i].title)!
                self.recruitmentInfo.commons[i+self.commenNum].click = (announcement.data?.common![i].click)!
            }
            self.commenNum += 10
            self.recruitmentTableView.reloadData()
            self.recruitmentTableView.mj_footer.endRefreshing()
        }) { _ in
            
        }

    }
}
extension RecruitmentInfoViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return importantNum + commenNum
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return RecruitmentInfoTableViewCell(recruitmentInfo: recruitmentInfo, index: indexPath.row, isSearch: false)
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 130
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row < importantNum {
            didSelectCell.id = recruitmentInfo.imporant[indexPath.row].id
        }else {
            didSelectCell.id = recruitmentInfo.commons[indexPath.row-importantNum].id
        }
        self.navigationController?.pushViewController(RecruitmentInfoDetailController(), animated: true)
    }
}
