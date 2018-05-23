//
//  DiningHallMainViewController.swift
//  WePeiYang
//
//  Created by 赵家琛 on 2018/5/3.
//  Copyright © 2018年 twtstudio. All rights reserved.
//

import UIKit
import SnapKit

class OneFloorDiningHallViewController: UIViewController {
    
    fileprivate var mainTableView: UITableView!
    fileprivate var VC: DiningHallChildViewController!
    var isOffsetMax: Bool!
    var mainTableViewOldOffset: CGFloat!
    var offsetType: OffsetType = .OffsetTypeMin
    
    let headerView: UIView = {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: 200))
        view.backgroundColor = .yellow
        return view
    }()
    
    let diningHallImageView: UIImageView = {
        let imgView = UIImageView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: 150))
        imgView.backgroundColor = .green
        return imgView
    }()
    
    let diningHallScoreView: UIView = {
        let scoreView = UIView()
        scoreView.backgroundColor = .red
        return scoreView
    }()
    
    let diningHallView: UIView = {
        let view = UIView(frame: CGRect(x: 20, y: 100, width: UIScreen.main.bounds.size.width-40, height: 70))
        view.backgroundColor = .white
        view.layer.shadowColor = UIColor.gray.cgColor
        view.layer.shadowRadius = 5
        view.layer.shadowOpacity = 0.4
        view.layer.shadowOffset = CGSize(width: 0, height: 5)
        return view
    }()
    
    let telephoneLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: UIFont.Weight.light)
        label.text = "联系电话： 21421423423"
        return label
    }()
    
    let openingHoursLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: UIFont.Weight.light)
        label.text = "营业时间： 6:00-20:00"
        return label
    }()
    
    func setupUI() {
        
        headerView.addSubview(diningHallImageView)
        headerView.addSubview(diningHallView)
        diningHallView.addSubview(telephoneLabel)
        diningHallView.addSubview(openingHoursLabel)
        diningHallView.addSubview(diningHallScoreView)
        telephoneLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(20)
            make.top.equalToSuperview().inset(15)
            make.bottom.equalToSuperview().inset(35)
            make.width.equalTo(180)
        }
        openingHoursLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(20)
            make.top.equalToSuperview().inset(35)
            make.bottom.equalToSuperview().inset(15)
            make.width.equalTo(180)
        }
        diningHallScoreView.snp.makeConstraints { make in
            make.right.equalToSuperview().inset(10)
            make.top.equalToSuperview().inset(15)
            make.bottom.equalToSuperview().inset(35)
            make.width.equalTo(100)
        }

    }
    
   
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        self.view.backgroundColor = .clear
        
        isOffsetMax = false
        VC = DiningHallChildViewController()
        self.addChildViewController(VC)
        mainTableView = UITableView(frame: CGRect(x: 0, y: 0, width: self.view.bounds.size.width, height: self.view.bounds.size.height), style: .plain)
        //mainTableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 100, right: 0)
        mainTableView.backgroundColor = .clear
        mainTableView.showsVerticalScrollIndicator = false
        mainTableView.delegate = self
        mainTableView.dataSource = self
        
//        mainTableView.tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.bounds.size.width, height: 150))
//        mainTableView.tableHeaderView?.backgroundColor = .yellow
        
        self.view.backgroundColor = .white
        self.view.addSubview(mainTableView)
        mainTableView.snp.makeConstraints { make in
            make.top.left.right.bottom.equalToSuperview()
        }
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
        self.navigationController?.navigationBar.isTranslucent = false
        //self.navigationController?.navigationBar.setBackgroundImage(UIImage(color: UIColor(red: 254/255, green: 119/255, blue: 11/255, alpha: 1))!, for: .default)
        //self.navigationController!.navigationBar.barTintColor = .red
        self.navigationController!.navigationBar.tintColor = .white
        self.navigationController!.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage.resizedImage(image: UIImage(named: "btn_2search")!, scaledToSize: CGSize(width: 20, height: 20)), style: .plain, target: self, action: #selector(goSearch(sender:)))
        
    }
    
    @objc func goSearch(sender: UIButton) {
        let vc = FoodSearchViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}

