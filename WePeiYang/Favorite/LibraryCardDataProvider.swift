//
//  LibraryCardDataProvider.swift
//  WePeiYang
//
//  Created by Halcao on 2017/12/12.
//  Copyright © 2017年 twtstudio. All rights reserved.
//

import UIKit

class LibraryCardDataProvider: NSObject, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        getBooks()
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = "\(indexPath)"
        return cell
    }
}

extension LibraryCardDataProvider: UITableViewDelegate {
    
}

extension LibraryCardDataProvider {
    func getBooks() {
        SolaSessionManager.solaSession(type: .get, url: "/library/user/info", token: "", parameters: nil, success: { dict in
            if let data = try? JSONSerialization.data(withJSONObject: dict, options: .prettyPrinted),
                let response = try? LibraryResponse(data: data) {

            } else {
                // TODO: 解析错误
            }
        }, failure: { err in
            
        })
    }
}
