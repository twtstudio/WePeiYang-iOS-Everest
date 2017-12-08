
//
//  SearchViewController.swift
//  WePeiYang
//
//  Created by Halcao on 2016/11/5.
//  Copyright © 2016年 Qin Yubo. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController, SearchDelegate {
    lazy var searchView: Search = {
        return Search(frame: self.view.bounds)
    }()
    var result: [Librarian.SearchResult] = []
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("Hey yoo")
        // searchView = Search(frame: self.view.bounds)
        //print(searchView)
        // self.view.addSubview(searchView)
        searchView.animate()
        searchView.delegate = self
        self.view.backgroundColor = .black
        self.view.alpha = 0.5
        self.navigationController?.navigationBar.barStyle = .default
        UIApplication.shared.keyWindow?.addSubview(self.searchView)
        if self.result.count > 0 {
            searchView.result = self.result
            searchView.tableView.reloadData()
        }
        //print(searchView.result)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.searchView.searchField.becomeFirstResponder()
//        self.view.backgroundColor = UIColor.groupTableViewBackground
    }
    
    func hideSearchView(status: Bool) {
        if status == true {
            self.dismiss(animated: false, completion: nil)
//            let _ = self.navigationController?.popViewController(animated: true)
        }
    }
    
    func saveResult(result: [Librarian.SearchResult])
    {
        self.result = result
    }
    /*
     - (void)pushSearchViewController {
     search = [[Search alloc] initWithFrame: self.view.bounds];
     search.delegate = self;
     [[UIApplication sharedApplication].keyWindow addSubview:search];
     [search animate];
     } 
     
     - (void) hideSearchView:(BOOL)status
     {
     if (status == YES){
     [search removeFromSuperview];
     }
     }
     */
    
}
