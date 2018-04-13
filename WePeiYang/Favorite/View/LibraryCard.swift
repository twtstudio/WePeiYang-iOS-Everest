
//
//  LibraryCard.swift
//  WePeiYang
//
//  Created by Halcao on 2017/12/12.
//  Copyright © 2017年 twtstudio. All rights reserved.
//

import UIKit
import SwiftMessages
import PopupDialog

class LibraryCard: CardView {
    let titleLabel = UILabel()
    let tableView = UITableView()
    let refreshButton = CardButton()
    let renewButton = CardButton()
    let toggleButton = CardButton()

    override func initialize() {
        super.initialize()
        
        self.backgroundColor = .white

        titleLabel.text = "图书馆"
        titleLabel.font = UIFont.systemFont(ofSize: 25, weight: UIFont.Weight.semibold)
        titleLabel.textColor = .black
        contentView.addSubview(titleLabel)
        titleLabel.sizeToFit()

        tableView.rowHeight = 50
        tableView.delegate = self
        tableView.dataSource = self
        tableView.isScrollEnabled = false
        tableView.allowsSelection = false
        contentView.addSubview(tableView)

        contentView.addSubview(renewButton)
        renewButton.setTitle("一键续借")
        renewButton.layer.cornerRadius = renewButton.height/2
        renewButton.tapAction = renew

        contentView.addSubview(refreshButton)
        refreshButton.setTitle("刷新")
        refreshButton.layer.cornerRadius = refreshButton.height/2
        refreshButton.tapAction = refreshBooks

        contentView.addSubview(toggleButton)
        toggleButton.setTitle("展开")
        toggleButton.tag = LibCardState.fold.rawValue
        toggleButton.layer.cornerRadius = toggleButton.height/2
        toggleButton.tapAction = toggle


        self.height = 240
        remakeConstraints()
    }

    override func layout(rect: CGRect) {
        super.layout(rect: rect)

        blankView.frame = CGRect(x: 10, y: 50, width: rect.size.width-20, height: rect.size.height-40-cardRadius)
    }

    override func refresh() {
        guard TwTUser.shared.libBindingState == true else {
            self.setState(.failed("请绑定图书馆", .gray))
            return
        }

        // 首次刷新，之后加载缓存 
        if LibraryDataContainer.shared.response == nil {
            self.refreshBooks(sender: self.refreshButton)
        }
        CacheManager.retreive("lib/info.json", from: .group, as: LibraryResponse.self, success: { response in
            LibraryDataContainer.shared.response = response
            self.tableView.reloadData()
            self.setState(.data)
        }, failure: {
            self.refreshBooks(sender: self.refreshButton)
//            refresh()
        })
    }

    func remakeConstraints() {
        let padding: CGFloat = 20

        contentView.snp.remakeConstraints { make in
            make.edges.equalToSuperview()
        }

        titleLabel.snp.remakeConstraints { make in
            make.left.equalToSuperview().offset(padding)
            make.top.equalToSuperview().offset(padding)
            make.width.equalTo(200)
            make.height.equalTo(30)
        }

        var divideSpacing: CGFloat = 30
        if UIScreen.main.bounds.width <= .iPhoneSEWidth {
            divideSpacing = 15
        }

        let height = self.height - 140
        tableView.snp.remakeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(titleLabel.snp.bottom).offset(20)
            make.width.equalToSuperview().multipliedBy(0.9)
            make.height.equalTo(height)
        }

        renewButton.snp.remakeConstraints { make in
            make.centerX.equalToSuperview()
            make.width.equalTo(renewButton.width)
            make.height.equalTo(renewButton.height)
            make.top.equalTo(tableView.snp.bottom).offset(10)
            make.bottom.equalToSuperview().offset(-10)
        }

        refreshButton.snp.remakeConstraints { make in
            make.right.equalTo(renewButton.snp.left).offset(-divideSpacing)
            make.width.equalTo(refreshButton.width)
            make.height.equalTo(refreshButton.height)
            make.top.equalTo(tableView.snp.bottom).offset(10)
            make.bottom.equalToSuperview().offset(-10)
        }

        toggleButton.snp.remakeConstraints { make in
            make.left.equalTo(renewButton.snp.right).offset(divideSpacing+(refreshButton.width-toggleButton.width)/2)
//            make.left.equalTo(renewButton.snp.right).offset(30)
            make.width.equalTo(toggleButton.width)
            make.height.equalTo(toggleButton.height)
            make.top.equalTo(tableView.snp.bottom).offset(10)
            make.bottom.equalToSuperview().offset(-10)
        }

        self.contentView.setNeedsUpdateConstraints()
        self.contentView.layoutIfNeeded()

        blankView.snp.remakeConstraints { make in
            make.top.equalTo(tableView.snp.top)
            make.left.equalTo(tableView.snp.left)
            make.right.equalTo(tableView.snp.right)
//            make.bottom.equalTo(toggleButton.snp.bottom)
            make.bottom.equalToSuperview().offset(-10)
        }
//        contentView.setNeedsUpdateConstraints()
//        self.contentView.layoutIfNeeded()

