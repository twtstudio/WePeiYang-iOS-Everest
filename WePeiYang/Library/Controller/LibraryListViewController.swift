//
//  LibraryListViewController.swift
//  WePeiYang
//
//  Created by 毛线 on 2018/11/1.
//  Copyright © 2018 twtstudio. All rights reserved.
//

import UIKit
import SnapKit
import Alamofire

class LibraryListViewController: UIViewController {
    private let defaultColor = UIColor(r: 238, g: 238, b: 238)
    private let chooseColor = LibraryMainViewController.bgColor
    private let itemH: CGFloat = 90
    //    private let buttonTitle = ["周榜", "月榜", "总榜"]
    private let listTopTableViewCellID = "listTopTableViewCellID"
    private let listTableViewCellID = "listTableViewCellID"
    
    private var buttons: [UIButton] = []
    
    private var books: [ListBook] = []
    
    //    private var icons: [UIImage] = [#imageLiteral(resourceName: "第一正位"), #imageLiteral(resourceName: "第二正位"), #imageLiteral(resourceName: "第三正位")]
    
    private lazy var listTableView: UITableView = {[unowned self] in
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.rowHeight = itemH
        tableView.sectionFooterHeight = 10
        tableView.sectionHeaderHeight = 0
        tableView.backgroundColor = LibraryMainViewController.bgColor
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = UITableViewCellSeparatorStyle.none
        tableView.showsVerticalScrollIndicator = false
        tableView.register(BookListTableViewCell.self, forCellReuseIdentifier: listTableViewCellID)
        tableView.register(BookListTableViewCell.self, forCellReuseIdentifier: listTopTableViewCellID)
        return tableView
        }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(r: 233, g: 233, b: 233)
        view.addSubview(listTableView)
        setUpButtons()
        refreshList(sender: buttons[0])
        for i in 0...2 {
            buttons[i].addTarget(self, action: #selector(self.refreshList(sender:)), for: .touchUpInside)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        for i in 0...2 {
            buttons[i].addCorner(roundingCorners: [.topRight, .topLeft], cornerSize: CGSize(width: 10, height: 10))
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}

extension LibraryListViewController {
    private func setUpButtons() {
        let buttonWidth: CGFloat = (view.frame.width - 30) / 3
        for i in 0..<3 {
            buttons.append(UIButton())
            buttons[i].setTitle(BookCostant.buttonTitles[i], for: .normal)
            buttons[i].backgroundColor = defaultColor
            buttons[i].titleLabel?.font = UIFont.systemFont(ofSize: 15.0)
            buttons[i].setTitleColor(LibraryMainViewController.fontColor, for: .normal)
            view.addSubview(buttons[i])
        }
        buttons[0].backgroundColor = chooseColor
        buttons[0].snp.makeConstraints { (make) -> Void in
            make.left.equalTo(self.view.snp.left).offset(5)
            make.width.equalTo(buttonWidth)
            //            make.height.equalTo(buttonHeight)
            make.top.equalTo(10)
            make.bottom.equalTo(listTableView.snp.top)
        }
        for i in 1..<3 {
            buttons[i].snp.makeConstraints { (make) -> Void in
                make.left.equalTo(buttons[i-1].snp.right).offset(10)
                make.width.equalTo(buttonWidth)
                //                make.height.equalTo(buttonHeight)
                make.top.equalTo(10)
                make.bottom.equalTo(listTableView.snp.top)
            }
        }
        listTableView.snp.makeConstraints { (make) -> Void in
            make.left.equalTo(self.view)
            make.width.equalTo(self.view)
            //                make.height.equalTo(buttonHeight)
            make.top.equalTo(buttons[0].snp.bottom)
            make.bottom.equalTo(self.view)
        }
        
    }
}

extension LibraryListViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return books.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: BookListTableViewCell?
        switch indexPath.section {
        case 0...2:
            cell = listTableView.dequeueReusableCell(withIdentifier: listTopTableViewCellID, for: indexPath) as? BookListTableViewCell
            cell?.listImage.image = BookCostant.icons[indexPath.section]
        default:
            cell = listTableView.dequeueReusableCell(withIdentifier: listTableViewCellID, for: indexPath) as? BookListTableViewCell
            cell?.listLabel.text = (indexPath.section + 1).description
        }
        if !books.isEmpty {
            cell?.book = books[indexPath.section]
        }
        cell?.selectionStyle = .none
        cell?.backgroundColor = LibraryMainViewController.bgColor
        //        cell?.listCard.shouldPresent(BookDetailViewController.self, from: self)
        return cell!
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 10
        }
        return 0.01
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 5
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        
        view.tintColor = LibraryMainViewController.bgColor
    }
    
    func tableView(_ tableView: UITableView, willDisplayFooterView view: UIView, forSection section: Int) {
        view.tintColor = LibraryMainViewController.bgColor
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = BookDetailViewController()
        vc.bookID = books[indexPath.section].bookID
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}

extension LibraryListViewController {
    private func getList(day: String, success: @escaping ([ListBook]) -> Void, failure: @escaping (Error) -> Void) {
        Alamofire.request("https://vote.twtstudio.com/getBorrowRank.php" + day, method: .post, headers: nil).responseJSON { response in
            switch response.result {
            case .success:
                guard let data = response.result.value,
                let dict = data as? [String: Any],
                let result = dict["result"] as? [Any] else {
                    let error = response.error ?? WPYCustomError.errorCode(-2, "数据解析错误")
                    failure(error)
                    return
                }

                do {
                    let bookData = try JSONSerialization.data(withJSONObject: result, options: [])
                    let list = try JSONDecoder().decode([ListBook].self, from: bookData)
                    success(list)
                } catch let err {
                    failure(err)
                }
            case .failure(let error):
                failure(error)
            }
        }
    }
    
    @objc func refreshList(sender: UIButton) {
        sender.backgroundColor = chooseColor
        buttons.filter { $0 != sender }.forEach { $0.backgroundColor = defaultColor }

        var day = ""
        switch sender {
        case buttons[0]:
            day = "?term=7"
        case buttons[1]:
            day = "?term=30"
        default:
            day = ""
        }
        getList(day: day, success: {
            list in
            self.books = list
            self.listTableView.reloadData()
        }, failure: {
            error in
            SwiftMessages.showErrorMessage(body: error.localizedDescription)
        })
    }
}

//自定义设置圆角
extension UIView {
    func addCorner(roundingCorners: UIRectCorner, cornerSize: CGSize) {
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: roundingCorners, cornerRadii: cornerSize)
        let cornerLayer = CAShapeLayer()
        cornerLayer.frame = bounds
        cornerLayer.path = path.cgPath
        layer.mask = cornerLayer
    }
}
