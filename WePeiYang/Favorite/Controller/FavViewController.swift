
//  FavViewController.swift
//  WePeiYang
//
//  Created by Allen X on 4/28/17.
//  Copyright © 2017 twtstudio. All rights reserved.
//

import UIKit
import ObjectMapper
import SnapKit

class FavViewController: UIViewController {

    // The below override will not be called if current viewcontroller is controlled by a UINavigationController
    // We should do self.navigationController.navigationBar.barStyle = UIBarStyleBlack
//    override var preferredStatusBarStyle: UIStatusBarStyle {
//        return .lightContent
//    }
    var headerView: UIView!
    var fooView: UIView!
    var cardTableView: UITableView!
    var cardDict: [String: CardView] = [:]
    var cellHeights: [CGFloat] = []

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
        
        
//        view.backgroundColor = Metadata.Color.GlobalViewBackgroundColor
        view.backgroundColor = .white

        cardTableView = UITableView(frame: view.frame, style: .grouped)
        view = cardTableView
        
        cardTableView.delegate = self
        cardTableView.dataSource = self
        cardTableView.estimatedRowHeight = 300
        cardTableView.rowHeight = UITableViewAutomaticDimension
        cardTableView.separatorStyle = .none
        cardTableView.allowsSelection = false
        cardTableView.backgroundColor = .white
        
        
        // init headerView
        headerView = UIView()
        headerView.frame = CGRect(x: 0, y: 0, width: 400, height: 80)
        let dateLabel = UILabel()
        let now = Date()
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US")
//        formatter.dateFormat = "EEEE, MMMM d"
        formatter.dateFormat = "EEE, MMMM d"

        dateLabel.textColor = UIColor(red:0.36, green:0.36, blue:0.36, alpha:1.00)
        dateLabel.text = formatter.string(from: now).uppercased()
        dateLabel.font = UIFont.systemFont(ofSize: 15)
        dateLabel.x = 15
        dateLabel.y = 15
        dateLabel.sizeToFit()
        headerView.addSubview(dateLabel)
        
        let titleLabel = UILabel(text: "Favorite")
        titleLabel.font = UIFont.systemFont(ofSize: 35, weight: UIFontWeightHeavy)
        titleLabel.x = 15
        titleLabel.y = 35
        titleLabel.sizeToFit()
        headerView.addSubview(titleLabel)
        NotificationCenter.default.addObserver(forName: NotificationName.NotificationCardWillRefresh.name, object: nil, queue: nil, using: { notification in
            if let info = notification.userInfo,
                let name = info["name"] as? String,
                let height = info["height"] as? CGFloat,
                let card = self.cardDict[name],
                let row = Array(self.cardDict.keys).index(of: name) {
                let indexPath = IndexPath(row: row, section: 0)
                let cell = self.cardTableView.cellForRow(at: indexPath)

//                self.cardTableView.beginUpdates()
//                card.snp.remakeConstraints { make in
//                    make.top.equalToSuperview().offset(10)
//                    make.bottom.equalToSuperview().offset(-10)
//                    make.height.equalTo(height)
//                    make.left.equalToSuperview().offset(15)
//                    make.right.equalToSuperview().offset(-15)
//                }
                self.cellHeights[row] = height

                card.snp.updateConstraints { make in
                    make.height.equalTo(height)
                }

                cell?.contentView.updateConstraintsIfNeeded()
                cell?.contentView.layoutIfNeeded()

                card.updateConstraintsIfNeeded()
//                self.cardTableView.endUpdates()
                self.cardTableView.reloadData()
                self.cardTableView.scrollToRow(at: indexPath, at: UITableViewScrollPosition.middle, animated: true)
//                self.cardTableView.reloadRows(at: [indexPath], with: .automatic)
            }
    })
        // init Cards
        initCards()
    }

    func initCards() {
        initClassTableCard()
        initLibraryCard()
        initGPACard()
        cardTableView.reloadData()
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

extension FavViewController {
    func initGPACard() {
        let card = GPACard()

        if let dic = CacheManager.loadGroupCache(withKey: GPAKey) as? [String: Any], let model = Mapper<GPAModel>().map(JSON: dic) {
            var data: [Double] = []
            for term in model.terms {
                data.append(term.stat.score)
            }

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
        }

        // TODO: else 没有数据时
        let gpaVC = GPAViewController()
        //        newVC.transitioningDelegate = self
        //        card.shouldPresent(gpaVC, from: self)
        card.shouldPush(gpaVC, from: self)
        cardDict["GPA"] = card
        // FIXME: gpa data
    }

    func initClassTableCard() {
        let card = ClassTableCard()

        if let dic = CacheManager.loadGroupCache(withKey: ClassTableKey) as? [String: Any], let table = Mapper<ClassTableModel>().map(JSON: dic) {
            let termStart = Date(timeIntervalSince1970: Double(table.termStart))
            let week = Int(Date().timeIntervalSince(termStart)/(7.0*24*60*60) + 1)
            let formatter = NumberFormatter()
            formatter.numberStyle = .spellOut
            let weekday = DateTool.getLocalWeekDay()
            card.titleLabel.text = "第\(formatter.string(from: NSNumber(integerLiteral: week))!)周 " + weekday
            card.titleLabel.sizeToFit()
        }
        let courses = ClassTableHelper.getTodayCourse().filter { course in
            return course.courseName != ""
        }

        // 这个时间点有课就代表着时候有课
        let keys = [1, 3, 5, 7, 9]
        for (idx, time) in keys.enumerated() {
            // 返回第一个包含时间点的课程 // 可能是 nil
            let course = courses.first { course in
                let range = course.arrange.first!.start...course.arrange.first!.start
                return range.contains(time)
            }
            if let course = course {
                card.cells[idx].load(course: course)
            } else {
                card.cells[idx].setIdle()
            }
        }

        let classtableVC = ClassTableViewController()
        card.shouldPush(classtableVC, from: self)
        cardDict["ClassTable"] = card
    }

    func initLibraryCard() {
        let card = LibraryCard()
        card.getBooks()
        cardDict["Library"] = card
    }
}

extension FavViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cardDict.keys.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let key = Array(cardDict.keys)[indexPath.row]
        let card = cardDict[key]!
        var cell = tableView.dequeueReusableCell(withIdentifier: "card\(indexPath)")

        if cell == nil {
            // no cell in reuse pool
            cell = UITableViewCell(style: .default, reuseIdentifier: "card\(indexPath)")
            cell!.contentView.addSubview(card)
            card.sizeToFit()
            let cellHeight: CGFloat = 240
            card.snp.makeConstraints { make in
                make.top.equalToSuperview().offset(10)
                make.bottom.equalToSuperview().offset(-10)
                make.height.equalTo(cellHeight)
                make.left.equalToSuperview().offset(15)
                make.right.equalToSuperview().offset(-15)
            }
            cellHeights.append(cellHeight)
            cell?.setNeedsLayout()
            cell?.layoutIfNeeded()
        }


        return cell!
    }
}

extension FavViewController {
    // TODO: gpa card generator
}

extension FavViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return cellHeights[indexPath.row]
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 {
            return headerView
        }
        return nil
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return headerView.systemLayoutSizeFitting(.init(width: CGFloat.infinity, height: CGFloat.infinity)).height
    }
}
