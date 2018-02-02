

//
//  GPACard.swift
//  GPACard
//
//  Created by Halcao on 2017/12/6.
//  Copyright © 2017年 twtstudio. All rights reserved.
//

import UIKit
import Charts

class GPACard: CardView {
    let titleLabel = UILabel()
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
        lineChartView.leftAxis.drawAxisLineEnabled = false
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
        // 只让看不让摸
        lineChartView.isUserInteractionEnabled = false
        lineChartView.borderColor = .white
        lineChartView.legend.enabled = false
        return lineChartView
    }()

    override func initialize() {
        super.initialize()
        let padding: CGFloat = 20
        
        titleLabel.frame = CGRect(x: padding, y: padding, width: 200, height: 30)
        titleLabel.text = "我的GPA"
        titleLabel.font = UIFont.systemFont(ofSize: 25, weight: UIFontWeightSemibold)
        titleLabel.textColor = .white
        titleLabel.sizeToFit()
        self.addSubview(titleLabel)
        
        self.backgroundColor = UIColor(red:0.98, green:0.66, blue:0.61, alpha:1.00)
        self.addSubview(lineChartView)
    }
    
    override func layout(rect: CGRect) {
        let padding: CGFloat = 20
        
        let layerWidth = rect.width - 2*padding
        let layerHeight = rect.height - 2*padding - 40

        lineChartView.frame = CGRect(x: padding, y: padding + 30 + 15, width: layerWidth, height: layerHeight)
//        bezierLayer.frame = CGRect(x: padding, y: padding + 30 + 20, width: layerWidth, height: layerHeight)
//        //        bezierLayer.points = points
//        self.layer.addSublayer(bezierLayer)
    }

    func load(model: GPAModel) {
        let entrys = model.terms.enumerated().map { tuple in
            return ChartDataEntry(x: Double(tuple.offset), y: tuple.element.stat.score)
        }
        // FIXME: 只有一学期的成绩
        let dataSet = LineChartDataSet(values: entrys, label: nil)
        dataSet.mode = .cubicBezier
        dataSet.drawCirclesEnabled = false
        dataSet.drawValuesEnabled = false
        dataSet.drawCircleHoleEnabled = false
        dataSet.drawFilledEnabled = true
        dataSet.setDrawHighlightIndicators(false)
        dataSet.fillColor = UIColor(red:0.98, green:0.66, blue:0.61, alpha:1.00)
        dataSet.fillAlpha = 1
        dataSet.lineWidth = 2
        dataSet.setColor(.white)
        lineChartView.data = LineChartData(dataSet: dataSet)
//        lineChartView.
    }
}

