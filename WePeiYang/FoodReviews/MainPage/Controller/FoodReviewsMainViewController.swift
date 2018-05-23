//
//  FoodReviewsMainViewController.swift
//  WePeiYang
//
//  Created by 赵家琛 on 2018/3/16.
//  Copyright © 2018年 twtstudio. All rights reserved.
//

import UIKit
import SnapKit
import PopupDialog

class FoodReviewsMainViewControloler: UIViewController {
    
    fileprivate let DiningHallNames: [String] = ["梅园食堂（学一）", "兰园食堂（学二）", "棠园食堂（学三）", "竹园食堂（学四）", "桃园食堂（学五）", "菊园餐厅（学六）", "留园食堂", "青园餐厅", ]
    
    var diningHallCollectionView: UICollectionView!
    var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView = UITableView(frame: self.view.bounds, style: .grouped)
        tableView.register(DeliciousFoodReviewsTableViewCell.self, forCellReuseIdentifier: "DeliciousFoodReviewsTableViewCell")
        tableView.register(DiningHallTableViewCell.self, forCellReuseIdentifier: "DiningHallTableViewCell")
        tableView.register(DeliciousFoodBoardTableViewCell.self, forCellReuseIdentifier: "DeliciousFoodBoardTableViewCell")
        tableView.register(DeliciousFoodReviewsAndPicturesTableViewCell.self, forCellReuseIdentifier: "DeliciousFoodReviewsAndPicturesTableViewCell")
        tableView.register(AdvertisementBoardTableViewCell.self, forCellReuseIdentifier: "AdvertisementBoardTableViewCell")
        
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.estimatedRowHeight = 500
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.showsVerticalScrollIndicator = false
        
        
        self.view.addSubview(tableView)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
        self.navigationController?.navigationBar.isTranslucent = false
        //self.navigationController?.navigationBar.setBackgroundImage(UIImage(color: UIColor(red: 254/255, green: 119/255, blue: 11/255, alpha: 1))!, for: .default)
        //self.navigationController!.navigationBar.barTintColor = .red
        self.navigationController!.navigationBar.tintColor = .white
        self.navigationController!.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
        self.navigationItem.title = "菜品点评"
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage.resizedImage(image: UIImage(named: "btn_2search")!, scaledToSize: CGSize(width: 20, height: 20)), style: .plain, target: self, action: #selector(goSearch(sender:)))
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage.resizedImage(image: UIImage(named: "btn_1back")!, scaledToSize: CGSize(width: 20, height: 20)), style: .plain, target: self, action: #selector(goBack(sender:)))

        
        //导航栏渐变色
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [Metadata.Color.foodReviewsLowColor.cgColor, Metadata.Color.foodReviewsHighColor.cgColor]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 1, y: 0)
        
        var HEIGHT:CGFloat = 64.0
        if UIScreen.main.bounds.size.height == 812 {
            HEIGHT = 88.0
        }
        
        gradientLayer.frame = CGRect(x: 0, y: 0, width: self.view.width, height: HEIGHT)
        if let barBackground = self.navigationController?.navigationBar.subviews.first {
            barBackground.layer.addSublayer(gradientLayer)
            barBackground.layer.insertSublayer(gradientLayer, at: 0)
        }
        
        
    }
    
    @objc func goBack(sender: UIButton) {
         self.tabBarController?.navigationController?.popViewController(animated: true)
    
    }
    
    @objc func goSearch(sender: UIButton) {
        let vc = FoodSearchViewController()
        vc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
}

extension FoodReviewsMainViewControloler: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard section == 1 else {
            return nil
        }
        let headerView = UIView()
        
        let imageView = UIImageView(imageName: "好吃点评", desiredSize: CGSize(width: 20, height: 20))
        imageView?.x = 10
        imageView?.y = 8
        imageView?.width = 20
        imageView?.height = 20
        
        let label = UILabel(text: "好吃点评", color: .black)
        label.font = UIFont.flexibleSystemFont(ofSize: 17, weight: UIFont.Weight.semibold)
        label.x = 40
        label.y = 10
        label.width = 100
        label.textAlignment = .left
        label.sizeToFit()
        
        headerView.addSubview(imageView!)
        headerView.addSubview(label)
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        guard section == 1 else {
            return 5
        }
        return 40
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        guard section == 1 else {
            return 0.01
        }
        return 100
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 100))
        footerView.backgroundColor = UIColor.clear
        return footerView
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 1 {
            tableView.deselectRow(at: indexPath, animated: true)
        }
        print("\(indexPath.row)")
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard indexPath.section == 1 else {
            if indexPath.row == 1 {
                return 35
            } else {
                return UITableViewAutomaticDimension
            }
        }
        if indexPath.row == 0 {
            return 150
        } else {
            return 120
        }
    }
    
}

