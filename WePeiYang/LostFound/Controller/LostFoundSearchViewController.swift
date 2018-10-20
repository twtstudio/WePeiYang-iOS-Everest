//
//  LostFoundSearchViewController.swift
//  WePeiYang
//
//  Created by JasonEWNL on 2018/10/20.
//  Copyright © 2018年 twtstudio. All rights reserved.
//

import UIKit

var inputText = ""
class LostFoundSearchViewController: UIViewController, UISearchBarDelegate, UITableViewDataSource, UITableViewDelegate {
    lazy var searchBar:UISearchBar = UISearchBar(frame: CGRect(x: 0, y: 0, width: 200, height: 20))
    var tableView: UITableView!
    var searchController: UISearchController!
    var historyNSArray: NSArray = []
    var historyArray: Array<String> = []
    var High = 0
    var buttonArray = ["身份证","饭卡","手机","钥匙","书包","手表&饰品","U盘&硬盘","水杯","钱包","银行卡","书","伞","其他"]
    var mainAry: [[String]] {
        return [historyArray, buttonArray]
    }
    let itemsArray = ["delete", "看"]
    let titleArray = ["搜索历史", "分类"]
    var searchArray: [String] = [String]() {
        didSet {
            self.tableView.reloadData()
        }
    }
    var searchOfMessage = ""
    
    var delButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchOfMessage = "noSearch"
        
        loadData()
        cellHeight()
        searchBar.placeholder = "搜索"
        //        var leftNavBarButton = UIBarButtonItem(customView:searchBar)
        //        self.navigationItem.leftBarButtonItem = leftNavBarButton
        
        let tableViewFrame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
        self.tableView = UITableView(frame: tableViewFrame, style: .grouped)
        self.tableView!.delegate = self
        self.tableView!.dataSource = self
        //        self.tableView.register(LFSearchCustomCell.self, forCellReuseIdentifier: "searchCell")
        self.tableView.backgroundColor = .white
        self.view.addSubview(self.tableView)
        self.tableView.estimatedRowHeight = 300
        //估算高度
        self.tableView.rowHeight = UITableViewAutomaticDimension
        
        
        self.searchController = UISearchController(searchResultsController: nil)
        self.searchController.searchBar.delegate = self
        self.searchController.hidesNavigationBarDuringPresentation = true
        self.searchController.dimsBackgroundDuringPresentation = false
        self.definesPresentationContext = true
        self.searchController.searchBar.searchBarStyle = .minimal
        self.searchController.searchBar.sizeToFit()
        self.tableView.tableHeaderView = self.searchController.searchBar
        self.searchController.searchBar.placeholder = "  可以直接搜索卡号哟！"
        
        self.view.addSubview(delButton)
        self.tableView.separatorStyle = .none
        self.tableView.delaysContentTouches = false
        //        self.tableView.canCancelContentTouches = false
        self.tableView.isUserInteractionEnabled = true
    }
    
    // 预计算搜索历史cell高度
    func cellHeight() {
        let cell = LFSearchCustomCell()
        High = cell.initMark(array: historyArray, title: "")
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        if searchOfMessage == "noSearch" {
            return mainAry.count
        } else {
            return searchArray.count
        }
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let identify: String = "searchCell"
        if let cell = tableView.dequeueReusableCell(withIdentifier: identify + "\(indexPath)") as? LFSearchCustomCell {
            if searchOfMessage == "noSearch" {
                if indexPath.row == 0 {
                    cell.delUI()
                    cell.deleteButton.addTarget(self, action: #selector(deleteOfButtonTapped(sender: )), for: .touchUpInside)
                }
                _ = cell.initMark(array: mainAry[indexPath.row], title: titleArray[indexPath.row] )
                cell.delegate = self
            } else {
                // print(searchArray)
                cell.textLabel?.text = self.searchArray[indexPath.row]
            }
            return cell
        } else {
            let cell = LFSearchCustomCell()
            if searchOfMessage == "noSearch" {
                if indexPath.row == 0 {
                    cell.delUI()
                    cell.deleteButton.addTarget(self, action: #selector(deleteOfButtonTapped(sender: )), for: .touchUpInside)
                }
                _ = cell.initMark(array: mainAry[indexPath.row], title: titleArray[indexPath.row] )
                cell.delegate = self
            } else {
                print(searchArray)
                cell.textLabel?.text = self.searchArray[indexPath.row]
            }
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if searchOfMessage == "noSearch" {
            if indexPath.row == 0 {
                return CGFloat(High)
            } else {
                return 200
            }
        }
        else {
            return 50
        }
    }
    // 在进行输入时的代理
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if searchText == "" {
            self.searchArray = self.historyArray
        }
        else {
            // 这个是遍历历史记录，减少输入量, 不区分大小写
            self.searchArray = []
            for index in historyArray {
                if index.lowercased().hasPrefix(searchText.lowercased()) {
                    self.searchArray.append(index)
                    // print(searchArray)
                }
            }
            searchOfMessage = "searched"
        }
        self.tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        
        if searchOfMessage == "searched" {
            inputText = historyArray[indexPath.row]
            let searchVC = LFSearchedResultViewController()
            self.navigationController?.pushViewController(searchVC, animated: true)
        }
    }
    
    // 点击搜索，保存记录
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.searchArray = self.historyArray.filter{ (mark) -> Bool in
            return mark.contains(searchBar.text!)
        }
        inputText = self.searchController.searchBar.text!
        writeToSave()
        let searchVC = LFSearchedResultViewController()
        self.navigationController?.pushViewController(searchVC, animated: true)
        
    }
    
    // 取消按钮调用的方法
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        //        self.searchArray = self.historyArray
        
        if searchOfMessage == "searched" {
            print(searchOfMessage)
            searchOfMessage = "noSearch"
            self.tableView.reloadData()
        }
    }
    // cell内部的button没有能力进行界面跳转的权力，需要委托一下
    func buttonTapped() {
        let searchedVC = LFSearchedResultViewController()
        self.navigationController?.pushViewController(searchedVC, animated: true)
    }
    
    // 保存历史搜索记录
    func writeToSave() {
        if historyArray.contains((self.searchController.searchBar.text)!) == true {
            return
        }
        historyArray.append((self.searchController.searchBar.text)!)
        historyNSArray = historyArray as NSArray
        let path1 = NSHomeDirectory()
        let path = path1 + "/Documents/historySearchList.plist"
        historyNSArray.write(toFile: path, atomically: true)
    }
    
    // 加载本地数据
    func loadData(){
        let path1 = NSHomeDirectory()
        let path = path1 + "/Documents/historySearchList.plist"
        /**NSFileManage文件管理*/
        let manage = FileManager.default
        //判断文件是否存在
        let isExist = manage.fileExists(atPath: path)
        if isExist == false {
            let array = [""] as NSArray
            
            array.write(toFile: path, atomically: true)
        } else {
            print("路径有文件")
        }
        historyNSArray = NSArray(contentsOfFile: path)!
        print(historyNSArray)
        historyArray = historyNSArray as! [String]
        self.tableView?.reloadData()
    }
    // 删除按钮的回调
    @objc func deleteOfButtonTapped(sender: UIButton) {
        historyNSArray = []
        let path1 = NSHomeDirectory()
        let path = path1 + "/Documents/historySearchList.plist"
        historyNSArray.write(toFile: path, atomically: true)
        historyArray = historyNSArray as! Array<String>
        self.tableView.reloadData()
    }
    
    // 界面迭代处理
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.searchController.searchBar.text = ""
        self.searchOfMessage = "noSearch"
        self.tableView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
