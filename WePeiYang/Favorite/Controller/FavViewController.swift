//  FavViewController.swift
//  WePeiYang
//
//  Created by Allen X on 4/28/17.
//  Copyright © 2017 twtstudio. All rights reserved.
//

import UIKit
import ObjectMapper
import SnapKit

let MessageKey = "MessageKey"
class FavViewController: UIViewController {

    // The below override will not be called if current viewcontroller is controlled by a UINavigationController
    // We should do self.navigationController.navigationBar.barStyle = UIBarStyleBlack
//    override var preferredStatusBarStyle: UIStatusBarStyle {
//        return .lightContent
    //    }
    var headerView: UIView!
    var fooView: UIView!
    var cardTableView: UITableView!
    var cardDict: [Module: CardView] = [:]
    var cellHeights: [CGFloat] = []

    var modules: [Module] = []

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.setNavigationBarHidden(true, animated: animated)
        navigationController?.navigationBar.shadowImage = UIImage()
        //
        //        navigationController?.navigationBar.barStyle = .black
        //        navigationController?.navigationBar.barTintColor = Metadata.Color.WPYAccentColor
        //        //Changing NavigationBar Title color
        //        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: Metadata.Color.naviTextColor]
        //
        //        navigationItem.title = "常用"
        refreshCards(info: Notification(name: NotificationName.NotificationCardWillRefresh.name))
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationController?.navigationBar.barStyle = .black
//        navigationController?.navigationBar.barTintColor = Metadata.Color.WPYAccentColor
        // Changing NavigationBar Title color
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: Metadata.Color.naviTextColor]
        // This is for removing the dark shadows when transitioning
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.isNavigationBarHidden = true

        navigationItem.title = "常用"

        //        view.backgroundColor = Metadata.Color.GlobalViewBackgroundColor
        view.backgroundColor = .white

        self.automaticallyAdjustsScrollViewInsets = false
        let statusBarHeight: CGFloat = UIScreen.main.bounds.height == 812 ? 44 : 20
        let tabBarHeight = self.tabBarController?.tabBar.height ?? 0

        let placeholderLabel = UILabel(text: "什么都不加你还想看什么😒", color: .lightGray)
        placeholderLabel.font = UIFont.flexibleSystemFont(ofSize: 20, weight: .medium)
        placeholderLabel.sizeToFit()
        view.addSubview(placeholderLabel)

        cardTableView = UITableView(frame: CGRect(x: 0, y: statusBarHeight, width: deviceWidth, height: deviceHeight-statusBarHeight-tabBarHeight), style: .grouped)

        placeholderLabel.center = cardTableView.center

        view.addSubview(cardTableView)

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

        dateLabel.textColor = UIColor(red: 0.36, green: 0.36, blue: 0.36, alpha: 1.00)
        dateLabel.text = formatter.string(from: now).uppercased()
        dateLabel.font = UIFont.systemFont(ofSize: 15)
        dateLabel.x = 15
        dateLabel.y = 15
        dateLabel.sizeToFit()
        headerView.addSubview(dateLabel)

        let titleLabel = UILabel(text: "Favorite")
        titleLabel.font = UIFont.systemFont(ofSize: 35, weight: UIFont.Weight.heavy)
        titleLabel.x = 15
        titleLabel.y = 35
        titleLabel.sizeToFit()
        headerView.addSubview(titleLabel)
        _ = NotificationCenter.default.addObserver(forName: NotificationName.NotificationCardWillRefresh.name, object: nil, queue: nil, using: { notification in
            // 这个地方很丑陋
            if let info = notification.userInfo,
                let nameString = info["name"] as? String,
                let name = Module(rawValue: nameString),
                let height = info["height"] as? CGFloat,
                let card = self.cardDict[name],
                let row = self.modules.index(where: { $0 == name }) {
                let indexPath = IndexPath(row: row, section: 0)
                let cell = self.cardTableView.cellForRow(at: indexPath)

                self.cellHeights[row] = height

                card.snp.updateConstraints { make in
                    make.height.equalTo(height)
                }

                card.setNeedsUpdateConstraints()
                cell?.setNeedsUpdateConstraints()
                UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.2, options: .curveEaseInOut, animations: {
                    card.layoutIfNeeded()
                    //                    cell?.contentView.layoutIfNeeded()
                    cell?.layoutIfNeeded()
                }, completion: { _ in
                })

                //                self.cardTableView.endUpdates()
                self.cardTableView.reloadData()
                self.cardTableView.scrollToRow(at: indexPath, at: UITableViewScrollPosition.middle, animated: true)
                //                self.cardTableView.reloadRows(at: [indexPath], with: .automatic)
            } else {
                self.refreshCards(info: notification)
            }
        })

        reloadOrder()

        NotificationCenter.default.addObserver(self, selector: #selector(refreshCards), name: NotificationName.NotificationUserDidLogout.name, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(refreshCards), name: NotificationName.NotificationUserDidLogin.name, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(reloadOrder), name: NotificationName.NotificationCardOrderChanged.name, object: nil)

        SolaSessionManager.solaSession(type: .get, url: "/app/message", token: nil, parameters: nil, success: { dict in
            if let data = dict["data"] as? [String: Any],
                let version = data["version"] as? Int,
                let title = data["title"] as? String,
                let message = data["message"] as? String {
                let prev = UserDefaults.standard.integer(forKey: MessageKey)
                if version > prev {
                    // new message
                    SwiftMessages.showNotification(title: title, message: message, handler: { _ in
                        UserDefaults.standard.set(version, forKey: MessageKey)
                        SwiftMessages.hideAll()
                    })
                }
            }
        })
    }

    // 重新加载顺序
    @objc func reloadOrder() {
        modules = ModuleStateManager.getModules()
        initCards()
    }

    // 重新加载数据
    @objc func refreshCards(info: Notification) {
        if modules.isEmpty {
            view.sendSubview(toBack: cardTableView)
        } else {
            view.bringSubview(toFront: cardTableView)
        }

        for item in modules {
            cardDict[item]?.refresh()
        }

        switch info.name {
        case NotificationName.NotificationUserDidLogin.name:
            cardTableView.reloadData()
        case NotificationName.NotificationUserDidLogout.name:
            cardTableView.reloadData()
        default:
            return
        }
    }

    // 初始化卡片
    func initCards() {
        for module in modules where cardDict[module] == nil {
            switch module {
            case .classtable:
                initClassTableCard()
            case .gpa:
                initGPACard()
            case .library:
                initLibraryCard()
            case .ecard:
                initEcard()
            case .exam:
                initExamCard()
            }
        }
        cardTableView.reloadData()
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

extension FavViewController {
    func initGPACard() {
        let card = GPACard()

//        card.refresh()

//        let gpaVC = GPAViewController()
//        let gpaNC = UINavigationController(rootViewController: gpaVC)
//        card.shouldPresent(gpaNC, from: self)
        card.shouldPresent(GPAViewController.self, from: self)
//        card.shouldPush(gpaVC, from: self)
        card.delegate = self
        cardDict[Module.gpa] = card
    }

    func initClassTableCard() {
        let card = ClassTableCard()

        card.delegate = self

        defer {
            card.shouldPresent(ClassTableViewController.self, from: self)
            cardDict[Module.classtable] = card
        }

//        card.refresh()
    }

    func initLibraryCard() {
        let card = LibraryCard()
        card.delegate = self

        card.refresh()
        card.shouldPresent(LibraryMainViewController.self, from: self)
        cardDict[Module.library] = card
    }

    func initEcard() {
        let card = ECardView()
        card.delegate = self
        card.refresh()
        card.shouldPresent(CardTransactionViewController.self, from: self)
        cardDict[Module.ecard] = card
    }

    func initExamCard() {
        let card = ExamCard()
        card.delegate = self
        card.refresh()
        card.shouldPresent(CardTransactionViewController.self, from: self)
        cardDict[Module.exam] = card
    }
}Module.

extension FavViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return modules.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let module = modules[indexPath.row]

//        let key = Array(cardDict.keys)[indexPath.row]
        let card = cardDict[module]!
        var cell = tableView.dequeueReusableCell(withIdentifier: "card\(module)")

        if cell == nil {
            // no cell in reuse pool
            cell = UITableViewCell(style: .default, reuseIdentifier: "card\(module)")
            cell!.contentView.addSubview(card)
            card.sizeToFit()
            let cellHeight: CGFloat = 240
            card.snp.makeConstraints { make in
                make.top.equalToSuperview().offset(10)
                make.bottom.equalToSuperview().offset(-10)
                make.height.equalTo(cellHeight)
                if isiPad {
                    make.centerX.equalToSuperview()
                    make.width.equalToSuperview().multipliedBy(0.6)
                } else {
                    make.left.equalToSuperview().offset(15)
                    make.right.equalToSuperview().offset(-15)
                }
            }
            cellHeights.append(cellHeight)
            cell?.setNeedsLayout()
            cell?.layoutIfNeeded()
        }

        return cell!
    }
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

extension FavViewController: CardViewDelegate {
    func cardIsTapped(card: CardView) {
        if TwTUser.shared.token == nil {
            card.superVC = nil
            showLoginView(success: {
//                card.superVC = self
            })
        } else {
            card.superVC = self
        }
    }
}
