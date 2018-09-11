//
//  PracticeWrongViewController.swift
//  WePeiYang
//
//  Created by JasonEWNL on 2018/8/2.
//  Copyright © 2018年 twtstudio. All rights reserved.
//

import UIKit
import PopupDialog

class PracticeWrongViewController: UIViewController {
    
    /* 错题模型 */
    var practiceWrong: PracticeWrongModel!
    
    /* 错题列表视图 */
    let practiceWrongTableView = UITableView(frame: CGRect(), style: .grouped)
        
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
        let titleLabel = UILabel(text: "我的错题")
        titleLabel.font = UIFont.boldSystemFont(ofSize: 21)
        titleLabel.textColor = .white
        titleLabel.sizeToFit()
        navigationItem.titleView = titleLabel
        
        /* 错题列表视图 */
        practiceWrongTableView.frame = self.view.bounds
        practiceWrongTableView.backgroundColor = .clear
        practiceWrongTableView.delegate = self
        practiceWrongTableView.dataSource = self
        self.view.addSubview(practiceWrongTableView)
    }
    
    // 刷新所有 //
    func reloadDataAndView() {
        PracticeWrongHelper.getWrong(success: { practiceWrong in
            self.practiceWrong = practiceWrong
            self.reloadTitleView()
            self.practiceWrongTableView.reloadData()
        }) { error in }
    }
    
    // 刷新标题 //
    func reloadTitleView() {
        let titleLabel = UILabel(text: "我的错题", color: .white)
        titleLabel.font = UIFont.boldSystemFont(ofSize: 21)
        
        // 错题不为零时显示错题数
        if practiceWrong.data.ques.count != 0 { titleLabel.text = "我的错题 (\(practiceWrong.data.ques.count))" }
        
        titleLabel.sizeToFit()
        self.navigationItem.titleView = titleLabel
    }
    
}

/* 表单视图数据 */
extension PracticeWrongViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if practiceWrong == nil { return 0 }
        return practiceWrong.data.ques.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if practiceWrong == nil { return UITableViewCell() }
        
        let wrongViewCell = WrongViewCell(byModel: practiceWrong, withIndex: indexPath.row)
        
        wrongViewCell.selectionStyle = .none
        wrongViewCell.isCollectedIcon.addTarget(self, action: #selector(switchFromCollection), for: .touchUpInside)
        wrongViewCell.isWrongIcon.addTarget(self, action: #selector(showRemoveWaring), for: .touchUpInside)
        
        return wrongViewCell
    }
    
    @objc func switchFromCollection(button: UIButton) {
        let indexPath = self.practiceWrongTableView.indexPath(for: button.superview?.superview as! WrongViewCell)
        
        if button.image(for: .normal) == #imageLiteral(resourceName: "practiceIsCollected") {
            PracticeCollectionHelper.deleteCollection(quesType: (self.practiceWrong?.data.ques[(indexPath?.row)!].quesType)!, quesID: String((self.practiceWrong?.data.ques[(indexPath?.row)!].quesID)!)) // 删除云端数据
            SwiftMessages.showSuccessMessage(body: "移除成功")
        } else {
            PracticeCollectionHelper.addCollection(quesType: (self.practiceWrong?.data.ques[(indexPath?.row)!].quesType)!, quesID: String((self.practiceWrong?.data.ques[(indexPath?.row)!].quesID)!)) // 增加云端数据
            SwiftMessages.showSuccessMessage(body: "收藏成功")
        }
        
        button.switchIconAnimation()
    }
    
    @objc func showRemoveWaring(button: UIButton) {
        button.setBounceAnimation()
        
        let indexPath = self.practiceWrongTableView.indexPath(for: button.superview?.superview as! WrongViewCell)
        
        let warningCard = PopupDialog(title: "移除", message: "您确定将本题移出错题本?", buttonAlignment: .horizontal, transitionStyle: .zoomIn)
        let cancelButton = CancelButton(title: "再留一段时间", action: nil)
        let removeButton = DestructiveButton(title: "我会了, 移走吧", dismissOnTap: true) {
            button.switchIconAnimation()
            PracticeWrongHelper.deleteWrong(quesType: (self.practiceWrong?.data.ques[(indexPath?.row)!].quesType)!, quesID: String((self.practiceWrong?.data.ques[(indexPath?.row)!].quesID)!)) // 删除云端数据
            self.practiceWrong.data.ques.remove(at: (indexPath?.row)!) // 删除本地数据
            self.practiceWrongTableView.deleteRows(at: [indexPath!], with: .right) // 删除界面单元
            self.reloadTitleView() // 刷新标题
            SwiftMessages.showSuccessMessage(body: "成功移除") // 提示成功
        }
        
        warningCard.addButtons([cancelButton, removeButton])
        self.present(warningCard, animated: true, completion: nil)
    }
    
}

/* 表单视图代理 */
extension PracticeWrongViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {        
        return WrongViewCell(byModel: practiceWrong, withIndex: indexPath.row).cellHeight
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

extension UIButton {
    // 设置交叉图标 //
    func setSwitchIcon(forNormalAndHighlighted firstImage: UIImage, andSelected secondImage: UIImage) {
        self.setImage(firstImage, for: .normal)
        self.setImage(firstImage, for: .highlighted)
        self.setImage(secondImage, for: .selected)
    }
    
    // 交换图标动画 //
    func switchIconAnimation() {
        self.setBounceAnimation {_ in
            self.setImage(self.image(for: .selected), for: .highlighted)
            self.setImage(self.image(for: .normal), for: .selected)
            self.setImage(self.image(for: .highlighted), for: .normal)
        }
    }
    
    // 利用 OC 的 runtime 特性, 创建属性, 并实现 get \ set 方法
    private struct AssociatedKeys {
        static var indexPath: IndexPath?
    }
    
    // 引入一个 IndexPath 类型属性, 用于记录 UIButton 所在 UITableViewCell 的 indexPath
    // 已经利用 .superView.superView 获取到了 UITableViewCell, 此方法暂时废弃
    var indexPath: IndexPath? {
        get { return objc_getAssociatedObject(self, &AssociatedKeys.indexPath) as? IndexPath }
        set { if let newValue = newValue { objc_setAssociatedObject(self, &AssociatedKeys.indexPath, newValue as IndexPath?, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC) } }
    }
}
