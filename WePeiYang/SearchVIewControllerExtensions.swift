//
//  SearchVIewControllerExtensions.swift
//  WePeiYang
//
//  Created by Hado on 2017/7/15.
//  Copyright © 2017年 twtstudio. All rights reserved.
//

import Foundation
import UIKit

extension SearchViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.searchController.isActive {
            return self.searchArray.count
        } else {
            return self.schoolArray.count
        }
    

}
