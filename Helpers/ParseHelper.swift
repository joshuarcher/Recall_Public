//
//  ParseHelper.swift
//  Reecall
//
//  Created by Joshua Archer on 10/15/15.
//  Copyright © 2015 Joshua Archer. All rights reserved.
//

import Foundation
import Parse

class ParseHelper {
    
    // MARK: - Parse Globals
    
    // Photo Relation
    static let ParsePhotoClass = "Photo"
    static let ParsePhotoDateSent = "dateSent"
    static let ParsePhotoImage = "imageSent"
    static let ParsePhotoUser = "userOwner"
    static let ParsePhotoTagged = "taggedUsers"
    static let ParsePhotoDisplayDate = "displayDate"
    static let ParsePhotoConversation = "converation"
    
    // User Relation
    static let ParseUserClass = "_User"
    static let ParseUserName = "username"
    static let ParseUserPass = "password"
    static let ParseUserPhone = "phoneNumber"
    
    // Convesation Relation
    static let ParseConvoClass = "Conversation"
    static let ParseConvoMessages = "Messages"
    static let ParseConvoTitle = "conversationTitle"
    static let ParseConvoCreator = "creator"
    static let ParseConvoUsers = "participants"
    static let ParseConvoPhoto = "photoOwner"
    
    // Messages Relation
    static let ParseMessageClass = "Message"
    static let ParseMessageSender = "fromUser"
    static let ParseMessageContent = "messagetext"
    static let ParseMessageConvo = "ParentConversation"
    
    // MARK: - Parse Queries
    
    static func timeCapsuleRequestForCurrentUser(range: Range<Int>, completionBlock: PFQueryArrayResultBlock) {
        
        let finalQuery = PFQuery(className: ParsePhotoClass)
        
        finalQuery.includeKey(ParsePhotoUser)
        finalQuery.orderByDescending("createdAt")
        
        finalQuery.skip = range.startIndex
        finalQuery.limit = range.endIndex - range.startIndex
        
        //finalQuery.findObjectsInBackgroundWithBlock(completionBlock)
        //finalQuery.findObjectsInBackgroundWithBlock(completionBlock)
        finalQuery.findObjectsInBackgroundWithBlock(completionBlock)
    }
    
}

extension PFUser {
    
    public override func isEqual(object: AnyObject?) -> Bool {
        if (object as? PFObject)?.objectId == self.objectId {
            return true
        }
        else {
            return super.isEqual(object)
        }
    }
    
}
