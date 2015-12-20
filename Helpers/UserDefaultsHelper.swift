//
//  UserDefaultsHelper.swift
//  Reecall
//
//  Created by Joshua Archer on 11/7/15.
//  Copyright © 2015 Joshua Archer. All rights reserved.
//

import Foundation

class UserDefaultsHelper {
    
    static let userDefaults = NSUserDefaults.standardUserDefaults()
    
    static let digitsVerified = "digitsVerified"
    static let digitsID = "digitsID"
    
    /*
    digitsVerifiedPhone - Bool
    digitsUserId - String
    */
    static func initializeUserDefaults() {
        let verified = userDefaults.boolForKey(digitsVerified)
        if verified {
            return
        } else {
            userDefaults.setBool(false, forKey: digitsVerified)
            if let userID = userDefaults.stringForKey(digitsID) {
                // already have something stored, don't do anything
                print("string stored for digitsID already: \(userID)")
            } else {
                userDefaults.setObject("", forKey: digitsID)
            }
        }
    }
    
    static func getDigitsUserId() -> String? {
        return userDefaults.stringForKey(digitsID)
    }
    
    static func isDigitsVerified() -> Bool {
        let verified = userDefaults.boolForKey(digitsVerified)
        return verified
    }
    
    static func verifyDigits(userID: String) {
        userDefaults.setBool(true, forKey: digitsVerified)
        userDefaults.setObject(userID, forKey: digitsID)
    }
    
}
