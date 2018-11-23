//
//  PCourseInfoCell.swift
//  WePeiYang
//
//  Created by yuting jiang on 2018/10/28.
//  Copyright © 2018 twtstudio. All rights reserved.
//

import Foundation
import SnapKit

class PCourseInfoCell: UITableViewCell {
    var index: String = ""
    let kitH: CGFloat = 20
    let qTypeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 13)
        return label
    }()
    
    let practiceBtn:UIButton = {
        let btn = UIButton()
        btn.layer.borderWidth = 1
        btn.layer.borderColor = UIColor.practiceBlue.cgColor
        btn.setTitleColor(UIColor.practiceBlue, for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 13)
        return btn
    }()

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupUI(typeInt: Int, quesType: String, numOfQues: String, doneQues: String, index: Int) {
        self.index = String(index)
        qTypeLabel.text = quesType + "  \(doneQues)/\(numOfQues)   当前：\(index)"
        if index == 0 {
            practiceBtn.setTitle("开始练习", for: .normal)
        } else {
            practiceBtn.setTitle("继续练习", for: .normal)
        }
        practiceBtn.tag = typeInt
        practiceBtn.layer.cornerRadius = 0.5 * kitH
        practiceBtn.addTarget(self, action: #selector(popExerciseVC(_:)), for: .touchUpInside)
        self.addSubview(practiceBtn)
        practiceBtn.snp.makeConstraints { (make) in
            make.width.equalTo(0.2 * self.width)
            make.height.equalTo(kitH)
            make.right.equalTo(self).offset(-0.05 * self.width)
            make.centerY.equalTo(self)
        }
        
        self.addSubview(qTypeLabel)
        qTypeLabel.snp.makeConstraints { (make) in
            make.width.equalTo(0.5 * self.width)
            make.height.equalTo(kitH)
            make.left.equalTo(self).offset(0.06 * self.width)
            make.centerY.equalTo(self)
        }
    }
    
    @objc private func popExerciseVC(_ button: UIButton) {
        log("POP BTN TAPPED")
        let typeInt = button.tag
        PracticeFigure.questionType = String(typeInt)
        PracticeFigure.currentCourseIndex = self.index
        let topVC = UIViewController.currentViewController()
        topVC?.navigationController?.pushViewController(ExerciseCollectionViewController(), animated: true)
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "HindCourseInfoCard"), object: nil)
    }
    
    // 获取当前最顶层的controller
    func currentVc() -> UIViewController {
        let keywindow = UIApplication.shared.keyWindow
        let firstView: UIView = (keywindow?.subviews.first)!
        let secondView: UIView = firstView.subviews.first!
        let vc = viewForController(view: secondView)
        return vc!
    }
    
    func viewForController(view:UIView)->UIViewController?{
        var next:UIView? = view
        repeat{
            if let nextResponder = next?.next, nextResponder is UIViewController {
                return (nextResponder as! UIViewController)
            }
            next = next?.superview
        }while next != nil
        return nil
    }
}

extension UIViewController {
    class func currentViewController(base: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
        if let nav = base as? UINavigationController {
            return currentViewController(base: nav.visibleViewController)
        }
        if let tab = base as? UITabBarController {
            return currentViewController(base: tab.selectedViewController)
        }
        if let presented = base?.presentedViewController {
            return currentViewController(base: presented)
        }
        return base
    }
}

