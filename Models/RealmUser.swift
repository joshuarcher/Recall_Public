//
//  RealmUser.swift
//  Reecall
//
//  Created by Joshua Archer on 3/14/16.
//  Copyright © 2016 Joshua Archer. All rights reserved.
//

import Foundation
import RealmSwift
import Parse

class RealmUser: Object {
    
    dynamic var parseObjectId: String? = nil
    dynamic var parseUsername: String? = nil
    dynamic var isFriend: Bool = false
    dynamic var isContact: Bool = false
    
    convenience init(user: PFUser, userInContacts: Bool = false, followingUser: Bool = false) {
        self.init()
        if let objectId = user.objectId, username = user.username {
            self.parseObjectId = objectId
            self.parseUsername = username
            self.isFriend = followingUser
            self.isContact = userInContacts
        }
    }
    
    override static func indexedProperties() -> [String] {
        return ["parseUsername"]
    }
    
    override static func primaryKey() -> String? {
        return "parseObjectId"
    }
    
}
