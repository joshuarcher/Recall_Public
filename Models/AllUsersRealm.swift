//
//  AllUsersRealm.swift
//  Reecall
//
//  Created by Joshua Archer on 12/4/15.
//  Copyright © 2015 Joshua Archer. All rights reserved.
//

import Foundation
import RealmSwift
import Parse

class AllUsersRealm: Object {
    
    dynamic var parseObjectId: String? = nil
    dynamic var parseUsername: String? = nil
    
    convenience init(user: PFUser) {
        self.init()
        if let objectId = user.objectId, username = user.username {
            self.parseObjectId = objectId
            self.parseUsername = username
        }
    }
    
    override static func indexedProperties() -> [String] {
        return ["parseUsername"]
    }
    
    override static func primaryKey() -> String? {
        return "parseObjectId"
    }
    
}
