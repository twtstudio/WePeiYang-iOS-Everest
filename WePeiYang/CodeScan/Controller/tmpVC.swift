//
//  tmpVC.swift
//  WePeiYang
//
//  Created by 安宇 on 2019/10/19.
//  Copyright © 2019 twtstudio. All rights reserved.
//

import UIKit
import SnapKit

//protocol GetCell {
//    func didClickButtonCallBlock(button: UIButton) -> UITableViewCell?
//}
class TmpViewController: UIViewController {
//    FIXME:等后台给了数据根据数据数量f计算高度
//
    private let activitiesTableView = UITableView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height), style: .grouped)
    private var selectedCellIndexPath: [IndexPath] = []
//    private var scrollerView = UIScrollView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
    
    var Activitydetail: ActivityDeatilModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
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
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
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


    }
    func loadData() {
        ActivityDetailHelper.getActivities(success: { (activities) in
            self.Activitydetail = activities
            self.activitiesTableView.reloadData()
            
        }) { (_) in
            print("???")
        }
    }
    @objc func pop() {
        navigationController?.popViewController(animated: true)
    }
    @objc func close() {
        self.dismiss(animated: true, completion: nil)
    }
    
}
extension TmpViewController: UITableViewDelegate {
    
}
extension TmpViewController: UITableViewDataSource {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
//        return Activitydetail.data.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        if (selectedCellIndexPath.contains(indexPath))  {
//            return 220
//        }
//        return 120
        return 180
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
        cell.activityImage.codeLogin.isHidden = true
        cell.activityImage.idLogin.isHidden = true
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
        let tmpText = "Illidari"
        //        cell.activityImage.activityName.text = "Emo"
        //        字间距
                let characterSpacing = 5
                let realText = NSMutableAttributedString(string: tmpText)
                realText.addAttribute(.kern, value: characterSpacing, range: NSRange(location: 0, length: realText.length - 1))
                cell.activityImage.activityName.attributedText = realText
//        cell.activityImage.activityName.text = Activitydetail.data[indexPath.row].title
        cell.activityImage.loc.text = "活动地点："
//        cell.activityImage.loc.text = "活动地点：" + Activitydetail.data[indexPath.row].position
        cell.activityImage.time.text = "活动时间："
//        cell.activityImage.time.text = "活动时间：" + Activitydetail.data[indexPath.row].start + "——" + Activitydetail.data[indexPath.row].end
        cell.activityImage.sponsor.text = "发起人："
//        cell.activityImage.sponsor.text = "发起人：" + Activitydetail.data[indexPath.row].teacher

//        cell.activityImage.arrow.addTarget(self, action: #selector(lengthen), for: .touchUpInside)
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
    
    
}

