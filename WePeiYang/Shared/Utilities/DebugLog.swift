//
//  log.swift
//  WePeiYang
//
//  Created by Allen X on 8/8/16.
//  Copyright © 2016 Qin Yubo. All rights reserved.
//

import Foundation

private let emojiDict = [String(describing: Error.self): "❗️",
                         String(describing: String.self): "✏️",
                         String(describing: AnyObject.self): "◽️",
                         String(describing: Any.self): "⚪️",
                         String(describing: URL.self): "🌏",
                         String(describing: Date.self): "🕑"]

/// Logs the message to the console with extra information, e.g. file name, method name and line number
///
/// To make it work you must set the "DEBUG" symbol, set it in the "Swift Compiler - Custom Flags" section, "Other Swift Flags" line.
/// You add the DEBUG symbol with the -D DEBUG entry.

func log<T>(_ object: T, functionName: String = #function, fileName: String = #file, lineNumber: Int = #line) {
    #if DEBUG
    let className = (fileName as NSString).lastPathComponent
    let typeName = String(describing: type(of: object))
    let emoji = emojiDict[typeName] ?? ""
    // swiftlint:disable:next print_check
    print("<\(className)> \(functionName) [#\(lineNumber)]|\(emoji) \(object)\n")
    #endif
}
