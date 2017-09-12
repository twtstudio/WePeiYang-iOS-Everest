//
//  SearchViewController.swift
//  WePeiYang
//
//  Created by Hado on 2017/7/15.
//  Copyright © 2017年 twtstudio. All rights reserved.
//

import UIKit


var inputText = ""

class SearchViewController: UIViewController, UISearchBarDelegate, UITableViewDataSource, UITableViewDelegate
{
    lazy   var searchBar:UISearchBar = UISearchBar(frame: CGRect(x: 0, y: 0, width: 200, height: 20))
    var tableView: UITableView!
    var searchController: UISearchController!
    let markArray = ["身份证","饭卡","手机","钥匙","书包","手表&饰品","U盘&硬盘","水杯","钱包","银行卡","书","伞","其他"]
    let searchedListArray: [LostFoundModel] = []
    var searchArray:[String] = [String](){
        didSet { self.tableView.reloadData() }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchBar.placeholder = "搜索"
//        var leftNavBarButton = UIBarButtonItem(customView:searchBar)
//        self.navigationItem.leftBarButtonItem = leftNavBarButton
    
        let tabelViewFrame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
        self.tableView = UITableView(frame: tabelViewFrame, style: .plain)
        self.tableView!.delegate = self
        self.tableView!.dataSource = self
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "searchCell")
        self.view.addSubview(self.tableView)
//        self.searchController = ({
//        let controller = UISearchController(searchResultsController: nil)
//            controller.searchBar.delegate = self
////            controller.hidesNavigationBarDuringPresentation = false
//            controller.dimsBackgroundDuringPresentation = false
////            controller.definesPresentationContext = true
//            controller.definesPresentationContext = true
//            
//            controller.searchBar.searchBarStyle = .minimal
//            controller.searchBar.sizeToFit()
//            controller.searchBar.placeholder = "可以直接搜索卡号哟！"
//            self.tableView.tableHeaderView = controller.searchBar
//            
//            return controller
//        })()
        self.searchController = UISearchController(searchResultsController: nil)
        self.searchController.searchBar.delegate = self
        self.searchController.hidesNavigationBarDuringPresentation = false
        self.searchController.dimsBackgroundDuringPresentation = false
        self.definesPresentationContext = true
        self.searchController.searchBar.searchBarStyle = .minimal
        self.searchController.searchBar.sizeToFit()
        self.tableView.tableHeaderView = self.searchController.searchBar
        self.searchController.searchBar.placeholder = "  可以直接搜索卡号哟！"
        
    
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        
//        if self.searchController.isActive{
//            
//            return self.searchArray.count
//        } else {
//            return self.markArray.count
//        }
        return searchedListArray.count
    }
    
    
    
    
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let identify:String = "searchCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: identify,for: indexPath) as! MyLostFoundTableViewCell
        
//        if self.searchController.isActive {
//            cell.textLabel?.text = self.searchArray[indexPath.row]
//            return cell
//        } else {
//            cell.textLabel?.text = self.markArray[indexPath.row]
//            return cell
//        }
        var picURL = ""
        
        if searchedListArray[indexPath.row].picture != "" {
            picURL = TWT_URL + searchedListArray[indexPath.row].picture
            
        } else {
            picURL = "http://open.twtstudio.com/uploads/17-07-12/945139dcd91e9ed3d5967ef7f81e18f6.jpg"
        }
       
        return cell
    }

    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        print(searchText)
        if searchText == "" {
            self.searchArray = self.markArray
        } else {
            self.searchArray = []
            for index in markArray {
                if index.lowercased().hasPrefix(searchText.lowercased()) {
                    self.searchArray.append(index)
                    
                }
            }
            
        }
        self.tableView.reloadData()
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.searchArray = self.markArray.filter{ (mark) -> Bool in
                return mark.contains(searchBar.text!)
            }
        inputText = self.searchController.searchBar.text!
        print(inputText)
        
        let searchVC = SearchedResultViewController()
        self.navigationController?.pushViewController(searchVC, animated: true)

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
