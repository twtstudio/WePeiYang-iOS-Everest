

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

        lineChartView.delegate = self
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
    }

    func loadData(model: GPAModel) {
        // TODO: data 校验
        let data = model.terms.map { $0.stat.score }

        // 至少俩点
        guard data.count > 1 else {
            // TODO: 只有一个或两个数据
            return
        }

        // 距卡片边缘
        let contentPadding: CGFloat = 15
        // 两点的间隔
        let space = (width - 2*contentPadding)/CGFloat(data.count - 1)

        // 图表
        let diagramHeight: CGFloat = 100
        let minVal = data.min()!
        // 数据范围
        let range = data.max()! - minVal
        // 数据进行放缩
        let ratio = diagramHeight/CGFloat(range)

        // 放缩过的数据
        let newData = data.map { e in
            return diagramHeight - CGFloat(e - minVal)*ratio
        }

        var points = [CGPoint]()

        for i in 0..<newData.count {
            let point = CGPoint(x: CGFloat(i)*space, y: newData[i])
            points.append(point)
        }

//        (card as? GPACard)?.drawLine(points: points)

    }
}

extension GPACard: ChartViewDelegate {

}
