//
//  FavViewController.swift
//  WePeiYang
//
//  Created by Allen X on 4/28/17.
//  Copyright © 2017 twtstudio. All rights reserved.
//

import UIKit
import ObjectMapper

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
        navigationController?.isNavigationBarHidden = true
        
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
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
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
        
        let dic = CacheManager.loadGroupCache(withKey: GPAKey) as? [String: Any]
        let model = Mapper<GPAModel>().map(JSON: dic ?? [:])
        
        // FIXME: gpa data
        var data: [Double] = []
        for term in model?.terms ?? [] {
            data.append(term.stat.score)
        }
        data = [90, 91, 85]
        
        let contentMargin: CGFloat = 15
        let width: CGFloat = self.view.frame.size.width - 60
        let space = (width - 2*contentMargin)/CGFloat(data.count - 1)
        
        let height: CGFloat = 100
        let minVal = data.min() ?? 0
        let range = data.max() ?? 0 - minVal
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
//        newVC.transitioningDelegate = self
//        card.shouldPresent(gpaVC, from: self)
        card.shouldPush(gpaVC, from: self)

        return cell
    }
}

extension FavViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}
