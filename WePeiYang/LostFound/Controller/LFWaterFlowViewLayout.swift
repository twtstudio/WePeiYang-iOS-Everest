//
//  LFWaterFlowViewLayout.swift
//  WePeiYang
//
//  Created by JasonEWNL on 2018/10/20.
//  Copyright © 2018年 twtstudio. All rights reserved.
//

import UIKit

protocol LFWaterFlowViewLayoutDelegate: NSObjectProtocol {
    func waterFlowViewLayout(waterFlowViewLayout: LFWaterFlowViewLayout, heightForWidth: CGFloat, atIndextPath: IndexPath) -> CGFloat
}

class LFWaterFlowViewLayout: UICollectionViewLayout {
    
    weak var delegate: LFWaterFlowViewLayoutDelegate?
    
    var setSize: () -> ([UIImage]) = { return [] }
    
    // 所有cell的布局属性,这是管理Collection布局
    private var layoutAttributes = [UICollectionViewLayoutAttributes]()
    // 用字典记录每列最大的y值
    var maxYDict = [Int: CGFloat]()
    var hs = [CGFloat]()
    
    //    static var Margin: CGFloat = 5;
    //    ///瀑布流四周的间距
    //    var sectionInsert = UIEdgeInsets(top: Margin, left: Margin, bottom: Margin, right: Margin)
    //    //列间距
    //    var columnMargin:CGFloat = Margin
    //    //行间距
    //    var rowMargin:CGFloat = Margin

    // 瀑布流列数
    var column = 2
    
    private var totalNum: Int!
    
    var maxY: CGFloat = 0
    var columnWidth: CGFloat = 0
    
    override func prepare() {
        // 清空字典里面的值
        super.prepare()
        for _ in 0..<column {
            hs.append(5)
        }
        // 清空之前的布局
        layoutAttributes.removeAll()
        // 清空最大列Y
        maxY = 0
        // 计算每列的宽度，需要在布局之前算好
        totalNum = collectionView?.numberOfItems(inSection: 0) ?? 0
        for i in 0..<totalNum {
            //布局每一个cell的frame
            let layoutAttr = layoutAttributesForItem(at: IndexPath(item: i, section: 0) as IndexPath)!
            layoutAttributes.append(layoutAttr)
        }
    }
    
    private let gap: CGFloat = 5 // 间隔，缝隙大小
    private var width: CGFloat!
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        width = (collectionView!.bounds.size.width-gap*(CGFloat(column)-1))/CGFloat(column)
        let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
        let sizes = setSize()
        attributes.size = CGSize(width: width, height: sizes[indexPath.row].size.height*width/sizes[indexPath.row].size.width)
        var nub: CGFloat = 0
        var h: CGFloat = 0
        (nub, h) = minH(hhs: hs)
        attributes.center = CGPoint(x: (nub+0.5)*(gap+width), y: h+(width/attributes.size.width*attributes.size.height+gap)/2)
        hs[Int(nub)] = h+width/attributes.size.width*attributes.size.height+gap
        return attributes
    }

    //    func calcMaxY() {
    //        //获取最大这一列的Y
    //        //默认第0列最长
    //        var maxYCoulumn = 0
    //        for (key,value) in maxYDict {
    //            if value > maxYDict[maxYCoulumn]! {
    //                // key 这列是Y值最大的
    //                maxYCoulumn = key
    //            }
    //        }
    //        // 获取Y最大的这一列
    //        maxY = maxYDict[maxYCoulumn]! + sectionInsert.bottom
    //    }
    
    private func minH(hhs: [CGFloat]) -> (CGFloat, CGFloat) {
        var num = 0
        var min = hhs[0]
        for i in 1..<hhs.count where min>hhs[i] {
            min = hhs[i]
            num = i
        }
        return (CGFloat(num), min)
    }
    
    func maxH(hhs: [CGFloat]) -> CGFloat {
        var max = hhs[0]
        for i in 1..<hhs.count where max<hhs[i] {
            max = hhs[i]
        }
        return max
    }
    
    // 返回collectionViewSize大小
    override var collectionViewContentSize: CGSize {
        get {
            return CGSize(width: UIScreen.main.bounds.width, height: maxY)
        }
        set {
            self.collectionViewContentSize = newValue
        }
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        return layoutAttributes
    }
    
}
