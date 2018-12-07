//
//  TestController.swift
//  WePeiYang
//
//  Created by yuting jiang on 2018/7/21.
//  Copyright © 2018年 twtstudio. All rights reserved.
//

import Foundation
import UIKit

class TestController: UIViewController {
    let questionViewParameters = PTQuestionViewParameters()

    let result: String? = "正确"
    let answer: String? = "通过更改数据源来给用户一个假象，图片在无限滚动（其实一共只有3个 cell），默认显示第一个，右滑 index + 1, 左滑 index - 1，然后修改数据源，异步回到第一个cell（注意不能有动画）通过更改数据源来给用户一个假象，图片在无限滚动（其实一共只有3个 cell），默认显示第一个，右滑 index + 1, 左滑 index - 1，然后修改数据源，异步回到第一个cell（注意不能有动画）"

    var testView = PTQuesListCollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
//        testView.backgroundColor = .purple
        var isCorrected: [isCorrect] = [.unknown, .right, .wrong, .unknown, .right]
        for _ in 0..<300 {
            isCorrected.append(.unknown)
        }
//        testView.initCollectionView(pagesNum: isCorrected.count, isCorrect: isCorrected)
//        testView.creatAnswerView(result: result, answer: answer)

        view.addSubview(testView)
        testView.snp.makeConstraints { (make) in
            make.width.equalTo(0.5 * deviceWidth)
            make.height.equalTo(0.3 * deviceHeight)
            make.centerX.equalTo(view).offset(0.1 * deviceWidth)
            make.centerY.equalTo(view).offset(0.1 * deviceHeight)
        }
    }
    
}

