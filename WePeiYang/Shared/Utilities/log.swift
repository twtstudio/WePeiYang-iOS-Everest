//
//  log.swift
//  WePeiYang
//
//  Created by Allen X on 8/8/16.
//  Copyright © 2016 Qin Yubo. All rights reserved.
//

//TODO: Make this only availible in Debug Mode because printing actually stalls the app
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

postfix func /(toBeLogged: log?) {
    guard let foo = toBeLogged else {
        return
    }
    
    func log<T>(_ emoji: String, _ object: T) {
        print(emoji + " " + String(describing: object))
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
