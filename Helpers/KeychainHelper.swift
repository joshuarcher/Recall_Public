//
//  KeychainHelper.swift
//  Reecall
//
//  Created by Joshua Archer on 11/7/15.
//  Copyright © 2015 Joshua Archer. All rights reserved.
//

import Foundation

class KeychainHelper {
    
    static let UserPhoneNumber: String = "userPhoneNumber"
    
    static let wrapper = KeychainWrapper()
    
    static func setKeychainUserPhone(phoneNo: String) -> Bool {
        let phoneNumberSuccessfull = KeychainWrapper.setString(phoneNo, forKey: UserPhoneNumber)
        if phoneNumberSuccessfull {
            print("phone number stored")
            return true
        } else {
            print("phone number did not store")
            return false
        }
    }
    
    static func getKeychainUserPhone() -> String? {
        let retrieveNumber = KeychainWrapper.stringForKey(UserPhoneNumber)
        return retrieveNumber
    }
    
}