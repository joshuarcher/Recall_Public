//
//  PushNotificationHelper.swift
//  Reecall
//
//  Created by Joshua Archer on 11/10/15.
//  Copyright © 2015 Joshua Archer. All rights reserved.
//

import Foundation
import Parse

class PushNotificationHelper {
    
    static let parseObjectId = "objectId"
    static let globalChannel = "global"
    static let installationUser = "user"
    
    static func signUpForNotifications() {
        let settings: UIUserNotificationSettings = UIUserNotificationSettings(forTypes: [.Alert, .Badge, .Sound], categories: nil)
        let application = UIApplication.sharedApplication()
        application.registerUserNotificationSettings(settings)
        application.registerForRemoteNotifications()
    }
    
    static func setDeviceTokenForInstallation(deviceToken: NSData) {
        // store device token + subscribe to global channel + set current user
        let installation: PFInstallation = PFInstallation.currentInstallation()
        installation.setDeviceTokenFromData(deviceToken)
        installation.channels = [globalChannel]
        if let parseUser = PFUser.currentUser() {
            installation[installationUser] = parseUser
        }
        installation.saveInBackgroundWithBlock { (success: Bool, error: NSError?) -> Void in
            if let error = error {
                NSLog("error saving device token for installation. error: %@", error)
            }
            if success {
                print("Great success saving device token for installation")
            }
        }
    }
    
    static func sendTestingPushNotificaton(forString message: String) {
        let push = PFPush()
        push.setChannel(globalChannel)
        push.setMessage(message)
        push.sendPushInBackground()
    }
    
    static func sendMessagePushNotification(forPhoto photo: Photo, withMessage message: String) {
        // users that are taggeed
        guard let taggedUsers = photo.taggedUsers, fromUser = photo.fromUser, userObjId = photo.fromUser?.objectId else {
            NSLog("Error unwrapping photo's tagged users and fromUser")
            return
        }
        
        guard let taggedUsersQuery = taggedUsers.query(), userPhotoOwnerQuery = PFUser.query(), currentUser = PFUser.currentUser()?.objectId else {
            NSLog("Error unwrapping taggedUsers query and PFUser query")
            return
        }
        // don't include current user
        taggedUsersQuery.whereKey(parseObjectId, notEqualTo: currentUser)
        
        userPhotoOwnerQuery.whereKey(parseObjectId, equalTo: userObjId)
        userPhotoOwnerQuery.whereKey(parseObjectId, notEqualTo: currentUser)

        let totalQuery = PFQuery.orQueryWithSubqueries([taggedUsersQuery, userPhotoOwnerQuery])
        
        let pushQuery = PFInstallation.query()
        pushQuery?.whereKey(installationUser, matchesQuery: totalQuery)
        
        let push = PFPush()
        push.setQuery(pushQuery)
        push.setMessage(message)
        push.sendPushInBackgroundWithBlock({ (success, error) -> Void in
            if success {
                print("great success sending push to parse")
            }
            if let error = error {
                NSLog("error sending push to parse: %@", error)
            }
        })
    }
    
}