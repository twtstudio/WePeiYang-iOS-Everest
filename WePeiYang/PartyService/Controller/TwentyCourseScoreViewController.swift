//
//  TwentyCourseScoreViewController.swift
//  WePeiYang
//
//  Created by JinHongxu on 16/8/14.
//  Copyright © 2016年 Qin Yubo. All rights reserved.
//

import UIKit

class TwentyCourseScoreViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet var tableView: UITableView!
    var scoreList = [[String: Any]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        Applicant.sharedInstance.get20score({
            self.scoreList = Applicant.sharedInstance.scoreOf20Course
            self.tableView.reloadData()
        })
        
    }
    
    //iOS 8 fucking bug
    init(){
        super.init(nibName: "TwentyCourseScoreViewController", bundle: nil)
        //print("haha")
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //print(Applicant.sharedInstance.scoreOf20Course.count)
        return scoreList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let dict = scoreList[indexPath.row]
        let cell = ScoreTableViewCell(title: dict["course_name"] as! String, score: dict["score"] as! String, completeTime: dict["complete_time"] as! String)
        
        cell.selectionStyle = .none
        //cell?.textLabel?.text = Applicant.sharedInstance.scoreOf20Course[indexPath.row].objectForKey("course_name")
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard section == 0 else {
            return nil
        }
        
        let view = UIView(frame: CGRect(x: 0, y: 0, width: (UIApplication.shared.keyWindow?.frame.size.width)!, height: 40))
        
        let titleLabel = UILabel(text: "课程名称")
        let scoreLabel = UILabel(text: "成绩")
        let timeLabel = UILabel(text: "完成时间")
        
        titleLabel.font = UIFont.boldSystemFont(ofSize: 13.0)
        scoreLabel.font = UIFont.boldSystemFont(ofSize: 13.0)
        timeLabel.font = UIFont.boldSystemFont(ofSize: 13.0)
        
        view.addSubview(titleLabel)
        view.addSubview(scoreLabel)
        view.addSubview(timeLabel)
        
        timeLabel.snp.makeConstraints {
            make in
            make.right.equalTo(view).offset(-8)
            make.centerY.equalTo(view)
        }
        
        scoreLabel.snp.makeConstraints {
            make in
            make.right.equalTo(timeLabel.snp.left).offset(-56)
            make.centerY.equalTo(view)
        }
        
        titleLabel.snp.makeConstraints {
            make in
            make.left.equalTo(view).offset(8)
            make.centerY.equalTo(view)
            
        }
        
        return view
        
    }
}
