//
//  LFSearchCellOfHeight.swift
//  WePeiYang
//
//  Created by JasonEWNL on 2018/10/20.
//  Copyright © 2018年 twtstudio. All rights reserved.
//

import Foundation

class LFSearchCellOfHeight {
    var historyNSArray: NSArray = []
    var historyArray: Array<String> = []
    var buttonArray = [" 身份证 "," 饭卡 "," 手机 "," 钥匙 "," 书包 "," 手表&饰品 "," U盘&硬盘 "," 水杯 "," 钱包 "," 银行卡 "," 书 "," 伞 "," 其他 "]
    let titleArray = ["搜索历史", "分类"]
    var mainAry: [[String]] {
        return [historyArray, buttonArray]
    }
    func cellOfHeight() -> Int {
        let vc = LostFoundSearchViewController()
        vc.loadData()
        let cell = LFSearchCustomCell()
        print(historyArray)
        var height = cell.initMark(array: historyArray, title: "")
        return height
    }
    
    
    
    
}
