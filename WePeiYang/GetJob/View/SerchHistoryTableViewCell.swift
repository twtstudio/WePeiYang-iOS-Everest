//
//  SerchHistoryTableViewCell.swift
//  WePeiYang
//
//  Created by 王春杉 on 2019/2/15.
//  Copyright © 2019 twtstudio. All rights reserved.
//

import UIKit
class SerchHistoryTableViewCell: UITableViewCell {
    
    private var timeImageView = UIImageView()
    private var lable = UILabel()
    private var deleteImageView = UIImageView()
    private var deleteBtn = UIButton(type: .system)
    private var deleteAllImageView = UIImageView()
    private var deleteAllBtn = UIButton(type: .system)
    
    private var tableView: UITableView!
    private var index: Int!
    private var historyData: [String]!
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    convenience init(historyData: [String], index: Int, tableView: UITableView) {
        self.init(style: .default, reuseIdentifier: "SerchHistoryTableViewCell")
        self.tableView = tableView
        self.index = index
        self.historyData = historyData
        let padding: CGFloat = 10
        
        if index < historyData.count {
            timeImageView.frame = CGRect(x: padding, y: 5, width: 40, height: 40)
            timeImageView.image = UIImage(named: "时间灰")
            contentView.addSubview(timeImageView)
            
            lable.frame = CGRect(x: padding+40, y: timeImageView.y+5, width: Device.width-padding*5, height: 30)
            lable.text = "\(historyData[index])"
            lable.font = UIFont.systemFont(ofSize: 15)
            contentView.addSubview(lable)
            
            deleteBtn.frame = CGRect(x: Device.width-padding-timeImageView.width, y: 5, width: 40, height: 40)
            let iconImage = UIImage(named:"清除")?.withRenderingMode(.alwaysOriginal)
            deleteBtn.setImage(iconImage, for: .normal)
            deleteBtn.addTarget(self, action: #selector(deleteOneHistory), for: .touchUpInside)
            contentView.addSubview(deleteBtn)
            
        }else if index == historyData.count {
            deleteAllBtn.frame = CGRect(x: Device.width-padding-40, y: 5, width: 40, height: 40)
            let iconImage = UIImage(named:"全部清除")?.withRenderingMode(.alwaysOriginal)
            deleteAllBtn.setImage(iconImage, for: .normal)
            deleteAllBtn.addTarget(self, action: #selector(deleteAll), for: .touchUpInside)
            contentView.addSubview(deleteAllBtn)
        }
        
        
    }
    @objc func deleteOneHistory() {
        self.historyData.remove(at: index)
        SearchHistory.historyData = self.historyData
        SearchHistory.userDefaults.set(SearchHistory.historyData, forKey: "GetJobSearchHistory")
        self.tableView.reloadData()
    }
    @objc func deleteAll() {
        self.historyData = nil
        SearchHistory.historyData = nil
        SearchHistory.userDefaults.set(SearchHistory.historyData, forKey: "GetJobSearchHistory")
        self.tableView.reloadData()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
