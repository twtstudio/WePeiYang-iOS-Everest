//
//  ECardView.swift
//  WePeiYang
//
//  Created by Halcao on 2018/11/27.
//  Copyright © 2018 twtstudio. All rights reserved.
//

import UIKit
import Charts
import ObjectMapper

class ECardView: CardView {
    private let titleLabel = UILabel()
    private let balanceLabel = UILabel()
    private let cardnumHintLabel = UILabel()
    private let expiryHintLabel = UILabel()
    private let cardnumLabel = UILabel()
    private let expiryLabel = UILabel()

//    override func initialize() {
//        super.initialize()
//        let padding: CGFloat = 20
//
//        titleLabel.frame = CGRect(x: padding, y: padding, width: 200, height: 30)
//        titleLabel.text = "校园卡"
//        titleLabel.font = UIFont.systemFont(ofSize: 25, weight: UIFont.Weight.semibold)
//        titleLabel.textColor = .black
//        titleLabel.sizeToFit()
//        self.addSubview(titleLabel)
//
//        balanceLabel.frame = CGRect(x: padding, y: padding + 30 + 20, width: 200, height: 30)
//        balanceLabel.font = UIFont.systemFont(ofSize: 25, weight: UIFont.Weight.bold)
//        balanceLabel.textColor = .black
////        balanceLabel.sizeToFit()
//        self.addSubview(balanceLabel)
//
//        self.backgroundColor = .white
//    }

    override func initialize() {
        super.initialize()
        let padding: CGFloat = 20
        titleLabel.text = "校园卡"
        titleLabel.font = UIFont.systemFont(ofSize: 25, weight: UIFont.Weight.semibold)
        titleLabel.textColor = .black
        titleLabel.sizeToFit()
        self.addSubview(titleLabel)

        titleLabel.snp.makeConstraints { make in
            make.left.top.equalToSuperview().offset(padding)
            make.width.equalTo(200)
            make.height.equalTo(30)
        }

        balanceLabel.font = UIFont.systemFont(ofSize: 25, weight: UIFont.Weight.medium)
        balanceLabel.textColor = .black
        balanceLabel.sizeToFit()
        balanceLabel.textAlignment = .center
        self.addSubview(balanceLabel)
        balanceLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.equalTo(200)
            make.height.equalTo(30)
        }

        cardnumLabel.textColor = .darkGray
        cardnumLabel.font = UIFont.systemFont(ofSize: 13)
        self.addSubview(cardnumLabel)
        cardnumLabel.snp.makeConstraints { make in
            make.bottom.equalToSuperview().offset(-padding)
            make.left.equalToSuperview().offset(padding)
            make.width.equalTo(100)
            make.height.equalTo(20)
        }

        cardnumHintLabel.text = "CARD NO."
        cardnumHintLabel.textColor = .gray
        cardnumHintLabel.font = UIFont.systemFont(ofSize: 13)
        self.addSubview(cardnumHintLabel)
        cardnumHintLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(padding)
            make.bottom.equalTo(cardnumLabel.snp.top).offset(-4)
        }

        expiryLabel.textColor = .darkGray
        expiryLabel.font = UIFont.systemFont(ofSize: 13)
        self.addSubview(expiryLabel)
        expiryLabel.snp.makeConstraints { make in
            make.bottom.equalToSuperview().offset(-padding)
            make.right.equalToSuperview().offset(-padding)
            make.width.equalTo(100)
            make.height.equalTo(20)
        }

        expiryHintLabel.text = "EXPIRY"
        expiryHintLabel.textColor = .gray
        expiryHintLabel.font = UIFont.systemFont(ofSize: 13)
        self.addSubview(expiryHintLabel)
        expiryHintLabel.snp.makeConstraints { make in
            make.left.equalTo(expiryLabel.snp.left)
            make.bottom.equalTo(expiryLabel.snp.top).offset(-4)
        }
    }

    override func layout(rect: CGRect) {
        let padding: CGFloat = 20

        let layerWidth = rect.width - 2*padding
        let layerHeight = rect.height - 2*padding - 40

        blankView.frame = CGRect(x: padding, y: padding + 30 + 15, width: layerWidth, height: layerHeight)

        super.layout(rect: rect)
    }

    func load(_ profile: EcardProfile) {
        self.balanceLabel.text = "¥" + profile.balance.replacingOccurrences(of: "元", with: "")
        self.cardnumLabel.text = profile.cardnum
        self.expiryLabel.text = profile.expiry
    }

    override func refresh() {
        super.refresh()
        guard TwTUser.shared.ecardBindingState == true else {
            self.setState(.failed("请绑定校园卡", .gray))
            return
        }

        setState(.loading("加载中...", .gray))
        guard TwTUser.shared.token != nil else {
            return
        }

        ECardAPI.getProfile(success: { profile in
            self.setState(.data)
            self.load(profile)
        }, failure: { err in
            self.setState(.failed(err.localizedDescription, .gray))
//            SwiftMessages.showErrorMessage(body: err.localizedDescription)
        })
//        CacheManager.retreive("gpa/gpa.json", from: .group, as: String.self, success: { string in
//            if let model = Mapper<GPAModel>().map(JSONString: string) {
//                if model.terms.count > 1 {
//                    self.setState(.data)
//                    self.load(model: model)
//                } else {
//                    self.setState(.empty("◉", .white))
//                }
//            } else {
//                self.setState(.failed("加载失败", .white))
//            }
//        })
    }
}
