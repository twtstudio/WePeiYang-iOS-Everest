
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
    
    // This property actually won't do nothing if the controller is in UINavigationController.
    // If you want to change color of status bar,
    // just set self.navigationController.navigationBar.barStyle
//    override var preferredStatusBarStyle: UIStatusBarStyle {
//            return .lightContent
//    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.navigationBar.barStyle = .default
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        headerView = ScoreHeaderView(frame: CGRect.zero)
        tableView = UITableView(frame: self.view.bounds, style: .grouped)
        tableView.delegate = self
        tableView.dataSource = self
        self.view.backgroundColor = .white
        tableView.backgroundColor = .white
        self.view.addSubview(tableView)
        let refreshItem = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(self.refresh))
        refreshItem.tintColor = .white
        self.navigationItem.rightBarButtonItem = refreshItem
    }
    
    func refresh() {

    }
    
    func segmentValueChanged(sender: UISegmentedControl) {
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.navigationBar.isTranslucent = UINavigationBar.appearance().isTranslucent
        self.navigationController?.navigationBar.shadowImage = UINavigationBar.appearance().shadowImage
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension GPAViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 7
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
            return 0
        case 4:
            return 0
        case 5:
            return 0
        case 6:
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
            let header = ScoreHeaderView()
            header.totalScoreLabel.text = "88.54"
            header.totalGPALabel.text = "3.65"
            header.totalCreditLabel.text = "84.5"
//            header.totalScoreLabel.sizeToFit()
//            header.totalGPALabel.sizeToFit()
//            header.totalCreditLabel.sizeToFit()
            return header
        case 1:
            let contentView = UIView()
            contentView.width = self.view.width
            contentView.height = 60
            contentView.backgroundColor = .white
            let label = UILabel()
            label.textColor = UIColor(red:0.22, green:0.22, blue:0.22, alpha:1.00)
            label.font = UIFont.systemFont(ofSize: 16, weight: UIFontWeightLight)
            label.text = "大二上"
            label.sizeToFit()
            label.center = contentView.center
            contentView.addSubview(label)
            let leftButton = UIButton(frame: CGRect(x: self.view.width/4, y: label.y, width: 20, height: 20))
            leftButton.setImage(UIImage(named: "leftArrow"), for: .normal)
            let rightButton = UIButton(frame: CGRect(x: self.view.width*3/4-20, y: label.y, width: 20, height: 20))
            rightButton.setImage(UIImage(named: "rightArrow"), for: .normal)
            contentView.addSubview(leftButton)
            contentView.addSubview(rightButton)
            return contentView
        case 2:
            let lineChartView = LineChartView(frame: CGRect(x: 0, y: 0, width: self.view.width, height: 200))
            lineChartView.dragEnabled = false
            for gesture in lineChartView.gestureRecognizers ?? [] {
                if gesture is UIPinchGestureRecognizer {
                    lineChartView.removeGestureRecognizer(gesture)
                }
            }
            lineChartView.pinchZoomEnabled = false
            lineChartView.doubleTapToZoomEnabled = false
            lineChartView.zoomToCenter(scaleX: 1.2, scaleY: 1)
            lineChartView.drawGridBackgroundEnabled = false
            lineChartView.leftAxis.drawGridLinesEnabled = false
            lineChartView.xAxis.drawLabelsEnabled = false
            lineChartView.leftAxis.drawLabelsEnabled = false
            lineChartView.xAxis.avoidFirstLastClippingEnabled = true
//            lineChartView.xAxis.
            lineChartView.rightAxis.enabled = false
            lineChartView.xAxis.drawGridLinesEnabled = false
//            lineChartView.extraBottomOffset = -100
            lineChartView.setViewPortOffsets(left: 0, top: -1, right: 0, bottom: 0)
            lineChartView.setExtraOffsets(left: 0, top: -1, right: 0, bottom: 0)
            lineChartView.chartDescription = nil
            lineChartView.drawBordersEnabled = false
            lineChartView.borderLineWidth = 0
            lineChartView.delegate = self
            lineChartView.isUserInteractionEnabled = true
            lineChartView.borderColor = .white
            lineChartView.legend.enabled = false
//            lineChartView.xAxis.xOffset = 50
//            lineChartView.borderColor = UIColor(red:0.98, green:0.40, blue:0.29, alpha:1.00)
//            lineChartView.fitScreen()
//            lineChartView.backgroundColor = UIColor(red:0.99, green:0.66, blue:0.60, alpha:1.00)
            let s1 = LineChartDataSet(values: [ChartDataEntry(x: 0, y: 95), ChartDataEntry(x: 1, y: 90), ChartDataEntry(x: 2, y: 60), ChartDataEntry(x: 3, y: 90), ChartDataEntry(x: 4, y: 100)], label: nil)
            s1.mode = .cubicBezier
            s1.drawCirclesEnabled = true
            s1.circleRadius = 11
            s1.setCircleColor(.white)
            s1.circleHoleRadius = 8
            s1.circleHoleColor = UIColor(red:0.98, green:0.44, blue:0.35, alpha:1.00)
            s1.drawValuesEnabled = false
            s1.drawCircleHoleEnabled = true
            s1.drawFilledEnabled = true
            s1.setDrawHighlightIndicators(false)
//            s1.highlightEnabled = false
            s1.fillColor = UIColor(red:0.99, green:0.66, blue:0.60, alpha:1.00)
            s1.fillAlpha = 1
            s1.lineWidth = 2
            s1.setColor(UIColor(red:0.98, green:0.49, blue:0.41, alpha:1.00))
            lineChartView.data  = LineChartData(dataSet: s1)
//            lineChartView.layer.shadowColor = UIColor(red:0.98, green:0.49, blue:0.41, alpha:1.00).cgColor
////            lineChartView.layer.shadowRadius = 2
//            lineChartView.layer.shadowOffset = CGSize(width: 0, height: -2)
            return lineChartView
        case 3:
            let separatorView = UIView()
            separatorView.backgroundColor = UIColor(red:0.99, green:0.66, blue:0.60, alpha:1.00)
            return separatorView
        case 4:
            let radarChartView = RadarChartView(frame: CGRect(x: 0, y: 0, width: self.view.width, height: self.view.width))
            radarChartView.yAxis.drawLabelsEnabled = false
//            radarChartView.yAxis.labelCount = 6
//            radarChartView.yAxis.drawLabelsEnabled = false
//            radarChartView.yAxis.labelTextColor = .clear
            radarChartView.yAxis.axisMinimum = 0
            radarChartView.yAxis.axisMaximum = 100
            radarChartView.yAxis.gridColor = .white
            
            let labels = ["大学物理", "马克思主义基本原理", "集中军事训练", "数据结构", "高等数学"]
            radarChartView.xAxis.valueFormatter = IndexAxisValueFormatter(values: labels)
            radarChartView.setExtraOffsets(left: 0, top: 0, right: 0, bottom: 0)
            //            entry1.
            let s1 = RadarChartDataSet(values: [RadarChartDataEntry(value: 70), RadarChartDataEntry(value: 80), RadarChartDataEntry(value: 90), RadarChartDataEntry(value: 85), RadarChartDataEntry(value: 95)], label: nil)
//            s1.highlightEnabled = false
            s1.drawValuesEnabled = false
            s1.fillColor = UIColor(red:1.00, green:0.81, blue:0.78, alpha:1.00)
            s1.fillAlpha = 1
            //            s1.fillColor = .white
            //            s1.fillAlpha = 0.5
            s1.drawFilledEnabled = true
            s1.setDrawHighlightIndicators(false)
//            s1.setColor(UIColor(red:0.99, green:0.66, blue:0.60, alpha:1.00))
            s1.setColor(.white)
            
            //            s1.highlightCircleInnerRadius = 80
            //            s1.drawHighlightCircleEnabled = true
            // s1.
            let data = RadarChartData(dataSet: s1)
            radarChartView.data = data
            
            let yAxis = radarChartView.yAxis
            yAxis.drawLabelsEnabled = false
//            radarChartView.yAxis.drawTopYLabelEntryEnabled = true
//            radarChartView.yAxis.drawAxisLineEnabled = false
//            radarChartView.yAxis.drawGridLinesEnabled = false
//            radarChartView.yAxis.gridAntialiasEnabled = false
//            radarChartView.yAxis.drawLabelsEnabled = false
//            radarChartView.webLineWidth = 2
//            radarChartView.skipWebLineCount = 3
//            radarChartView.innerWebColor = .clear
//            radarChartView.xAxis.drawAxisLineEnabled = false
//            radarChartView.
//            radarChartView.yAxis.drawTopYLabelEntryEnabled = true
            radarChartView.backgroundColor = UIColor(red:0.99, green:0.66, blue:0.60, alpha:1.00)
            radarChartView.webColor = .white
            radarChartView.innerWebColor = .white
            radarChartView.innerWebLineWidth = 2
            radarChartView.delegate = self
            radarChartView.webLineWidth = 2
            radarChartView.webAlpha = 1
            radarChartView.chartDescription = nil
            radarChartView.xAxis.labelTextColor = .white
            
//            radarChartView.
            //radarChartView
            radarChartView.xAxis.drawLabelsEnabled = true
            //            radarChartView.yAxis.drawLabelsEnabled = false
            radarChartView.yAxis.drawLabelsEnabled = false
            radarChartView.legend.enabled = false
            return radarChartView
        case 5:
            let contentView = UIView()
            contentView.width = self.view.width
            contentView.height = 50
            contentView.backgroundColor = UIColor(red:0.99, green:0.66, blue:0.60, alpha:1.00)
            let segmentView = UISegmentedControl(items: ["成绩降序", "学分降序"])
            segmentView.addTarget(self, action: #selector(self.segmentValueChanged(sender:)), for: .valueChanged)
            segmentView.tintColor = .white
            segmentView.layer.borderWidth = 2
            segmentView.layer.borderColor = UIColor.white.cgColor
            segmentView.layer.cornerRadius = 6
            segmentView.layer.masksToBounds = true
            segmentView.selectedSegmentIndex = 0
            segmentView.center = contentView.center
            contentView.addSubview(segmentView)
            
            contentView.layer.masksToBounds = false
            contentView.layer.shadowOpacity = 0.5
            contentView.layer.shadowRadius = 2
            contentView.layer.shadowOffset = CGSize(width: 0, height: 2)
            contentView.layer.shadowColor = UIColor.black.cgColor 
            let shadowPath = UIBezierPath(rect: CGRect(x: 0, y: contentView.height, width: contentView.width, height: 2)).cgPath
            contentView.layer.shadowPath = shadowPath
            return contentView
        case 6:
            return nil // number of classes in current term
        default:
            return nil
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch section {
        case 0:
            return 131
        case 1:
            return 60
        case 2:
            return 200
        case 3:
            return 50
        case 4:
            return self.view.width
        case 5:
            return 52
        default:
            return 0.01
        }
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.01
    }
}

