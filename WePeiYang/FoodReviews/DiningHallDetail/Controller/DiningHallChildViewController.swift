//
//  DiningHallChildViewController.swift
//  WePeiYang
//
//  Created by 赵家琛 on 2018/5/5.
//  Copyright © 2018年 twtstudio. All rights reserved.
//

import UIKit
import SnapKit

enum OffsetType {
    case OffsetTypeMin
    case OffsetTypeCenter
    case OffsetTypeMax
}

class DiningHallChildViewController: UIViewController {
    
    fileprivate let FoodCatalogueIdentifier = "FoodCatalogueIdentifier"
    fileprivate let FoodDetailIdentifier = "FoodDetailIdentifier"
    var isScrollDown: Bool = true
    var lastOffsetY: CGFloat = 0
    var isOffsetMin: Bool = true
    var offsetType: OffsetType = .OffsetTypeMin
    var didSelectLeft: Bool = false
    
    var foodCatalogueTableView: UITableView!
    var foodDetailTableView: StrikeTableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        
    }
    
    func setupUI() {
        
        foodCatalogueTableView = UITableView(frame: CGRect(x: 0, y: 0, width: 80, height: UIScreen.main.bounds.size.height), style: .plain)
        foodCatalogueTableView.rowHeight = 55
        foodCatalogueTableView.showsVerticalScrollIndicator = false
        foodCatalogueTableView.separatorColor = .clear
        foodCatalogueTableView.delegate = self
        foodCatalogueTableView.dataSource = self
        foodCatalogueTableView.register(FoodCatalogueTableViewCell.self, forCellReuseIdentifier: FoodCatalogueIdentifier)
        //foodCatalogueTableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 100, right: 0)
        
        foodDetailTableView = StrikeTableView(frame: CGRect(x: 80, y: 0, width: UIScreen.main.bounds.size.width-80, height: UIScreen.main.bounds.size.height), style: .plain)
        foodDetailTableView.rowHeight = 80
        foodDetailTableView.showsVerticalScrollIndicator = false
        foodDetailTableView.delegate = self
        foodDetailTableView.dataSource = self
        foodDetailTableView.register(FoodDetailTableViewCell.self, forCellReuseIdentifier: FoodDetailIdentifier)
        //foodDetailTableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 100, right: 0)
        
        self.view.addSubview(foodCatalogueTableView)
        self.view.addSubview(foodDetailTableView)
        
        foodCatalogueTableView.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.top.bottom.equalToSuperview()
            make.width.equalTo(90)
        }
        
        foodDetailTableView.snp.makeConstraints { make in
            make.right.equalToSuperview()
            make.top.bottom.equalToSuperview()
            make.left.equalToSuperview().inset(90)
        }
        
        self.view.backgroundColor = .clear
        
    }
    
    
    
}

extension DiningHallChildViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if tableView == foodCatalogueTableView {
            return 1
        } else {
            return 16
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == foodCatalogueTableView {
            return 16
        } else {
            return 10
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == foodCatalogueTableView {
            let cell = tableView.dequeueReusableCell(withIdentifier: FoodCatalogueIdentifier, for: indexPath) as! FoodCatalogueTableViewCell
            cell.label.text = "\(indexPath)"
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: FoodDetailIdentifier, for: indexPath) as! FoodDetailTableViewCell
            
            cell.likeButton.addTarget(self, action: #selector(go(sender:)), for: .touchUpInside)
            
            return cell
        }
    }
    
    @objc func go (sender: UIButton) {
        print("fuck")
    }
    
    
}

extension DiningHallChildViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        guard tableView == foodDetailTableView else {
            return 55
        }
        return 90
        
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        guard tableView == foodDetailTableView else {
            return 0
        }
        return 25
        
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        guard tableView == foodDetailTableView else {
            return nil
        }
        let view = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: 25))
        //view.backgroundColor = UIColor(red: 240, green: 240, blue: 240, alpha: 0.8)
        //view.backgroundColor = UIColor(white: 0, alpha: 0.1)
        view.backgroundColor = .white
        
        let label = UILabel(frame: CGRect(x: 20, y: 0, width: 200, height: 25))
        label.font = UIFont.systemFont(ofSize: 14)
        label.text = "近期新品\(section)"
        
        view.addSubview(label)
        return view
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        guard tableView == foodCatalogueTableView else {
            return
        }
        foodDetailTableView.scrollToRow(at: IndexPath(row: 0, section: indexPath.row), at: .top, animated: true)
        didSelectLeft = true
        
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        
        guard tableView == foodDetailTableView && tableView.isDragging && isScrollDown else {
            return
        }
        foodCatalogueTableView.selectRow(at: IndexPath(row: section, section: 0), animated: true, scrollPosition: .top)
        
    }
    
    func tableView(_ tableView: UITableView, didEndDisplayingHeaderView view: UIView, forSection section: Int) {
        
        guard tableView == foodDetailTableView && tableView.isDragging && !isScrollDown else {
            return
        }
        foodCatalogueTableView.selectRow(at: IndexPath(row: section+1, section: 0), animated: true, scrollPosition: .top)
        
    }
    
}

extension DiningHallChildViewController: UIScrollViewDelegate {
    
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        
        if let tableView = scrollView as? UITableView {
            if tableView == foodDetailTableView && !didSelectLeft {
                
                isScrollDown = lastOffsetY > scrollView.contentOffset.y
                
                if scrollView.contentOffset.y <= 0 {
                    scrollView.contentOffset = CGPoint(x: 0, y: 0)
                    //self.isOffsetMin = true
                    self.offsetType = .OffsetTypeMin
                } else {
                    //self.isOffsetMin = false
                    self.offsetType = .OffsetTypeCenter
                }
                
                if let VC = self.parent as? OneFloorDiningHallViewController {
                    if VC.offsetType != .OffsetTypeMax && !isScrollDown {
                        scrollView.contentOffset = CGPoint(x: 0, y: lastOffsetY)
                    }
                    
                }
                
                if let VC = self.parent as? TwoFloorsDiningHallViewController {
                    if VC.offsetType != .OffsetTypeMax && !isScrollDown {
                        scrollView.contentOffset = CGPoint(x: 0, y: lastOffsetY)
                    }
                    
                }
                
                lastOffsetY = scrollView.contentOffset.y
            }
        }
        
    }
    
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        if scrollView == self.foodDetailTableView {
            didSelectLeft = false
            lastOffsetY = scrollView.contentOffset.y
        }
    }
    
}
