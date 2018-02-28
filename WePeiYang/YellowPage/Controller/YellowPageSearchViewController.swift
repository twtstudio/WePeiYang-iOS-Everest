//
//  YellowPageSearchViewController.swift
//  YellowPage
//
//  Created by Halcao on 2017/2/23.
//  Modified by Halcao on 2017/7/18.
//  Copyright © 2017年 Halcao. All rights reserved.
//

import UIKit

class YellowPageSearchViewController: UIViewController {
    let searchView = SearchView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: 60))
    let tableView = UITableView(frame: CGRect.zero, style: .plain)
    
    var history: [String] = []
    var result: [ClientItem] = []
    var isSearching = false
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        history = (UserDefaults.standard.object(forKey: "YellowPageHistory") as? [String]) ?? []
        // FIXME: set bar color
//        UIApplication.shared.setStatusBarStyle(.lightContent, animated: true)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        let y = searchView.frame.size.height
        let width = UIScreen.main.bounds.size.width
        let height = view.frame.size.height - y
        tableView.frame = CGRect(x: 0, y: y, width: width, height: height)
    }
    
    @objc func keyboardWillHide(notification: Notification) {
        let height = view.frame.size.height - searchView.frame.size.height
        tableView.frame = CGRect(x: 0, y: searchView.frame.size.height, width: tableView.frame.size.width, height: height)
        tableView.setNeedsLayout()
        tableView.layoutIfNeeded()
    }
        
    @objc func keyboardWillShow(notification: Notification) {
        if let endRect = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as AnyObject).cgRectValue, let beginRect = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as AnyObject).cgRectValue {
            if beginRect.size.height > 0 && beginRect.origin.y - endRect.origin.y > 0 {
                let height = view.frame.size.height - searchView.frame.size.height - endRect.size.height
                tableView.frame = CGRect(x: 0, y: searchView.frame.size.height, width: tableView.frame.size.width, height: height)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        //改变 statusBar 颜色
        
        let backTapGesture = UITapGestureRecognizer(target: self, action: #selector(backToggled))
        searchView.backButton.addGestureRecognizer(backTapGesture)
        self.view.addSubview(searchView)
        searchView.textField.delegate = self
        searchView.textField.becomeFirstResponder()
        self.view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableViewAutomaticDimension
        
        searchView.textField.addTarget(self, action: #selector(textFieldTextChanged(sender:)), for: .allEditingEvents)
        tableView.sectionFooterHeight = 30
    }
    
    func hideKeyboard() {
        let height = view.frame.size.height - searchView.frame.size.height
        tableView.frame = CGRect(x: 0, y: searchView.frame.size.height, width: tableView.frame.size.width, height: height)
        tableView.endUpdates()
        self.searchView.textField.resignFirstResponder()
    }
    
    @objc func backToggled() {
//        searchView.backButton.
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func clearTapped() {
        // FIXME: Write to model singleton
        self.history.removeAll()
        tableView.reloadData()
    }
    
    func deleteTapped(sender: UIButton) {
        if let cell = sender.superview as? YellowPageSearchHistoryCell, let indexPath = tableView.indexPath(for: cell) {
            self.history.remove(at: indexPath.row)
            tableView.reloadData()
        }
    }
    
    @objc func textFieldTextChanged(sender : AnyObject) {
        // got what you want
        guard searchView.textField.text! != "" else {
            isSearching = false
            tableView.reloadData()
            return
        }
        
        self.result = PhoneBook.shared.getResult(with: searchView.textField.text!)
        DispatchQueue.main.async {
            self.isSearching = true
            self.tableView.reloadData() // 更新tableView
        }
        // TODO: if not found, display not-found-view
    }
    
    @objc func cellTapped(sender: YellowPageCell) {
        let alertVC = UIAlertController(title: "详情", message: "想要做什么？", preferredStyle: .actionSheet)
        let copyAction = UIAlertAction(title: "复制到剪切板", style: .default) { action in
            sender.longPressed()
        }
        let cancelAction = UIAlertAction(title: "取消", style: .cancel) { action in
        }
        alertVC.addAction(copyAction)
        alertVC.addAction(cancelAction)
        self.present(alertVC, animated: true, completion: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        UserDefaults.standard.set(self.history, forKey: "YellowPageHistory")
        searchView.textField.resignFirstResponder()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

// MARK: UITableViewDataSource
extension YellowPageSearchViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let text = searchView.textField.text else {
            return 0
        }
        if text == "" && !isSearching {
            return history.count
        } else {
            return result.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if searchView.textField.text == "" && !isSearching {
            let cell = YellowPageSearchHistoryCell(name: history[indexPath.row])
            cell.deleteView.addTarget(self, action: #selector(delete(_:)), for: .touchUpInside)
            return cell
        } else if self.result.count > 0 {
            let cell = YellowPageCell(with: .detailed, model: result[indexPath.row])
            let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(cellTapped(sender:)))
            cell.phoneLabel.addGestureRecognizer(tapRecognizer)
            return cell
        } else { // if self.result.count == 0 {
            return UITableViewCell()
            // FIXME: not found view
        }
    }
    
}

// MARK: UITableViewDelegate
extension YellowPageSearchViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        self.searchView.textField.resignFirstResponder()
        if !isSearching {
            let text = history[indexPath.row]
            searchView.textField.text = text
            self.result = PhoneBook.shared.getResult(with: text)
            //            self.tableView.reloadData()
            DispatchQueue.main.async {
                self.isSearching = true
                self.tableView.reloadData() // 更新tableView
            }
        }
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 30))
        
        // not found
        if history.count != 0 && result.count == 0 && isSearching {
            let label = UILabel()
            // FIXME: replace hint
            label.text = "找不到呢😐"
            label.font = UIFont.boldSystemFont(ofSize: 16)
            label.textColor = UIColor.magenta
            label.sizeToFit()
            footerView.addSubview(label)
            label.snp.makeConstraints { make in
                make.centerX.equalTo(footerView)
                make.centerY.equalTo(footerView)
            }
            return footerView
        }
        
        if history.count == 0 || self.isSearching {
            return footerView
        }
        let label = UILabel()
        label.text = "清除搜索记录"
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.textColor = UIColor.magenta
        label.sizeToFit()
        footerView.addSubview(label)
        label.snp.makeConstraints { make in
            make.centerX.equalTo(footerView)
            make.centerY.equalTo(footerView)
        }
        // TODO: separator
        let clearTapGesture = UITapGestureRecognizer(target: self, action: #selector(YellowPageSearchViewController.clearTapped))
        footerView.addGestureRecognizer(clearTapGesture)
        return footerView
    }
}



// MARK: UITextFieldDelegate
extension YellowPageSearchViewController: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        if !history.contains(searchView.textField.text!) && searchView.textField.text! != ""{
            self.history.append(searchView.textField.text!)
        }
    }
}
