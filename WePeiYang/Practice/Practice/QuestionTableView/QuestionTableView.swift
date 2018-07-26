//
//  File.swift
//  WePeiYang
//
//  Created by yuting jiang on 2018/7/16.
//  Copyright © 2018年 twtstudio. All rights reserved.
//

import Foundation

struct QuestionViewParameters {
    static let questionViewW = 0.9 * deviceWidth
    static let questionViewH = 0.48 * deviceHeight
    static let cellH = 0.04 * deviceHeight
    static let optionGap = 0.06 * deviceHeight
}

class QuestionTableView: UITableView {
    
    var content: String?
    var options: [String?] = []
  
    override init(frame: CGRect, style: UITableViewStyle) {
        super.init(frame: frame, style: style)
        
        content =  "以下不属于共同的论证评价标准的是()。以下不属于共同的论证评价标准的是()。"
        options = ["逻辑标准", "修辞标准", "论辩标准", "分析标准"]
        
        initTableView()
    }
    
    func initTableView() {
        self.separatorStyle = .none
        self.showsVerticalScrollIndicator = false
        self.bounces = false
        self.delegate = self
        self.dataSource = self
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        self.delegate = nil
        print("QuestionTableView deinit")
    }

}

extension QuestionTableView: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return options.count + 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.item {
        case 0:
            let questionCell = QuestionCell()
            questionCell.initQCell(question: content)
            return questionCell
        case 1:
            return OptionsCell()
        default:
            let optionCell = OptionsCell()
            optionCell.initUI(order: indexPath.item - 2, optionsContent: options[indexPath.item - 2])
            return optionCell
        }

    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        cellForRow(at: indexPath)?.contentView
    }
}

extension QuestionTableView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.item {
        case 0:
            if let question = content {
                let height = question.calculateHeightWithConstrained(width: frame.width, font: QuestionViewParameters.qFont) < 35 ? 35 : question.calculateHeightWithConstrained(width: frame.width, font: QuestionViewParameters.qFont)
                return height
            } else {
                return 44
            }
            
        case 1:
            return 0.02 * deviceHeight
            
        default:
            if let option = options[indexPath.item - 2] {
                let height = option.calculateHeightWithConstrained(width: QuestionViewParameters.optionLabelW, font: QuestionViewParameters.aFont) + QuestionViewParameters.optionsOffsetY * 2
                let oHeight = height < 60 ? 60 : height
                return oHeight
            } else {
                return QuestionViewParameters.cellH
            }
            
        }

    }
}