        self.contentView.setNeedsUpdateConstraints()
        self.contentView.layoutIfNeeded()
        self.contentView.setNeedsDisplay()

//        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.2, options: .curveEaseInOut, animations: {
//            self.setNeedsDisplay()
//        }, completion: { _ in
//        })
    }
}

extension LibraryCard: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return LibraryDataContainer.shared.books.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "\(indexPath)")
        let book = LibraryDataContainer.shared.books[indexPath.row]

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYY-MM-dd"

        var image = #imageLiteral(resourceName: "感叹号")
        // 如果还没到还书时间
        if dateFormatter.string(from: Date()) <= book.returnTime {
            image = #imageLiteral(resourceName: "对号")
        }

        let imageSize = CGSize(width: 25, height: 25)
        image = UIImage.resizedImage(image: image, scaledToSize: imageSize)
        UIGraphicsBeginImageContext(imageSize)
        let imageRect = CGRect(origin: .zero, size: imageSize)
        image.draw(in: imageRect)
        cell.imageView?.contentMode = .scaleAspectFit
        cell.imageView?.image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        cell.textLabel?.text = book.title
        cell.detailTextLabel?.text = "应还时间: " + book.returnTime
        return cell
    }
}

// MARK: 点击事件
extension LibraryCard {
    func renew(sender: CardButton) {
        let popup = PopupDialog(title: "注意", message: "每个月只能续借一次\n存在逾期未还书籍不能续借")
        let okButton = DefaultButton(title: "好的") {
            let group = DispatchGroup()
            //        library/renew/{barcode}
            var count = 0
            for book in LibraryDataContainer.shared.books {
                group.enter()
                SolaSessionManager.solaSession(type: .get, url: "/library/renew/\(book.barcode)", token: "", parameters: nil, success: { dict in
                    // TODO: Check
                    count += 1
                    group.leave()
                }, failure: { err in
                    group.leave()
                    SwiftMessages.showErrorMessage(body: err.localizedDescription)
                })
            }
            group.notify(queue: .main, execute: {
                SwiftMessages.showSuccessMessage(body: "已续借\(count)本书")
                self.getBooks(success: {
                    self.tableView.reloadData()
                })
            })
        }
        popup.addButton(okButton)
        UIViewController.current?.present(popup, animated: true, completion: nil)
    }

    func updateBookStatus() {

    }

    func getBooks(success: (()->())? = nil) {
        self.setState(.loading("加载中...", .gray))
        SolaSessionManager.solaSession(type: .get, url: "/library/user/info", token: "", parameters: nil, success: { dict in
            if let data = try? JSONSerialization.data(withJSONObject: dict, options: .init(rawValue: 0)),
                let response = try? LibraryResponse(data: data) {
                LibraryDataContainer.shared.response = response
                if response.data.books.count == 0 {
                    self.setState(.empty("没有借阅书籍", .gray))
                } else {
                    self.setState(.data)
                }
                if self.toggleButton.tag == LibCardState.fold.rawValue {
                    let leftCount = LibraryDataContainer.shared.books.count - 2
                    if leftCount <= 0 {
                        self.toggleButton.setTitle("展开")
                    } else {
                        self.toggleButton.setTitle("展开(\(leftCount))")
                    }
//                    self.remakeConstraints()
                }
                self.tableView.reloadData()
                // 缓存起来撒
                CacheManager.store(object: response, in: .group, as: "lib/info.json")
                success?()
            } else {
                self.setState(.failed("加载中", .gray))
                // TODO: 解析错误
            }
        }, failure: { err in
            self.setState(.failed(err.localizedDescription, .gray))
        })
    }

    // 真正的请求
    func refreshBooks(sender: CardButton) {
        // 先折叠 再刷新
        if toggleButton.tag == LibCardState.unfold.rawValue {
            toggle(sender: toggleButton)
        }

        getBooks(success: {
            SwiftMessages.showSuccessMessage(body: "借阅列表刷新成功", context: SwiftMessages.PresentationContext.window(windowLevel: UIWindowLevelStatusBar), layout: MessageView.Layout.statusLine)
        })
    }
    private enum LibCardState: Int {
        case fold = 0
        case unfold = 1
    }

    func toggle(sender: CardButton) {
        var height: CGFloat
        if toggleButton.tag == LibCardState.fold.rawValue {
            // 展开
            height = tableView.rowHeight * CGFloat(max(LibraryDataContainer.shared.books.count, 2)) + 140
            toggleButton.setTitle("收起")
            toggleButton.tag = LibCardState.unfold.rawValue
        } else {
            // 收起
            height = tableView.rowHeight * 2 + 140
            let moreCount = LibraryDataContainer.shared.books.count-2
            if moreCount > 0 {
                toggleButton.setTitle("展开(\(moreCount))")
            } else {
                toggleButton.setTitle("展开")
            }
            toggleButton.tag = LibCardState.fold.rawValue
        }
        self.height = height
        remakeConstraints()

        let info: [String : Any] = ["name": Module.library.rawValue, "height": height as CGFloat]
        NotificationCenter.default.post(name: NotificationName.NotificationCardWillRefresh.name, object: nil, userInfo: info)
    }
}

extension LibraryCard: UITableViewDelegate {
}

