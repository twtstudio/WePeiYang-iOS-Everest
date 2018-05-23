//
//  TableViewController.swift
//  Comment
//
//  Created by yuting jiang on 2018/5/3.
//  Copyright © 2018年 yuting jiang. All rights reserved.
//

import Foundation
import UIKit
import SnapKit


let bgColor = UIColor(red: 240/255, green: 240/255, blue: 240/255, alpha: 1)
let uiOrange = UIColor(red: 254/255, green: 119/255, blue: 11/255, alpha: 1)
let lowerGray = UIColor(red: 112/255, green: 112/255, blue: 112/255, alpha: 1)
let normalGray = UIColor(red: 153/255, green: 152/255, blue: 152/255, alpha: 1)
let lowestGray = UIColor(red: 86/255, green: 86/255, blue: 86/255, alpha: 1)
let sWid = Double(UIScreen.main.bounds.width)
let sHeight = Double(UIScreen.main.bounds.height)

var updatePic: [UIImage] = []
var updatePicUrl: [URL] = []

class FoodCommentTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, JNStarReteViewDelegate {
    let labels: [UILabel] = []
    var mealButtons: [UIButton] = []
    var commentButtons: [UIButton] = []
    
    let topImgViewH = sHeight * 0.2
    let titleViewH = sHeight * 0.1
    let titleVIewW = sWid * 0.85
    let nameLabelH = sHeight * 0.02
    let labelsW = sWid * 0.17
    let labelsH = sHeight * 23 / 736
    let labelVerOffset = sHeight * 43 / 736
    let commentButtonsH = sHeight * 23 / 736
    let mealButtonsH = sHeight * 23 / 736
    let mealButtonsW = sWid * 64 / 414
    let picButtonW = Int((sWid * 0.85 - 20) / 3)
    let criticalTextFieldH = sHeight * 165 / 736
    let gGap = sHeight * 20 / 736
    
    var comButsWid = 0
    var offset = 0.0
    let horOffset = 0.075 * sWid
    let fIndex = NSIndexPath(index: 0)
    
    var headImg = #imageLiteral(resourceName: "dish")
    
