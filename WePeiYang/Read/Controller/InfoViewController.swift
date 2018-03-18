//
//  InfoViewController.swift
//  YuePeiYang
//
//  Created by Halcao on 2016/10/22.
//  Copyright © 2016年 Halcao. All rights reserved.
//

import UIKit

class InfoViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    private let bigiPhoneWidth: CGFloat = 414.0
    var headerArr: [String] = ["我的收藏", "我的点评"]
    var bookShelf: [MyBook] = []
    var reviewArr: [Review] = []
    let tableView = UITableView(frame: CGRect(x: 0, y: 108, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height-108) , style: .grouped)
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "我的"
        self.tableView.backgroundColor = UIColor.groupTableViewBackground
        self.tableView.estimatedRowHeight = 60
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.separatorStyle = .none
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.view.addSubview(tableView)
        User.shared.getBookShelf(success: {
            self.bookShelf = User.shared.bookShelf
            self.tableView.reloadData()
        })
        User.shared.getReviews {
            self.reviewArr = User.shared.reviews
            self.tableView.reloadData()
        }
    }
    
// MARK: push to viewcontroller
    @objc func sectionTapped(sender: UITapGestureRecognizer)
    {
        guard let tag = sender.view?.tag else{
            return
        }
        switch tag {
        case 0:
            let bvc = BookShelfViewController()
            // only push once
            // bvc.bookShelf = self.bookShelf
            if !(self.navigationController?.topViewController is BookDetailViewController){
                self.navigationController?.pushViewController(bvc, animated: true)
            }
        case 1:
            let rvc = ReviewListViewController()
            rvc.reviewArr = self.reviewArr
            if !(self.navigationController?.topViewController is ReviewListViewController){
                self.navigationController?.pushViewController(rvc, animated: true)
            }

            break
        default:
            break
        }
    }
    
// Mark: UITableViewDataSource
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return (bookShelf.count > 2) ? 2 : bookShelf.count
        case 1:
            return (reviewArr.count > 2) ? 2 : reviewArr.count
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let cell = UITableViewCell(style: .value1, reuseIdentifier: "cell1")
            cell.textLabel?.text = self.bookShelf[indexPath.row].title
            let width = UIScreen.main.bounds.size.width
            if width >= bigiPhoneWidth {
                cell.textLabel?.font = UIFont.systemFont(ofSize: 16)
                cell.detailTextLabel?.font = UIFont.systemFont(ofSize: 12)
            } else {
                cell.textLabel?.font = UIFont.systemFont(ofSize: 14)
                cell.detailTextLabel?.font = UIFont.systemFont(ofSize: 10)
            }
            cell.detailTextLabel?.text = self.bookShelf[indexPath.row].author
            print(self.bookShelf[indexPath.row].id)
            if indexPath.row != self.bookShelf.count - 1 && indexPath.row != 2 - 1 {
                let separator = UIView()
                separator.backgroundColor = UIColor.init(red: 227/255, green: 227/255, blue: 229/255, alpha: 1)
                cell.addSubview(separator)
                separator.snp.makeConstraints { make in
                    make.height.equalTo(1)
                    make.left.equalTo(cell).offset(20)
                    make.right.equalTo(cell).offset(-20)
                    make.bottom.equalTo(cell)
                }
            }
            return cell
        case 1:
            let cell = ReviewCell(model: self.reviewArr[indexPath.row])
            if indexPath.row == 1 {
                cell.separator.removeFromSuperview()
            }
            return cell
        default:
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        if indexPath.section == 0 {
            return .delete
        } else {
            return .none
        }
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        switch indexPath.section {
        case 0:
            // FIXME: 删除的时候section也会动
            if editingStyle == .delete {
                User.shared.delFavorite(id: "\(self.bookShelf[indexPath.row].id)") {
                    DispatchQueue.main.async {
                        self.bookShelf.remove(at: indexPath.row)
                        User.shared.bookShelf = self.bookShelf
                        self.tableView.deleteRows(at: [indexPath], with: .fade)
                        self.tableView.reloadData()
                    }
                }
            }
            break
        default:
            return
        }
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
    
// MARK: HeaderView delegate
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.width = self.view.width
        headerView.height = 50
        headerView.backgroundColor = .white
        let label = UILabel(text: headerArr[section], fontSize: 16)
        label.textColor = UIColor.init(red: 136/255, green: 137/255, blue: 138/255, alpha: 1)
        label.sizeToFit()
        label.x = 15
        label.center.y = headerView.center.y
        headerView.addSubview(label)
        
        let arrowView = UIImageView(image: UIImage(named: "rightArrow"))
        arrowView.width = 20
        arrowView.height = 20
        arrowView.x = headerView.width - 40
        arrowView.center.y = label.center.y
        headerView.addSubview(arrowView)
