//
//  BookDetailCard.swift
//  WePeiYang
//
//  Created by 毛线 on 2018/11/1.
//  Copyright © 2018 twtstudio. All rights reserved.
//

import UIKit
import SnapKit

class BookDetailCard: CardView {
    private let insertPadding: CGFloat = UIScreen.main.bounds.height * 0.008
    private let padding: CGFloat = 20
    private let detailCellID = "detailCellID"
    private let detailHeaderID = "detailHeaderID"
    
    var book: DetailBook? {
        didSet {
            if let book = book {
                title.text = book.title
                var authorName = ""
                for author in book.authorPrimary {
                    authorName += author + " "
                }
                bookMessage[0].text = "作者 " + authorName
                bookMessage[1].text = "出版社 " + book.publisher
                bookMessage[2].text = "出版日期 " + book.year
                LibraryBook.getImage(id: book.id, success: {
                    link in
                    self.bookImage.sd_setImage(with: URL(string: link), placeholderImage: #imageLiteral(resourceName: "暂无图片"))
                }, failure: {
                    self.bookImage.image = #imageLiteral(resourceName: "暂无图片")
                })
                sortholding = book.holding.sorted(by: { $0.state > $1.state })
                tableView.reloadData()
            }
        }
    }
    private var sortholding = [Holding]()
    private let bookImage = UIImageView()
    private let title = UILabel()
    private var bookMessage: [UILabel] = []
    private let storage = UILabel(text: "馆藏情况", color: LibraryMainViewController.fontGrayColor, fontSize: 15)
    private lazy var tableView: UITableView = {[unowned self] in
        let tableView = UITableView()
        tableView.rowHeight = 60
        tableView.sectionHeaderHeight = 25
        tableView.backgroundColor = UIColor.white
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = UITableViewCellSeparatorStyle.none
        tableView.showsVerticalScrollIndicator = false
        tableView.register(BookDetailTableViewCell.self, forCellReuseIdentifier: detailCellID)
        tableView.register(BookDetailTableHeaderView.self, forHeaderFooterViewReuseIdentifier: detailHeaderID)
        return tableView
        }()
    //    private var labelString: [String] = ["作者 ", "出版社 ", "出版日期 "]
    
    override func initialize() {
        super.initialize()
        self.backgroundColor = .white
        bookImage.image = #imageLiteral(resourceName: "暂无图片")
        title.text = ""
        title.textColor = LibraryMainViewController.fontDarkColor
        title.font = UIFont.systemFont(ofSize: 15)
        title.numberOfLines = 2
        
        setUpViews()
        setUpBookMessage()
    }
    
    private func setUpViews() {
        addSubview(bookImage)
        addSubview(title)
        addSubview(storage)
        addSubview(tableView)
        
        bookImage.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(contentView).offset(padding)
            make.left.equalTo(contentView).offset(padding)
            make.width.equalTo(contentView).multipliedBy(0.35)
            make.height.equalTo(bookImage.snp.width).multipliedBy(1.1)
        }
        title.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(bookImage).offset(5)
            make.left.equalTo(bookImage.snp.right).offset(padding)
            make.right.equalTo(contentView).offset(-padding)
        }
        
        storage.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(bookImage.snp.bottom).offset(padding)
            make.left.equalTo(bookImage)
        }
        
        tableView.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(storage.snp.bottom).offset(padding)
            make.left.equalTo(contentView).offset(padding)
            make.right.equalTo(contentView).offset(-padding)
            make.bottom.equalTo(contentView).offset(-padding)
        }
        
    }
    
    private func setUpBookMessage() {
        
        for i in 0..<3 {
            bookMessage.append(UILabel(text: "", color: LibraryMainViewController.fontGrayColor, fontSize: 13))
            addSubview(bookMessage[i])
        }
        bookMessage[0].snp.makeConstraints { (make) -> Void in
            make.top.equalTo(title.snp.bottom).offset(insertPadding * 2)
            make.left.equalTo(title)
            make.right.equalTo(title)
        }
        for i in 1..<3 {
            bookMessage[i].snp.makeConstraints { (make) -> Void in
                make.top.equalTo(bookMessage[i-1].snp.bottom).offset(insertPadding)
                make.left.equalTo(title)
                make.right.equalTo(title)
            }
        }
    }
    
}

extension BookDetailCard: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return book?.holding.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: detailCellID, for: indexPath) as! BookDetailTableViewCell
        cell.backgroundColor = UIColor.white
        cell.selectionStyle = .none
        cell.holding = sortholding[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: detailHeaderID) as! BookDetailTableHeaderView
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 25
    }
}