extension GPAViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offset = scrollView.contentOffset.y - 100
        if offset > 0 {
//            UIAppearance.
            self.navigationItem.rightBarButtonItem?.isEnabled = true
            self.navigationController?.navigationBar.barStyle = .black
            self.title = "大二上"
            self.navigationController?.navigationBar.alpha = offset * 0.02
            let image = UIImage(color: UIColor(red:0.99, green:0.66, blue:0.60, alpha:1.00), size: CGSize(width: self.view.width, height: 64))
            self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
            self.navigationController?.navigationBar.setBackgroundImage(image, for: .default)
            self.navigationController?.navigationBar.shadowImage = UIImage()
            self.navigationController?.navigationBar.isTranslucent = true
        } else {
            self.navigationItem.rightBarButtonItem?.isEnabled = false
            self.navigationController?.navigationBar.barStyle = .default
            self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
            self.navigationController?.navigationBar.shadowImage = UIImage()
            self.navigationController?.navigationBar.isTranslucent = true
        }
//        self.navigationController?.setNeedsStatusBarAppearanceUpdate()
    }
}

extension GPAViewController: ChartViewDelegate {
    func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {

    }
}

class ScoreHeaderView: UIView {
    let totalScoreLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 27, weight: UIFontWeightLight)
        label.textAlignment = .center
        label.sizeToFit()
        return label
    }()
    let totalGPALabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 27, weight: UIFontWeightLight)
        label.textAlignment = .center
        label.sizeToFit()
        return label
    }()
    let totalCreditLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 27, weight: UIFontWeightLight)
        label.textAlignment = .center
        label.sizeToFit()
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white
        layout()
        // Total height: 40 + LabelHeight + 20 + smallLabelHeight + 40
    }
    
    func layout() {
        // constants
        let topPadding: CGFloat = 40
        let baseWidth: CGFloat = UIScreen.main.bounds.width/4
//        let bottomPadding = topPadding
        let labelPadding: CGFloat = 5
        
        totalScoreLabel.width = baseWidth
        totalGPALabel.width = baseWidth
        totalCreditLabel.width = baseWidth
        
        totalScoreLabel.height = 35
        totalGPALabel.height = 35
        totalCreditLabel.height = 35
        
        totalScoreLabel.center.x = baseWidth*1
        totalGPALabel.center.x = baseWidth*2
        totalCreditLabel.center.x = baseWidth*3
        
        totalScoreLabel.y = topPadding
        totalGPALabel.y = topPadding
        totalCreditLabel.y = topPadding

        
        self.addSubview(totalScoreLabel)
        self.addSubview(totalGPALabel)
        self.addSubview(totalCreditLabel)
        
        // color
        let scoreHintLabel = UILabel(text: "总加权", color: UIColor(red:0.28, green:0.28, blue:0.28, alpha:1.00))
        scoreHintLabel.textAlignment = .center
        scoreHintLabel.font = UIFont.systemFont(ofSize: 12, weight: UIFontWeightThin)

        let GPAHintLabel = UILabel(text: "总绩点", color: UIColor(red:0.28, green:0.28, blue:0.28, alpha:1.00))
        GPAHintLabel.textAlignment = .center
        GPAHintLabel.font = UIFont.systemFont(ofSize: 12, weight: UIFontWeightThin)

        let creditHintLabel = UILabel(text: "总学分", color: UIColor(red:0.28, green:0.28, blue:0.28, alpha:1.00))
        creditHintLabel.textAlignment = .center
        creditHintLabel.font = UIFont.systemFont(ofSize: 12, weight: UIFontWeightThin)
        
        self.addSubview(scoreHintLabel)
        self.addSubview(GPAHintLabel)
        self.addSubview(creditHintLabel)

        scoreHintLabel.center.x = baseWidth*1
        GPAHintLabel.center.x = baseWidth*2
        creditHintLabel.center.x = baseWidth*3
        
        scoreHintLabel.y = totalScoreLabel.y + totalScoreLabel.height + labelPadding
        GPAHintLabel.y = scoreHintLabel.y
        creditHintLabel.y = scoreHintLabel.y
        
        let separator = UIView()
        self.addSubview(separator)
        separator.height = 1
        separator.width = 3*baseWidth
        separator.x = baseWidth/2
        separator.y = scoreHintLabel.y + scoreHintLabel.height + 30
        separator.backgroundColor = UIColor(red:0.93, green:0.93, blue:0.93, alpha:1.00)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
