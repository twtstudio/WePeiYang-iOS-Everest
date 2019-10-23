//
//  JobFairViewController.swift
//  WePeiYang
//
//  Created by 王春杉 on 2019/2/13.
//  Copyright © 2019 twtstudio. All rights reserved.
//  ok

import UIKit
import Alamofire
import MJRefresh

// 招聘会
class JobFairViewController: UIViewController {
    var jobFairTableView: UITableView!
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
        
        let RecruitmentUrl = "http://job.api.twtstudio.com/api/recruit/index?type=1&page=1"
        JobFireUrl.url = RecruitmentUrl
        JobFireHelper.getJobFire(success: { jobFireResult in
            RecruitInfo.pageCountOfType0 = (jobFireResult.data?.pageCount)!
            self.recruitmentInfo.page = Int((jobFireResult.data?.page)!)!
            self.recruitmentInfo.type = (jobFireResult.data?.type)!
            self.importantNum = (jobFireResult.data?.important?.count)!
            self.commenNum = (jobFireResult.data?.common?.count)!
            for i in 0..<self.importantNum {
                
                self.recruitmentInfo.imporant.append(Imporant())
                self.recruitmentInfo.imporant[i].id = (jobFireResult.data?.important![i].id)!
                self.recruitmentInfo.imporant[i].date = (jobFireResult.data?.important![i].date)!
                self.recruitmentInfo.imporant[i].title = (jobFireResult.data?.important![i].title)!
                self.recruitmentInfo.imporant[i].click = (jobFireResult.data?.important![i].click)!
                self.recruitmentInfo.imporant[i].place = (jobFireResult.data?.important![i].place)!
                self.recruitmentInfo.imporant[i].heldDate = (jobFireResult.data?.important![i].heldDate)!
                self.recruitmentInfo.imporant[i].heldTime = (jobFireResult.data?.important![i].heldTime)!
            }
            for i in 0..<self.commenNum {
                self.recruitmentInfo.commons.append(Commons())
                self.recruitmentInfo.commons[i].id = (jobFireResult.data?.common![i].id)!
                self.recruitmentInfo.commons[i].date = (jobFireResult.data?.common![i].date)!
                self.recruitmentInfo.commons[i].title = (jobFireResult.data?.common![i].title)!
                self.recruitmentInfo.commons[i].click = (jobFireResult.data?.common![i].click)!
                self.recruitmentInfo.commons[i].place = (jobFireResult.data?.common![i].place)!
                self.recruitmentInfo.commons[i].heldDate = (jobFireResult.data?.common![i].heldDate)!
                self.recruitmentInfo.commons[i].heldTime = (jobFireResult.data?.common![i].heldTime)!
            }
            self.setTableView()
        }) { _ in
            
        }

    }
    func setTableView() {
        jobFairTableView = UITableView(frame: view.bounds, style: .plain)
        jobFairTableView.separatorStyle = .none  // 去掉系统分割线
        view.addSubview(jobFairTableView)
        jobFairTableView.delegate = self
        jobFairTableView.dataSource = self
        // MARK: - 上拉加载相关设置
        footer.setRefreshingTarget(self, refreshingAction: #selector(RecruitmentInfoViewController.footerLoad))
        // 是否自动加载（默认为true，即表格滑到底部就自动加载）
        footer.isAutomaticallyRefresh = false
        self.jobFairTableView.mj_footer = footer
    }
    @objc func footerLoad() {
        print("上拉加载")
        currentPage += 1
        
        let RecruitmentUrl = "http://job.api.twtstudio.com/api/recruit/index?type=1&page=\(currentPage)"
        JobFireUrl.url  = RecruitmentUrl
        JobFireHelper.getJobFire(success: { jobFireResult in
            for i in 0..<10 {
                self.recruitmentInfo.commons.append(Commons())
                self.recruitmentInfo.commons[i+self.commenNum].id = (jobFireResult.data?.common![i].id)!
                self.recruitmentInfo.commons[i+self.commenNum].date = (jobFireResult.data?.common![i].date)!
                self.recruitmentInfo.commons[i+self.commenNum].title = (jobFireResult.data?.common![i].title)!
                self.recruitmentInfo.commons[i+self.commenNum].click = (jobFireResult.data?.common![i].click)!
                self.recruitmentInfo.commons[i+self.commenNum].place = (jobFireResult.data?.common![i].place)!
                self.recruitmentInfo.commons[i+self.commenNum].heldDate = (jobFireResult.data?.common![i].heldDate)!
                self.recruitmentInfo.commons[i+self.commenNum].heldTime = (jobFireResult.data?.common![i].heldTime)!
            }
            self.commenNum += 10
            self.jobFairTableView.reloadData()
            self.jobFairTableView.mj_footer.endRefreshing()
            
        }) { _ in
            
        }
//        Alamofire.request(RecruitmentUrl).responseJSON { response in
//            switch response.result.isSuccess {
//            case true:
//                //把得到的JSON数据转为数组
//                if let value = response.result.value {
//                    let json = JSON(value)
//                    for i in 0..<self.commenNum {
//                        self.recruitmentInfo.commons.append(Commons())
//                        self.recruitmentInfo.commons[i+self.commenNum].id = json["data"]["common"][i]["id"].string ?? ""
//                        self.recruitmentInfo.commons[i+self.commenNum].date = json["data"]["common"][i]["date"].string!
//                        self.recruitmentInfo.commons[i+self.commenNum].title = json["data"]["common"][i]["title"].string!
//                        self.recruitmentInfo.commons[i+self.commenNum].click = json["data"]["common"][i]["click"].string!
//                        self.recruitmentInfo.commons[i+self.commenNum].place = json["data"]["common"][i]["place"].string!
//                        self.recruitmentInfo.commons[i+self.commenNum].heldDate = json["data"]["common"][i]["held_date"].string!
//                        self.recruitmentInfo.commons[i+self.commenNum].heldTime = json["data"]["common"][i]["held_time"].string!
//                    }
//                    self.commenNum += 10
//                    self.jobFairTableView.reloadData()
//                    self.jobFairTableView.mj_footer.endRefreshing()
//                }
//            case false:
//                print(response.result.error)
//            }
//        }
    }
}
extension JobFairViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return importantNum + commenNum
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return JobFairTableViewCell(recruitmentInfo: recruitmentInfo, index: indexPath.row, isSearch: false)
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 210
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row < importantNum {
            didSelectCell.id = recruitmentInfo.imporant[indexPath.row].id
        }else {
            didSelectCell.id = recruitmentInfo.commons[indexPath.row-importantNum].id
        }
        self.navigationController?.pushViewController(JobFireDetaileController(), animated: true)
    }
}
