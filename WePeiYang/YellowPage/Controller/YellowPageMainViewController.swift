//
//  YellowPageMainViewController.swift
//  YellowPage
//
//  Created by Halcao on 2017/2/22.
//  Modified by Halcao on 2017/7/18.
//  Copyright © 2017年 Halcao. All rights reserved.
//

import UIKit

class YellowPageMainViewController: UIViewController {
    
    let titles = ["1895综合服务大厅", "图书馆", "维修服务中心", "校园自行车", "学生宿舍管理中心", "天大医院"]
    let icons = ["icon-1895", "icon-library", "icon-repair", "icon-bike", "icon-building", "icon-hospital"]
    
    let tableView = UITableView(frame: CGRect.zero, style: .grouped)
    
    var sections: [String] {
        return PhoneBook.shared.sections
    }
    var favorite: [ClientItem] {
        return PhoneBook.shared.favorite
    }
    
    var shouldLoadSections: [Int] = [] // contains each section which should be loaded
    var shouldLoadFavorite = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.view.backgroundColor = UIColor.white
        self.title = "黄页"
        let titleLabel = UILabel(text: "黄页")
        titleLabel.backgroundColor = UIColor.clear
        titleLabel.font = UIFont.boldSystemFont(ofSize: 18.0)
        titleLabel.textColor = UIColor.white
        titleLabel.sizeToFit()
        self.navigationItem.titleView = titleLabel
        
        
        let rightButton = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(YellowPageMainViewController.searchToggle))
        self.navigationItem.rightBarButtonItem = rightButton
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.estimatedSectionHeaderHeight = 0
        tableView.estimatedSectionFooterHeight = 0
        tableView.estimatedRowHeight = 200.5
        tableView.rowHeight = UITableViewAutomaticDimension
        
        self.view.addSubview(tableView)
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(view)
            make.bottom.equalTo(view)
            make.left.equalTo(view)
            make.right.equalTo(view)
        }
        // FIXME: MsgDisplay Loading
        //MsgDisplay.showLoading()
        SwiftMessages.showLoading()

        PhoneBook.shared.load(success: {
            self.tableView.reloadData()
            SwiftMessages.hide()
        }, failure: {
            PhoneBook.checkVersion {
                self.tableView.reloadData()
            }
        })

//        UIView.performWithoutAnimation {
//            self.tableView.reloadSections([1], with: .none)
//        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(color: UIColor(red: 0.1059, green: 0.6352, blue: 0.9019, alpha: 1)), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.navigationBar.barStyle = .black
        self.navigationController!.navigationBar.tintColor = .white
    }

    @objc func searchToggle() {
        let searchVC = YellowPageSearchViewController()
        self.present(searchVC, animated: true, completion: nil)
    }
    
    @objc func cellTapped(sender: YellowPageCell) {
        let alertVC = UIAlertController(title: "详情", message: "想要做什么？", preferredStyle: .actionSheet)
        let copyAction = UIAlertAction(title: "复制到剪切板", style: .default) { action in
            sender.longPressed()
        }
        let cancelAction = UIAlertAction(title: "取消", style: .cancel) { action in
        }
        alertVC.addAction(copyAction)
        alertVC.addAction(cancelAction)
        self.present(alertVC, animated: true, completion: nil)
    }

}

// delegate and dataSource

extension YellowPageMainViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let title = titles[indexPath.row]
        let detailedVC = YellowPageDetailViewController()
        detailedVC.title = title
        detailedVC.models = PhoneBook.shared.getModels(with: title)
        self.navigationController?.pushViewController(detailedVC, animated: true)
    }
}

extension YellowPageMainViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CommonClientCell", for: indexPath) as! CommonClientCell
        cell.load(with: titles[indexPath.row], and: icons[indexPath.row])
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsetsMake(5, 15, 5, 15)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return titles.count
    }
}


