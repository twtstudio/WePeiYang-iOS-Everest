
//
//  GPAViewController.swift
//  WePeiYang
//
//  Created by Halcao on 2017/7/11.
//  Copyright © 2017年 twtstudio. All rights reserved.
//

import UIKit
import Charts

class GPAViewController: UIViewController {
    var headerView: UIView!
    var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        headerView = ScoreHeaderView(frame: CGRect.zero)
        tableView = UITableView(frame: self.view.bounds, style: .grouped)
        tableView.delegate = self
        tableView.dataSource = self
        self.view.addSubview(tableView)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension GPAViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 0
        case 1:
            return 0
        case 2:
            return 0
        case 3:
            return 5 // number of classes in current term
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = "\(indexPath.row)"
        return UITableViewCell()
    }

}

extension GPAViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        switch section {
        case 0:
            return ScoreHeaderView()
        case 1:
            let lineChartView = LineChartView(frame: CGRect(x: 0, y: 0, width: self.view.width, height: 200))
            lineChartView.dragEnabled = false
            lineChartView.pinchZoomEnabled = false
            lineChartView.doubleTapToZoomEnabled = false
            lineChartView.drawGridBackgroundEnabled = false
            lineChartView.leftAxis.drawGridLinesEnabled = false
            lineChartView.rightAxis.enabled = false
            lineChartView.xAxis.drawGridLinesEnabled = false
//            lineChartView.backgroundColor = UIColor(red:0.99, green:0.66, blue:0.60, alpha:1.00)
            let s1 = LineChartDataSet(values: [ChartDataEntry(x: 1, y: 90), ChartDataEntry(x: 2, y: 80), ChartDataEntry(x: 3, y: 70), ChartDataEntry(x: 4, y: 90)], label: "第一学期")
            s1.mode = .cubicBezier
            s1.drawCirclesEnabled = true
            s1.circleRadius = 4
            s1.drawFilledEnabled = true
            s1.fillColor = UIColor(red:0.99, green:0.66, blue:0.60, alpha:1.00)
            s1.fillAlpha = 1
            s1.setColor(UIColor(red:0.98, green:0.49, blue:0.41, alpha:1.00))
            lineChartView.data  = LineChartData(dataSet: s1)
            return lineChartView
        case 2:
            return ScoreHeaderView()
        case 3:
            return nil // number of classes in current term
        default:
            return nil
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch section {
        case 0:
            return 120
        case 1:
            return 200
        case 2:
            return 200
        default:
            return 0.01
        }
    }
}

extension GPAViewController: ChartViewDelegate {
    
}


class ScoreHeaderView: UIView {
    let totalScoreLabel: UILabel = {
        
        return UILabel()
    }()
    let totalGPALabel: UILabel = {
        
        return UILabel()
    }()
    let totalCreditLabel: UILabel = {
        
        return UILabel()
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(totalScoreLabel)
        self.addSubview(totalGPALabel)
        self.addSubview(totalGPALabel)
        layout()
        // Total height: 40 + LabelHeight + 20 + smallLabelHeight + 40
    }
    
    func layout() {
        // constants
        let topPadding: CGFloat = 40
        let baseWidth: CGFloat = UIScreen.main.bounds.width/4
        let bottomPadding = topPadding
        let labelPadding: CGFloat = 20
        
        totalScoreLabel.center.x = baseWidth*1
        totalGPALabel.center.x = baseWidth*2
        totalCreditLabel.center.x = baseWidth*3
        
        totalScoreLabel.y = topPadding
        totalGPALabel.y = topPadding
        totalCreditLabel.y = topPadding
        
        // color
        let scoreHintLabel = UILabel(text: "总加权", color: .black, fontSize: 14)
        let GPAHintLabel = UILabel(text: "总绩点", color: .black, fontSize: 14)
        let creditHintLabel = UILabel(text: "总学分", color: .black, fontSize: 14)
        
        self.addSubview(scoreHintLabel)
        self.addSubview(GPAHintLabel)
        self.addSubview(creditHintLabel)

        scoreHintLabel.center.x = baseWidth*1
        GPAHintLabel.center.x = baseWidth*2
        creditHintLabel.center.x = baseWidth*3
        
        scoreHintLabel.y = totalScoreLabel.x + totalScoreLabel.height + labelPadding
        GPAHintLabel.y = scoreHintLabel.y
        creditHintLabel.y = scoreHintLabel.y
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
