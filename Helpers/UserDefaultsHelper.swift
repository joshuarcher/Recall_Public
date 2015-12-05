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
        }
    }
    
    static func isDigitsVerified() -> Bool {
        let verified = userDefaults.boolForKey(digitsVerified)
        return verified
    }
    
    static func verifyDigits() {
        userDefaults.setBool(true, forKey: digitsVerified)
    }
    
}
