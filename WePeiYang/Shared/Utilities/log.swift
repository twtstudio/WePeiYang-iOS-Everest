//
//  log.swift
//  WePeiYang
//
//  Created by Allen X on 8/8/16.
//  Copyright © 2016 Qin Yubo. All rights reserved.
//

import Foundation

enum log {
    case errorMessage(_: String)
    case error(_: Error)
    case url(_: String)
    case obj(_: AnyObject)
    case date(_: Date)
    case word(_: String)
    case any(_: Any)
}

postfix operator /

postfix func / (toBeLogged: log?) {
    guard let foo = toBeLogged else {
        return
    }

    func log<T>(_ emoji: String, _ object: T, functionName: String = #function, fileName: String = #file, lineNumber: Int = #line) {
        debugLog(emoji + " " + String(describing: object), functionName: functionName, fileName: fileName, lineNumber: lineNumber)
    }

    /// Logs the message to the console with extra information, e.g. file name, method name and line number
    ///
    /// To make it work you must set the "DEBUG" symbol, set it in the "Swift Compiler - Custom Flags" section, "Other Swift Flags" line.
    /// You add the DEBUG symbol with the -D DEBUG entry.
    func debugLog(_ object: Any, functionName: String, fileName: String, lineNumber: Int) {
        #if DEBUG
            let className = (fileName as NSString).lastPathComponent
            print("<\(className)> \(functionName) [#\(lineNumber)]| \(object)\n")
        #endif
    }

    switch foo {
    case .error(let error):
        log("❗️", error)
    case .errorMessage(let errorMessage):
        log("❗️", errorMessage)
    case .url(let url):
        log("🌏", url)
    case .obj(let obj):
        log("◽️", obj)
    case .date(let date):
        log("🕑", date)
    case .word(let word):
        log("✏️", word)
    case .any(let any):
        log("⚪️", any)
    }
}
