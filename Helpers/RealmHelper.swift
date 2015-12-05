//
//  RealmHelper.swift
//  Reecall
//
//  Created by Joshua Archer on 12/2/15.
//  Copyright © 2015 Joshua Archer. All rights reserved.
//

import Foundation
import Parse
import RealmSwift

class RealmHelper {
    
    static let parseUsername = "parseUsername"
    
    // MARK: - FriendRealm
    
    // return friends for TagFriendsViewController
    static func getFriends() -> Results<FriendRealm>? {
        var friends = Results<FriendRealm>?()
        var realm: Realm?
        do {
            realm = try Realm()
        } catch let error as NSError {
            NSLog("Error trying realm in getFriends of RealmHelper: %@", error)
        }
        
        if let realm = realm {
            friends = realm.objects(FriendRealm).sorted(parseUsername)
        }
        
        return friends
    }
    
    // takes in PFUsers who the user is friends with
    // updates Realm objects of friends (doesn't duplicate objects)
    static func saveFriendsFromParse(users: [PFUser]) {
        var realm: Realm?
        do {
            realm = try Realm()
        } catch let error as NSError {
            NSLog("Error trying realm in saveFriends of RealmHelper: %@", error)
        }
        
        if let realm = realm {
            realm.beginWrite()
            for user in users {
                let realmFriend = FriendRealm(user: user)
                realm.add(realmFriend, update: true)
            }
            do {
                try realm.commitWrite()
            } catch let error as NSError {
                NSLog("error committing in saveFriends of RealmHelper: %@", error)
            }
        }
    }
    
    // MARK: - ContactRealm
    
    // return contacts for AddFriendsViewController
    static func getContacts() -> Results<ContactRealm>? {
        var contacts = Results<ContactRealm>?()
        var realm: Realm?
        do {
            realm = try Realm()
        } catch let error as NSError {
            NSLog("Error trying realm in getContacts of RealmHelper: %@", error)
        }
        
        if let realm = realm {
            contacts = realm.objects(ContactRealm).sorted(parseUsername)
        }
        
        return contacts
    }
    
    // takes in PFUsers that are in the users contacts
    //              but there is no relation tied from 
    //              the user to the PFUser in their contacts
    static func saveContactsFromParse(users: [PFUser]) {
        var realm: Realm?
        do {
            realm = try Realm()
        } catch let error as NSError {
             NSLog("Error trying realm in saveContacts of RealmHelper: %@", error)
        }
        
        if let realm = realm {
            realm.beginWrite()
            for user in users {
                let realmContact = ContactRealm(user: user)
                realm.add(realmContact, update: true)
            }
            do {
                try realm.commitWrite()
            } catch let error as NSError {
                NSLog("error committing in saveContacts of RealmHelper: %@", error)
            }
        }
    }
    
    // MARK: - AllUsersRealm
    
    // return users for AddFriendsViewController
    static func getAllUsers() -> Results<AllUsersRealm>? {
        var users = Results<AllUsersRealm>?()
        var realm: Realm?
        do {
            realm = try Realm()
        } catch let error as NSError {
            NSLog("Error trying realm in getContacts of RealmHelper: %@", error)
        }
        
        if let realm = realm {
            users = realm.objects(AllUsersRealm).sorted(parseUsername)
        }
        
        return users
    }
    
    // takes in all PFUsers on recall.... (NEED TO REPLACE THIS WHEN THE APP SCALESSSSS)
    static func saveAllUsersFromParse(users: [PFUser]) {
        var realm: Realm?
        do {
            realm = try Realm()
        } catch let error as NSError {
            NSLog("Error trying realm in saveContacts of RealmHelper: %@", error)
        }
        
        if let realm = realm {
            realm.beginWrite()
            for user in users {
                let realmContact = AllUsersRealm(user: user)
                realm.add(realmContact, update: true)
            }
            do {
                try realm.commitWrite()
            } catch let error as NSError {
                NSLog("error committing in saveContacts of RealmHelper: %@", error)
            }
        }
    }
    
}
