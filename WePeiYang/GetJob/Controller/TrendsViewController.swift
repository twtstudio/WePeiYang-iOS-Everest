//
//  TrendsViewController.swift
//  WePeiYang
//
//  Created by 王春杉 on 2019/2/14.
//  Copyright © 2019 twtstudio. All rights reserved.
//  ok
// 动态
import UIKit
import Alamofire
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
        Page.url = RecruitmentUrl
        TrendHelper.getTrend(success: { announcement in
            RecruitInfo.pageCountOfType0 = (announcement.data?.pageCount)!
            self.recruitmentInfo.page = Int((announcement.data?.currentPage)!)!
            self.recruitmentInfo.type = (announcement.data?.type)!
            self.importantNum = (announcement.data?.important?.count)!
            self.commenNum = (announcement.data?.common?.count)!
            self.rotationNum = (announcement.data?.rotation?.count)!
            for i in 0..<self.importantNum {
                
                self.recruitmentInfo.imporant.append(Imporant())
                self.recruitmentInfo.imporant[i].id = String((announcement.data?.important![i].id)!)
                self.recruitmentInfo.imporant[i].date = (announcement.data?.important![i].date)!
                self.recruitmentInfo.imporant[i].title = (announcement.data?.important![i].title)!
                self.recruitmentInfo.imporant[i].click = (announcement.data?.important![i].click)!
            }
            for i in 0..<self.rotationNum {
                self.recruitmentInfo.rotation.append(Rotation())
                self.recruitmentInfo.rotation[i].id = String((announcement.data?.rotation![i].id)!)
                self.recruitmentInfo.rotation[i].date = (announcement.data?.rotation![i].date)!
                self.recruitmentInfo.rotation[i].title = (announcement.data?.rotation![i].title)!
                self.recruitmentInfo.rotation[i].click = (announcement.data?.rotation![i].click)!
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
        Page.url = RecruitmentUrl
        TrendHelper.getTrend(success: { announcement in
            for i in 0..<10 {
                self.recruitmentInfo.commons.append(Commons())
                self.recruitmentInfo.commons[i+self.commenNum].id = String((announcement.data?.common![i].id)!)
                self.recruitmentInfo.commons[i+self.commenNum].date = (announcement.data?.common![i].date)!
                self.recruitmentInfo.commons[i+self.commenNum].title = (announcement.data?.common![i].title)!
                self.recruitmentInfo.commons[i+self.commenNum].click = (announcement.data?.common![i].click)!
            }
            self.commenNum += 10
            self.trendsTableView.reloadData()
            self.trendsTableView.mj_footer.endRefreshing()
        }) { _ in
            
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
            didSelectCell.id = recruitmentInfo.commons[indexPath.row-importantNum-rotationNum].id
        }
        self.navigationController?.pushViewController(TrendsDetailController(), animated: true)
    }
}
