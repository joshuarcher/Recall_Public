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
    
    // Conversation Relation
    static let ParseConvoClass = "Conversation"
    static let ParseConvoMessages = "Messages"
    static let ParseConvoTitle = "conversationTitle"
    static let ParseConvoCreator = "creator"
    static let ParseConvoUsers = "participants"
    static let ParseConvoPhoto = "photoOwner"
    
    // Messages Relation
    static let ParseMessageClass = "Message"
    static let ParseMessageSender = "fromUser"
    static let ParseMessageContent = "messageText"
    static let ParseMessageConvo = "ParentConversation"
    static let ParseMessageParentPhoto = "parentPhoto"
    
    // FriendsWith Relation
    static let ParseFriendClass = "friendsWith"
    static let ParseFriendFromUser = "fromUser"
    static let ParseFriendTouser = "toUser"
    static let ParseFriendToUsername = "toUserUsername"
    
    // User Relation
    static let ParseUserUsername = "username"
    
    // MARK: - Parse Timeline Queries
    
    static func timeCapsuleRequestForCurrentUser(range: Range<Int>, completionBlock: PFQueryArrayResultBlock) {
        let finalQuery = PFQuery(className: ParsePhotoClass)
        finalQuery.includeKey(ParsePhotoUser)
        
        finalQuery.whereKey(ParsePhotoDisplayDate, greaterThan: NSDate())
        finalQuery.orderByAscending(ParsePhotoDisplayDate)
        
        finalQuery.skip = range.startIndex
        finalQuery.limit = range.endIndex - range.startIndex
        
        finalQuery.findObjectsInBackgroundWithBlock(completionBlock)
    }
    
    static func timelineRequestForCurrentUser(range: Range<Int>, completionBlock: PFQueryArrayResultBlock) {
        let finalQuery = PFQuery(className: ParsePhotoClass)
        finalQuery.includeKey(ParsePhotoUser)
        
        finalQuery.whereKey(ParsePhotoDisplayDate, lessThan: NSDate())
        finalQuery.orderByDescending("createdAt")
        
        finalQuery.skip = range.startIndex
        finalQuery.limit = range.endIndex - range.startIndex
        
        finalQuery.findObjectsInBackgroundWithBlock(completionBlock)
    }
    
    // MARK: - Parse Friend Shtuff
    
    static func addFriendsRequestForCurrentUser(completionBlock: PFQueryArrayResultBlock) {
        
        let friendQuery = PFQuery(className: ParseFriendClass)
        friendQuery.whereKey(ParseFriendFromUser, equalTo: PFUser.currentUser()!)
        
        let finalQuery = PFQuery(className: ParseUserClass)
        
        
        finalQuery.whereKey(ParseUserUsername, doesNotMatchKey: ParseFriendToUsername, inQuery: friendQuery)
        finalQuery.whereKey(ParseUserUsername, notEqualTo: PFUser.currentUser()!.username!)
        finalQuery.orderByAscending(ParseUserUsername)

        
        finalQuery.findObjectsInBackgroundWithBlock(completionBlock)
        
    }
    
    static func addFriendsWithRelationForCurrentUser(friendsWith: PFUser) {
        
        let friendRelation = PFObject(className: ParseFriendClass)
        friendRelation[ParseFriendFromUser] = PFUser.currentUser()
        friendRelation[ParseFriendTouser] = friendsWith
        friendRelation[ParseFriendToUsername] = friendsWith.username
        
        friendRelation.saveInBackgroundWithBlock(nil)
    }
    
    static func findFriendsRequestForCurrentUser(completionBlock: PFQueryArrayResultBlock) {
        let friendQuery = PFQuery(className: ParseFriendClass)
        friendQuery.whereKey(ParseFriendFromUser, equalTo: PFUser.currentUser()!)
        friendQuery.includeKey(ParseFriendTouser)
        friendQuery.orderByAscending(ParseFriendTouser)
        
        friendQuery.findObjectsInBackgroundWithBlock(completionBlock)
    }
    
    // MARK: - Parse message shtuff
    
    
    
    static func findMessagesForPhoto(photo: Photo) {
        
    }
    
}

// MARK: - PFUser capabilities

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
