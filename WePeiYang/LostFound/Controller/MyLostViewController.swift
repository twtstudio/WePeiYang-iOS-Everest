//
//  LostFountMineViewController.swift
//  WePeiYang
//
//  Created by Hado on 2017/7/3.
//  Copyright © 2017年 twtstudio. All rights reserved.
//

import UIKit
let TWT_URL = "http://open.twtstudio.com/"
var id = ""
class MyLostViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    
//    var id = ""
    var tableView: UITableView!
    var myLost: [MyLostFoundModel] = []
    //    let TWT_URL = "http://open.twtstudio.com/"
    
    //    var myLost1 = MyLoatFoundModel(isBack: "未找到", title: "求大大", mark:"钱包" , time: "2017/5/1", place: "图书馆", picture: "pic2")
    //    var myLost2 = MyLoatFoundModel(isBack: "未找到", title: "求大大", mark:"钱包" , time: "2017/5/1", place: "图书馆", picture: "pic3")
    //    var myLost3 = MyLoatFoundModel(isBack: "已找到", title: "求大大", mark:"钱包" , time: "2017/5/1",place: "图书馆", picture: "pic1")
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //        myLost.append(myLost1)
        //        myLost.append(myLost2)
        //        myLost.append(myLost3)
        
        self.title = "我的"
        
        self.tableView = UITableView(frame: CGRect.init(x: 0, y: 0, width: self.view.bounds.width, height: self.view.bounds.height-110), style: .grouped)
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.backgroundColor = UIColor(hex6: 0xeeeeee)
        self.tableView.register(MyLostFoundTableViewCell.self, forCellReuseIdentifier: "MyCell")
        
        self.tableView.estimatedRowHeight = 500
        self.tableView.rowHeight = UITableViewAutomaticDimension
        //        self.automaticallyAdjustsScrollViewInsets = false
        
        self.view.addSubview(tableView!)
        refresh()
        let fab = FAB(subActions: [
            (name: "fuck", function: {
                
                let vc = PublishLostViewController()
                self.navigationController?.pushViewController(vc, animated: true)
            }),
            (name: "fs", function: {
                
                let vc = PublishLostViewController()
                self.navigationController?.pushViewController(vc, animated: true)
                
            })
            ])
        fab.frame = CGRect(x: 0, y: 0, width: 200, height: 200)
        self.view.addSubview(fab)
        
    }
    
    func refresh() {
        
        GetMyLostAPI.getMyLostAPI(success: { (myLosts) in
            self.myLost = myLosts
            self.tableView.reloadData()
            
            
        }, failure: {error in
            print(error)
            
        })
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        id = myLost[indexPath.row].id
        
        tableView.deselectRow(at: indexPath, animated: true)
        let detailView = DetailViewController()
        detailView.id = id
        
        
        self.navigationController?.pushViewController(detailView, animated: true)
    }
    
    
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.01
    }
    
    //    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
    //
    //
    //
    //    }
    //    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
    //        return UITableViewCellEditingStyle.delete
    //    }
    //    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
    //        return true
    //    }
    //    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
    //
    //        if editingStyle == UITableViewCellEditingStyle.delete {
    //
    //
    //        }
    //
    //    }
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        
        return myLost.count
        
    }
    
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "MyCell", for: indexPath) as? MyLostFoundTableViewCell{
            

            cell.editButton.addTarget(self, action: #selector(editButtonTapped(editButton: )), for: .touchUpInside)
            cell.inverseButton.addTarget(self, action: #selector(inverseButtonTapped(inverseButton: )), for: .touchUpInside)
//
            
            let pic = myLost[indexPath.row].picture
            print(pic)
            cell.initMyUI(pic: pic, title: myLost[indexPath.row].title, isBack: myLost[indexPath.row].isBack, mark: myLost[indexPath.row].detail_type, time: myLost[indexPath.row].time, place: myLost[indexPath.row].place)
            
            return cell
            
            
            
        }
        
        let cell = MyLostFoundTableViewCell()
        let pic = TWT_URL + myLost[indexPath.row].picture
        

             cell.initMyUI(pic: pic, title: myLost[indexPath.row].title, isBack: myLost[indexPath.row].isBack, mark: myLost[indexPath.row].detail_type, time: myLost[indexPath.row].time, place: myLost[indexPath.row].place)
        
        
        
        return cell
    }
    @objc func editButtonTapped(editButton: UIButton) {
        
        let cell = editButton.superView(of: UITableViewCell.self)!
        let indexPath = tableView.indexPath(for: cell)
        id = myLost[(indexPath?[1])!].id
        print(id)
        
        print("indexPath：\(indexPath!)")
        let vc = PublishLostViewController()
        let index = 1
        vc.index = index
        
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    @objc func inverseButtonTapped(inverseButton: UIButton) {
//        let cell = superUITableViewCell(of: inverseButton)!
        
        let cell = inverseButton.superView(of: UITableViewCell.self)!
        let indexPath = tableView.indexPath(for: cell)
        id = myLost[(indexPath?[1])!].id
        print(id)
        
    print("indexPath：\(indexPath!)")
        
        GetInverseAPI.getInverse(id: id, success: { _ in
            
            
            

            
            self.refresh()
            
        }, failure: { error in
            print(error)
        })
        
    }
    
//    func superUITableViewCell(of: UIButton) -> UITableViewCell? {
//        for view in sequence(first: of.superview, next: { $0?.superview }) {
//            if let cell = view as? UITableViewCell {
//                return cell
//            }
//        }
//        return nil
//    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    
}
extension UIView {
    //返回该view所在的父view
    func superView<T: UIView>(of: T.Type) -> T? {
        for view in sequence(first: self.superview, next: { $0?.superview }) {
            if let father = view as? T {
                return father
            }
        }
        return nil
    }
}
