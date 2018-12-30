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

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func setData(_ exam: ExamModel) {
        nameLabel.text = exam.name
        locationLabel.text = exam.location + "#" + exam.seat
        arrangeLabel.text = exam.arrange
        if exam.ext != "" && exam.state != "正常" {
            extLabel.isHidden = true
        } else {
            extLabel.isHidden = false
            extLabel.text = exam.state + ": " + exam.ext
        }
    }
}
