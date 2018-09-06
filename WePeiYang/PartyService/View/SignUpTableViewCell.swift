//
//  SignUpTableViewCell.swift
//  WePeiYang
//
//  Created by Allen X on 8/19/16.
//  Copyright © 2016 Qin Yubo. All rights reserved.
//

import UIKit

class SignUpTableViewCell: UITableViewCell {

    var signUpBtn: UIButton!
    var msgLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @objc func signUp(_ sender: UIButton!) {

        switch sender.tag {

        case 0:
            ApplicantTest.ApplicantEntry.signUp(forID: (ApplicantTest.ApplicantEntry.testInfo?.id)!) {
                self.refreshUI()
            }
        case 1:
            ApplicantTest.AcademyEntry.signUp(forID: (ApplicantTest.AcademyEntry.testInfo?.id)!) {
                self.refreshUI()
            }
        case 2:
            ApplicantTest.ProbationaryEntry.singUp(forID: (ApplicantTest.ProbationaryEntry.testInfo?.id)!) {
                self.refreshUI()
            }
        default:
            break
        }
       // log.word("entered func")/
    }

}

extension SignUpTableViewCell {
    convenience init(status: Int?, message: String?, hasEntry: Int?, testIdentifier: Int) {
        self.init()
        signUpBtn = UIButton(status: status, hasEntry: hasEntry, identifier: testIdentifier)
        //signUpBtn.bindToFunc()

        if status == 1 {
            signUpBtn.addTarget(self, action: #selector(SignUpTableViewCell.signUp(_:)), for: .touchUpInside)
        }
        msgLabel = UILabel(text: message)
        msgLabel.numberOfLines = 0

        contentView.addSubview(signUpBtn)
        signUpBtn.snp.makeConstraints {
            make in
            make.centerY.equalTo(contentView)
            make.left.equalTo(contentView).offset(16)
            make.width.equalTo(80)
            make.height.equalTo(40)
        }

        contentView.addSubview(msgLabel)
        msgLabel.snp.makeConstraints {
            make in
            make.centerY.equalTo(signUpBtn)
            make.right.equalTo(contentView).offset(-16)
            make.left.equalTo(signUpBtn.snp.right).offset(50)

        }
    }

    func refreshUI() {
        self.signUpBtn.refreshViewForState()
        switch signUpBtn.tag {
        case 0:
            msgLabel.text = ApplicantTest.ApplicantEntry.message
        case 1:
            msgLabel.text = ApplicantTest.AcademyEntry.message
        case 2:
            msgLabel.text = ApplicantTest.ProbationaryEntry.message
        default: break

        }
    }
}

private extension UIButton {

    convenience init(status: Int?, hasEntry: Int?, identifier: Int) {
        self.init()

        if status != nil && status != 0 {
            if hasEntry != nil {
                if hasEntry == 0 {
                    backgroundColor = .green
                    setTitle("报名", for: [.normal, .highlighted, .disabled, .selected, .focused, .application, .reserved])
                } else {
                    backgroundColor = .lightGray
                    setTitle("已报名", for: [.normal, .highlighted, .disabled, .selected, .focused, .application, .reserved])
                    isEnabled = false
                }
            }
        } else {
            backgroundColor = .lightGray
            setTitle("报名", for: [.normal, .highlighted, .disabled, .selected, .focused, .application, .reserved])
            isEnabled = false
        }

        layer.cornerRadius = 8
        titleLabel?.textColor = .white
        tag = identifier
        //titleLabel?.sizeToFit()

    }

    func refreshViewForState() {

        var status: Int? = nil
        var hasEntry: Int? = nil

        switch self.tag {
        case 0:
            status = ApplicantTest.ApplicantEntry.status!
            hasEntry = ApplicantTest.ApplicantEntry.testInfo?.hasEntry
        case 1:
            status = ApplicantTest.AcademyEntry.status!
            hasEntry = ApplicantTest.AcademyEntry.testInfo?.hasEntry
        case 2:
            status = ApplicantTest.ProbationaryEntry.status!
            hasEntry = ApplicantTest.ProbationaryEntry.testInfo?.hasEntry

        default:
            status = 0

        }

        if status != nil && status != 0 {
            if hasEntry != nil {
                if hasEntry == 0 {
                    backgroundColor = .green
                } else {
                    backgroundColor = .lightGray
                    setTitle("已报名", for: [.normal, .highlighted, .disabled, .selected, .focused, .application, .reserved])
                    isEnabled = false
                }
            }
        } else {
            backgroundColor = .lightGray
            isEnabled = false
        }
    }

}
