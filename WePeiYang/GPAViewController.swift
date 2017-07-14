
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
    var tableView: UITableView!
    
    let summaryView = ScoreHeaderView()
    
    let termLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(red:0.22, green:0.22, blue:0.22, alpha:1.00)
        label.font = UIFont.systemFont(ofSize: 16, weight: UIFontWeightLight)
        label.sizeToFit()
        return label
    }()
    let leftButton = UIButton()
    let rightButton = UIButton()
    let termSwitchView: UIView = {
        let contentView = UIView()
        contentView.backgroundColor = .white
        return contentView
    }()
    
    let lineChartView: LineChartView = {
        let lineChartView = LineChartView()
        lineChartView.dragEnabled = false
        for gesture in lineChartView.gestureRecognizers ?? [] {
            if gesture is UIPinchGestureRecognizer {
                lineChartView.removeGestureRecognizer(gesture)
            }
        }
        lineChartView.pinchZoomEnabled = false
        lineChartView.doubleTapToZoomEnabled = false
        lineChartView.drawGridBackgroundEnabled = false
        lineChartView.leftAxis.drawGridLinesEnabled = false
        lineChartView.xAxis.drawLabelsEnabled = false
        lineChartView.leftAxis.drawLabelsEnabled = false
        lineChartView.rightAxis.enabled = false
        lineChartView.xAxis.drawGridLinesEnabled = false
        // -1 for the fucking top border
        lineChartView.setViewPortOffsets(left: 0, top: -1, right: 0, bottom: 0)
        lineChartView.setExtraOffsets(left: 0, top: -1, right: 0, bottom: 0)
        lineChartView.chartDescription = nil
        lineChartView.drawBordersEnabled = false
        lineChartView.borderLineWidth = 0
        lineChartView.isUserInteractionEnabled = true
        lineChartView.borderColor = .white
        lineChartView.legend.enabled = false
        return lineChartView
    }()
    
    let paddingView = UIView()
    
    let radarChartView: RadarChartView = {
        let radarChartView = RadarChartView()
        radarChartView.yAxis.drawLabelsEnabled = false
        radarChartView.yAxis.axisMinimum = 0
        radarChartView.yAxis.axisMaximum = 100
        radarChartView.yAxis.gridColor = .white
        radarChartView.setExtraOffsets(left: 0, top: 0, right: 0, bottom: 0)
        radarChartView.backgroundColor = UIColor(red:0.99, green:0.66, blue:0.60, alpha:1.00)
        radarChartView.webColor = .white
        radarChartView.innerWebColor = .white
        radarChartView.innerWebLineWidth = 2
        radarChartView.webLineWidth = 2
        radarChartView.webAlpha = 1
        radarChartView.chartDescription = nil
        radarChartView.xAxis.labelTextColor = .white
        radarChartView.xAxis.drawLabelsEnabled = true
        radarChartView.yAxis.drawLabelsEnabled = false
        radarChartView.legend.enabled = false
        return radarChartView
    }()
    
    let segmentView: UISegmentedControl = {
        let segmentView = UISegmentedControl(items: ["成绩降序", "学分降序"])
        segmentView.tintColor = .white
        segmentView.layer.borderWidth = 2
        segmentView.layer.borderColor = UIColor.white.cgColor
        segmentView.layer.cornerRadius = 6
        segmentView.layer.masksToBounds = true
        segmentView.selectedSegmentIndex = 0
        return segmentView
    }()
    
    let segmentContentView: UIView = {
        let contentView = UIView()
        contentView.backgroundColor = UIColor(red:0.99, green:0.66, blue:0.60, alpha:1.00)
        contentView.layer.masksToBounds = false
        contentView.layer.shadowOpacity = 0.5
        contentView.layer.shadowRadius = 2
        contentView.layer.shadowOffset = CGSize(width: 0, height: 2)
        contentView.layer.shadowColor = UIColor.black.cgColor
        let shadowPath = UIBezierPath(rect: CGRect(x: 0, y: contentView.height, width: contentView.width, height: 2)).cgPath
        contentView.layer.shadowPath = shadowPath
        return contentView
    }()
    
    // This property actually won't do anything if the controller is in UINavigationController.
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
        
        // set termSwitchView
        termSwitchView.frame = CGRect(x: 0, y: 0, width: self.view.width, height: 60)
        termLabel.center = termSwitchView.center
        termSwitchView.addSubview(termLabel)
        leftButton.frame = CGRect(x: UIScreen.main.bounds.width/4, y: termLabel.y, width: 20, height: 20)
        rightButton.frame = CGRect(x: UIScreen.main.bounds.width*3/4-20, y: termLabel.y, width: 20, height: 20)
        leftButton.setImage(UIImage(named: "leftArrow"), for: .normal)
        rightButton.setImage(UIImage(named: "rightArrow"), for: .normal)
        termSwitchView.addSubview(leftButton)
        termSwitchView.addSubview(rightButton)
        // set lineChartView
        lineChartView.frame = CGRect(x: 0, y: 0, width: self.view.width, height: 200)
        // set radarChartView
        radarChartView.frame = CGRect(x: 0, y: 0, width: self.view.width, height: self.view.width)
        // set segmentView
        segmentContentView.frame =  CGRect(x: 0, y: 0, width: self.view.width, height: 50)
        segmentView.center = segmentContentView.center
        segmentContentView.addSubview(segmentView)
        segmentView.addTarget(self, action: #selector(self.segmentValueChanged(sender:)), for: .valueChanged)
        // set paddingView 
        paddingView.backgroundColor = UIColor(red:0.99, green:0.66, blue:0.60, alpha:1.00)

        tableView = UITableView(frame: self.view.bounds, style: .plain)
        tableView.delegate = self
        tableView.dataSource = self
        self.view.backgroundColor = .white
        tableView.backgroundColor = .white
        tableView.rowHeight = 100
//        tableView.height = tableView.sizeThatFits(CGSize(width: self.view.width, height: CGFloat.greatestFiniteMagnitude)).height
        self.view.addSubview(tableView)
        let refreshItem = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(self.refresh))
        refreshItem.tintColor = .white
        self.navigationItem.rightBarButtonItem = refreshItem
    }
    
    func refresh() {
        summaryView.totalScoreLabel.text = "88.54"
        summaryView.totalGPALabel.text = "3.65"
        summaryView.totalCreditLabel.text = "84.5"

    }
    
    func segmentValueChanged(sender: UISegmentedControl) {
        
    }
    
    func setupLineChartView() {
        let dataSet = LineChartDataSet(values: [ChartDataEntry(x: 0, y: 95), ChartDataEntry(x: 1, y: 90), ChartDataEntry(x: 2, y: 60), ChartDataEntry(x: 3, y: 90), ChartDataEntry(x: 4, y: 100)], label: nil)
        dataSet.mode = .cubicBezier
        dataSet.drawCirclesEnabled = true
        dataSet.circleRadius = 11
        dataSet.setCircleColor(.white)
        dataSet.circleHoleRadius = 8
        dataSet.circleHoleColor = UIColor(red:0.98, green:0.44, blue:0.35, alpha:1.00)
        dataSet.drawValuesEnabled = false
        dataSet.drawCircleHoleEnabled = true
        dataSet.drawFilledEnabled = true
        dataSet.setDrawHighlightIndicators(false)
        //            dataSet.highlightColor = .blue
        dataSet.fillColor = UIColor(red:0.99, green:0.66, blue:0.60, alpha:1.00)
        dataSet.fillAlpha = 1
        dataSet.lineWidth = 2
        dataSet.setColor(UIColor(red:0.98, green:0.49, blue:0.41, alpha:1.00))
        lineChartView.data  = LineChartData(dataSet: dataSet)
        lineChartView.zoomToCenter(scaleX: 1.2, scaleY: 1)
    }
    
    func setupRadarChartView() {
        let dataSet = RadarChartDataSet(values: [RadarChartDataEntry(value: 70), RadarChartDataEntry(value: 80), RadarChartDataEntry(value: 90), RadarChartDataEntry(value: 85), RadarChartDataEntry(value: 95)], label: nil)
        radarChartView.xAxis.valueFormatter = IndexAxisValueFormatter(values: ["SubjectNames"])
        dataSet.drawValuesEnabled = false
        dataSet.fillColor = UIColor(red:1.00, green:0.81, blue:0.78, alpha:1.00)
        dataSet.fillAlpha = 1
        dataSet.drawFilledEnabled = true
        dataSet.setDrawHighlightIndicators(false)
        dataSet.setColor(.white)
        let data = RadarChartData(dataSet: dataSet)
        radarChartView.data = data
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

fileprivate enum GPASectionType: Int {
    case summary
    case termSwitch
    case lineChart
    case padding
    case radarChart
    case subject
}

extension GPAViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 6
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let type = GPASectionType(rawValue: section) {
            switch type {
            case .summary:
                return 0
            case .termSwitch:
                return 0
            case .lineChart:
                return 0
            case .padding:
                return 0
            case .radarChart:
                return 0
            case .subject:
                let numberOfClasses = 15
                return numberOfClasses
            }
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.backgroundColor = .white
        let classNameLabel = UILabel(text: "大学物理", color: UIColor(red:0.32, green:0.32, blue:0.32, alpha:1.00), fontSize: 14)
        let creditLabel = UILabel(text: "学分: 4.0", color: UIColor(red:0.32, green:0.32, blue:0.32, alpha:1.00), fontSize: 14)
        let scoreLabel = UILabel(text: "成绩: 95", color: UIColor(red:0.32, green:0.32, blue:0.32, alpha:1.00), fontSize: 14)
        classNameLabel.frame = CGRect(x: 20, y: 20, width: 200, height: 20)
        creditLabel.frame = CGRect(x: 20, y: 60, width: 100, height: 20)
        scoreLabel.frame = CGRect(x: 120, y: 60, width: 200, height: 20)
        cell.contentView.addSubview(classNameLabel)
        cell.contentView.addSubview(creditLabel)
        cell.contentView.addSubview(scoreLabel)
        return cell
    }
}

