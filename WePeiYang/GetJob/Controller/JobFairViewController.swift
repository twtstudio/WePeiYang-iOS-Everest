//
//  JobFairViewController.swift
//  WePeiYang
//
//  Created by 王春杉 on 2019/2/13.
//  Copyright © 2019 twtstudio. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
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
        Alamofire.request(RecruitmentUrl).responseJSON { response in
            switch response.result.isSuccess {
            case true:
                //把得到的JSON数据转为数组
                if let value = response.result.value {
                    let json = JSON(value)
                    RecruitInfo.pageCountOfType0 = json["data"]["page_count"].int!
                    self.recruitmentInfo.page = Int(json["data"]["page"].string!)!
                    self.recruitmentInfo.type = json["data"]["type"].string!
                    self.importantNum = json["data"]["important"].count
                    self.commenNum = json["data"]["common"].count
                    for i in 0..<self.importantNum {
                        
                        self.recruitmentInfo.imporant.append(Imporant())
                        self.recruitmentInfo.imporant[i].id = json["data"]["important"][i]["id"].string!
                        self.recruitmentInfo.imporant[i].date = json["data"]["important"][i]["date"].string!
                        self.recruitmentInfo.imporant[i].title = json["data"]["important"][i]["title"].string!
                        self.recruitmentInfo.imporant[i].click = json["data"]["important"][i]["click"].string!
                        self.recruitmentInfo.imporant[i].place = json["data"]["important"][i]["place"].string!
                        self.recruitmentInfo.imporant[i].heldDate = json["data"]["important"][i]["held_date"].string!
                        self.recruitmentInfo.imporant[i].heldTime = json["data"]["important"][i]["held_time"].string!
                    }
                    for i in 0..<self.commenNum {
                        self.recruitmentInfo.common.append(Common())
                        self.recruitmentInfo.common[i].id = json["data"]["common"][i]["id"].string!
                        self.recruitmentInfo.common[i].date = json["data"]["common"][i]["date"].string!
                        self.recruitmentInfo.common[i].title = json["data"]["common"][i]["title"].string!
                        self.recruitmentInfo.common[i].click = json["data"]["common"][i]["click"].string!
                        self.recruitmentInfo.common[i].place = json["data"]["common"][i]["place"].string!
                        self.recruitmentInfo.common[i].heldDate = json["data"]["common"][i]["held_date"].string!
                        self.recruitmentInfo.common[i].heldTime = json["data"]["common"][i]["held_time"].string!
                    }
                    self.setTableView()
                }
            case false:
                print(response.result.error)
            }
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
        Alamofire.request(RecruitmentUrl).responseJSON { response in
            switch response.result.isSuccess {
            case true:
                //把得到的JSON数据转为数组
                if let value = response.result.value {
                    let json = JSON(value)
                    for i in 0..<self.commenNum {
                        self.recruitmentInfo.common.append(Common())
                        self.recruitmentInfo.common[i+self.commenNum].id = json["data"]["common"][i]["id"].string ?? ""
                        self.recruitmentInfo.common[i+self.commenNum].date = json["data"]["common"][i]["date"].string!
                        self.recruitmentInfo.common[i+self.commenNum].title = json["data"]["common"][i]["title"].string!
                        self.recruitmentInfo.common[i+self.commenNum].click = json["data"]["common"][i]["click"].string!
                        self.recruitmentInfo.common[i+self.commenNum].place = json["data"]["common"][i]["place"].string!
                        self.recruitmentInfo.common[i+self.commenNum].heldDate = json["data"]["common"][i]["held_date"].string!
                        self.recruitmentInfo.common[i+self.commenNum].heldTime = json["data"]["common"][i]["held_time"].string!
                    }
                    self.commenNum += 10
                    self.jobFairTableView.reloadData()
                    self.jobFairTableView.mj_footer.endRefreshing()
                }
            case false:
                print(response.result.error)
            }
        }
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
            didSelectCell.id = recruitmentInfo.common[indexPath.row-importantNum].id
        }
        self.navigationController?.pushViewController(JobFireDetaileController(), animated: true)
    }
}
