//
//  SearchViewController.swift
//  WePeiYang
//
//  Created by Hado on 2017/7/15.
//  Copyright © 2017年 twtstudio. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate{
    
    var tableView: UITableView!
    var searchController = UISearchController()
    let markArray = ["身份证","饭卡","手机","钥匙","书包","手表&饰品","U盘&硬盘","水杯","钱包","银行卡","书","伞","其他"]
    
    var searchArray:[String] = [String](){
        didSet { self.tableView.reloadData() }
    
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tabelViewFrame = CGRect(x: 0, y: 20, width: self.view.frame.width, height: self.view.frame.height-20 )
        self.tableView = UITableView(frame: tabelViewFrame, style: .plain)
        self.tableView!.delegate = self
        self.tableView!.dataSource = self
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "searchCell")
        self.view.addSubview(self.tableView)
        self.searchController = ({
            let controller = UISearchController(searchResultsController: nil)
            controller.searchBar.delegate = self
            controller.hidesNavigationBarDuringPresentation = false
            controller.dimsBackgroundDuringPresentation = false
            controller.definesPresentationContext = true
            
            controller.searchBar.searchBarStyle = .minimal
            controller.searchBar.sizeToFit()
            controller.searchBar.placeholder = "可以直接搜索卡号哟！"
            self.tableView.tableHeaderView = controller.searchBar
            
            return controller
        })()

    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
    
        if self.searchController.isActive{
        
            return self.searchArray.count
        } else {
            return self.markArray.count
        }
    }
    
    

    

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //为了提供表格显示性能，已创建完成的单元需重复使用
        let identify:String = "searchCell"
        //同一形式的单元格重复使用，在声明时已注册
        let cell = tableView.dequeueReusableCell(withIdentifier: identify,for: indexPath)
        
        if self.searchController.isActive {
            cell.textLabel?.text = self.searchArray[indexPath.row]
            return cell
        } else {
            cell.textLabel?.text = self.markArray[indexPath.row]
            return cell
        }
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.searchArray = self.markArray.filter{ (mark) -> Bool in
            return mark.contains(searchBar.text!)
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.searchArray = self.markArray
        
        
    }


    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        self.tableView.reloadData()
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    


}