extension FoodReviewsMainViewControloler: UITableViewDataSource {
    
   
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            if indexPath.row == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "DeliciousFoodBoardTableViewCell", for: indexPath) as! DeliciousFoodBoardTableViewCell
                cell.selectionStyle = .none
                return cell
            } else if indexPath.row == 1 {
                let cell = UITableViewCell()
                
                let locationImageView = UIImageView(imageName: "定位", desiredSize: CGSize(width: 20, height: 20))
                locationImageView?.frame = CGRect(x: 10, y: 10, width: 20, height: 20)
                cell.contentView.addSubview(locationImageView!)
                
                let label = UILabel(frame: CGRect(x: 40, y: 10, width: 200, height: 20))
                label.text = "北洋园校区"
                label.font = UIFont.flexibleSystemFont(ofSize: 17, weight: UIFont.Weight.semibold)
                label.textAlignment = .left
                label.sizeToFit()
                cell.contentView.addSubview(label)
                
//                let btn = UIButton(frame: CGRect(x: 200, y: 5, width: 50, height: 20))
//                btn.setTitle("asd", for: .normal)
//                btn.setTitleColor(.red, for: .normal)
//                btn.addTarget(self, action: #selector(gogo(sender:)), for: .touchUpInside)
                
                let btn = UIButton(backgroundImageName: "切换", desiredSize: CGSize(width: 20, height: 20))
                cell.contentView.addSubview(btn!)
                btn?.snp.makeConstraints { make in
                    make.left.equalTo(label.snp.right).offset(10)
                    make.top.equalToSuperview().inset(10)
                    make.height.width.equalTo(20)
                }
                btn?.addTarget(self, action: #selector(gogo(sender:)), for: .touchUpInside)
                
                cell.selectionStyle = .none
                return cell
            } else if indexPath.row == 2 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "DiningHallTableViewCell", for: indexPath) as! DiningHallTableViewCell
                cell.selectionStyle = .none
                
                cell.delegate = self
                
                return cell
            } else  if indexPath.row == 3 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "AdvertisementBoardTableViewCell", for: indexPath) as! AdvertisementBoardTableViewCell
                cell.selectionStyle = .none
                return cell
            } else {
                return UITableViewCell()
            }
            
        case 1:
            //return UITableViewCell()
            //DeliciousFoodReviewsAndPicturesTableViewCell
//            let cell = tableView.dequeueReusableCell(withIdentifier: "DeliciousFoodReviewsTableViewCell", for: indexPath) as! DeliciousFoodReviewsTableViewCell
//            return cell
            if indexPath.row == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "DeliciousFoodReviewsAndPicturesTableViewCell", for: indexPath) as! DeliciousFoodReviewsAndPicturesTableViewCell
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "DeliciousFoodReviewsTableViewCell", for: indexPath) as! DeliciousFoodReviewsTableViewCell
                return cell
            }
        default:
            return UITableViewCell()
        }
    }
    
//    let popup = PopupDialog(title: "绑定状态", message: "要解绑吗？", buttonAlignment: .horizontal, transitionStyle: .zoomIn)
//
//    let cancelButton = CancelButton(title: "不了", action: nil)
//
//    let defaultButton = DestructiveButton(title: "确认", dismissOnTap: true) {
//        self.unbind(indexPathAtRow: indexPath.row)
//    }
//    popup.addButtons([cancelButton, defaultButton])
//    self.present(popup, animated: true, completion: nil)
    
    @objc func gogo(sender: UIButton) {
        
        let popup = PopupDialog(title: "是否切换至：卫津路校区", message: "当前位置：北洋园校区", buttonAlignment: .horizontal, transitionStyle: .zoomIn)
        let cancelButton = CancelButton(title: "不了", action: nil)
        let defaultButton = DefaultButton(title: "切换") {
            self.tableView.reloadData()
            print("heiheihei")
        }
        popup.addButtons([cancelButton, defaultButton])
        self.present(popup, animated: true, completion: nil)
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 4
        case 1:
            return 3
        default:
            return 3
        }
    }
    
}

extension FoodReviewsMainViewControloler: TransmitValueProtocol {
    func chooseDiningHall(location: Int) {
        //self.navigationController?.pushViewController(UIViewController(), animated: true)
        let vc = TwoFloorsDiningHallViewController()
        vc.hidesBottomBarWhenPushed = true
        vc.title = DiningHallNames[location]
        self.navigationController?.pushViewController(vc, animated: true)
    }
}



