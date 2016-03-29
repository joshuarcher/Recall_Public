//
//  MessageRealm.swift
//  Reecall
//
//  Created by Joshua Archer on 12/7/15.
//  Copyright © 2015 Joshua Archer. All rights reserved.
//

import Foundation
import RealmSwift
import Parse
import JSQMessagesViewController

class MessageRealm: Object, JSQMessageData {
    
    dynamic var parseObjectId: String? = nil
    dynamic var parseSenderUserName: String? = nil
    dynamic var parseSenderObjId: String? = nil
    dynamic var parseMessageText: String? = nil
    dynamic var parseCreatedAt: NSDate = NSDate()
    dynamic var parseParentPhotoObjectId: String? = nil
    dynamic var isParseObject: Bool = true
    dynamic var mediaImagePath: String? = nil
    
    convenience init(message: Message) {
        self.init()
        if let objectId = message.objectId,
                username = message.fromUser?.username,
                userObjId = message.fromUser?.objectId,
                text = message.messageText,
                date = message.createdAt,
                photoId = message.parentPhoto?.objectId {
            self.parseObjectId = objectId
            self.parseSenderUserName = username
            self.parseSenderObjId = userObjId
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
            self.parseSenderObjId = user.objectId
            if let sender = user.username {
                self.parseCreatedAt = date
                self.parseSenderUserName = sender
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
    
    func senderId() -> String! {
        var sender = "troll"
        if let user = parseSenderUserName {
            sender = user
        }
        return sender
    }
    
    func senderDisplayName() -> String! {
        var sender = "troll"
        if let name = parseSenderUserName {
            sender = name
        }
        return sender
    }
    
    func date() -> NSDate! {
        return parseCreatedAt
    }
    
    func isMediaMessage() -> Bool {
        if let _ = mediaImagePath {
            return true
        } else {
            return false
        }
    }
    
    func setImagePathForObject(path: String) {
        self.mediaImagePath = path
    }
    
    func media() -> JSQMessageMediaData! {
        guard let mediaImagePath = mediaImagePath else { return JSQMediaItem() }
        let image = FileManager.getImage(fromPath: mediaImagePath)
        let mediaItem = JSQPhotoMediaItem(image: image)
        
        return mediaItem
    }
    
    func getDataFromUrl(url:NSURL, completion: ((data: NSData?, response: NSURLResponse?, error: NSError? ) -> Void)) {
        NSURLSession.sharedSession().dataTaskWithURL(url) { (data, response, error) in
            completion(data: data, response: response, error: error)
            }.resume()
    }
    
    func messageHash() -> UInt {
        let dateString = tempHash(parseCreatedAt)
        return UInt(dateString)!
    }
    
}


