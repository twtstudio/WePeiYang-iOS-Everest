//
//  ECardView.swift
//  WePeiYang
//
//  Created by Halcao on 2018/11/27.
//  Copyright © 2018 twtstudio. All rights reserved.
//

import UIKit

class ECardView: CardView {
    private let titleLabel = UILabel()
    private let balanceLabel = UILabel()
    private let cardnumHintLabel = UILabel()
    private let balanceHintLabel = UILabel()
    private let cardnumLabel = UILabel()
    private let todayHintLabel = UILabel()
    private let todayLabel = UILabel()

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

        todayLabel.font = UIFont.systemFont(ofSize: 25, weight: UIFont.Weight.medium)
        todayLabel.textColor = .black
        todayLabel.sizeToFit()
        todayLabel.textAlignment = .center
        self.addSubview(todayLabel)
        todayLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.equalTo(100)
            make.height.equalTo(30)
        }

        todayHintLabel.textColor = .darkGray
        todayHintLabel.text = "今日消费: "
        todayHintLabel.textAlignment = .right
        todayHintLabel.font = UIFont.systemFont(ofSize: 13)
        self.addSubview(todayHintLabel)
        todayHintLabel.snp.makeConstraints { make in
            make.bottom.equalTo(todayLabel.snp.bottom)
            make.right.equalTo(todayLabel.snp.left)
            make.width.equalTo(100)
            make.height.equalTo(20)
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

        balanceLabel.textColor = .darkGray
        balanceLabel.font = UIFont.systemFont(ofSize: 13)
        self.addSubview(balanceLabel)
        balanceLabel.snp.makeConstraints { make in
            make.bottom.equalToSuperview().offset(-padding)
            make.right.equalToSuperview().offset(-padding)
            make.width.equalTo(100)
            make.height.equalTo(20)
        }

        balanceHintLabel.text = "余额"
        balanceHintLabel.textColor = .gray
        balanceHintLabel.font = UIFont.systemFont(ofSize: 13)
        self.addSubview(balanceHintLabel)
        balanceHintLabel.snp.makeConstraints { make in
            make.left.equalTo(balanceLabel.snp.left)
            make.bottom.equalTo(balanceLabel.snp.top).offset(-4)
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
        self.todayLabel.text = "¥" + profile.amount
        self.balanceLabel.text = "¥" + profile.balance.replacingOccurrences(of: "元", with: "")
        self.cardnumLabel.text = profile.cardnum
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
        })
    }
}
