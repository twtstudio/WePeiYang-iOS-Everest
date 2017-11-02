
//
//  GPAViewController.swift
//  WePeiYang
//
//  Created by Halcao on 2017/7/11.
//  Copyright © 2017年 twtstudio. All rights reserved.
//

import UIKit
import Charts

fileprivate enum GPASortMethod {
    case scoreFirst
    case creditFirst
}

class GPAViewController: UIViewController {
    var tableView: UITableView!
    
    var terms: [GPATermModel] = []
    
    var currentTerm: GPATermModel?
    
    var stat: GPAStatModel?
    
    var session: String!
    
    fileprivate var sortMethod: GPASortMethod = .scoreFirst {
        didSet {
            if sortMethod == .scoreFirst {
                currentTerm?.classes.sort(by: { (a, b) -> Bool in
                    a.score > b.score
                })
                tableView.reloadData()
            } else {
                currentTerm?.classes.sort(by: { $0.0.credit > $0.1.credit })
                tableView.reloadData()
            }
        }
    }
    
    let summaryView = ScoreHeaderView()
    
    let termLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(red:0.22, green:0.22, blue:0.22, alpha:1.00)
        label.font = UIFont.systemFont(ofSize: 16, weight: UIFontWeightLight)
        label.textAlignment = .center
        label.width = 100
        label.height = 20
//        label.sizeToFit()
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
        radarChartView.yAxis.granularity = 20
//        radarChartView.yAxis.setLabelCount(5, force: true)
        radarChartView.yAxis.setLabelCount(1, force: true)
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
        self.navigationController?.navigationBar.tintColor = .white
        termSwitchView.frame = CGRect(x: 0, y: 0, width: self.view.width, height: 60)
        termLabel.center = termSwitchView.center
        termSwitchView.addSubview(termLabel)
        leftButton.frame = CGRect(x: UIScreen.main.bounds.width/4, y: termLabel.y, width: 20, height: 20)
        leftButton.adjustsImageWhenHighlighted = true
        rightButton.frame = CGRect(x: UIScreen.main.bounds.width*3/4-20, y: termLabel.y, width: 20, height: 20)
        rightButton.adjustsImageWhenHighlighted = true
        leftButton.add(for: .touchUpInside, {
            if let index = self.terms.index(where: { $0.name == self.currentTerm!.name }) {
                guard index > 0 && index < self.terms.count else {
                    return
                }
                self.rightButton.isHidden = false
                if index-1 == 0 {
                    self.leftButton.isHidden = true
                }
                self.lineChartView.highlightValue(x: Double(index-1), dataSetIndex: 0, callDelegate: true)

            }
        })
        rightButton.add(for: .touchUpInside, {
            if let index = self.terms.index(where: { $0.name == self.currentTerm!.name }) {
                guard index >= 0 && index < self.terms.count-1 else {
                    return
                }
                self.leftButton.isHidden = false
                if index+1 == self.terms.count-1 {
                    self.rightButton.isHidden = true
                }
                self.lineChartView.highlightValue(x: Double(index+1), dataSetIndex: 0, callDelegate: true)
            }
        })
        leftButton.setImage(UIImage(named: "leftArrow"), for: .normal)
        rightButton.setImage(UIImage(named: "rightArrow"), for: .normal)
        termSwitchView.addSubview(leftButton)
        termSwitchView.addSubview(rightButton)
        // set lineChartView
        lineChartView.frame = CGRect(x: 0, y: 0, width: self.view.width, height: 200)
        lineChartView.delegate = self
        // set radarChartView
        radarChartView.frame = CGRect(x: 0, y: 0, width: self.view.width, height: self.view.width)
        // set segmentView
        segmentContentView.frame =  CGRect(x: 0, y: 0, width: self.view.width, height: 50)
        segmentContentView.layer.masksToBounds = false
        segmentContentView.layer.shadowOpacity = 0.5
        segmentContentView.layer.shadowRadius = 2
        segmentContentView.layer.shadowOffset = CGSize(width: 0, height: 2)
        segmentContentView.layer.shadowColor = UIColor.black.cgColor
        let shadowPath = UIBezierPath(rect: CGRect(x: 0, y: segmentContentView.height, width: segmentContentView.width, height: 2)).cgPath
        segmentContentView.layer.shadowPath = shadowPath
        
        
        segmentView.center = segmentContentView.center
        segmentContentView.addSubview(segmentView)
        segmentView.addTarget(self, action: #selector(self.segmentValueChanged(sender:)), for: .valueChanged)
        // set paddingView 
        paddingView.backgroundColor = UIColor(red:0.99, green:0.66, blue:0.60, alpha:1.00)

        // CGRect(x: 0, y: -44, width: self.view.width, height: UIScreen.main.bounds.height)
        tableView = UITableView(frame: self.view.bounds, style: .plain)
//        self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 44, 0);
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 64, right: 0)
        
