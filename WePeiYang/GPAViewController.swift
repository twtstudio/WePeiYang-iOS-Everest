
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
        tableView = UITableView(frame: self.view.bounds, style: .plain)
        tableView.delegate = self
        tableView.dataSource = self
        self.view.backgroundColor = .white
        tableView.backgroundColor = .white
        tableView.rowHeight = 100

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
            return 15
//        case 6:
//            return 15 // number of classes in current term
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = UITableViewCell()
//        cell.textLabel?.text = "\(indexPath.row)"
//        return UITableViewCell()
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
            lineChartView.drawGridBackgroundEnabled = false
            lineChartView.leftAxis.drawGridLinesEnabled = false
            lineChartView.xAxis.drawLabelsEnabled = false
            lineChartView.leftAxis.drawLabelsEnabled = false
            lineChartView.xAxis.avoidFirstLastClippingEnabled = true
            lineChartView.rightAxis.enabled = false
            lineChartView.xAxis.drawGridLinesEnabled = false
            // -1 for the fucking top border
            lineChartView.setViewPortOffsets(left: 0, top: -1, right: 0, bottom: 0)
            lineChartView.setExtraOffsets(left: 0, top: -1, right: 0, bottom: 0)
            lineChartView.chartDescription = nil
            lineChartView.drawBordersEnabled = false
            lineChartView.borderLineWidth = 0
            lineChartView.delegate = self
            lineChartView.isUserInteractionEnabled = true
            lineChartView.borderColor = .white
            lineChartView.legend.enabled = false
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
//            s1.highlightColor = .blue
            s1.fillColor = UIColor(red:0.99, green:0.66, blue:0.60, alpha:1.00)
            s1.fillAlpha = 1
            s1.lineWidth = 2
            s1.setColor(UIColor(red:0.98, green:0.49, blue:0.41, alpha:1.00))
            lineChartView.data  = LineChartData(dataSet: s1)
            lineChartView.zoomToCenter(scaleX: 1.2, scaleY: 1)
            return lineChartView
        case 3:
            let separatorView = UIView()
            separatorView.backgroundColor = UIColor(red:0.99, green:0.66, blue:0.60, alpha:1.00)
            return separatorView
        case 4:
            let radarChartView = RadarChartView(frame: CGRect(x: 0, y: 0, width: self.view.width, height: self.view.width))
            radarChartView.yAxis.drawLabelsEnabled = false
            radarChartView.yAxis.axisMinimum = 0
            radarChartView.yAxis.axisMaximum = 100
            radarChartView.yAxis.gridColor = .white
            
            let labels = ["大学物理", "马克思主义基本原理", "集中军事训练", "数据结构", "高等数学"]
            radarChartView.xAxis.valueFormatter = IndexAxisValueFormatter(values: labels)
            radarChartView.setExtraOffsets(left: 0, top: 0, right: 0, bottom: 0)
            //            entry1.
            let s1 = RadarChartDataSet(values: [RadarChartDataEntry(value: 70), RadarChartDataEntry(value: 80), RadarChartDataEntry(value: 90), RadarChartDataEntry(value: 85), RadarChartDataEntry(value: 95)], label: nil)
            s1.drawValuesEnabled = false
            s1.fillColor = UIColor(red:1.00, green:0.81, blue:0.78, alpha:1.00)
            s1.fillAlpha = 1
            s1.drawFilledEnabled = true
            s1.setDrawHighlightIndicators(false)
            s1.setColor(.white)
            let data = RadarChartData(dataSet: s1)
            radarChartView.data = data
            
            let yAxis = radarChartView.yAxis
            yAxis.drawLabelsEnabled = false
            radarChartView.backgroundColor = UIColor(red:0.99, green:0.66, blue:0.60, alpha:1.00)
            radarChartView.webColor = .white
            radarChartView.innerWebColor = .white
            radarChartView.innerWebLineWidth = 2
//            radarChartView.delegate = self
            radarChartView.webLineWidth = 2
            radarChartView.webAlpha = 1
            radarChartView.chartDescription = nil
            radarChartView.xAxis.labelTextColor = .white
            
            radarChartView.xAxis.drawLabelsEnabled = true
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
            // TODO: change the alpha when it scrolls
//            contentView.alpha = 0.909
            
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
            return 111
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
//        self.navigationController?.setNeedsStatusBarAppearanceUpdate()
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
        let topPadding: CGFloat = 20
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
