//
//  LibraryAPIs.swift
//  WePeiYang
//
//  Created by Tigris on 12/8/17.
//  Copyright © 2017 twtstudio. All rights reserved.
//

import Foundation

public var barcode: String!
public var bookID: String!

struct LibraryAPIs {
    static let baseURL = "open.twtstudio.com/api/v1/"
    
    static let infoURL = "library/user/info"
    
    static let historyURL = "library/user/history"
    
    static let renewURL = "library/renew/\(barcode)"
    
    static let bookURL = "library/book"
    
    static let bookDetailURL = "library/book/\(bookID)"
}
