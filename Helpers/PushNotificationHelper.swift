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
        // store device token
        let installation: PFInstallation = PFInstallation.currentInstallation()
        installation.setDeviceTokenFromData(deviceToken)
        installation.channels = ["global"]
        installation.saveInBackgroundWithBlock { (success: Bool, error: NSError?) -> Void in
            if let error = error {
                NSLog("error saving device token for installation. error: %@", error)
            }
            if success {
                print("Greate success saving deveice token for installation")
            }
        }
    }
    
    static func sendTestingPushNotificaton(forString message: String) {
        let push = PFPush()
        push.setChannel("global")
        push.setMessage(message)
        push.sendPushInBackground()
    }
    
}