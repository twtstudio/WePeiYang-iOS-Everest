//
//  ECardHomeView.swift
//  WePeiYang
//
//  Created by JasonEWNL on 2019/3/14.
//  Copyright © 2019年 twtstudio. All rights reserved.
//

import UIKit

enum ECardDetailCategory {
    case recharge
    case consumption
}

class ECardHomeViewCell: UITableViewCell {
    
    private var eCardDetail: ECardDetail!
    
    private let categoryIcon = UIImageView()
    private let venueLabel = UILabel()
    private let facilityLabel = UILabel()
    private let amountLabel = UILabel()
    
    convenience init(byModel eCardTurnover: ECardTurnoverModel, withCategory category: ECardDetailCategory, andIndex index: Int) {
        self.init(style: .default, reuseIdentifier: "ECardHomeViewCell")
        
        switch category {
        case .recharge:
            eCardDetail = eCardTurnover.data.recharge[index]
        case .consumption:
            eCardDetail = eCardTurnover.data.consumption[index]
        }
        
        categoryIcon.frame = CGRect(x: 20, y: 20, width: 64, height: 64)
        // categoryIcon.image =
        contentView.addSubview(categoryIcon)
        
        venueLabel.text = eCardDetail.location
        venueLabel.textColor = .eCardDark
        venueLabel.sizeToFit()
        contentView.addSubview(venueLabel)
    }

}
