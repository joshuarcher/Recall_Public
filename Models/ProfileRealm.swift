//
//  ProfileRealm.swift
//  Reecall
//
//  Created by Joshua Archer on 3/24/16.
//  Copyright © 2016 Joshua Archer. All rights reserved.
//

import Foundation
import Parse
import RealmSwift

class ProfilePhoto: Object {
    dynamic var parseObjectId: String? = nil
    dynamic var parseUsername: String? = nil
    dynamic var updatedAt: NSDate? = nil
    dynamic var pictureFile: NSData? = nil
    
    convenience init(user: PFUser, image: UIImage) {
        self.init()
        if let objectId = user.objectId, username = user.username {
            self.parseObjectId = objectId
            self.parseUsername = username
            self.updatedAt = NSDate()
            self.pictureFile = UIImagePNGRepresentation(image)
        }
    }
    
    override static func indexedProperties() -> [String] {
        return ["updatedAt"]
    }
    
    override static func primaryKey() -> String? {
        return "parseObjectId"
    }
    
    func saveSelf() {
        var realm: Realm?
        do {
            realm = try Realm()
        } catch let error as NSError {
            NSLog("Error trying REalm in saveSelf() profile photo... Error: %@", error)
        }
        
        if let realm = realm {
            realm.beginWrite()
            realm.add(self, update: true)
            do {
                try realm.commitWrite()
            } catch let error as NSError {
                NSLog("Error committing realm in saveSelf() profile photo... Error: %@", error)
            }
        }
        
    }
    
}