//
//  KeychainManager.swift
//  NumiParis
//
//  Created by imran shaik on 01/04/21.
//

import UIKit
import Security

// Arguments for the keychain queries
let kSecClassValue = NSString(format: kSecClass)
let kSecAttrAccountValue = NSString(format: kSecAttrAccount)
let kSecValueDataValue = NSString(format: kSecValueData)
let kSecClassGenericPasswordValue = NSString(format: kSecClassGenericPassword)
let kSecAttrServiceValue = NSString(format: kSecAttrService)
let kSecMatchLimitValue = NSString(format: kSecMatchLimit)
let kSecReturnDataValue = NSString(format: kSecReturnData)
let kSecMatchLimitOneValue = NSString(format: kSecMatchLimitOne)

class KeychainManager: NSObject {
    

// Mark -> Save & Retrive Auth Token
    public class func saveToken(token: NSString) {
        self.save(service: KeychainServiceKeys.tokenKey as NSString, data: token)
    }

    public class func getToken() -> NSString? {
        return self.get(service: KeychainServiceKeys.tokenKey as NSString)
    }
    
// Mark -> Save & Retrive AccountTypeText
    public class func saveAccountTypeText(accountTypeText: NSString) {
        self.save(service: KeychainServiceKeys.accountTypeTextkey as NSString, data: accountTypeText)
    }

    public class func getAccountTypeText() -> NSString? {
        return self.get(service: KeychainServiceKeys.accountTypeTextkey as NSString)
    }

// Mark -> Save & Retrive AccountType
    public class func saveAccountType(accountType: NSString) {
        self.save(service: KeychainServiceKeys.accountTypeKey as NSString, data: accountType)
    }

    public class func getAccountType() -> NSString? {
        return self.get(service: KeychainServiceKeys.accountTypeKey as NSString)
    }
    
    public class func removeToken() {
        self.removePassword(service: KeychainServiceKeys.tokenKey, account: userAccount)
    }

  
    
// Mark -> Flush Keychain all data
    static func flush()  {
      let secItemClasses =  [kSecClassGenericPassword]
      for itemClass in secItemClasses {
        let spec: NSDictionary = [kSecClass: itemClass]
        SecItemDelete(spec)
      }
    }
    
    
    /**
     * Internal methods for querying the keychain.
     */

    private class func save(service: NSString, data: NSString) {
        if let dataFromString = data.data(using: String.Encoding.utf8.rawValue, allowLossyConversion: false) {
            
            // Instantiate a new default keychain query
            let keychainQuery: NSMutableDictionary = NSMutableDictionary(objects: [kSecClassGenericPasswordValue, service, userAccount, dataFromString], forKeys: [kSecClassValue, kSecAttrServiceValue, kSecAttrAccountValue, kSecValueDataValue])
            
            // Delete any existing items
            SecItemDelete(keychainQuery as CFDictionary)
            
            // Add the new keychain item
            SecItemAdd(keychainQuery as CFDictionary, nil)
        }
    }

    private class func get(service: NSString) -> NSString? {
        // Instantiate a new default keychain query
        // Tell the query to return a result
        // Limit our results to one item
        let keychainQuery: NSMutableDictionary = NSMutableDictionary(objects: [kSecClassGenericPasswordValue, service, userAccount, kCFBooleanTrue ?? false, kSecMatchLimitOneValue], forKeys: [kSecClassValue, kSecAttrServiceValue, kSecAttrAccountValue, kSecReturnDataValue, kSecMatchLimitValue])

        var dataTypeRef :AnyObject?

        // Search for the keychain items
        let status: OSStatus = SecItemCopyMatching(keychainQuery, &dataTypeRef)
        var contentsOfKeychain: NSString? = nil

        if status == errSecSuccess {
            if let retrievedData = dataTypeRef as? NSData {
                contentsOfKeychain = NSString(data: retrievedData as Data, encoding: String.Encoding.utf8.rawValue)
            }
        } else {
            print("Nothing was retrieved from the keychain. Status code \(status)")
        }

        return contentsOfKeychain
    }
    
    class func removePassword(service: String, account:String) {
        
        // Instantiate a new default keychain query
        let keychainQuery: NSMutableDictionary = NSMutableDictionary(objects: [kSecClassGenericPasswordValue, service, account, kCFBooleanTrue], forKeys: [kSecClassValue, kSecAttrServiceValue, kSecAttrAccountValue, kSecReturnDataValue])
        
        // Delete any existing items
        let status = SecItemDelete(keychainQuery as CFDictionary)
        if (status != errSecSuccess) {
            if #available(iOS 11.3, *) {
                if let err = SecCopyErrorMessageString(status, nil) {
                    print("Remove failed: \(err)")
                }
            } else {
                // Fallback on earlier versions
            }
        }
        
    }
    
}