extension GPAViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if let type = GPASectionType(rawValue: section) {
            switch type {
            case .summary:
                return summaryView
            case .termSwitch:
                return termSwitchView
            case .lineChart:
                return lineChartView
            case .padding:
                return paddingView
            case .radarChart:
                return radarChartView
            case .subject:
                return segmentContentView
            }
        } else {
            return nil
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if let type = GPASectionType(rawValue: section) {
            switch type {
            case .summary:
                return 111
            case .termSwitch:
                return 60
            case .lineChart:
                return 200
            case .padding:
                return 50
            case .radarChart:
                return self.view.width
            case .subject:
                return 52
            }
        } else {
            return 0.01
        }
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.01
    }
}

extension GPAViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offset = scrollView.contentOffset.y - 80
        if offset > 0 {
//            UIAppearance.
            self.navigationItem.rightBarButtonItem?.tintColor = .white
            self.navigationController?.navigationBar.barStyle = .black
            self.title = "大二上"
            if offset > 530 {
//                0.1-1
                self.navigationController?.navigationBar.alpha = 1
//                min(max(0.1, (offset-530)/60), 1)
                self.navigationController?.navigationBar.isTranslucent = false
                return
            }
            self.navigationController?.navigationBar.alpha = min(offset * 0.02, 1)
            let image = UIImage(color: UIColor(red:0.99, green:0.66, blue:0.60, alpha:1.00), size: CGSize(width: self.view.width, height: 64))
            self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
            self.navigationController?.navigationBar.setBackgroundImage(image, for: .default)
            self.navigationController?.navigationBar.shadowImage = UIImage()
            self.navigationController?.navigationBar.isTranslucent = true
        } else {
            self.title = ""
            self.navigationController?.navigationBar.alpha = 1
            self.navigationItem.rightBarButtonItem?.tintColor = UIColor(red:0.99, green:0.66, blue:0.60, alpha:1.00)
            self.navigationController?.navigationBar.barStyle = .default
            self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
            self.navigationController?.navigationBar.shadowImage = UIImage()
//            self.navigationController?.navigationBar.isTranslucent = false
            self.navigationController?.navigationBar.isTranslucent = true
        }
    }
}

