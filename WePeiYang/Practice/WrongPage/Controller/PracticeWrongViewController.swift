//
//  PracticeWrongViewController.swift
//  WePeiYang
//
//  Created by JasonEWNL on 2018/8/2.
//  Copyright © 2018年 twtstudio. All rights reserved.
//

import UIKit

class PracticeWrongViewController: UIViewController {
    
    /* 错题模型 */
    var practiceWrong: PracticeWrongModel!
    
    /* 错题列表视图 */
    let practiceWrongTableView = UITableView(frame: CGRect(), style: .plain)
        
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white

        /* 错题模型 */
        PracticeWrongHelper.getWrong(success: { practiceWrong in
            self.practiceWrong = practiceWrong
            self.practiceWrongTableView.reloadData()
            
            // 错题不为零时显示错题数
            if practiceWrong.ques.count != 0 {
                let titleLabel = UILabel(text: "我的错题 (\(practiceWrong.ques.count))")
                titleLabel.font = UIFont.boldSystemFont(ofSize: 21)
                titleLabel.textColor = .white
                titleLabel.sizeToFit()
                self.navigationItem.titleView = titleLabel
            }
        }) { error in }
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
        
        /* 标题 */
        let titleLabel = UILabel(text: "我的错题")
        titleLabel.font = UIFont.boldSystemFont(ofSize: 21)
        titleLabel.textColor = .white
        titleLabel.sizeToFit()
        navigationItem.titleView = titleLabel
        
        practiceWrongTableView.frame = self.view.bounds
        practiceWrongTableView.delegate = self
        practiceWrongTableView.dataSource = self
        self.view.addSubview(practiceWrongTableView)
    }
    
}

/* 表单视图数据 */
extension PracticeWrongViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if practiceWrong == nil { return 0 }
        return practiceWrong.ques.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if practiceWrong == nil { return UITableViewCell() }
        
        let wrongViewCell = WrongViewCell(byModel: practiceWrong, withIndex: indexPath.row)
        
        wrongViewCell.selectionStyle = .none
        
        return wrongViewCell
    }
    
}

/* 表单视图代理 */
extension PracticeWrongViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {        
        return WrongViewCell(byModel: practiceWrong, withIndex: indexPath.row).cellHeight
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        return
    }
    
}
