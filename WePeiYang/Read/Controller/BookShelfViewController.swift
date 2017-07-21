//
//  BookShelfViewController.swift
//  YuePeiYang
//
//  Created by Halcao on 2016/10/22.
//  Copyright © 2016年 Halcao. All rights reserved.
//


import UIKit

let bigiPhoneWidth: CGFloat = 375.0

class BookShelfViewController: UITableViewController {
    var bookShelf: [MyBook] = []
    var label = UILabel()
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //        self.navigationController?.navigationBar.backgroundColor = UIColor(colorLiteralRed: 234.0/255.0, green: 74.0/255.0, blue: 70/255.0, alpha: 1.0)
        //        //titleLabel设置
        let titleLabel = UILabel(text: "我的收藏", fontSize: 17)
        titleLabel.backgroundColor = UIColor.clear
        titleLabel.textAlignment = .center
        titleLabel.textColor = UIColor.white
        self.navigationItem.titleView = titleLabel;
        
        //NavigationBar 的背景，使用了View
//        self.navigationController!.jz_navigationBarBackgroundAlpha = 0;
        let bgView = UIView(frame: CGRect(x: 0, y: -664, width: self.view.frame.size.width, height: self.navigationController!.navigationBar.frame.size.height+UIApplication.shared.statusBarFrame.size.height+600))
        
        bgView.backgroundColor = UIColor(colorLiteralRed: 234.0/255.0, green: 74.0/255.0, blue: 70/255.0, alpha: 1.0)
        self.view.addSubview(bgView)
        
        //        //改变 statusBar 颜色
        self.navigationController?.navigationBar.barStyle = .black
//        UIApplication.sharedApplication().setStatusBarStyle(.LightContent, animated: true)
        self.bookShelf = User.shared.bookShelf
        addNoBookLabel()

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "我的收藏"
        self.tableView.tableFooterView = UIView()
        self.tableView.separatorStyle = .none
    }
    
    func addNoBookLabel() {
        if self.bookShelf.count == 0 {
            label.text = "你还没有收藏哦，快去添加收藏吧！"
            label.sizeToFit()
            self.view.addSubview(label)
            label.snp.makeConstraints { make in
                make.center.equalTo(self.view.snp.center)
            }
        } else {
            label.removeFromSuperview()
        }
    }
    
    // Mark: UITableViewDataSource
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return bookShelf.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .value1, reuseIdentifier: "cell1")
        cell.textLabel?.text = self.bookShelf[indexPath.row].title
//        cell.textLabel?.font = UIFont.systemFont(ofSize: 13)
//        cell.detailTextLabel?.font = UIFont.systemFont(ofSize: 12)
        let width = UIScreen.main.bounds.size.width
        if width >= bigiPhoneWidth {
            cell.textLabel?.font = UIFont.systemFont(ofSize: 16)
            cell.detailTextLabel?.font = UIFont.systemFont(ofSize: 12)
        } else {
            cell.textLabel?.font = UIFont.systemFont(ofSize: 14)
            cell.detailTextLabel?.font = UIFont.systemFont(ofSize: 10)
        }
        cell.detailTextLabel?.text = self.bookShelf[indexPath.row].author
        //cell.tag = self.bookShelf[indexPath.row].isbn
        var separatorMargin = 20
        // MARK: 这个效果看起来很奇怪
        if indexPath.row == self.bookShelf.count - 1 {
            separatorMargin = 0
        }
        let separator = UIView()
        separator.backgroundColor = UIColor.init(red: 227/255, green: 227/255, blue: 229/255, alpha: 1)
        cell.addSubview(separator)
        
        separator.snp.makeConstraints { make in
            make.height.equalTo(1)
            make.left.equalTo(cell).offset(separatorMargin)
            make.right.equalTo(cell).offset(-separatorMargin)
            make.bottom.equalTo(cell).offset(0)
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            User.shared.delFavorite(id: "\(self.bookShelf[indexPath.row].id)") {
                self.bookShelf.remove(at: indexPath.row)
                User.shared.bookShelf = self.bookShelf
                self.tableView.deleteRows(at: [indexPath], with: .fade)
                self.addNoBookLabel()
            }
        }
    }
    
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = BookDetailViewController(bookID: "\(self.bookShelf[indexPath.row].id)")
        self.navigationController?.show(vc, sender: nil)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}