extension GPAViewController: ChartViewDelegate {
    func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {
        for view in chartView.subviews {
            view.removeFromSuperview()
        }
        let image = UIImage(named: "bubble")!
        let bubbleView = UIImageView(image: image)
        bubbleView.width = 115
        bubbleView.height = 115
        bubbleView.y = highlight.yPx + 10
        bubbleView.center.x = highlight.xPx
        bubbleView.contentMode = .scaleToFill
        
        var upsidedownOffset: CGFloat = 0
        
        if bubbleView.y + bubbleView.height > 200 {
            let revertedImage = UIImage(cgImage: image.cgImage!, scale: 1, orientation: UIImageOrientation.downMirrored)
            bubbleView.image = revertedImage
            bubbleView.y -= bubbleView.height + 10 + 10
            upsidedownOffset = -10
        }
        
        let scoreLabel = UILabel(text: "加权: 99.0", color: UIColor(red:0.32, green:0.32, blue:0.32, alpha:1.00), fontSize: 12)
        scoreLabel.font = UIFont.systemFont(ofSize: 12, weight: UIFontWeightThin)
        let GPALabel = UILabel(text: "绩点: 4.0", color: UIColor(red:0.32, green:0.32, blue:0.32, alpha:1.00), fontSize: 12)
        GPALabel.font = UIFont.systemFont(ofSize: 12, weight: UIFontWeightThin)
        let creditsLabel = UILabel(text: "总学分: 150.5", color: UIColor(red:0.32, green:0.32, blue:0.32, alpha:1.00), fontSize: 12)
        creditsLabel.font = UIFont.systemFont(ofSize: 12, weight: UIFontWeightThin)
        scoreLabel.frame = CGRect(x: 21.5, y: 22.5 + upsidedownOffset, width: 125, height: 20)
        GPALabel.frame = CGRect(x: 21.5, y: 52.5 + upsidedownOffset, width: 125, height: 20)
        creditsLabel.frame = CGRect(x: 21.5, y: 82.5 + upsidedownOffset, width: 125, height: 20)
        bubbleView.addSubview(scoreLabel)
        bubbleView.addSubview(GPALabel)
        bubbleView.addSubview(creditsLabel)
        
        bubbleView.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
        UIView.animate(withDuration: 0.2, delay: 0.1, usingSpringWithDamping: 0.7, initialSpringVelocity: 0, options: [], animations: {
            bubbleView.transform = CGAffineTransform(scaleX: 1, y: 1)
            chartView.addSubview(bubbleView)
        }, completion: nil)
    }
}


