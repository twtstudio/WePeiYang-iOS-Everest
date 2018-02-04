//
//  LibraryCardDataProvider.swift
//  WePeiYang
//
//  Created by Halcao on 2017/12/12.
//  Copyright © 2017年 twtstudio. All rights reserved.
//

import UIKit

struct LibraryDataContainer {
    static var shared = LibraryDataContainer()
    var response: LibraryResponse?
    var books: [LibraryBook] {
        return response?.data.books ?? []
    }
}
