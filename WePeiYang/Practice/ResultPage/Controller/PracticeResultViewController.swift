//
//  PracticeResultViewController.swift
//  WePeiYang
//
//  Created by JasonEWNL on 2018/10/27.
//  Copyright © 2018年 twtstudio. All rights reserved.
//

import UIKit

// MARK: UIViewController
class PracticeResultViewController: UIViewController {
    
    /* 错题模型 */
    var practiceWrong: PracticeWrongModel!
    
    /* 顶部结果视图 */
    let resultHeadView = ResultHeadView()
    
    /* 结果列表视图 */
    let practiceResultTableView = UITableView(frame: CGRect(), style: .grouped)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        
        practiceResultTableView.alpha = 0
        PracticeWrongHelper.getWrong(success: { practiceWrong in
            self.practiceWrong = practiceWrong
            UIView.animate(withDuration: 0.5, animations: {
                self.practiceResultTableView.reloadData()
                self.practiceResultTableView.alpha = 1
            })
        }) { _ in
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        /* 导航栏 */
        navigationController?.setNavigationBarHidden(false, animated: true)
        navigationController?.navigationBar.barStyle = .black
        navigationController?.navigationBar.setBackgroundImage(UIImage(color: .practiceBlue), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.tintColor = .white
        
//        // 额外视图 //
//        let additionalView = UIView(frame: CGRect(x: 0, y: -barHeight, width: deviceWidth, height: barHeight))
//        additionalView.backgroundColor = .practiceBlue
//        resultHeadView.addSubview(additionalView)
        
        /* 收藏列表视图 */
        practiceResultTableView.frame = view.bounds
        practiceResultTableView.backgroundColor = .practiceBlue
        practiceResultTableView.delegate = self
        practiceResultTableView.dataSource = self
        view.addSubview(practiceResultTableView)
    }
    
}

// MARK: - UITableView
/* 表单视图数据 */
extension PracticeResultViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if practiceWrong == nil { return 0 }
        return practiceWrong.data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if practiceWrong == nil { return UITableViewCell() }
        
        let resultViewCell = ResultViewCell(byModel: practiceWrong, withIndex: indexPath.row)
        
        resultViewCell.selectionStyle = .none
        resultViewCell.isCollectedIcon.addTarget(self, action: #selector(switchFromCollection), for: .touchUpInside)
        
        return resultViewCell
    }
    
    @objc func switchFromCollection(button: UIButton) {
        let indexPath = self.practiceResultTableView.indexPath(for: button.superview?.superview as! ResultViewCell)
        
        if button.image(for: .normal) == #imageLiteral(resourceName: "practiceIsCollected") {
            PracticeCollectionHelper.deleteCollection(quesType: (self.practiceWrong?.data[(indexPath?.row)!].quesType)!, quesID: String((self.practiceWrong?.data[(indexPath?.row)!].quesID)!)) // 删除云端数据
            SwiftMessages.showSuccessMessage(body: "移除成功")
        } else {
            PracticeCollectionHelper.addCollection(quesType: (self.practiceWrong?.data[(indexPath?.row)!].quesType)!, quesID: String((self.practiceWrong?.data[(indexPath?.row)!].quesID)!)) // 增加云端数据
            SwiftMessages.showSuccessMessage(body: "收藏成功")
        }
        
        button.switchIconAnimation()
    }
    
}

/* 表单视图代理 */
extension PracticeResultViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return ResultViewCell(byModel: practiceWrong, withIndex: indexPath.row).cellHeight
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section != 0 { return UIView() }
        return resultHeadView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section != 0 { return 0.1 }
        return 220
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.1
    }
    
}
