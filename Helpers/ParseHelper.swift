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
    static let ParsePhotoFromUser = "fromUser"
    static let ParsePhotoTagged = "taggedUsers"
    static let ParsePhotoDisplayDate = "displayDate"
    static let ParsePhotoConversation = "converation"
    
    // User Relation
    static let ParseUserClass = "_User"
    static let ParseUserName = "username"
    static let ParseUserPass = "password"
    static let ParseUserPhone = "phoneNumber"
    static let ParseUserDigits = "digitsID"
    
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
    static let ParseMessageCreated = "createdAt"
    
    // FriendsWith Relation
    static let ParseFriendClass = "friendsWith"
    static let ParseFriendFromUser = "fromUser"
    static let ParseFriendTouser = "toUser"
    static let ParseFriendToUsername = "toUserUsername"
    
    // Feedback Relation
    static let ParseFeedbackClass = "Feedback"
    static let ParseFeedbackFromUser = "fromUser"
    static let ParseFeedbackOne = "changeRecall"
    static let ParseFeedbackTwo = "problemUnderstand"
    static let ParseFeedbackThree = "creatingRecall"
    static let ParseFeedbackFour = "recallFeature"
    
    // User Relation
    static let ParseUserUsername = "username"
    
    // userSaved Relation
    static let ParseSavedClass = "userSaved"
    static let ParseSavedUser = "user"
    static let ParseSavedPhoto = "photoSaved"
   
    
    // MARK: - Parse Timeline Queries
    
    static func timeCapsuleRequestForCurrentUser(range: Range<Int>, completionBlock: PFQueryArrayResultBlock) {
        
        guard let user = PFUser.currentUser() else { return }
        
        // default photo
        let targetQuery = PFQuery(className: ParsePhotoClass)
        targetQuery.whereKey("objectId", equalTo: "XT1ohbnpej")
        
        let taggedQuery = PFQuery(className: ParsePhotoClass)
        taggedQuery.whereKey(ParsePhotoTagged, equalTo: user)
        taggedQuery.whereKey(ParsePhotoDisplayDate, greaterThan: NSDate())
        
        let ownerPhotoQuery = PFQuery(className: ParsePhotoClass)
        ownerPhotoQuery.whereKey(ParsePhotoFromUser, equalTo: user)
        ownerPhotoQuery.whereKey(ParsePhotoDisplayDate, greaterThan: NSDate())
        
        let finalQuery = PFQuery.orQueryWithSubqueries([taggedQuery, ownerPhotoQuery, targetQuery])
        
        finalQuery.includeKey(ParsePhotoFromUser)
        finalQuery.orderByAscending(ParsePhotoDisplayDate)
        
        finalQuery.skip = range.startIndex
        finalQuery.limit = range.endIndex - range.startIndex
        
        finalQuery.findObjectsInBackgroundWithBlock(completionBlock)
    }
    
    static func timelineRequestForCurrentUser(range: Range<Int>, completionBlock: PFQueryArrayResultBlock) {
        
        guard let user = PFUser.currentUser() else { return }
        
        // default photo
        let targetQuery = PFQuery(className: ParsePhotoClass)
        targetQuery.whereKey("objectId", equalTo: "XT1ohbnpej")
        
        let taggedQuery = PFQuery(className: ParsePhotoClass)
        taggedQuery.whereKey(ParsePhotoTagged, equalTo: user)
        taggedQuery.whereKey(ParsePhotoDisplayDate, lessThan: NSDate())
        
        let ownerPhotoQuery = PFQuery(className: ParsePhotoClass)
        ownerPhotoQuery.whereKey(ParsePhotoFromUser, equalTo: user)
        ownerPhotoQuery.whereKey(ParsePhotoDisplayDate, lessThan: NSDate())
        
        let finalQuery = PFQuery.orQueryWithSubqueries([taggedQuery, ownerPhotoQuery, targetQuery])
        
        finalQuery.includeKey(ParsePhotoFromUser)
        finalQuery.orderByDescending(ParsePhotoDisplayDate)
        
        finalQuery.skip = range.startIndex
        finalQuery.limit = range.endIndex - range.startIndex
        
        finalQuery.findObjectsInBackgroundWithBlock(completionBlock)
    }
    
    static func taggedUsersMessages(forRelation relation: PFRelation, completionBlock: PFQueryArrayResultBlock) {
        if let query = relation.query() {
            query.findObjectsInBackgroundWithBlock(completionBlock)
        } else {
            completionBlock(nil, nil)
        }
    }
    
    // MARK: - Parse Friend Shtuff
    
    static func addressBookFriendsForCurrentUser(digitsIDs: [String], completionBlock: PFQueryArrayResultBlock) {
        let friendQuery = PFQuery(className: ParseFriendClass)
        friendQuery.whereKey(ParseFriendFromUser, equalTo: PFUser.currentUser()!)
        
        let finalQuery = PFQuery(className: ParseUserClass)
        finalQuery.whereKey(ParseUserUsername, doesNotMatchKey: ParseFriendToUsername, inQuery: friendQuery)
        finalQuery.whereKey(ParseUserUsername, notEqualTo: PFUser.currentUser()!.username!)
        finalQuery.whereKey(ParseUserDigits, containedIn: digitsIDs)
        finalQuery.orderByAscending(ParseUserUsername)
        
        finalQuery.findObjectsInBackgroundWithBlock(completionBlock)
    }
    
    static func addFriendsRequestForCurrentUser(completionBlock: PFQueryArrayResultBlock) {
        
        let friendQuery = PFQuery(className: ParseFriendClass)
        friendQuery.whereKey(ParseFriendFromUser, equalTo: PFUser.currentUser()!)
        
        let finalQuery = PFQuery(className: ParseUserClass)
        
        
        finalQuery.whereKey(ParseUserUsername, doesNotMatchKey: ParseFriendToUsername, inQuery: friendQuery)
        finalQuery.whereKey(ParseUserUsername, notEqualTo: PFUser.currentUser()!.username!)
        finalQuery.orderByAscending(ParseUserUsername)

        
        finalQuery.findObjectsInBackgroundWithBlock(completionBlock)
        
    }
    
    // add relationship
    static func addFriendsWithRelationForCurrentUser(friendsWith: PFUser) {
        
        let friendRelation = PFObject(className: ParseFriendClass)
        friendRelation[ParseFriendFromUser] = PFUser.currentUser()
        friendRelation[ParseFriendTouser] = friendsWith
        friendRelation[ParseFriendToUsername] = friendsWith.username
        
        friendRelation.saveInBackgroundWithBlock(nil)
    }
    
    static func addContactRealmFriendRelation(friendsWith: ContactRealm) {
        
        let friendRelation = PFObject(className: ParseFriendClass)
        friendRelation[ParseFriendFromUser] = PFUser.currentUser()
        let user: PFUser = PFUser(withoutDataWithObjectId: friendsWith.parseObjectId)
        friendRelation[ParseFriendTouser] = user
        friendRelation[ParseFriendToUsername] = friendsWith.parseUsername
        
        friendRelation.saveInBackgroundWithBlock(nil)
        
    }
    
    static func addAllUserRealmFriendRelation(friendsWith: AllUsersRealm) {
        
        let friendRelation = PFObject(className: ParseFriendClass)
        friendRelation[ParseFriendFromUser] = PFUser.currentUser()
        let user: PFUser = PFUser(withoutDataWithObjectId: friendsWith.parseObjectId)
        friendRelation[ParseFriendTouser] = user
        friendRelation[ParseFriendToUsername] = friendsWith.parseUsername
        
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
    
    
    
    static func findMessagesForPhoto(photo: Photo, completionBlock: PFQueryArrayResultBlock) {
        let messageQuery = PFQuery(className: ParseMessageClass)
        messageQuery.whereKey(ParseMessageParentPhoto, equalTo: photo)
        messageQuery.orderByAscending(ParseMessageCreated)
        messageQuery.includeKey(ParseMessageSender)
        
        messageQuery.findObjectsInBackgroundWithBlock(completionBlock)
    }
    
    static func getDefualtPhotot() {
        let photo = Photo()
        // image, created at, from user
        photo.fromUser?.username = "recall founders"
    }
    
    // MARK: - Parse Feedback Shtuff
    
    static func saveFeedback(one: String, two: String, three: String, four: String) {
        let feedbackObject: PFObject = PFObject(className: ParseFeedbackClass)
        feedbackObject.setValue(PFUser.currentUser(), forKey: ParseFeedbackFromUser)
        feedbackObject.setValue(one, forKey: ParseFeedbackOne)
        feedbackObject.setValue(two, forKey: ParseFeedbackTwo)
        feedbackObject.setValue(three, forKey: ParseFeedbackThree)
        feedbackObject.setValue(four, forKey: ParseFeedbackFour)
        
        feedbackObject.saveInBackground()
    }
    
    // MARK: - Parse Saved Methods
    
    static func saveRelationshipSaved(forPhotoId photoObjectId: String) {
        guard let user = PFUser.currentUser() else {
            NSLog("No current user in saveRelationshipSaved")
            return
        }
        let photoObject = PFObject(withoutDataWithClassName: ParsePhotoClass, objectId: photoObjectId)
        
        let savedRelation = PFObject(className: ParseSavedClass)
        savedRelation[ParseSavedUser] = user
        savedRelation[ParseSavedPhoto] = photoObject
        
        savedRelation.saveInBackgroundWithBlock(nil)
    }
    
    static func didUserSavePhoto(photo: Photo, completionBlock: PFQueryArrayResultBlock) {
        // should return only the current user
        guard let user = PFUser.currentUser() else {
            NSLog("no current user in userSavedForPhoto")
            return
        }
        let saveQuery = PFQuery(className: ParseSavedClass)
        saveQuery.whereKey(ParseSavedPhoto, equalTo: photo)
        saveQuery.whereKey(ParseSavedUser, equalTo: user)
        
        saveQuery.findObjectsInBackgroundWithBlock(completionBlock)
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
    
    static func setCurrentUserPhone(phoneNumber: String?) -> Bool {
        if let user = self.currentUser(), phoneNumber = phoneNumber {
            user["phone"] = phoneNumber
            user.saveInBackground()
            return true
        }
        return false
    }
    
    static func setCurrentUserDigitsID(digitsID: String) {
        if let user = self.currentUser() {
            user["digitsID"] = digitsID
            user.saveInBackground()
        }
    }
    
}