//        arrowView.snp.makeConstraints { make in
//            make.height.width.equalTo(20)
//            make.right.equalToSuperview()
//        }
//        let header = UITableViewCell(style: .default, reuseIdentifier: "section")
//        header.contentView.backgroundColor = UIColor.init(red: 254/255, green: 255/255, blue: 255/255, alpha: 1)
//        header.textLabel?.textColor = UIColor.init(red: 136/255, green: 137/255, blue: 138/255, alpha: 1)
//        header.detailTextLabel?.textColor = UIColor.init(red: 163/255, green: 163/255, blue: 163/255, alpha: 1)
//        header.textLabel!.text = headerArr[section]
//        header.detailTextLabel?.font = UIFont.systemFont(ofSize: 16)
//        header.accessoryType = .disclosureIndicator
//        header.backgroundColor = UIColor.white
//        header.isUserInteractionEnabled = true
        // tag 作为点击事件的索引 跳转到相关控制器
        headerView.tag = section
        let tap = UITapGestureRecognizer(target: self, action: #selector(sectionTapped(sender:)))
        headerView.addGestureRecognizer(tap)
        let 🌚 = UIView()
        headerView.addSubview(🌚)
        🌚.backgroundColor = UIColor.init(red: 245/255, green: 246/255, blue: 247/255, alpha: 1)
        🌚.snp.makeConstraints { make in
            make.height.equalTo(2)
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        return headerView
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        switch section {
        case 0:
            if bookShelf.count == 0 {
                // 🤓 stands for footer
                let 🤓 = UITableViewCell(style: .default, reuseIdentifier: "footer")
                🤓.backgroundColor = UIColor.white
                🤓.textLabel?.text = "暂时还没有收藏，快去收藏吧！"
                🤓.textLabel?.font = UIFont.systemFont(ofSize: 15)
                🤓.textLabel?.textColor = .gray
                🤓.textLabel?.sizeToFit()
                🤓.textLabel?.snp.makeConstraints { make in
                    make.centerX.equalTo(🤓.contentView.snp.centerX)
                    make.centerY.equalTo(🤓.contentView.snp.centerY)
                }
                // 🌚 stands for separator
                let 🌚 = UIView()
                🤓.addSubview(🌚)
                🌚.backgroundColor = UIColor.init(red: 245/255, green: 246/255, blue: 247/255, alpha: 1)
                🌚.snp.makeConstraints { make in
                    make.height.equalTo(2)
                    make.left.equalTo(🤓)
                    make.right.equalTo(🤓)
                    make.bottom.equalTo(🤓)
                }
                return 🤓
            }
        case 1:
            if reviewArr.count == 0 {
                // 🤓 stands for footer
                let 🤓 = UITableViewCell(style: .default, reuseIdentifier: "footer")
                🤓.backgroundColor = UIColor.white
                🤓.textLabel?.text = "暂时还没有评论，快去评论吧！"
                🤓.textLabel?.font = UIFont.systemFont(ofSize: 15)
                🤓.textLabel?.textColor = .gray
                🤓.textLabel?.sizeToFit()
                🤓.textLabel?.snp.makeConstraints { make in
                    make.centerX.equalTo(🤓.contentView.snp.centerX)
                    make.centerY.equalTo(🤓.contentView.snp.centerY)
                }
                return 🤓
            }
        default:
            break
        }
        return nil
    }
    
    
// MARK: Select Row at IndexPath
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.section {
        case 0:
            let vc = BookDetailViewController(bookID: "\(self.bookShelf[indexPath.row].id)")
            self.navigationController?.pushViewController(vc, animated: true)
            break
        case 1:
            print("Push Detail View Controller, bookID: \(reviewArr[indexPath.row].bookID)")
            let vc = BookDetailViewController(bookID: "\(self.reviewArr[indexPath.row].bookID)")
            self.navigationController?.pushViewController(vc, animated: true)

        default:
            break
        }
        self.tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        switch section {
        case 0:
            if bookShelf.count == 0 {
                return 40
            }
            return 10;
        case 1:
            if reviewArr.count == 0 {
                return 40
            }
        default:
            return 0;
        }
        return 0;
    }
}
