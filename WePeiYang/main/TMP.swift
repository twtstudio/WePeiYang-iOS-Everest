//
//  TMP.swift
//  WePeiYang
//
//  Created by Zrzz on 2020/11/21.
//  Copyright © 2020 twtstudio. All rights reserved.
//

import UIKit

class TMP: UIViewController {
     override func viewDidLoad() {
          view.backgroundColor = .white
          let stackView = UIStackView(frame: CGRect(x: 100, y: 200, width: 200, height: 50))
          stackView.distribution = .fillEqually
//          stackView.layer.borderWidth = 1
          stackView.spacing = 2
          stackView.backgroundColor = .black
          stackView.addCornerRadius(15)
//          stackView.layer.borderColor = UIColor.black.cgColor
          var labels: [UILabel] = []
          for i in 0..<3 {
               let label = UILabel()
               label.text = "Label \(i)"
               labels.append(label)
               label.backgroundColor = UIColor(hex6: arc4random())
               stackView.addArrangedSubview(label)
          }
          view.addSubview(stackView)
     }
}
