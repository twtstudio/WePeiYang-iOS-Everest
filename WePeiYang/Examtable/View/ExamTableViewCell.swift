//
//  ExamTableViewCell.swift
//  WePeiYang
//
//  Created by Halcao on 2018/12/30.
//  Copyright © 2018 twtstudio. All rights reserved.
//

import UIKit

class ExamTableViewCell: UITableViewCell {
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var arrangeLabel: UILabel!
    @IBOutlet weak var extLabel: UILabel!
    @IBOutlet weak var dayLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func setData(_ exam: ExamModel, displayDate: Bool = false) {
//        let day = BookCard.calculateDay(returnTime: exam.date) + 1
//        if day < 7 {
//            dayLabel.textColor = UIColor.yellow
//        } else if day < 3 {
//            dayLabel.textColor = UIColor.red
//        }
//        let offset = day > 0 ? "\(BookCard.calculateDay(returnTime: exam.date))天" : ""
//        dayLabel.text = offset
        if displayDate {
            let shortName = exam.name.prefix(6)
            nameLabel.text = shortName + " " + exam.location + "#SEAT " + exam.seat
            locationLabel.text = exam.date
            arrangeLabel.text = exam.arrange
        } else {
            nameLabel.text = exam.name
            locationLabel.text = exam.location + "#SEAT " + exam.seat
            arrangeLabel.text = exam.arrange
        }

        if exam.ext == "" && exam.state == "正常" {
            extLabel.isHidden = true
        } else {
            extLabel.isHidden = false
            extLabel.text = exam.state + ": " + exam.ext
        }
    }
}
