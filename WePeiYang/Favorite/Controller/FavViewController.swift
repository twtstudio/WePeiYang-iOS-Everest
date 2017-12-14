//
//  FavViewController.swift
//  WePeiYang
//
//  Created by Allen X on 4/28/17.
//  Copyright © 2017 twtstudio. All rights reserved.
//

import UIKit

class FavViewController: UIViewController {

    // The below override will not be called if current viewcontroller is controlled by a UINavigationController
    // We should do self.navigationController.navigationBar.barStyle = UIBarStyleBlack
//    override var preferredStatusBarStyle: UIStatusBarStyle {
//        return .lightContent
//    }
    
    var fooView: UIView!
    var cardTableView: UITableView!
    
    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//        
//        navigationController?.navigationBar.barStyle = .black
//        navigationController?.navigationBar.barTintColor = Metadata.Color.WPYAccentColor
//        //Changing NavigationBar Title color
//        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: Metadata.Color.naviTextColor]
//        
//        navigationItem.title = "常用"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        navigationController?.navigationBar.barStyle = .black
        navigationController?.navigationBar.barTintColor = Metadata.Color.WPYAccentColor
        // Changing NavigationBar Title color
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: Metadata.Color.naviTextColor]
        // This is for removing the dark shadows when transitioning
        navigationController?.navigationBar.isTranslucent = false
        
        navigationItem.title = "常用"
        
        
        view.backgroundColor = Metadata.Color.GlobalViewBackgroundColor
        
        cardTableView = UITableView()
        cardTableView.frame = view.frame
        view = cardTableView
        
        cardTableView.delegate = self
        cardTableView.dataSource = self
        cardTableView.estimatedRowHeight = 200
        cardTableView.rowHeight = UITableViewAutomaticDimension
        cardTableView.separatorStyle = .none
        cardTableView.allowsSelection = false
    }
}


extension FavViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = UITableViewCell()
            let card = GPACard()
            cell.contentView.addSubview(card)
            card.snp.makeConstraints { make in
                make.top.equalToSuperview().offset(10)
                make.bottom.equalToSuperview().offset(-10)
                make.height.equalTo(200)
                make.left.equalToSuperview().offset(15)
                make.right.equalToSuperview().offset(-15)
            }
            
            let data = [91.3, 90.8, 89.1, 89.9]
            
            let contentMargin: CGFloat = 15
            let width: CGFloat = self.view.frame.size.width - 60
            let space = (width - 2*contentMargin)/CGFloat(data.count - 1)
            
            let height: CGFloat = 100
            let minVal = data.min()!
            let range = data.max()! - minVal
            let ratio = height/CGFloat(range)
            
            let newData = data.map({ item in
                return height - CGFloat(item - minVal)*ratio
            })
            
            var points = [CGPoint]()
            
            for i in 0..<newData.count {
                let point = CGPoint(x: CGFloat(i)*space, y: newData[i])
                points.append(point)
            }
            
            card.drawLine(points: points)
            let gpaVC = GPAViewController()
            let gpaNC = UINavigationController(rootViewController: gpaVC)
            //        newVC.transitioningDelegate = self
            card.shouldPresent(gpaNC, from: self)
            return cell
        } else {
            let cell = UITableViewCell()
            let card = LibraryCard()
            cell.contentView.addSubview(card)
            card.snp.makeConstraints { make in
                make.top.equalToSuperview().offset(10)
                make.bottom.equalToSuperview().offset(-10)
//                make.height.equalTo(200)
                make.left.equalToSuperview().offset(15)
                make.right.equalToSuperview().offset(-15)
            }
            return cell
        }
    }
}

extension FavViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}
