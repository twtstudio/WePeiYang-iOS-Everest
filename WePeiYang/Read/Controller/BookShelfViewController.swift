//
//  BookShelfViewController.swift
//  YuePeiYang
//
//  Created by Halcao on 2016/10/22.
//  Copyright © 2016年 Halcao. All rights reserved.
//


import UIKit

private let bigiPhoneWidth: CGFloat = 375.0

class BookShelfViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    var bookShelf: [MyBook] = []
    var label = UILabel()
    let tableView = UITableView()
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "我的收藏"
        self.view.addSubview(tableView)
        self.tableView.snp.makeConstraints { make in
            make.left.right.bottom.top.equalToSuperview()
        }
        tableView.delegate = self
        tableView.dataSource = self
        self.tableView.tableFooterView = UIView()
        self.tableView.separatorStyle = .none
        self.bookShelf = User.shared.bookShelf
        addNoBookLabel()
        let rightItem = UIBarButtonItem(title: "编辑", style: .plain, target: self, action: #selector(self.editingStateOnChange(sender:)))
        self.navigationItem.rightBarButtonItem = rightItem
    }
    
    @objc func editingStateOnChange(sender: UIBarButtonItem) {
        tableView.setEditing(!tableView.isEditing, animated: true)
        if tableView.isEditing {
            self.navigationItem.rightBarButtonItem?.title = "完成"
        } else {
            self.navigationItem.rightBarButtonItem?.title = "编辑"
        }
    }

    func addNoBookLabel() {
        if self.bookShelf.count == 0 {
            label.text = "你还没有收藏哦，快去添加收藏吧！"
            label.textColor = UIColor(red:0.80, green:0.80, blue:0.80, alpha:1.00)
            label.font = UIFont.boldSystemFont(ofSize: 19)
            label.sizeToFit()
            self.view.addSubview(label)
            label.snp.makeConstraints { make in
                make.centerX.equalToSuperview()
                make.centerY.equalToSuperview().offset(-40)
            }
        } else {
            label.removeFromSuperview()
        }
    }
    
    // Mark: UITableViewDataSource
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return bookShelf.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
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
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            User.shared.delFavorite(id: "\(self.bookShelf[indexPath.row].id)") {
                self.bookShelf.remove(at: indexPath.row)
                User.shared.bookShelf = self.bookShelf
                self.tableView.deleteRows(at: [indexPath], with: .fade)
                self.addNoBookLabel()
            }
        }
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let vc = BookDetailViewController(bookID: "\(self.bookShelf[indexPath.row].id)")
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
}