        tableView.delegate = self
        tableView.dataSource = self
        self.view.backgroundColor = .white
        tableView.backgroundColor = .white
        tableView.rowHeight = 100
        self.view.addSubview(tableView)
        let refreshItem = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(self.refresh))
        refreshItem.tintColor = .white
        self.navigationItem.rightBarButtonItem = refreshItem
        refresh()
    }
    
    func refresh() {
        GPASessionManager.getGPA(success: { (terms, stat, session) in
            self.terms = terms
            self.stat = stat
            self.session = session
            if terms.count > 0 {
                self.currentTerm = terms[0]
            } else {
                // TODO: 没有成绩的界面
                print("没有成绩")
                return
            }
            self.load()
            self.lineChartView.highlightValue(x: Double(0), dataSetIndex: 0, callDelegate: true)
        }, failure: { error in
            print(error)
        })
    }
    
    
    func load() {
        termLabel.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
        UIView.animate(withDuration: 0.2, delay: 0.1, usingSpringWithDamping: 0.7, initialSpringVelocity: 0, options: [], animations: {
            self.termLabel.text = self.currentTerm?.name ?? ""
            self.termLabel.transform = CGAffineTransform(scaleX: 1, y: 1)
        }, completion: nil)
        
        if currentTerm!.name == terms[0].name {
            leftButton.isHidden = true
        } else {
            leftButton.isHidden = false
        }
        if currentTerm!.name == terms[terms.count-1].name {
            rightButton.isHidden = true
        } else {
            rightButton.isHidden = false
        }
        
        summaryView.totalScoreLabel.text = "\(stat?.score ?? 0)"
        summaryView.totalGPALabel.text = "\(stat?.gpa ?? 0)"
        summaryView.totalCreditLabel.text = "\(stat?.credit ?? 0)"
        setupLineChartView()
        setupRadarChartView()
        
        // keep the sorting method, and refresh the tableView
        segmentValueChanged(sender: segmentView)
        tableView.reloadData()
//        lineChartView.highlightValue(x: 0, dataSetIndex: 0)
    }
    
    func segmentValueChanged(sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            sortMethod = .scoreFirst
        } else if sender.selectedSegmentIndex == 1 {
            sortMethod = .creditFirst
        }
    }
    
    func setupLineChartView() {
        // 这里为了曲线上点不出现在屏幕边缘做了一些处理
        // 向最前和最后插入一个元素
        // 即第一个和最后一个变成了第二个和倒数第二个
        
        var entrys = [ChartDataEntry]()
        for (index, term) in terms.enumerated() {
            let entry = ChartDataEntry(x: Double(index), y: term.stat.score)
            entrys.append(entry)
        }

        if entrys.count > 0 {
                let fakeLastEntry = ChartDataEntry(x: Double(entrys.count), y: entrys[entrys.count-1].y)
                entrys.append(fakeLastEntry)
                let fakeFirstEntry = ChartDataEntry(x: -1, y: entrys[0].y)
                entrys.insert(fakeFirstEntry, at: 0)
        }
        
        let dataSet = LineChartDataSet(values: entrys, label: nil)
        dataSet.mode = .cubicBezier
        dataSet.drawCirclesEnabled = true
        dataSet.circleRadius = 8
        dataSet.setCircleColor(UIColor(red:0.98, green:0.44, blue:0.35, alpha:1.00))

        dataSet.drawValuesEnabled = false
        dataSet.drawCircleHoleEnabled = false
        dataSet.drawFilledEnabled = true
        dataSet.setDrawHighlightIndicators(false)
        dataSet.fillColor = UIColor(red:0.99, green:0.66, blue:0.60, alpha:1.00)
        dataSet.fillAlpha = 1
        dataSet.lineWidth = 2
        dataSet.setColor(UIColor(red:0.98, green:0.49, blue:0.41, alpha:1.00))
        lineChartView.data = LineChartData(dataSet: dataSet)
        lineChartView.zoomOut()
        lineChartView.zoomToCenter(scaleX: 1.15, scaleY: 1)
    }
    
    func setupRadarChartView() {
        var entrys = [RadarChartDataEntry]()
        var labels = [String]()
        let classes = currentTerm?.classes ?? []
        for `class` in classes {
            let entry = RadarChartDataEntry(value: `class`.score)
            entrys.append(entry)
            labels.append(`class`.name)
        }
        
        let dataSet = RadarChartDataSet(values: entrys, label: nil)
        radarChartView.xAxis.valueFormatter = IndexAxisValueFormatter(values: labels)
        dataSet.drawValuesEnabled = false
//        dataSet.fillColor = UIColor(red:1.00, green:0.81, blue:0.78, alpha:1.00)
        dataSet.fillColor = .white
//        dataSet.fillAlpha = 1
        dataSet.fillAlpha = 0.5
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
//    case termSwitch
    case lineChart
    case padding
    case radarChart
    case subject
}

