//
//  PasswordArrangement.swift
//  WePeiYang
//
//  Created by Tigris on 12/11/2017.
//  Copyright © 2017 twtstudio. All rights reserved.
//

import Foundation
import Security

// Constant Identifiers
let userAccount = "AuthenticatedUser"
let accessGroup = "SecuritySerivice"


/**
 *  User defined keys for new entry
 *  Note: add new keys for new secure item and use them in load and save methods
 */

let passwordKey = "KeyForPassword"

// Arguments for the keychain queries
let kSecClassValue = NSString(format: kSecClass)
let kSecAttrAccountValue = NSString(format: kSecAttrAccount)
let kSecValueDataValue = NSString(format: kSecValueData)
let kSecClassGenericPasswordValue = NSString(format: kSecClassGenericPassword)
let kSecAttrServiceValue = NSString(format: kSecAttrService)
let kSecMatchLimitValue = NSString(format: kSecMatchLimit)
let kSecReturnDataValue = NSString(format: kSecReturnData)
let kSecMatchLimitOneValue = NSString(format: kSecMatchLimitOne)

struct KeychainService {
    
    /**
     * Exposed methods to perform save and load queries.
     */
    
    public static func savePassword(token: String) {
        self.save(service: passwordKey, data: token)
    }
    
    public static func loadPassword() -> String? {
        return self.load(service: passwordKey)
    }

    public static func saveWLAN(account: String, password: String) {
        self.save(service: "WLANAccount", data: account)
        self.save(service: "WLANPassword", data: password)
    }

    public static func getWLAN() -> (account: String?, password: String?) {
        let account = self.load(service: "WLANAccount") as String?
        let password = self.load(service: "WLANPassword") as String?
        return (account: account, password: password)
    }

    /**
     * Internal methods for querying the keychain.
     */
    
    private static func save(service: String, data: String) {
        let dataFromString: NSData = data.data(using: .utf8, allowLossyConversion: false)! as NSData
        
        // Instantiate a new default keychain query
        let keychainQuery: NSMutableDictionary = NSMutableDictionary(objects: [kSecClassGenericPasswordValue, service, userAccount, dataFromString], forKeys: [kSecClassValue, kSecAttrServiceValue, kSecAttrAccountValue, kSecValueDataValue])
        
        // Delete any existing items
        SecItemDelete(keychainQuery as CFDictionary)
        
        // Add the new keychain item
        SecItemAdd(keychainQuery as CFDictionary, nil)
    }
    
    private static func load(service: String) -> String? {
        // Instantiate a new default keychain query
        // Tell the query to return a result
        // Limit our results to one item
        let keychainQuery: NSMutableDictionary = NSMutableDictionary(objects: [kSecClassGenericPasswordValue, service, userAccount, kCFBooleanTrue, kSecMatchLimitOneValue], forKeys: [kSecClassValue, kSecAttrServiceValue, kSecAttrAccountValue, kSecReturnDataValue, kSecMatchLimitValue])
        
        var dataTypeRef :AnyObject?
        
        // Search for the keychain items
        let status: OSStatus = SecItemCopyMatching(keychainQuery, &dataTypeRef)
        var contentsOfKeychain: String? = nil
        
        if status == errSecSuccess {
            if let retrievedData = dataTypeRef as? NSData {
                contentsOfKeychain = String(data: retrievedData as Data, encoding: .utf8)
            }
        } else {
            print("Nothing was retrieved from the keychain. Status code \(status)")
        }
        
        return contentsOfKeychain
    }
}
