//
//  PhotoProfileRealm.swift
//  Reecall
//
//  Created by Joshua Archer on 1/12/16.
//  Copyright © 2016 Joshua Archer. All rights reserved.
//

import Foundation
import RealmSwift
import Parse

class PhotoProfileRealm: Object {
    
    dynamic var parseObjectId: String? = nil
    dynamic var parseFromUserUsername: String? = nil
    dynamic var parseCreatedAt: NSDate = NSDate()
    dynamic var imageSentFilePath: String? = nil
    // dynamic var parseTaggedUsersIds: [String]? = nil
    
    convenience init(photo: Photo, image: UIImage) {
        self.init()
        if let objId = photo.objectId,
            fromUser = photo.fromUser,
            userUsername = fromUser.username,
            createdAt = photo.createdAt {
            self.parseObjectId = objId
            self.parseFromUserUsername = userUsername
            self.parseCreatedAt = createdAt
            saveImage(image)
            // getTagged(tagged)
        }
    }
    
    private func saveImage(photoImage: UIImage) {
        if let imageData = UIImageJPEGRepresentation(photoImage, 0.7) {
            if let filePath = FileManager.saveProfileImageData(toPath: self.parseObjectId, data: imageData) {
                self.imageSentFilePath = filePath
                saveSelf()
            }
        }
    }
    
//    private func getTagged(taggedRelation: PFRelation) {
//        // FIND PARSE OBJECTS GIVEN PFRELATION
//        ParseHelper.taggedUsersMessages(forRelation: taggedRelation) { (results: [PFObject]?, error: NSError?) -> Void in
//            if let results = results {
//                var taggedIds: [String] = []
//                for one in results {
//                    if let objId = one.objectId {
//                        taggedIds.append(objId)
//                    }
//                }
//                self.parseTaggedUsersIds = taggedIds
//                // Save
//                self.saveSelf()
//            }
//        }
//    }
    
    func saveSelf() {
        var realm: Realm?
        do {
            realm = try Realm()
        } catch let error as NSError {
            NSLog("Error trying REalm in saveSelf()... Error: %@", error)
        }
        
        if let realm = realm {
            realm.beginWrite()
            realm.add(self, update: true)
            do {
                try realm.commitWrite()
            } catch let error as NSError {
                NSLog("Error committing realm in saveSelf()... Error: %@", error)
            }
        }
        
    }
    
//    override static func indexedProperties() -> [String] {
//        return ["parseCreatedAt"]
//    }
    
    override static func primaryKey() -> String? {
        return "parseObjectId"
    }
    
}