extension OneFloorDiningHallViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        //return VC.view.bounds.size.height
        return 667-64-40
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        guard section == 1 else {
            return 190
        }
        return 40
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard section == 0 else {
            let view = UIView(frame: CGRect(x: 10, y: 0, width: self.view.bounds.size.width-20, height: 40))
            view.backgroundColor = .purple
            
            return view
        }
//        var headerView: UIView!
//        var diningHallImageView: UIImageView!
//        var diningHallLabel: UILabel!
//        var diningHallScore: UIView!
//        var telephoneLabel: UILabel!
//        var openingHoursLabel: UILabel!
        
//        headerView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 200))
//        headerView.backgroundColor = .gray
//
//        diningHallImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 150))
//        diningHallImageView.backgroundColor = .green
//        headerView.addSubview(diningHallImageView)
//
//        diningHallLabel = UILabel(frame: CGRect(x: 20, y: 100, width: self.view.frame.size.width-40, height: 80))
//        diningHallLabel.backgroundColor = .white
//        headerView.addSubview(diningHallLabel)
//
//        //telephoneLabel = UILabel(frame: CGRect(x: 40, y: <#T##CGFloat#>, width: <#T##CGFloat#>, height: <#T##CGFloat#>))
//        telephoneLabel = UILabel()
//        telephoneLabel.font = UIFont.systemFont(ofSize: 14, weight: UIFont.Weight.light)
//        telephoneLabel.text = "联系电话： 21421423423"
//        openingHoursLabel = UILabel()
//        openingHoursLabel.font = UIFont.systemFont(ofSize: 14, weight: UIFont.Weight.light)
//        openingHoursLabel.text = "营业时间： 6:00-20:00"
//        diningHallLabel.addSubview(telephoneLabel)
//        diningHallLabel.addSubview(openingHoursLabel)
//
//        telephoneLabel.snp.makeConstraints { make in
//            make.left.equalToSuperview().inset(20)
//            make.top.equalToSuperview().inset(15)
//            make.bottom.equalToSuperview().inset(45)
//            make.width.equalTo(180)
//        }
//        openingHoursLabel.snp.makeConstraints { make in
//            make.left.equalToSuperview().inset(20)
//            make.top.equalToSuperview().inset(45)
//            make.bottom.equalToSuperview().inset(15)
//            make.width.equalTo(180)
//        }
//
//
        return headerView
    }
    
    
}

extension OneFloorDiningHallViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard section == 1 else {
            return 0
        }
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let cell = UITableViewCell()
        cell.contentView.addSubview(VC.view)
        
        cell.backgroundColor = .white
        cell.selectionStyle = .none
        VC.view.frame = cell.bounds
        return cell
        
    }
    
}

extension OneFloorDiningHallViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        guard scrollView == mainTableView else {
            return
        }
        
        if scrollView.contentOffset.y >= scrollView.contentSize.height-scrollView.bounds.size.height {
            //self.isOffsetMax = true
            scrollView.contentOffset = CGPoint(x: scrollView.contentOffset.x, y: scrollView.contentSize.height-scrollView.bounds.size.height)
            mainTableViewOldOffset = scrollView.contentSize.height-scrollView.bounds.size.height
            self.offsetType = .OffsetTypeMax
        } else if scrollView.contentOffset.y <= 0 {
            //self.isOffsetMax = false
            self.offsetType = .OffsetTypeMin
        } else {
            //self.isOffsetMax = false
            self.offsetType = .OffsetTypeCenter
        }
        
        if self.VC.offsetType != .OffsetTypeMin && self.VC.isScrollDown {
            scrollView.contentOffset = CGPoint(x: scrollView.contentOffset.x, y: mainTableViewOldOffset)
        }
        
        mainTableViewOldOffset = scrollView.contentOffset.y
        
    }
    
}


