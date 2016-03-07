//
//  FabricHelper.swift
//  Reecall
//
//  Created by Joshua Archer on 11/7/15.
//  Copyright © 2015 Joshua Archer. All rights reserved.
//

import Foundation
import DigitsKit

typealias DGDataCallback = (success: Bool, phoneNumber: String?, digitsUserId: String?) -> Void

class FabricHelper {
    
    static let digits = Digits.sharedInstance()
    
    class func recallAppearance() -> DGTAppearance {
        let appearance = DGTAppearance()
        appearance.backgroundColor = UIColor.recallOffWhite()
        appearance.accentColor = UIColor.recallRed()
        return appearance
    }
    
    static func getDigitsUserID() -> String? {
        return digits.session()?.userID
    }
    
    static func getDigitsData(dataCallback: DGDataCallback) {
        var success = false
        var phone: String? = nil
        var userId: String? = nil
        
        if let session = digits.session() {
            success = true
            phone = session.phoneNumber
            userId = session.userID
        }
        
        dataCallback(success: success, phoneNumber: phone, digitsUserId: userId)
    }
    
    static func verifyUserPhoneNumber(completion: (success: Bool, number: String?) -> Void) {
        let configuration = DGTAuthenticationConfiguration(accountFields: .DefaultOptionMask)
        configuration.appearance = recallAppearance()
        
        digits.authenticateWithViewController(nil, configuration: configuration) { (session: DGTSession?, error: NSError?) -> Void in
            // TODO: associate the session userID with user model
            if let error = error {
                NSLog("Authentication in digits button error: %@", error.localizedDescription)
                completion(success: false, number: nil)
            }
            if let session = session {
                // removed store in keychain
                completion(success: true, number: session.phoneNumber)
            }
        }
    }
    
    static func getDigitSession(completion: (session: DGTSession?) -> Void) {
        let configuration = DGTAuthenticationConfiguration(accountFields: .DefaultOptionMask)
        configuration.appearance = recallAppearance()
        
        digits.authenticateWithViewController(nil, configuration: configuration) { (session: DGTSession?, error: NSError?) -> Void in
            if let session = session {
                completion(session: session)
            }
        }
    }
    
    static func findFriends(completion: (digitUsers: [String]?) -> Void) {
        getDigitSession { (session) -> Void in
            if let session = session {
                uploadDigitsContacts(session, completion: { (digitUsers) -> Void in
                    completion(digitUsers: digitUsers)
                })
            }
        }
    }
    
    static func uploadDigitsContacts(session: DGTSession, completion: (digitUsers: [String]?) -> Void) {
        let digitsContacts = DGTContacts(userSession: session)
        let appearance = recallAppearance()
        digitsContacts.startContactsUploadWithDigitsAppearance(appearance, presenterViewController: nil, title: "Let's find friends :)") { (result, error) -> Void in
            if let error = error {
                
                NSLog("error starting contacts upload: %@", error)
            }
            if result != nil {
                // the result object tells how many contacts were uploaded
                print("Total contacts:\(result.totalContacts), uploaded successfully: \(result.numberOfUploadedContacts)")
            }
            self.findDigitsFriends(session, completion: { (digitUsers) -> Void in
                completion(digitUsers: digitUsers)
            })
        }
    }
    
    static func findDigitsFriends(session: DGTSession, completion: (digitUsers: [String]?) -> Void) {
        let digitsContacts = DGTContacts(userSession: session)
        // looking up friends happens in batches. Pass nil as cursor to get the first batch.
        digitsContacts.lookupContactMatchesWithCursor(nil) { (matches, nextCursor, error) -> Void in
            // If nextCursor is not nil, you can continue to call lookupContactMatchesWithCursor: to retrieve even more friends.
            // Matches contain instances of DGTUser. Use DGTUser's userId to lookup users in your own database.
            if let error = error {
                NSLog("Error looking up contacts: %@", error)
                completion(digitUsers: nil)
                return
            }
            // map userID's and fill completion so we can do this lookup to parse
            if let matches = matches as? [DGTUser] {
                var digitUsersIDs = [String]()
                digitUsersIDs = matches.map({$0.userID})
                completion(digitUsers: digitUsersIDs)
            } else {
                completion(digitUsers: nil)
            }
        }
    }

    
}