//
//  FoodSearchViewController.swift
//  WePeiYang
//
//  Created by 赵家琛 on 2018/5/13.
//  Copyright © 2018年 twtstudio. All rights reserved.
//

import UIKit
import SnapKit

class FoodSearchViewController: UIViewController {
    
    var searchBar: UISearchBar!
    var tableView: UITableView!
    var toolBar: UIToolbar!
    var anotherToolBar: UIToolbar!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let vview = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width*7/10, height: 44))
        vview.backgroundColor = .clear
        //view.clipsToBounds = true
        
        searchBar = UISearchBar(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width*7/10, height: 44))
        vview.addSubview(searchBar)
        
        self.navigationItem.titleView = vview
        
        //searchBar = UISearchBar()
        searchBar.showsScopeBar = false
        searchBar.tintColor = .black
        searchBar.barTintColor = .white
        searchBar.placeholder = "搜索"
        searchBar.delegate = self
        //searchBar.searchBarStyle = .minimal
        
        
        if let searchField = searchBar.value(forKey: "searchField") as? UITextField {
            searchField.backgroundColor = UIColor(red: 240/255.0, green: 240/255.0, blue: 240/255.0, alpha: 1)
            
            //searchField.becomeFirstResponder()
        }
        
        tableView = UITableView(frame: self.view.bounds, style: .plain)
        tableView.delegate = self
        tableView.dataSource = self
        
        //布局有点迷...
        toolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: self.view.bounds.size.width, height: 44))
        anotherToolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: self.view.bounds.size.width, height: 44))
        
        let barItem = UIBarButtonItem(title: "添加菜品", style: .plain, target: self, action: #selector(self.addFood(sender:)))
        //坑
        let anotherBarItem = UIBarButtonItem(title: "添加菜品", style: .plain, target: self, action: #selector(self.addFood(sender:)))
        let flexibleButtonItem =  UIBarButtonItem(barButtonSystemItem:.flexibleSpace,
                                    target:nil, action:nil);
        
        anotherToolBar.items = [flexibleButtonItem, anotherBarItem, flexibleButtonItem]
        toolBar.items = [flexibleButtonItem, barItem, flexibleButtonItem]
        searchBar.inputAccessoryView = anotherToolBar
        
        toolBar.tintColor = .red
        anotherToolBar.tintColor = .red
        
        //self.view.addSubview(searchBar)
        self.view.addSubview(tableView)
        self.view.addSubview(toolBar)
        
        
        var HEIGHT:CGFloat = 0
        if UIScreen.main.bounds.size.height == 812 {
            HEIGHT = 34
        }
        
        toolBar.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.height.equalTo(44)
            make.bottom.equalToSuperview().inset(HEIGHT)
        }
        
//        searchBar.snp.makeConstraints { make in
//            make.left.right.top.equalToSuperview()
//            make.height.equalTo(40)
//        }
        
        tableView.snp.makeConstraints { make in
            make.left.right.bottom.top.equalToSuperview()
        }
        
        
        self.view.backgroundColor = .white
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
//        self.navigationController?.setNavigationBarHidden(false, animated: animated)
//        self.navigationController?.navigationBar.isTranslucent = false
//        self.navigationController!.navigationBar.tintColor = .white
//        self.navigationController!.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
        
        
        self.navigationItem.title = "搜索"
        //searchBar.becomeFirstResponder()
        
        //self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        //self.navigationItem.hidesBackButton = true
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "取消", style: .plain, target: self, action: #selector(goBack(sender:)))
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.searchBar.resignFirstResponder()
    }
    
   
    
    @objc func goBack(sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }

    @objc func addFood(sender: UIButton) {
        let commentVC = FoodCommentTableViewController()
        //self.searchBar.resignFirstResponder()
        self.navigationController?.pushViewController(commentVC, animated: true)
        
    }
    
}

extension FoodSearchViewController: UISearchBarDelegate {
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 30
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 30))
        view.backgroundColor = .white
        
        let label = UILabel(frame: CGRect(x: 10, y: 0, width: 200, height: 30))
        label.font = UIFont.systemFont(ofSize: 14, weight: UIFont.Weight.light)
        label.text = "搜索结果-共10条"
        
        view.addSubview(label)
        return view
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 130
    }
    
}

extension FoodSearchViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return SearchResultTableViewCell()
    }
}



extension FoodSearchViewController: UITableViewDelegate {
    
}

