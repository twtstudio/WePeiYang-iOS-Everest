
//
//  LibraryCard.swift
//  WePeiYang
//
//  Created by Halcao on 2017/12/12.
//  Copyright © 2017年 twtstudio. All rights reserved.
//

import UIKit
import SwiftMessages

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
        refreshButton.tapAction = refresh

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
        remakeConstraints()
    }

    override func refresh() {
        refresh(sender: refreshButton)
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

        let height = self.height - 125
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

        blankView.snp.updateConstraints { make in
            make.top.equalTo(tableView.snp.top)
            make.left.equalTo(tableView.snp.left)
            make.right.equalTo(tableView.snp.right)
//            make.bottom.equalTo(tableView.snp.bottom).offset(10+toggleButton.height+5)
            make.bottom.equalTo(toggleButton.snp.bottom)
            make.height.equalTo(height + 10 + toggleButton.height)
//            make.bottom.equalToSuperview()
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
        dateFormatter.dateFormat = "YYYY-MM-DD"

        var image = #imageLiteral(resourceName: "感叹号")
        // 如果还没到还书时间
        if let date = dateFormatter.date(from: book.returnTime),
            date >= Date() {
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
                // TODO: 解析错误
            })
        }
        group.notify(queue: .main, execute: {
            SwiftMessages.showSuccessMessage(body: "成功续借\(count)本书")
            self.getBooks(success: {
                self.tableView.reloadData()
            })
        })
    }

    func updateBookStatus() {

    }

    func getBooks(success: (()->())? = nil) {
        self.setState(.loading("加载中...", .gray))
        SolaSessionManager.solaSession(type: .get, url: "/library/user/info", token: "", parameters: nil, success: { dict in
            if let data = try? JSONSerialization.data(withJSONObject: dict, options: .init(rawValue: 0)),
                let response = try? LibraryResponse(data: data) {
                LibraryDataContainer.shared.response = response
                self.setState(.data)
                if response.data.books.count == 0 {
                    self.setState(.empty("没有待还的书籍", .gray))
                }
                if self.toggleButton.tag == 0 {
                    let leftCount = LibraryDataContainer.shared.books.count - 2
                    if leftCount == 0 {
                        self.toggleButton.setTitle("展开")
                    } else {
                        self.toggleButton.setTitle("展开(\(leftCount))")
                    }
                    self.remakeConstraints()
                }
                self.tableView.reloadData()
                // 缓存起来撒
                CacheManager.store(object: response, in: .group, as: "lib/info.json")
//                Storage.store(response, in: .group, as: "lib")
//                Storage.store(response, in: .caches, as: CacheFilenameKey.libUserInfo.name)
                success?()
            } else {
                self.setState(.failed("解析失败"))
                // TODO: 解析错误
            }
        }, failure: { err in
            self.setState(.failed(err.localizedDescription))
        })
    }

    func refresh(sender: CardButton) {
        // 先折叠 再刷新
        if toggleButton.tag == LibCardState.unfold.rawValue {
            toggle(sender: toggleButton)
        }

        getBooks(success: {
            self.setState(.data)
            SwiftMessages.showSuccessMessage(body: "借阅列表刷新成功", context: SwiftMessages.PresentationContext.window(windowLevel: UIWindowLevelStatusBar), layout: MessageView.Layout.statusLine)
        })
    }
    private enum LibCardState: Int {
        case fold = 0
        case unfold = 1
    }

    func toggle(sender: CardButton) {
        var height: CGFloat = 0
        if sender.tag == LibCardState.fold.rawValue {
            // 展开
            height = tableView.rowHeight * CGFloat(max(LibraryDataContainer.shared.books.count, 2)) + 125
            sender.setTitle("收起")
            sender.tag = LibCardState.unfold.rawValue
        } else {
            // 收起
            height = tableView.rowHeight * 2 + 125
            let moreCount = LibraryDataContainer.shared.books.count-2
            if moreCount > 0 {
                sender.setTitle("展开(\(moreCount))")
            } else {
                sender.setTitle("展开")
            }
            sender.tag = LibCardState.fold.rawValue
        }
        self.height = height
        remakeConstraints()

        let info: [String : Any] = ["name": Module.library.rawValue, "height": height as CGFloat]
        NotificationCenter.default.post(name: NotificationName.NotificationCardWillRefresh.name, object: nil, userInfo: info)
    }
}

extension LibraryCard: UITableViewDelegate {
}

