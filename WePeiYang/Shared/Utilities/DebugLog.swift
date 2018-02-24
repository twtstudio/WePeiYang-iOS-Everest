//
//  DebugLog.swift
//  WePeiYang
//
//  Created by Halcao on 2018/2/25.
//  Copyright © 2018年 twtstudio. All rights reserved.
//

import Foundation

/// Logs the message to the console with extra information, e.g. file name, method name and line number
///
/// To make it work you must set the "DEBUG" symbol, set it in the "Swift Compiler - Custom Flags" section, "Other Swift Flags" line.
/// You add the DEBUG symbol with the -D DEBUG entry.
public func debugLog(object: Any, functionName: String = #function, fileName: String = #file, lineNumber: Int = #line) {
    #if DEBUG
        let className = (fileName as NSString).lastPathComponent
        print("<\(className)> \(functionName) [#\(lineNumber)]| \(object)\n")
    #endif
}