// MARK: UITableViewDataSource
extension YellowPageMainViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2 + sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0: //.commonUsedHeader:
            return 1
        case 1: //.favorite:
            return shouldLoadFavorite ? favorite.count+1 : 1
        case let section where section > 1 && section < 2+sections.count:
            let n = section - 2
            if shouldLoadSections.contains(n) {
                return PhoneBook.shared.getMembers(with: sections[n]).count+1
            } else {
                return 1
            }
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let cell = YellowPageCell(with: .header, name: "")
//            cell.contentView.height = 200
            cell.commonView.collectionView.delegate = self
            cell.commonView.collectionView.dataSource = self
            return cell
        case 1:
            if indexPath.row == 0 { // section
                let cell = YellowPageCell(with: .section, name: "我的收藏")
                cell.canUnfold = !shouldLoadFavorite
                cell.countLabel.text = "\(favorite.count)"
                return cell
            } else { // detailed item
                let cell = YellowPageCell(with: .detailed, model: favorite[indexPath.row-1])
                let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(cellTapped(sender:)))
                cell.phoneLabel.addGestureRecognizer(tapRecognizer)
                return cell
            }
        case let section where section > 1 && section < 2+sections.count:
            let n = indexPath.section - 2
            let members = PhoneBook.shared.getMembers(with: sections[n])
            
            if indexPath.row == 0 { // section
                let cell = YellowPageCell(with: .section, name: sections[n])
                cell.countLabel.text = "\(members.count)"
                if shouldLoadSections.contains(n) {
                    cell.canUnfold = false
                } else {
                    cell.canUnfold = true
                }
                return cell
            } else {
                if shouldLoadSections.contains(n) {
                    let cell = YellowPageCell(with: .item, name: members[indexPath.row-1])
                    return cell
                }
            }
            let cell = UITableViewCell()
            return cell
        default:
            // will never be executed
            let cell = UITableViewCell()
            return cell
        }
    }
}


// MARK: UITableViewDelegate
extension YellowPageMainViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true )
        switch indexPath.section {
        case 0: // header: common used
            tableView.deselectRow(at: indexPath, animated: true)
        case 1: // favorite
            if indexPath.row == 0 {
                self.shouldLoadFavorite = !self.shouldLoadFavorite
                tableView.reloadData()
                // xxx
//                    tableView.reloadSections([1], with: .none)
            } else {
                // toggle phone call
            }
        case let section where section > 1 && section < 2+sections.count: //  section
            let n = indexPath.section - 2
            if indexPath.row == 0 {
                if self.shouldLoadSections.contains(n) {
                    // if the section is unfolded
                    self.shouldLoadSections = self.shouldLoadSections.filter { e in
                        return e != n
                    }
                } else {
                    // will unfold the section
                    self.shouldLoadSections.append(n)
                }
                //                DispatchQueue.main.sync {
                    // reload data
                tableView.reloadData()
                // xxx
//                    self.tableView.reloadSections([indexPath.section], with: .none)
                    tableView.scrollToRow(at: IndexPath(row: 0, section: indexPath.section), at: .top, animated: true)
//               }
            } else {
                // push to detailed ViewController
                let detailedVC = YellowPageDetailViewController()
                let members = PhoneBook.shared.getMembers(with: sections[n])
                detailedVC.navigationItem.title = members[indexPath.row-1]
                detailedVC.models = PhoneBook.shared.getModels(with: members[indexPath.row-1])
                self.navigationController?.pushViewController(detailedVC, animated: true)
            }
        default:
            return
        }

    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            // don't know why i can't just return 0
            return 0.001
        } else if section < 3 {
            return 7
        } else {
            // return 0
            return 0.001
        }
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if section < 2 {
            return 7
        } else {
            return 0.001
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // FIXME: setBarColor
//        self.navigationController?.navigationBar.isTranslucent = UINavigationBar.appearance().isTranslucent
//        self.navigationController?.navigationBar.shadowImage = UINavigationBar.appearance().shadowImage
//        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        PhoneBook.shared.save()
    }
}
