//
//  TrendsViewController.swift
//  WePeiYang
//
//  Created by 王春杉 on 2019/2/14.
//  Copyright © 2019 twtstudio. All rights reserved.
//
// 动态
import UIKit
import Alamofire
import SwiftyJSON
import MJRefresh

class TrendsViewController: UIViewController {
    var trendsTableView: UITableView!
    var recruitmentInfo = RecruitInfo()
    let footer = MJRefreshAutoNormalFooter()
    var importantNum: Int = 5
    var rotationNum: Int = 3
    var commenNum: Int = 10
    var currentPage: Int = 1

    override func loadView() {
        super.loadView()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        let RecruitmentUrl = "http://job.api.twtstudio.com/api/notice/index?type=1&page=1"
        Alamofire.request(RecruitmentUrl).responseJSON { response in
            switch response.result.isSuccess {
            case true:
                //把得到的JSON数据转为数组
                if let value = response.result.value {
                    let json = JSON(value)
                    RecruitInfo.pageCountOfType0 = json["data"]["page_count"].int!
                    self.recruitmentInfo.page = Int(json["data"]["current_page"].string!)!
                    self.recruitmentInfo.type = json["data"]["type"].string!
                    self.importantNum = json["data"]["important"].count
                    self.commenNum = json["data"]["common"].count
                    self.rotationNum = json["data"]["rotation"].count
                    for i in 0..<self.importantNum {

                        self.recruitmentInfo.imporant.append(Imporant())
                        self.recruitmentInfo.imporant[i].id = String(json["data"]["important"][i]["id"].int!)
                        self.recruitmentInfo.imporant[i].date = json["data"]["important"][i]["date"].string!
                        self.recruitmentInfo.imporant[i].title = json["data"]["important"][i]["title"].string!
                        self.recruitmentInfo.imporant[i].click = json["data"]["important"][i]["click"].string!
                    }
                    for i in 0..<self.rotationNum {
                        self.recruitmentInfo.rotation.append(Rotation())
                        self.recruitmentInfo.rotation[i].id = String(json["data"]["rotation"][i]["id"].int!)
                        self.recruitmentInfo.rotation[i].date = json["data"]["rotation"][i]["date"].string!
                        self.recruitmentInfo.rotation[i].title = json["data"]["rotation"][i]["title"].string!
                        self.recruitmentInfo.rotation[i].click = json["data"]["rotation"][i]["click"].string!
                    }
                    for i in 0..<self.commenNum {
                        self.recruitmentInfo.common.append(Common())
                        self.recruitmentInfo.common[i].id = String(json["data"]["common"][i]["id"].int!)
                        self.recruitmentInfo.common[i].date = json["data"]["common"][i]["date"].string!
                        self.recruitmentInfo.common[i].title = json["data"]["common"][i]["title"].string!
                        self.recruitmentInfo.common[i].click = json["data"]["common"][i]["click"].string!
                    }
                    self.setTableView()
                }
            case false:
                print(response.result.error)
            }
        }

    }
    func setTableView() {
        trendsTableView = UITableView(frame: view.bounds, style: .plain)
        trendsTableView.separatorStyle = .none  // 去掉系统分割线
        view.addSubview(trendsTableView)
        trendsTableView.delegate = self
        trendsTableView.dataSource = self
        // MARK: - 上拉加载相关设置
        footer.setRefreshingTarget(self, refreshingAction: #selector(RecruitmentInfoViewController.footerLoad))
        // 是否自动加载（默认为true，即表格滑到底部就自动加载）
        footer.isAutomaticallyRefresh = false
        self.trendsTableView.mj_footer = footer
    }
    @objc func footerLoad() {
        print("上拉加载")
        currentPage += 1

        let RecruitmentUrl = "http://job.api.twtstudio.com/api/notice/index?type=1&page=\(currentPage)"
        Alamofire.request(RecruitmentUrl).responseJSON { response in
            switch response.result.isSuccess {
            case true:
                // 把得到的JSON数据转为数组
                if let value = response.result.value {
                    let json = JSON(value)
                    for i in 0..<10 {
                        self.recruitmentInfo.common.append(Common())
                        self.recruitmentInfo.common[i+self.commenNum].id = String(json["data"]["common"][i]["id"].int!)
                        self.recruitmentInfo.common[i+self.commenNum].date = json["data"]["common"][i]["date"].string!
                        self.recruitmentInfo.common[i+self.commenNum].title = json["data"]["common"][i]["title"].string!
                        self.recruitmentInfo.common[i+self.commenNum].click = json["data"]["common"][i]["click"].string!
                    }
                    self.commenNum += 10
                    self.trendsTableView.reloadData()
                    self.trendsTableView.mj_footer.endRefreshing()
                }
            case false:
                print(response.result.error)
            }
        }
    }
}
extension TrendsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return importantNum + rotationNum + commenNum
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return TrendsTableViewCell(recruitmentInfo: recruitmentInfo, index: indexPath.row)
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 130
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row < importantNum {
            didSelectCell.id = recruitmentInfo.imporant[indexPath.row].id
        }else if indexPath.row >= importantNum && indexPath.row < importantNum + rotationNum {
            didSelectCell.id = recruitmentInfo.rotation[indexPath.row-importantNum].id
        } else {
            didSelectCell.id = recruitmentInfo.common[indexPath.row-importantNum-rotationNum].id
        }
        self.navigationController?.pushViewController(TrendsDetailController(), animated: true)
    }
}
