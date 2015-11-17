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
        installation.channels = ["global"]
        if let parseUser = PFUser.currentUser() {
            installation["user"] = parseUser
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
        push.setChannel("global")
        push.setMessage(message)
        push.sendPushInBackground()
    }
    
    static func sendMessagePushNotification(forPhoto photo: Photo, withMessage message: String) {
        // users that are taggeed
        let taggedQuery = photo.taggedUsers!.query()
        // user who sent the photo
        let userOwnerQuery = PFUser.query()
        userOwnerQuery?.whereKey("objectId", equalTo: photo.fromUser!.objectId!)
        
        let totalQuery = PFQuery.orQueryWithSubqueries([taggedQuery!, userOwnerQuery!])
        
        let pushQuery = PFInstallation.query()
        pushQuery?.whereKey("user", matchesQuery: totalQuery)
        
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