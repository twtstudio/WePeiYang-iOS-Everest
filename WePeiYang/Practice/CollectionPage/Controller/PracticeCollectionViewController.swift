//
//  PracticeCollectionViewController.swift
//  WePeiYang
//
//  Created by JasonEWNL on 2018/9/1.
//  Copyright © 2018年 twtstudio. All rights reserved.
//

import UIKit
import PopupDialog

class PracticeCollectionViewController: UIViewController {
    
    /* 错题模型 */
    var practiceCollection: PracticeCollectionModel!
    
    /* 错题列表视图 */
    let practiceCollectionTableView = UITableView(frame: CGRect(), style: .grouped)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        
        // 刷新所有 //
        self.reloadDataAndView()
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
        let titleLabel = UILabel(text: "我的收藏")
        titleLabel.font = UIFont.boldSystemFont(ofSize: 21)
        titleLabel.textColor = .white
        titleLabel.sizeToFit()
        navigationItem.titleView = titleLabel
        
        /* 错题列表视图 */
        practiceCollectionTableView.frame = self.view.bounds
        practiceCollectionTableView.backgroundColor = .clear
        practiceCollectionTableView.delegate = self
        practiceCollectionTableView.dataSource = self
        self.view.addSubview(practiceCollectionTableView)
    }
    
    // 刷新所有 //
    func reloadDataAndView() {
        PracticeCollectionHelper.getCollection(success: { practiceCollection in
            self.practiceCollection = practiceCollection
            self.practiceCollectionTableView.reloadData()
            self.reloadTitleView()
        }) { error in }
    }
    
    // 刷新标题 //
    func reloadTitleView() {
        let titleLabel = UILabel(text: "我的收藏", color: .white)
        titleLabel.font = UIFont.boldSystemFont(ofSize: 21)
        
        // 错题不为零时显示错题数
        if practiceCollection.ques.count != 0 { titleLabel.text = "我的收藏 (\(practiceCollection.ques.count))" }
        
        titleLabel.sizeToFit()
        self.navigationItem.titleView = titleLabel
    }
    
}

/* 表单视图数据 */
extension PracticeCollectionViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if practiceCollection == nil { return 0 }
        return practiceCollection.ques.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if practiceCollection == nil { return UITableViewCell() }
        
        let collectionViewCell = CollectionViewCell(byModel: practiceCollection, withIndex: indexPath.row)
        
        collectionViewCell.selectionStyle = .none
        collectionViewCell.isCollectedIcon.addTarget(self, action: #selector(showRemoveWaring), for: .touchUpInside)
        
        return collectionViewCell
    }
    
    @objc func showRemoveWaring(button: UIButton) {
        button.setBounceAnimation()
        
        let indexPath = self.practiceCollectionTableView.indexPath(for: button.superview?.superview as! CollectionViewCell)
        
        let warningCard = PopupDialog(title: "移除", message: "您确定将本题移出收藏夹?", buttonAlignment: .horizontal, transitionStyle: .zoomIn)
        let cancelButton = CancelButton(title: "再留一段时间", action: nil)
        let removeButton = DestructiveButton(title: "我会了, 移走吧", dismissOnTap: true) {
            button.switchIconAnimation()
            PracticeCollectionHelper.deleteCollection(quesType: (self.practiceCollection?.ques[(indexPath?.row)!].type)!, quesID: String((self.practiceCollection?.ques[(indexPath?.row)!].id)!)) // 删除云端数据
            self.practiceCollection.ques.remove(at: (indexPath?.row)!) // 删除本地数据
            self.practiceCollectionTableView.deleteRows(at: [indexPath!], with: .right) // 删除界面
            self.reloadTitleView() // 刷新标题
            SwiftMessages.showSuccessMessage(body: "移除成功") // 提示成功
        }
        
        warningCard.addButtons([cancelButton, removeButton])
        self.present(warningCard, animated: true, completion: nil)
    }
    
}

/* 表单视图代理 */
extension PracticeCollectionViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CollectionViewCell(byModel: practiceCollection, withIndex: indexPath.row).cellHeight
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.1
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.1
    }
    
}
