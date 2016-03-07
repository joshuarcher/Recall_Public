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
    static let parseCreatedAt = "parseCreatedAt"
    
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
    
    // MARK: - PhotosRealm
    
    static func saveProfilePhotosFromParse(photos: [Photo]) {
        var realm: Realm?
        do {
            realm = try Realm()
        } catch let error as NSError {
            NSLog("Error trying realm in saveProfilePhotos of RealmHelper: %@", error)
        }
        
        if let realm = realm {
            realm.beginWrite()
            for photo in photos {
                // cannot assume photo has fromUser or image
                let realmPhoto = PhotoProfileRealm(photo: photo)
                realm.add(realmPhoto, update: false)
            }
            do {
                try realm.commitWrite()
                print("committing photo write")
            } catch let error as NSError {
                NSLog("Error commiting in saveProfilePhotos of RealmHelper: %@", error)
            }
        }
    }
    
    static func getAllProfilePhotos() -> Results<PhotoProfileRealm>? {
        var photos = Results<PhotoProfileRealm>?()
        var realm: Realm?
        do {
            realm = try Realm()
        } catch let error as NSError {
            NSLog("Error trying realm in getProfilePhotos of RealmHelper: %@", error)
        }
        
        if let realm = realm {
            photos = realm.objects(PhotoProfileRealm).sorted(parseCreatedAt)
        }
        
        return photos
    }
    
    static func purgeNullPhotos() {
        var photosToPurge = Results<PhotoProfileRealm>?()
        var realm: Realm?
        do {
            realm = try Realm()
        } catch let error as NSError {
            NSLog("Error trying realm in saveMessageeeeee of RealmHelper: %@", error)
            return
        }
        
        if let realm = realm {
            let predicate = NSPredicate(format: "parseObjectId = NULL")
            photosToPurge = realm.objects(PhotoProfileRealm).filter(predicate)
        } else {
            return
        }
        
        if let photosToPurge = photosToPurge {
            if let realm = realm {
                do {
                    try realm.write {
                        realm.delete(photosToPurge)
                    }
                } catch let error as NSError {
                    NSLog("Error trying to purge photos in purgeNullPhotos: %@", error)
                }
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
    
    static func getMessagesForPhoto(photo: Photo) -> Results<MessageRealm>? {
        var messages = Results<MessageRealm>?()
        var realm: Realm?
        do {
            realm = try Realm()
        } catch let error as NSError {
            NSLog("Error trying realm in getMessages of RealmHelper: %@", error)
        }
        
        realmIf: if let realm = realm {
            guard let photoId = photo.objectId else {break realmIf}
            let predicate = NSPredicate(format: "parseParentPhotoObjectId = %@", photoId)
            messages = realm.objects(MessageRealm).filter(predicate)
        }
        
        return messages
    }
    
    static func saveMessagesFromParse(messages: [Message]) {
        var realm: Realm?
        do {
            realm = try Realm()
        } catch let error as NSError {
            NSLog("Error trying realm in saveMessages of RealmHelper: %@", error)
        }
        
        if let realm = realm {
            realm.beginWrite()
            for message in messages {
                let realmMessage = MessageRealm(message: message)
                realm.add(realmMessage, update: true)
            }
            
            do {
                try realm.commitWrite()
            } catch let error as NSError {
                NSLog("error committing in saveMessages of RealmHelper: %@", error)
            }
        }
    }
    
    static func saveMessageAlreadyCreated(message: MessageRealm) {
        var realm: Realm?
        do {
            realm = try Realm()
        } catch let error as NSError {
            NSLog("Error trying realm in saveMessageeeeee of RealmHelper: %@", error)
        }
        
        if let realm = realm {
            realm.beginWrite()
            realm.add(message, update: true)
            do {
                try realm.commitWrite()
            } catch let error as NSError {
                NSLog("error committing in saveMessageeee of RealmHelper: %@", error)
            }
        }
    }
    
    static func purgeNonParseMessages() {
        var messagesToPurge = Results<MessageRealm>?()
        var realm: Realm?
        do {
            realm = try Realm()
        } catch let error as NSError {
            NSLog("Error trying realm in saveMessageeeeee of RealmHelper: %@", error)
            return
        }
        
        if let realm = realm {
            let predicate = NSPredicate(format: "isParseObject = %@", false)
            messagesToPurge = realm.objects(MessageRealm).filter(predicate)
        } else {
            return
        }
        
        if let messagesToPurge = messagesToPurge {
            if let realm = realm {
                do {
                    try realm.write {
                        realm.delete(messagesToPurge)
                    }
                } catch let error as NSError {
                    NSLog("Error trying to purge messages in purgeNonParseMessages: %@", error)
                }
            }
        }
        
    }
    
}
