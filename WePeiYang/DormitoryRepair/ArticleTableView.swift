//
//  ArticleTableView.swift
//  WePeiYang
//
//  Created by 赵家琛 on 2017/9/5.
//  Copyright © 2017年 twtstudio. All rights reserved.
//

import UIKit

class ArticleTableView: UIViewController {
    
    var tableView: UITableView!
    var button: UIButton!
    var articles: [Article] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView = UITableView(frame: view.bounds, style: .grouped)
        tableView.register(ArticleTableViewCell.self, forCellReuseIdentifier: "articleCell")
        tableView.separatorStyle = .none
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 110
        self.view.addSubview(tableView)
        
        self.navigationController?.navigationBar.barTintColor = UIColor(red: 254.0 / 255.0, green: 210.0 / 255.0, blue: 44.0 / 255.0, alpha: 1.0)
        self.title = "宿舍报修"
        self.navigationController?.navigationBar.tintColor = UIColor.black

        
        button = UIButton()
        button.backgroundColor = UIColor(red: 254.0 / 255.0, green: 210.0 / 255.0, blue: 44.0 / 255.0, alpha: 1.0)
        
        self.view.addSubview(button)
        button.snp.makeConstraints { make in
            make.width.equalTo(58)
            make.height.equalTo(58)
            make.top.equalTo(self.view.bounds.height * 8 / 10)
            make.left.equalTo(self.view.bounds.width * 7.5 / 10)
        }
        button.setImage(ImageData.repairToolImage, for: .normal)
        button.imageEdgeInsets = UIEdgeInsetsMake(14, 14, 14, 14)
        //button.layer.cornerRadius = button.frame.size.width / 2
        button.layer.cornerRadius = 58 / 2
        button.layer.masksToBounds = true
        button.addTarget(self, action: #selector(toSubmit), for: .touchUpInside)
        
    }
    
    func toSubmit() {
        let rvc = SubmitViewController()
        let item = UIBarButtonItem(title: "我要报修", style: .plain, target: self, action: nil)
        self.navigationItem.backBarButtonItem = item
        self.navigationController?.pushViewController(rvc, animated: true)
    }
    
    func fetchArticles() {
        
        GetRepairApi.getRepair(success: { (lists) in
            
            self.articles = lists
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
            print(self.articles.count)
        }, failure: { error in
            print("fuck")
        })
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        fetchArticles()
    }
    
}

extension ArticleTableView: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.articles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "articleCell", for: indexPath) as! ArticleTableViewCell
        cell.itemDetailInformationLabel.text = self.articles[indexPath.row].detailRepair
        cell.itemLabel.text = self.articles[indexPath.row].itemsRepair
        
        let time = self.articles[indexPath.row].submitTimeRepair
        let start = time?.index((time?.startIndex)!, offsetBy: 10)
        
        cell.dateLabel.text = self.articles[indexPath.row].submitTimeRepair?.substring(to: start!)
        cell.locationLabel.text = self.articles[indexPath.row].locationRepair
        let sta = self.articles[indexPath.row].situationRepair
        cell.progressLabel.text = sta
        if(sta == "已投诉") {
            cell.progressLabel.textColor = UIColor.red
        } else {
            cell.progressLabel.textColor = UIColor(red: 0.55, green: 0.78, blue: 0.59, alpha: 1.00)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let situation:String = articles[indexPath.row].situationRepair!
        let article = articles[indexPath.row]
        
        let rvcFirst = FirstProgressRateController()
        let rvcSecond =  SecondProgressRateController()
        let rvcThird =  ThirdProgressRateController()//维修1
        let rvcFour =  FourProgressRateController() //维修2
        let rvcFive =  FiveProgressRateController()
        let rvcSixth =  SixthProgressRateController()
        
        if  situation == "已上报" {
            self.navigationController?.pushViewController(rvcFirst, animated: true)
        } else if situation == "已接收" {
            self.navigationController?.pushViewController(rvcSecond, animated: true)
        } else if situation == "已维修" {
            if article.state == 3 {
                //维修1
                self.navigationController?.pushViewController(rvcThird, animated: true)
            } else if article.state == 2 {
                //维修2
                self.navigationController?.pushViewController(rvcFour, animated: true)
            }
        } else if situation == "已投诉" {
            self.navigationController?.pushViewController(rvcFive, animated: true)
        } else {
            self.navigationController?.pushViewController(rvcSixth, animated: true)
        }
        
        
        GetRepairApi.getDormitory(state: situation, id: article.idRepair! , success: { (lists) in
            
            if situation == "已上报" {
                
                rvcFirst.itemLabel.text = article.itemsRepair
                rvcFirst.detailLabel.text = article.detailRepair
                rvcFirst.locationLabel.text = article.locationRepair
                rvcFirst.timeLabel.text = article.submitTimeRepair
                rvcFirst.list = lists
                rvcFirst.tabelView.reloadData()
                
            } else if situation == "已接收" {
                
                rvcSecond.itemLabel.text = article.itemsRepair
                rvcSecond.detailLabel.text = article.detailRepair
                rvcSecond.locationLabel.text = article.locationRepair
                rvcSecond.timeLabel.text = article.submitTimeRepair
                rvcSecond.list = lists
                rvcSecond.tabelView.reloadData()
                rvcSecond.Button.isEnabled = true
                
            } else if situation == "已维修" {
                if article.state == 3 {
                    
                    rvcThird.itemLabel.text = article.itemsRepair
                    rvcThird.detailLabel.text = article.detailRepair
                    rvcThird.locationLabel.text = article.locationRepair
                    rvcThird.timeLabel.text = article.submitTimeRepair
                    rvcThird.list = lists
                    rvcThird.tabelView.reloadData()
                    rvcThird.Button.isEnabled = true
                    
                } else if article.state == 2 {
                    
                    rvcFour.itemLabel.text = article.itemsRepair
                    rvcFour.detailLabel.text = article.detailRepair
                    rvcFour.locationLabel.text = article.locationRepair
                    rvcFour.timeLabel.text = article.submitTimeRepair
                    rvcFour.list = lists
                    rvcFour.tabelView.reloadData()
                    rvcFour.ButtonLeft.isEnabled = true
                    rvcFour.ButtonRight.isEnabled = true
                    
                }
            } else if situation == "已投诉" {
                
                rvcFive.itemLabel.text = article.itemsRepair
                rvcFive.detailLabel.text = article.detailRepair
                rvcFive.locationLabel.text = article.locationRepair
                rvcFive.timeLabel.text = article.submitTimeRepair
                rvcFive.list = lists
                rvcFive.list.remove(at: 4)
                rvcFive.tabelView.reloadData()
                rvcFive.Button.isEnabled = true
                
            } else {
                
                rvcSixth.itemLabel.text = article.itemsRepair
                rvcSixth.detailLabel.text = article.detailRepair
                rvcSixth.locationLabel.text = article.locationRepair
                rvcSixth.timeLabel.text = article.submitTimeRepair
                rvcSixth.list = lists
                rvcSixth.tabelView.reloadData()
                rvcSixth.Button.isEnabled = true
                
            }
            
        }, failure: { error in
            print(error)
        })
        
    }
    
}

