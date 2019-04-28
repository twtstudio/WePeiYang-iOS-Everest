//
//  AnnouncementViewController.swift
//  WePeiYang
//
//  Created by 王春杉 on 2019/2/14.
//  Copyright © 2019 twtstudio. All rights reserved.
//  ok

// 公告
import UIKit
import Alamofire
import MJRefresh

class AnnouncementViewController: UIViewController {
    var announcementTableView: UITableView!
    var recruitmentInfo = RecruitInfo()
    let footer = MJRefreshAutoNormalFooter()
    var importantNum: Int = 5
    var commenNum: Int = 10
    var currentPage: Int = 1
    var announcement: Announcement!
    
    override func loadView() {
        super.loadView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let RecruitmentUrl = "http://job.api.twtstudio.com/api/notice/index?type=0&page=1"
        Page.url = RecruitmentUrl
        
        AnnouncementHelper.getAnnouncement(success: { announcement in
            self.announcement = announcement
            RecruitInfo.pageCountOfType0 = (announcement.data?.pageCount!)!
            self.recruitmentInfo.page = Int(announcement.data!.currentPage!)!
            self.recruitmentInfo.type = (announcement.data?.type!)!
            self.importantNum = (announcement.data?.important?.count)!
            self.commenNum = (announcement.data?.common?.count)!
            for i in 0..<self.importantNum {
                
                self.recruitmentInfo.imporant.append(Imporant())
                self.recruitmentInfo.imporant[i].id = String(announcement.data!.important![i].id!)//"\(String(describing: announcement.data!.important![i].id))"
                self.recruitmentInfo.imporant[i].date = (announcement.data?.important![i].date)!
                self.recruitmentInfo.imporant[i].title = (announcement.data?.important![i].title)!
                self.recruitmentInfo.imporant[i].click = (announcement.data?.important![i].click)!
            }
            for i in 0..<self.commenNum {
                self.recruitmentInfo.commons.append(Commons())
                self.recruitmentInfo.commons[i].id = String(announcement.data!.common![i].id!)
                self.recruitmentInfo.commons[i].date = (announcement.data?.common![i].date)!
                self.recruitmentInfo.commons[i].title = (announcement.data?.common![i].title)!
                self.recruitmentInfo.commons[i].click = (announcement.data?.common![i].click)!
            }
            self.setTableView()

        }) { _ in
            
        }
        

        
    }
    func setTableView() {
        announcementTableView = UITableView(frame: view.bounds, style: .plain)
        announcementTableView.separatorStyle = .none  // 去掉系统分割线
        view.addSubview(announcementTableView)
        announcementTableView.delegate = self
        announcementTableView.dataSource = self
        // MARK: - 上拉加载相关设置
        footer.setRefreshingTarget(self, refreshingAction: #selector(RecruitmentInfoViewController.footerLoad))
        // 是否自动加载（默认为true，即表格滑到底部就自动加载）
        footer.isAutomaticallyRefresh = false
        self.announcementTableView.mj_footer = footer
    }
    @objc func footerLoad() {
        print("上拉加载")
        currentPage += 1
        Page.currentPage += 1
        let RecruitmentUrl = "http://job.api.twtstudio.com/api/notice/index?type=0&page=\(currentPage)"
        Page.url = RecruitmentUrl
        AnnouncementHelper.getAnnouncement(success: { announcement in
            self.announcement = announcement
            for i in 0..<10 {
                self.recruitmentInfo.commons.append(Commons())
                self.recruitmentInfo.commons[i+self.commenNum].id = String(announcement.data!.common![i].id!)
                self.recruitmentInfo.commons[i+self.commenNum].date = (announcement.data?.common![i].date!)!
                self.recruitmentInfo.commons[i+self.commenNum].title = (announcement.data?.common![i].title!)!
                self.recruitmentInfo.commons[i+self.commenNum].click = (announcement.data?.common![i].click)!
            }
            self.commenNum += 10
            self.announcementTableView.reloadData()
            self.announcementTableView.mj_footer.endRefreshing()
        }) { _ in
            
        }

    }
}
extension AnnouncementViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return commenNum + importantNum
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return AnnouncementTableViewCell(recruitmentInfo: recruitmentInfo, index: indexPath.row)
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
        self.navigationController?.pushViewController(AnnouncementDetailController(), animated: true)
    }
}
