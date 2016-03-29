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
    
    convenience init(photo: Photo) {
        self.init()
        if let objId = photo.objectId, createdAt = photo.createdAt {
            self.parseObjectId = objId
            self.parseCreatedAt = createdAt
        }
    }
    
    convenience init(photo: Photo, image: UIImage?) {
        self.init()
        if let objId = photo.objectId,
            fromUser = photo.fromUser,
            createdAt = photo.createdAt {
                self.parseObjectId = objId
                self.parseCreatedAt = createdAt
                
                if let userUsername = fromUser.username {
                    self.parseFromUserUsername = userUsername
                }
            
                if let image = image {
                    saveImage(image)
                }
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