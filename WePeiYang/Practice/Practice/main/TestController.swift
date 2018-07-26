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
    let result: String? = "正确"
    let answer: String? = "通过更改数据源来给用户一个假象，图片在无限滚动（其实一共只有3个 cell），默认显示第一个，右滑 index + 1, 左滑 index - 1，然后修改数据源，异步回到第一个cell（注意不能有动画）通过更改数据源来给用户一个假象，图片在无限滚动（其实一共只有3个 cell），默认显示第一个，右滑 index + 1, 左滑 index - 1，然后修改数据源，异步回到第一个cell（注意不能有动画）"

    var testView = AnswerScrollView(frame: .zero)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        testView.backgroundColor = .purple
        testView.creatAnswerView(result: result, answer: answer)

        view.addSubview(testView)
        testView.snp.makeConstraints { (make) in
            make.width.equalTo(QuestionViewParameters.questionViewW)
            make.height.equalTo(AnswerViewParameters.answerViewH)
            make.centerX.bottom.equalTo(view)
        }
    }
    
}

