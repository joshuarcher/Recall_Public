//
//  MessageRealm.swift
//  Reecall
//
//  Created by Joshua Archer on 12/7/15.
//  Copyright © 2015 Joshua Archer. All rights reserved.
//

import Foundation
import RealmSwift

class MessageRealm: Object, JSQMessageData {
    
    dynamic var parseObjectId: String? = nil
    dynamic var parseSenderUserName: String? = nil
    dynamic var parseMessageText: String? = nil
    dynamic var parseCreatedAt: NSDate = NSDate()
    dynamic var parseParentPhotoObjectId: String? = nil
    dynamic var isParseObject: Bool = true
    dynamic var imageUrl_: String? = nil
    
    convenience init(message: Message) {
        self.init()
        if let objectId = message.objectId,
                username = message.fromUser?.username,
                text = message.messageText,
                date = message.createdAt,
                photoId = message.parentPhoto?.objectId {
            self.parseObjectId = objectId
            self.parseSenderUserName = username
            self.parseMessageText = text
            self.parseCreatedAt = date
            self.parseParentPhotoObjectId = photoId
        }
    }
    
    convenience init(text: String, sender: String, photoId: String) {
        self.init()
        let date = NSDate()
        self.parseMessageText = text
        self.parseSenderUserName = sender
        self.parseParentPhotoObjectId = photoId
        self.parseCreatedAt = date
        self.parseObjectId = tempHash(date)
        self.isParseObject = false
    }
    
    convenience init(photoObject: Photo) {
        self.init()
        self.parseObjectId = photoObject.objectId
        self.parseParentPhotoObjectId = photoObject.objectId
        if let date = photoObject.createdAt, user = photoObject.fromUser, image = photoObject.imageSent {
            if let sender = user.username, url = image.url {
                self.parseCreatedAt = date
                self.parseSenderUserName = sender
                self.imageUrl_ = url
            }
        }
    }
    
    func tempHash(date: NSDate) -> String {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyyMMddhhmmss" // 14 charactersss
        let dateString = dateFormatter.stringFromDate(date)
        return dateString
    }
    
    override static func primaryKey() -> String? {
        return "parseObjectId"
    }
    
    func text() -> String! {
        var text = "message failure"
        if let message = parseMessageText {
            text = message
        }
        return text
    }
    
    func sender() -> String! {
        var sender = "troll"
        if let user = parseSenderUserName {
            sender = user
        }
        return sender
    }
    
    func date() -> NSDate! {
        return parseCreatedAt
    }
    
    func imageUrl() -> String? {
        return imageUrl_;
    }
    
}