extension GPAViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let type = GPASectionType(rawValue: section) {
            switch type {
            case .summary:
                return 0
//            case .termSwitch:
//                return 0
            case .lineChart:
                return 0
            case .padding:
                return 0
            case .radarChart:
                return 0
            case .subject:
                return currentTerm?.classes.count ?? 0
            }
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(frame: CGRect(x: 0, y: 0, width: self.view.width, height: 100))
        cell.backgroundColor = .white
        let `class` = currentTerm!.classes[indexPath.row]
        let classNameLabel = UILabel(text: `class`.name, color: UIColor(red:0.32, green:0.32, blue:0.32, alpha:1.00), fontSize: 14)
        let creditLabel = UILabel(text: "学分: \(`class`.credit)", color: UIColor(red:0.32, green:0.32, blue:0.32, alpha:1.00), fontSize: 14)
        let scoreLabel = UILabel(text: "成绩: \(`class`.score)", color: UIColor(red:0.32, green:0.32, blue:0.32, alpha:1.00), fontSize: 14)
        classNameLabel.frame = CGRect(x: 20, y: 20, width: 200, height: 20)
        creditLabel.frame = CGRect(x: 20, y: 60, width: 100, height: 20)
        scoreLabel.frame = CGRect(x: 120, y: 60, width: 200, height: 20)
        cell.contentView.addSubview(classNameLabel)
        cell.contentView.addSubview(creditLabel)
        cell.contentView.addSubview(scoreLabel)
        // stands for normal state
        cell.tag = 0
        if `class`.score == -1 {
            scoreLabel.text = "点这里去评价"
            cell.tag = -1
        }
        
        return cell
    }
}

extension GPAViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if let cell = tableView.cellForRow(at: indexPath), cell.tag == -1 {
            let `class` = currentTerm!.classes[indexPath.row]
            let appraiseVC = CourseAppraiseViewController()
            appraiseVC.data = `class`
            appraiseVC.GPASession = session
            self.navigationController?.pushViewController(appraiseVC, animated: true)
        }
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if let type = GPASectionType(rawValue: section) {
            switch type {
            case .summary:
                return summaryView
            case .lineChart:
                let contentView = UIView()
                contentView.width = self.view.width
                contentView.height = 260
                termSwitchView.y = 0
                lineChartView.y = 60
                contentView.addSubview(termSwitchView)
                contentView.addSubview(lineChartView)
                return contentView
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
            case .lineChart:
                return 260
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
            self.navigationItem.rightBarButtonItem?.tintColor = .white
            self.navigationController?.navigationBar.barStyle = .black
            self.title = currentTerm?.name
            if offset > 530 {
                self.navigationController?.navigationBar.alpha = 1
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
            self.navigationController?.navigationBar.isTranslucent = true
        }
    }
}

extension GPAViewController: ChartViewDelegate {
    func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {
        guard entry.x > -1 && entry.x < Double(terms.count) else {
            return
        }
        
        let term = terms[Int(entry.x)]
        self.currentTerm = term
        load()
        
        if let dataSets = chartView.data?.dataSets, dataSets.count > 1 {
            let _ = dataSets[1].removeFirst()
            let _ = dataSets[1].addEntry(entry)
        } else {
            // add another dataSet for the only selected entry
            let dataSetSelected = LineChartDataSet(values: [entry], label: nil)
            dataSetSelected.circleRadius = 11
            dataSetSelected.setCircleColor(.white)
            dataSetSelected.circleHoleRadius = 8
            dataSetSelected.drawValuesEnabled = false
            dataSetSelected.circleHoleColor = UIColor(red:0.98, green:0.44, blue:0.35, alpha:1.00)
            dataSetSelected.drawCircleHoleEnabled = true
            chartView.data?.dataSets.append(dataSetSelected)
        }
        
        for view in chartView.subviews {
            view.removeFromSuperview()
        }
        
        let point = lineChartView.getTransformer(forAxis: lineChartView.data!.dataSets[0].axisDependency).pixelForValues(x: entry.x, y: entry.y)
        
        let image = UIImage(named: "bubble")!
        let bubbleView = UIImageView(image: image)
        bubbleView.width = 115
        bubbleView.height = 115
        bubbleView.y = point.y + 10
        bubbleView.center.x = point.x
        bubbleView.contentMode = .scaleToFill
        
        var upsidedownOffset: CGFloat = 0
        
        if bubbleView.y + bubbleView.height > 200 {
            let revertedImage = UIImage(cgImage: image.cgImage!, scale: 1, orientation: UIImageOrientation.downMirrored)
            bubbleView.image = revertedImage
            bubbleView.y -= bubbleView.height + 10 + 10
            upsidedownOffset = -10
        }
        
        let scoreLabel = UILabel(text: "加权: \(term.stat.score)", color: .black, fontSize: 12)
        scoreLabel.font = UIFont.systemFont(ofSize: 12, weight: UIFontWeightThin)
        let GPALabel = UILabel(text: "绩点: \(term.stat.gpa)", color: .black, fontSize: 12)
        GPALabel.font = UIFont.systemFont(ofSize: 12, weight: UIFontWeightThin)
        let creditsLabel = UILabel(text: "总学分: \(term.stat.credit)", color: .black, fontSize: 12)
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
    
    func chartValueNothingSelected(_ chartView: ChartViewBase) {
        
    }
}

