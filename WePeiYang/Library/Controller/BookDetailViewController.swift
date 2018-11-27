//
//  BookDetailViewController.swift
//  WePeiYang
//
//  Created by 毛线 on 2018/11/23.
//  Copyright © 2018 twtstudio. All rights reserved.
//

import UIKit
import SnapKit

private let statusH: CGFloat = UIApplication.shared.statusBarFrame.height
private let navigationBarH: CGFloat = 44
private let tabbarH: CGFloat = 44

class BookDetailViewController: UIViewController {
    
    var bookID: String = "599771"
    
    private let bookView: BookDetailCard = {
        let card = BookDetailCard()
        return card
    }()
    
    private let borrowView: CardView = {
        let card = CardView()
        return card
    }()
    
    private var labels: [UILabel] = []

    private var borrowNumLabel: UILabel {
        return labels[1]
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = LibraryMainViewController.bgColor
        setUpViews()
        getBookDetail(success: { book in
            self.bookView.book = book
        }, failure: { error in
            SwiftMessages.showErrorMessage(body: error.localizedDescription)
        })
        getBorrowNum(success: { num in
            self.labels[1].text = num.description
        }, failure: { err in
            SwiftMessages.showErrorMessage(body: err.localizedDescription)
            self.labels[1].text = "0"
        })
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.title = "图书详情"
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(color: LibraryMainViewController.mainColor), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.navigationBar.barStyle = .black
        self.navigationController?.navigationBar.tintColor = .white
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func setUpViews() {
        navigationController?.navigationBar.barTintColor = LibraryMainViewController.mainColor

        view.addSubview(bookView)
        view.addSubview(borrowView)
        setUpBorrowView()
        borrowView.backgroundColor = .white
        bookView.backgroundColor = .white
        let verticlePadding: CGFloat = 15
        let horizontalPadding: CGFloat = 20
        bookView.snp.makeConstraints { make in
            make.top.equalTo(view).offset(verticlePadding + statusH + navigationBarH)
            make.left.equalTo(view).offset(horizontalPadding)
            make.bottom.equalTo(borrowView.snp.top).offset(-verticlePadding)
            make.right.equalTo(view).offset(-horizontalPadding)
        }
        borrowView.snp.makeConstraints { make in
            make.left.equalTo(view).offset(horizontalPadding)
            make.bottom.equalTo(view).offset(-verticlePadding)
            make.right.equalTo(view).offset(-horizontalPadding)
            make.height.equalTo(view).multipliedBy(0.1)
        }
    }
    
    private func setUpBorrowView() {
        let padding: CGFloat = 30
        for i in 0..<3 {
            labels.append(UILabel())
            borrowView.addSubview(labels[i])
            labels[i].textColor = LibraryMainViewController.fontDarkColor
            labels[i].font = UIFont.systemFont(ofSize: 18)
            labels[i].snp.makeConstraints { make in
                make.centerY.equalTo(borrowView)
            }
        }
        labels[1].textColor = LibraryMainViewController.fontGrayColor
        labels[0].text = "总体借阅次数"
        labels[1].text = ""
        labels[1].textColor = LibraryMainViewController.fontColor
        labels[2].text = "次"
        labels[0].snp.makeConstraints { make in
            make.left.equalTo(borrowView).offset(padding)
        }
        labels[2].snp.makeConstraints { make in
            make.right.equalTo(borrowView).offset(-padding)
        }
        labels[1].snp.makeConstraints { make in
            make.right.equalTo(labels[2].snp.left).offset(-padding)
        }
    }
}

extension BookDetailViewController {
    private func getBookDetail(success: @escaping (DetailBook) -> Void, failure: @escaping (Error) -> Void) {
        SolaSessionManager.solaSession(url: "/library/book/" + bookID, success: { dict in
            if let data = dict["data"] as? [String: Any] {
                do {
                    let json = try JSONSerialization.data(withJSONObject: data, options: [])
                    let detailBook = try JSONDecoder().decode(DetailBook.self, from: json)
                    success(detailBook)
                } catch {
                    failure(error)
                }
            } else {
                let error = WPYCustomError.custom("没有该书数据")
                failure(error)
            }
        })
    }
    private func getBorrowNum(success: @escaping (Int) -> Void, failure: @escaping (Error) -> Void) {
        SolaSessionManager.solaSession(url: "/library/book/getTotalBorrow/" + bookID, success: { dict in
            if let num = dict["totalBorrowNum"] as? Int {
                success(num)
            } else {
                failure(WPYCustomError.custom("没有借阅次数数据"))
            }
        }, failure: { err in
            failure(err)
        })
    }
}
