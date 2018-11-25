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
    
    /* 判断历史还是当前次结果 */
    static var ishistory: Bool = true   //true: 历史    false: 当前
    
    /* 错题模型 */
    static var pQuizResult: PQuizResult = PQuizResult()
    
    /* 顶部结果视图 */
    let resultHeadView = PQResultHeadView()
    
    /* 结果列表视图 */
    let practiceResultTableView = UITableView(frame: CGRect(), style: .grouped)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        
        practiceResultTableView.alpha = 0
        self.practiceResultTableView.reloadData()
        self.practiceResultTableView.alpha = 1
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
        self.navigationItem.title = "检测成绩"
        let item = UIBarButtonItem.init(title: "", style: .plain, target: self, action: nil)
        self.navigationItem.backBarButtonItem = item
    
        /* 收藏列表视图 */
        practiceResultTableView.frame = view.bounds
        practiceResultTableView.backgroundColor = .practiceBlue
        practiceResultTableView.delegate = self
        practiceResultTableView.dataSource = self
        view.addSubview(practiceResultTableView)
    }
    
    override func navigationShouldPopMethod() -> Bool {
        guard let vcpopto = self.navigationController?.viewControllers[2] else { return false }
        if PracticeResultViewController.ishistory {
            self.navigationController?.popViewController(animated: true)
        } else {
            self.navigationController?.popToViewController(vcpopto, animated: true)
        }
        return true
    }
}

// MARK: - UITableView
/* 表单视图数据 */
extension PracticeResultViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        log(PracticeResultViewController.pQuizResult.results.count)
        return PracticeResultViewController.pQuizResult.results.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let resultViewCell = PQResultViewCell(byModel: PracticeResultViewController.pQuizResult.results, withIndex: indexPath.row)
        
        resultViewCell.selectionStyle = .none
        resultViewCell.isCollectedIcon.addTarget(self, action: #selector(switchFromCollection), for: .touchUpInside)
        
        return resultViewCell
    }
    
    @objc func switchFromCollection(button: UIButton) {
        let indexPath = self.practiceResultTableView.indexPath(for: button.superview?.superview as! PQResultViewCell)
        
        if button.image(for: .normal) == #imageLiteral(resourceName: "practiceIsCollected") {
            PracticeCollectionHelper.deleteCollection(quesType: (PracticeResultViewController.pQuizResult.results[(indexPath?.row)!].quesType), quesID: String((PracticeResultViewController.pQuizResult.results[(indexPath?.row)!].quesID))) // 删除云端数据
            SwiftMessages.showSuccessMessage(body: "移除成功")
        } else {
            PracticeCollectionHelper.addCollection(quesType: (PracticeResultViewController.pQuizResult.results[(indexPath?.row)!].quesType), quesID: String((PracticeResultViewController.pQuizResult.results[(indexPath?.row)!].quesID))) // 增加云端数据
            SwiftMessages.showSuccessMessage(body: "收藏成功")
        }
        
        button.switchIconAnimation()
    }
    
}

/* 表单视图代理 */
extension PracticeResultViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return PQResultViewCell(byModel: PracticeResultViewController.pQuizResult.results, withIndex: indexPath.row).cellHeight
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section != 0 { return UIView() }
        resultHeadView.initHeader(score: PracticeResultViewController.pQuizResult.score, practiceTime: PQuizCollectionViewController.usedTime, errorNum: PracticeResultViewController.pQuizResult.errNum)
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

