//
//  DiskStorage.swift
//  WePeiYang
//
//  Created by Halcao on 2018/2/15.
//  Copyright © 2018年 twtstudio. All rights reserved.
//

import UIKit

struct DiskStorage {
    fileprivate init() { }
    enum Directory {
        // Only documents and other data that is user-generated, or that cannot otherwise be recreated by your application, should be stored in the <Application_Home>/Documents directory and will be automatically backed up by iCloud.
        case documents

        // Data that can be downloaded again or regenerated should be stored in the <Application_Home>/Library/Caches directory. Examples of files you should put in the Caches directory include database cache files and downloadable content, such as that used by magazine, newspaper, and map applications.
        case caches
    }

    static
}