    //=========
    
//    let tableView = UITableView(frame: CGRect(x: 0, y: 64, width: sWid, height: sHeight - 64), style: .grouped)
    let tableView = UITableView(frame: CGRect(x: 0, y: 0, width: sWid, height: sHeight), style: .grouped)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.estimatedRowHeight = 44
        setNavBar()
        setTableView()
    }
    
    func setTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = bgColor
        tableView.separatorStyle = .none
        tableView.estimatedRowHeight = 44
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "tableCells")
        self.view.addSubview(tableView)
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tableCells")
        cell?.backgroundColor = .clear
        cell?.selectedBackgroundView = UIView()
        cell?.selectedBackgroundView?.backgroundColor = .clear
        switch indexPath.item {
        case 1:
            return setTimeCell()                //用餐时间
        case 2:
            return setSecondCell()              //综合打分
        case 3:
            return setThirdCell()               //标签快评
        case 4:
            return setForthCell()               //评论
        case 5:
            return TableViewCell()             //添加图片
        case 6:
            return setAnonymityCell()           //匿名button
        case 7:
            return setSubmitCell()              //提交button
        default:
            return cell!
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 9
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return CGFloat(topImgViewH)
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let titleView: UIView = {
            let view = UIView()
            view.backgroundColor = .white
            view.layer.shadowColor = UIColor(red: 50/255, green: 50/255, blue: 50/255, alpha: 1).cgColor
            return view
        }()
        
        let nameLabel: UILabel = {
            let label = UILabel()
            label.text = "菜名"
            label.textColor = UIColor(red: 44/255, green: 44/255, blue: 44/255, alpha: 1)
            label.font = UIFont.boldSystemFont(ofSize: 20)
            
            label.adjustsFontSizeToFitWidth = true
            //label.adjustsFontForContentSizeCategory = true
            return label
        }()
        
        let canteenLabel: UILabel = {
            let label = UILabel()
            label.text = "竹园餐厅（学四）二层1号窗口"
            label.textColor = UIColor(red: 94/255, green: 94/255, blue: 94/255, alpha: 1)
            label.font = UIFont.systemFont(ofSize: 12)
            label.adjustsFontSizeToFitWidth = true
            return label
        }()
        
        if section == 0 {
            let headImgView = UIImageView(image: headImg)
            headImgView.sizeToFit()
            headImgView.frame = CGRect(x: 0, y: 0, width: sWid, height: topImgViewH)
            
            headImgView.addSubview(titleView)
            titleView.snp.makeConstraints { (make) in
                make.width.equalTo(titleVIewW)//350
                make.height.equalTo(titleViewH) //70
                make.centerX.equalTo(headImgView)
                make.bottomMargin.equalTo(headImgView).offset(20)
            }
            
            headImgView.addSubview(nameLabel)
            nameLabel.snp.makeConstraints { (make) in
                make.height.equalTo(nameLabelH)//15
                make.leftMargin.equalTo(titleView).offset(sWid * 0.05) //20
                make.topMargin.equalTo(titleView).offset(sHeight * 0.02) //18
            }
            
            headImgView.addSubview(canteenLabel)
            canteenLabel.snp.makeConstraints { (make) in
                make.width.equalTo(sWid * 0.7)
                make.height.equalTo(sHeight * 0.02)//15
                make.leftMargin.equalTo(nameLabel)
                make.topMargin.equalTo(nameLabel).offset(25)
            }
            return headImgView
        } else {
            return nil
        }
    }
    
    func setNavBar() {
//        self.navigationController?.navigationBar.barTintColor = uiOrange
//        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white, NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 19)]
//        navigationItem.title = "点评"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationItem.title = "点评"
    }
    
    func setTimeCell() -> UITableViewCell {
        let timeLabel: UILabel = {
            let label = UILabel()
            label.text = "就餐时间"
            return label
        }()
        
        let breakfastButton: UIButton = {
            let button = UIButton()
            button.setTitle("早餐", for: .normal)
            return button
        }()
        
        let lunchButton: UIButton = {
            let button = UIButton()
            button.setTitle("中餐", for: .normal)
            return button
        }()
        
        let dinnerButton: UIButton = {
            let button = UIButton()
            button.setTitle("晚餐", for: .normal)
            return button
        }()
        let mealButtons = [breakfastButton, lunchButton, dinnerButton]
        let firstcell: UITableViewCell = tableView.mm_dequeueStaticCell(indexPath: fIndex)
        firstcell.backgroundColor = .clear
        
        firstcell.contentView.addSubview(timeLabel)
        timeLabel.textAlignment = .center
        timeLabel.font = UIFont.systemFont(ofSize: 16)
        timeLabel.textColor = .darkGray
        timeLabel.adjustsFontSizeToFitWidth = true
        timeLabel.snp.makeConstraints { (make) in
            make.width.equalTo(labelsW)
            make.height.equalTo(labelsH)
            make.left.equalTo(firstcell.contentView).offset(horOffset)
            make.top.equalTo(firstcell.contentView)
            make.bottom.equalTo(firstcell.contentView).offset(-labelsH)
        }
        
        for i in 0..<mealButtons.count {
            let gap = sWid * 20 / 414
            let buttonsOffset = gap + mealButtonsW
            let HorOffset = labelsW + gap + buttonsOffset * Double(i)
            
            setMealButton(mealButtons[i])
            firstcell.contentView.addSubview(mealButtons[i])
            mealButtons[i].snp.makeConstraints { (make) in
                make.width.equalTo(mealButtonsW)
                make.height.equalTo(mealButtonsH)
                make.left.equalTo(timeLabel).offset(HorOffset)
                make.top.equalTo(timeLabel)
            }
            mealButtons[i].addTarget(self, action: #selector(tapped(_ :)), for: .touchUpInside)
        }
        firstcell.selectionStyle = .none
        return firstcell
    }
    
    func setSecondCell() -> UITableViewCell {
        let commentLabel: UILabel = {
            let label = UILabel()
            label.text = "综合打分"
            return label
        }()
        
        let firstcell: UITableViewCell = tableView.mm_dequeueStaticCell(indexPath: fIndex)
        firstcell.backgroundColor = .clear
        
        firstcell.contentView.addSubview(commentLabel)
        commentLabel.textAlignment = .center
        commentLabel.font = UIFont.systemFont(ofSize: 16)
        commentLabel.textColor = .darkGray
        commentLabel.adjustsFontSizeToFitWidth = true
        commentLabel.snp.makeConstraints { (make) in
            make.width.equalTo(labelsW)
            make.height.equalTo(labelsH)
            make.left.equalTo(firstcell.contentView).offset(horOffset)
            make.top.equalTo(firstcell.contentView)
            make.bottom.equalTo(firstcell.contentView).offset(-labelsH)
        }
        
        //评分
        let gap = sWid * 20 / 414
        let heartViewH = sHeight * 15 / 736
        let heartViewW = sWid * 100 / 414
        let heartView = JNStarRateView.init(frame: CGRect(x: 20, y: 60, width: heartViewW, height: heartViewH))
        heartView.delegate = self
        heartView.allowUserPan = true
        heartView.usePanAnimation = true
        heartView.allowUnderCompleteStar = false
        
        firstcell.contentView.addSubview(heartView)
        heartView.snp.makeConstraints { (make) in
            make.width.equalTo(heartViewW)
            make.height.equalTo(heartViewH)
            make.left.equalTo(commentLabel).offset(labelsW + gap)
            make.top.equalTo(commentLabel)
            make.bottom.equalTo(commentLabel)
        }
        firstcell.selectionStyle = .none
        return firstcell
    }
    
    func setThirdCell() -> UITableViewCell {
        let label: UILabel = {
            let label = UILabel()
            label.backgroundColor = .clear
            return label
        }()
        
        let labelLabel: UILabel = {
            let label = UILabel()
            label.text = "标签快评"
            return label
        }()
        
        let comButton0: UIButton = {
            let button = UIButton()
            button.setTitle("服务好", for: .normal)
            return button
        }()
        
        let comButton1: UIButton = {
            let button = UIButton()
            button.setTitle("酸", for: .normal)
            return button
        }()
        
        let comButton2: UIButton = {
            let button = UIButton()
            button.setTitle("环境好", for: .normal)
            return button
        }()
        
        let comButton3: UIButton = {
            let button = UIButton()
            button.setTitle("支持移动支付", for: .normal)
            return button
        }()
        
        let comButton4: UIButton = {
            let button = UIButton()
            button.setTitle("辣", for: .normal)
            return button
        }()
        
        let comButton5: UIButton = {
            let button = UIButton()
            button.setTitle("咸", for: .normal)
            return button
        }()
        
        let comButton6: UIButton = {
            let button = UIButton()
            button.setTitle("甜", for: .normal)
            return button
        }()
        
        let comButton7: UIButton = {
            let button = UIButton()
            button.setTitle("味道好", for: .normal)
            return button
        }()
        
        let comButton8: UIButton = {
            let button = UIButton()
            button.setTitle("上菜快", for: .normal)
            return button
        }()
        
        let comButton9: UIButton = {
            let button = UIButton()
            button.setTitle("分量足", for: .normal)
            return button
        }()
        commentButtons = [comButton0, comButton1, comButton2, comButton4, comButton3, comButton5, comButton6, comButton7, comButton8, comButton9]
        
        let firstcell: UITableViewCell = tableView.mm_dequeueStaticCell(indexPath: fIndex)
        firstcell.backgroundColor = .clear
        
        for i in 0..<commentButtons.count {
            let wid = commentButtons[i].setWidth(withTitle: commentButtons[i].currentTitle!)
            let gap = Int(sWid * 20 / 414)
            let vGap = sHeight * 20 / 736
            
            comButsWid = comButsWid + wid + gap
            
            if comButsWid >= Int(sWid * 0.68) {
                comButsWid = wid + gap
                offset = offset + vGap + commentButtonsH
            }
        }
        
        firstcell.contentView.addSubview(label)
        label.snp.makeConstraints { (make) in
            make.width.equalTo(labelsW)
            make.height.equalTo(offset + gGap)
            make.left.equalTo(firstcell.contentView).offset(horOffset)
            make.top.equalTo(firstcell.contentView)
            make.bottom.equalTo(firstcell.contentView).offset(-labelsH)
        }
        
        firstcell.contentView.addSubview(labelLabel)
        labelLabel.textAlignment = .center
        labelLabel.font = UIFont.systemFont(ofSize: 16)
        labelLabel.textColor = .darkGray
        labelLabel.adjustsFontSizeToFitWidth = true
        labelLabel.snp.makeConstraints { (make) in
            make.width.equalTo(labelsW)
            make.height.equalTo(labelsH)
            make.left.equalTo(label)
            make.top.equalTo(label)
        }
        
        offset = 0
        comButsWid = 0
        for i in 0..<commentButtons.count {
            let wid = commentButtons[i].setWidth(withTitle: commentButtons[i].currentTitle!)
            let gap = Int(sWid * 20 / 414)
            let vGap = sHeight * 20 / 736
            let initialOff = gap + Int(labelsW)
            
            comButsWid = comButsWid + wid + gap
            
            if comButsWid >= Int(sWid * 0.68) {
                comButsWid = wid + gap
                offset = offset + vGap + commentButtonsH
            }
            
            setMealButton(commentButtons[i])
            firstcell.contentView.addSubview(commentButtons[i])
            commentButtons[i].snp.makeConstraints { (make) in
                make.width.equalTo(wid)
                make.height.equalTo(commentButtonsH)
                make.leftMargin.equalTo(label).offset(initialOff + comButsWid - wid - gap)
                make.topMargin.equalTo(label).offset(offset)
            }
            commentButtons[i].addTarget(self, action: #selector(tapped(_ :)), for: .touchUpInside)
        }
        firstcell.selectionStyle = .none
        return firstcell
    }
    
    func setForthCell() -> UITableViewCell {
        let label: UILabel = {
            let label = UILabel()
            label.backgroundColor = .clear
            return label
        }()
        
        let firstcell: UITableViewCell = tableView.mm_dequeueStaticCell(indexPath: fIndex)
        firstcell.backgroundColor = .clear
        
        firstcell.contentView.addSubview(label)
        label.snp.makeConstraints { (make) in
            make.width.equalTo(labelsW)
            make.height.equalTo(criticalTextFieldH + labelsH * 2)
            make.left.equalTo(firstcell.contentView).offset(horOffset)
            make.top.equalTo(firstcell.contentView)
            make.bottom.equalTo(firstcell.contentView).offset(-horOffset)
        }
        
        let criticLabel: UILabel = {
            let label = UILabel()
            label.text = " 评论"
            label.font = UIFont.systemFont(ofSize: 16)
            label.textColor = .darkGray
            return label
        }()
        firstcell.contentView.addSubview(criticLabel)
        criticLabel.adjustsFontSizeToFitWidth = true
        criticLabel.snp.makeConstraints { (make) in
            make.width.equalTo(labelsW * 0.6)
            make.height.equalTo(labelsH)
            make.left.equalTo(label)
            make.top.equalTo(label)
        }
        
        let criticTextField: UITextView = {
            let field = UITextView()
            field.layer.borderWidth = 1
            field.layer.borderColor = UIColor(red: 229/255, green: 229/255, blue: 229/255, alpha: 1).cgColor
            return field
        }()
        firstcell.contentView.addSubview(criticTextField)
        criticTextField.snp.makeConstraints { (make) in
            make.width.equalTo(sWid * 0.85)
            make.height.equalTo(criticalTextFieldH)
            make.leftMargin.equalTo(label)
            make.topMargin.equalTo(label).offset(labelsH)
        }
        
        let picLabel: UILabel = {
            let label = UILabel()
            label.text = "添加图片"
            label.textAlignment = .center
            label.font = UIFont.systemFont(ofSize: 16)
            label.textColor = .darkGray
            return label
        }()
        
        firstcell.contentView.addSubview(picLabel)
        picLabel.snp.makeConstraints { (make) in
            make.width.equalTo(labelsW)
            make.height.equalTo(labelsH)
            make.left.equalTo(firstcell.contentView).offset(horOffset)
            make.bottom.equalTo(firstcell.contentView)
        }
        firstcell.selectionStyle = .none
        return firstcell
    }
    
    func setAddPicsCell() -> UITableViewCell {
        //        let collectionViewController = CollectionViewController()
        let picLabel: UILabel = {
            let label = UILabel()
            label.text = "添加图片"
            label.textAlignment = .center
            label.font = UIFont.systemFont(ofSize: 16)
            label.textColor = .darkGray
            return label
        }()
        let firstcell: UITableViewCell = tableView.mm_dequeueStaticCell(indexPath: fIndex)
        firstcell.backgroundColor = .clear
        
        firstcell.contentView.addSubview(picLabel)
        picLabel.snp.makeConstraints { (make) in
            make.width.equalTo(labelsW)
            make.height.equalTo(labelsH)
            make.left.equalTo(firstcell.contentView).offset(horOffset)
            make.top.equalTo(firstcell.contentView)
        }
        
        firstcell.selectionStyle = .none
        return firstcell
    }
    
    func setAddPicButtonCell() -> UITableViewCell {
        let cell = TableViewCell()
        cell.heightAnchor.constraint(equalToConstant: CGFloat(picButtonW))
        return cell
    }
    
    //匿名button
    func setAnonymityCell() -> UITableViewCell {
        let firstcell: UITableViewCell = tableView.mm_dequeueStaticCell(indexPath: fIndex)
        firstcell.selectionStyle = .none
        firstcell.backgroundColor = .clear
        let button: UIButton = {
            let button = UIButton()
            button.setTitle("", for: .normal)
            button.layer.borderWidth = 1
            button.layer.borderColor = UIColor(red: 229/255, green: 229/255, blue: 229/255, alpha: 1).cgColor
            button.backgroundColor = .white
            return button
        }()
        button.addTarget(self, action: #selector(selected(_:)), for: .touchUpInside)
        firstcell.contentView.addSubview(button)
        let width = sWid * 23 / 414
        //        let offset = sHeight * 65 / 736
        
        button.snp.makeConstraints { (make) in
            make.width.equalTo(width)
            make.height.equalTo(width)
            make.leftMargin.equalTo(firstcell.contentView).offset(horOffset)
            make.topMargin.equalTo(firstcell.contentView)
        }
        let anonymityLabel: UILabel = {
            let label = UILabel()
            label.text = "匿名"
            label.textColor = .darkGray
            label.font = UIFont.systemFont(ofSize: 16)
            return label
        }()
        
        anonymityLabel.adjustsFontSizeToFitWidth = true
        firstcell.contentView.addSubview(anonymityLabel)
        anonymityLabel.snp.makeConstraints { (make) in
            let height = sWid * 23 / 414
            let wid = sWid * 50 / 414
            make.width.equalTo(wid)
            make.height.equalTo(height)
            make.left.equalTo(button).offset(width + horOffset / 3)
            make.bottom.equalTo(button)
        }
        return firstcell
    }
    
    func setSubmitCell() -> UITableViewCell {
        let fIndex = NSIndexPath(index: 0)
        let firstcell: UITableViewCell = tableView.mm_dequeueStaticCell(indexPath: fIndex)
        firstcell.backgroundColor = .clear
        
        let submitButton: UIButton = {
            let button = UIButton()
            button.setTitle("提交", for: .normal)
            button.backgroundColor = uiOrange
            button.setTitleColor(.white, for: .normal)
            button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
            button.layer.cornerRadius = 3
            return button
        }()
        
        firstcell.contentView.addSubview(submitButton)
        let submitButH = sHeight * 50 / 736
        submitButton.titleLabel?.adjustsFontSizeToFitWidth = true
        submitButton.snp.makeConstraints { (make) in
            //            let offset = sHeight * 300 / 736
            make.width.equalTo(sWid * 0.85)
            make.height.equalTo(submitButH)
            make.centerX.equalTo(firstcell.contentView)
            make.top.equalTo(firstcell.contentView)
        }
        firstcell.selectionStyle = .none
        return firstcell
    }
    
    func setMealButton(_ button: UIButton) {
        button.backgroundColor = .clear
        button.layer.cornerRadius = 2
        button.layer.borderWidth = 1
        button.layer.borderColor = normalGray.cgColor
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        button.setTitleColor(normalGray, for: .normal)
        button.titleLabel?.adjustsFontSizeToFitWidth = true
    }
    
    func resetButton(_ button: UIButton) {
        if button.backgroundColor == .clear {
            button.backgroundColor = uiOrange
            button.setTitleColor(.white, for: .normal)
            button.layer.borderColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1).cgColor
            print("button tapped")
            
        } else {
            button.backgroundColor = .clear
            button.setTitleColor(normalGray, for: .normal)
            button.layer.borderColor = normalGray.cgColor
        }
    }
    
    func starRate(view starRateView: JNStarRateView, score: Float) {
        print(score)
    }
    
    @objc fileprivate func tapped(_ button: UIButton) {
        resetButton(button)
    }
    
    /// 匿名打勾
    ///
    /// - Parameter button: 是否开启匿名
    @objc fileprivate func selected(_ button: UIButton) {
        // button.currentTitle
        if button.currentTitle == "" {
            button.setTitle("✔️", for: .normal)
            //            button.titleLabel?.text = "✔️"
            print("打勾")
        } else {
            button.setTitle("", for: .normal)
            //            button.titleLabel?.text = ""
            print("clear")
        }
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 10)
    }
}

extension FoodCommentTableViewController {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.item {
        case 5:
            return CGFloat(1.2 * Float(picButtonW))
        default:
            return UITableViewAutomaticDimension
        }
    }
}



