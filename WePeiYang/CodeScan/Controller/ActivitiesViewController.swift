//
//  ActivitiesViewController.swift
//  WePeiYang
//
//  Created by 安宇 on 27/07/2019.
//  Copyright © 2019 twtstudio. All rights reserved.
//

import UIKit
import SnapKit

protocol GetCell {
    func didClickButtonCallBlock(button: UIButton) -> UITableViewCell?
}
class ActivitiesViewController: UIViewController {
//    FIXME:等后台给了数据根据数据数量f计算高度
//
    private let activitiesTableView = UITableView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height), style: .grouped)
    private var selectedCellIndexPath: [IndexPath] = []
//    private var scrollerView = UIScrollView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
    
    var activityDetail: ActivityDeatilModel!
    var uid: Uid!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //导航栏
//        避免最后一个cell显示不全
        self.activitiesTableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 70, right: 0)
        view.backgroundColor = .white
        navigationItem.title = "活动"
        navigationController?.navigationBar.tintColor = .white
//
        navigationController?.navigationBar.setBackgroundImage(nil, for: .default)
        //        MARK:导航栏颜色
        navigationController?.navigationBar.barTintColor = MyColor.ColorHex("#54B9F1")
        navigationController?.setNavigationBarHidden(false, animated: true)
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
        let leftButton = UIBarButtonItem(title: "", style: .plain, target: self, action: #selector(pop))
        let image = UIImage(named:"3")!
        leftButton.image = UIImage.resizedImage(image: image, scaledToSize: CGSize(width: 10, height: 20))
//        let buttonImage = UIImage(named:"cocktail_dog")?.withRenderingMode(.alwaysOriginal)
        navigationItem.leftBarButtonItem = leftButton
        
        if isModal {
            let image = UIImage(named: "3")!
            self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(close))
        }
        activitiesTableView.delegate = self
        activitiesTableView.dataSource = self
        
        activitiesTableView.separatorStyle = .none
        activitiesTableView.allowsSelection = false
        view.addSubview(activitiesTableView)
        
        loadData()

    }
    func loadData() {
        UIDHelper.getUID(success: { (info) in
            self.uid = info
            ScanHelper.uid = String(info.data.userID)
            ActivityDetailHelper.getActivities(success: { (activities) in
                self.activityDetail = activities
                self.activitiesTableView.reloadData()
                
            }) { (_) in
                print("???")
            }
        }) { (_) in
            
        }
        
    }
    @objc func pop() {
        navigationController?.popViewController(animated: true)
    }
    @objc func close() {
        self.dismiss(animated: true, completion: nil)
    }
    
}
extension ActivitiesViewController: UITableViewDelegate {
    
}
extension ActivitiesViewController: UITableViewDataSource {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if activityDetail != nil {
            return activityDetail.data.data.count
        } else {
            return 0
        }
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        if (selectedCellIndexPath.contains(indexPath))  {
//            return 220
//        }
//        return 120
        return 220
    }


    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        为了让上面没有那个灰色的
        let whiteImage = UIView()
        whiteImage.backgroundColor = .white
        return whiteImage
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = ActivityCell()
        

        cell.sizeToFit()
        cell.activityImage.arrow.isHidden = true
//        伸缩效果
//        if !(selectedCellIndexPath.contains(indexPath)) {
        cell.frame.size.height = 220
//            cell.activityImage.loc.isHidden = true
//            cell.activityImage.time.isHidden = true
//            cell.activityImage.sponsor.isHidden = true
////            self.activitiesTableView.beginUpdates()
////            self.activitiesTableView.endUpdates()
//        } else {
//            cell.activityImage.loc.isHidden = false
//            cell.activityImage.time.isHidden = false
//            cell.activityImage.sponsor.isHidden = false
////            下面这句保证在点击的时候button图片改变
//            cell.activityImage.arrow.isSelected = true
//
//        }
        if activityDetail != nil {
            let tmpText = self.activityDetail.data.data[indexPath.row].title
            //        cell.activityImage.activityName.text = "Emo"
            //        字间距
            let characterSpacing = 5
            let realText = NSMutableAttributedString(string: tmpText)
            realText.addAttribute(.kern, value: characterSpacing, range: NSRange(location: 0, length: realText.length - 1))
            cell.activityImage.activityName.attributedText = realText
            //        cell.activityImage.activityName.text = Activitydetail.data[indexPath.row].title
//            cell.activityImage.loc.text = "活动地点：" + self.activityDetail.data.data[indexPath.row].position!
//            //        cell.activityImage.loc.text = "活动地点：" + Activitydetail.data[indexPath.row].position
//            cell.activityImage.time.text = "活动时间：" + String(self.activityDetail.data.data[indexPath.row].start) + " : " + String(self.activityDetail.data.data[indexPath.row].end)
//            //        cell.activityImage.time.text = "活动时间：" + Activitydetail.data[indexPath.row].start + "——" + Activitydetail.data[indexPath.row].end
//            cell.activityImage.sponsor.text = "发起人：" + String(self.activityDetail.data.data[indexPath.row].teacher)
        }
        
//        cell.activityImage.sponsor.text = "发起人：" + Activitydetail.data[indexPath.row].teacher

        cell.activityImage.arrow.addTarget(self, action: #selector(lengthen), for: .touchUpInside)
        cell.activityImage.codeLogin.addTarget(self, action: #selector(loginByCode), for: .touchUpInside)
        cell.activityImage.idLogin.addTarget(self, action: #selector(loginById), for: .touchUpInside)

        cell.setNeedsLayout()
        cell.layoutIfNeeded()
//        cell.frame.height = cell.
        return cell
        
        
    }
    @objc func loginByCode() {
        navigationController?.navigationBar.setBackgroundImage(UIImage.init(), for: .default)
        navigationController?.pushViewController(SaoMiaoViewController(), animated: true)
    }
    @objc func loginById() {
        navigationController?.pushViewController(IdLoginViewController(), animated: true)
    }
    @objc func lengthen(sender: UIButton) {

        let btn = sender
        let cell = didClickButtonCallBlock(button: btn)
        let temp = activitiesTableView.indexPath(for: cell!)
        if let index = selectedCellIndexPath.index(of: temp!) {
            selectedCellIndexPath.remove(at: index)

            self.activitiesTableView.reloadData()

//            写的有点烂，下面return防止一些神奇的事情
            return
        } else {
            selectedCellIndexPath.append(temp!)
        }
        
    
        self.activitiesTableView.reloadRows(at: selectedCellIndexPath, with: .fade)

        self.activitiesTableView.beginUpdates()
        self.activitiesTableView.endUpdates()

    }
    
    
}
extension ActivitiesViewController: GetCell {
//    通过button获得父视图cell
    func didClickButtonCallBlock(button: UIButton) -> UITableViewCell? {
        for view in sequence(first: button.superview, next: { $0?.superview }) {
            if let cell = view as? UITableViewCell {
                return cell
            }
        }
        return nil
    }
    
}

