//
//  Search.swift
//  YouTube
//
//  Created by Haik Aslanyan on 7/4/16.
//  Copyright © 2016 Haik Aslanyan. All rights reserved.
//

protocol SearchDelegate {
    func hideSearchView(status : Bool)
    func saveResult(result: [Librarian.SearchResult])
}

import UIKit

enum LabelContent: String {
    case NotFound = "没有找到相关书籍👀"
    case Morning = "早上好~ (｡･∀･)ﾉﾞ"
    case Afternoon = "下午好~ (๑•̀ㅂ•́)و✧"
    case Evening = "晚上好~ <( ￣^￣)"
}

class Search: UIView, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
    var result: [Librarian.SearchResult] = []
    //MARK: Properties
    let label = UILabel()
    var notFoundView:UIView!
    
    
    let statusView: UIView = {
        let st = UIView.init(frame: UIApplication.sharedApplication().statusBarFrame)
        st.backgroundColor = UIColor.blackColor()
        st.alpha = 0.15
        return st
    }()
    
    lazy var searchView: UIView = {
       let sv = UIView.init(frame: CGRect.init(x: 0, y: 0, width: self.frame.width, height: 68))
        sv.backgroundColor = UIColor.whiteColor()
        sv.alpha = 0
        return sv
    }()
    lazy var backgroundView: UIView = {
        let bv = UIView.init(frame: self.frame)
        bv.backgroundColor = UIColor.blackColor()
        bv.alpha = 0
        return bv
    }()
    lazy var backButton: UIButton = {
       let bb = UIButton.init(frame: CGRect.init(x: 0, y: 20, width: 48, height: 48))
        bb.setBackgroundImage(UIImage.init(named: "back"), forState: [])
        bb.addTarget(self, action: #selector(Search.dismiss), forControlEvents: .TouchUpInside)
        return bb
    }()
    lazy var searchField: UITextField = {
        let sf = UITextField.init(frame: CGRect.init(x: 48, y: 20, width: self.frame.width - 50, height: 48))
        sf.placeholder = "查询书籍在馆记录"
        sf.autocapitalizationType = .None
        sf.clearsOnBeginEditing = true
        sf.returnKeyType = .Go
        // sf.keyboardAppearance = UIKeyboardAppearance.Dark
        return sf
    }()
    lazy var tableView: UITableView = {
        let tv: UITableView = UITableView.init(frame: CGRect.init(x: 0, y: 68, width: self.frame.width, height: self.frame.height - 68))
        return tv
    }()
    var items = [String]()
    
    var delegate:SearchDelegate?
    
    //MARK: Methods
    func customization()  {
        self.addSubview(self.backgroundView)
        self.backgroundView.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(Search.dismiss)))
        self.addSubview(self.searchView)
        self.searchView.addSubview(self.searchField)
        self.searchView.addSubview(self.backButton)
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.tableFooterView = UIView()
        self.tableView.backgroundColor = UIColor.clearColor()
        self.searchField.delegate = self
        self.addSubview(self.statusView)
        self.addSubview(self.tableView)
        self.tableView.estimatedRowHeight = 80
        self.tableView.rowHeight = UITableViewAutomaticDimension
        
        notFoundView = UIView(frame: CGRect.init(x: 0, y: 68, width: self.frame.width, height: 50))
        notFoundView.backgroundColor = UIColor.whiteColor()
        notFoundView.addSubview(self.label)
        self.addSubview(notFoundView)
        //UIApplication.sharedApplication().keyWindow?.addSubview(notFoundView)
        self.label.sizeToFit()
        self.label.snp_makeConstraints { make in
            make.center.equalTo(notFoundView)
        }
        self.refreshLabel()
    }
    
    func refreshLabel() {
        
        let date = NSDate()
        let timeFormatter = NSDateFormatter()
        timeFormatter.dateFormat = "HH"
        let strNowTime = timeFormatter.stringFromDate(date) as String
        let hour = Int(strNowTime)!
        var str: LabelContent = .Morning
        switch hour {
        case 5...11:
            str = .Morning
        case 12...18:
            str = .Afternoon
        case 19...24, 0...4:
            str = .Evening
        default:
            break;
        }
        label.text = str.rawValue
    }
    
    func animate()  {
        UIView.animateWithDuration(0.2, animations: {
            self.backgroundView.alpha = 0.5
            self.searchView.alpha = 1
        //    self.searchField.becomeFirstResponder()
        })
    }
    
    func dismiss()  {
        self.searchField.text = ""
        self.items.removeAll()
        self.tableView.removeFromSuperview()
      //  self.notFoundView.removeFromSuperview()
        // 没有动画
      //  UIView.animateWithDuration(0.0, animations: {
          //  self.backgroundView.alpha = 0
          //  self.searchView.alpha = 0
            self.searchField.resignFirstResponder()
            self.searchView.removeFromSuperview()
            self.removeFromSuperview()
      //      }, completion: {(Bool) in
                self.delegate?.hideSearchView(true)
     //   })
    }
    
    //MARK: 搜索
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        guard let str = textField.text else {
            return true
        }
        //self.notFoundView.removeFromSuperview()
        result.removeAll()
        self.tableView.reloadData()
        Librarian.searchBook(withString: str) { searchResult in
            self.result = searchResult
            self.delegate?.saveResult(self.result)
            if self.result.count == 0 {
                self.tableView.tableHeaderView = self.notFoundView
                self.label.text = LabelContent.NotFound.rawValue
                self.notFoundView.frame = CGRectMake(0, 68, self.frame.width, 50)
                //self.addSubview(self.notFoundView)
            }
            self.searchField.resignFirstResponder()
            //UIApplication.sharedApplication().keyWindow?.addSubview(self.notFoundView)

            self.tableView.reloadData()
        }
        
        return true
    }
    
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
        self.result.removeAll()
        self.tableView.reloadData()
        self.notFoundView.frame = CGRectMake(0, 0, 0, 0)
        label.text = ""
        return true
    }
    
    //MARK: TableView Delegates and Datasources
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       // 
        return result.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = SearchResultCell(model: result[indexPath.row])
        return cell
    }

    func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        self.searchField.resignFirstResponder()
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.tableView.deselectRowAtIndexPath(indexPath, animated: true)
        let vc = BookDetailViewController(bookID: "\(result[indexPath.row].bookID)")
        self.removeFromSuperview()
        //print(self.tableView.contentOffset)
        // only push once
        if !(UIViewController.currentViewController().navigationController?.topViewController is BookDetailViewController){
            UIViewController.currentViewController().navigationController?.showViewController(vc, sender: nil)
        }
      //  UIViewController.currentViewController().navigationController?.pushViewController(vc, animated: true)
    }
    
    
    //MARK: Inits
   override init(frame: CGRect) {
        super.init(frame: frame)
        customization()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
}

