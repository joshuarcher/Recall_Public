//
//  AppDelegate.swift
//  Reecall
//
//  Created by Joshua Archer on 10/7/15.
//  Copyright © 2015 Joshua Archer. All rights reserved.
//

import UIKit
import Parse
import Fabric
import DigitsKit
import Crashlytics

/*
DigitsVerifyViewController
LoginViewController
SignUpViewController
AppNavigationController
*/

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        
        Fabric.with([Digits.self, Crashlytics.self])
        
        // Register parse ID
        // Parse.enableLocalDatastore()
        Parse.setApplicationId("BWQm6KKz966A5aH0PLNufiBd5BoHobddqnxj5ZBC", clientKey: "uCDKJNDJOSIC12YVQimx9NzrR98ARS3OCkE60eQD")
        
        // PushNotificationHelper.signUpForNotifications()
        
        // changing ACL default
        let acl = PFACL()
        acl.setPublicReadAccess(true)
        PFACL.setDefaultACL(acl, withAccessForCurrentUser: true)
        
        application.statusBarHidden = true
        self.window = UIWindow(frame: UIScreen.mainScreen().bounds)
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        var initViewControllerID = "LoginViewController"
        
        
        if let userParse = PFUser.currentUser() {
            if userParse["digitsID"] != nil {
                // user logged in and has phone number, show app
                initViewControllerID = "AppNavigationController"
                self.logUser(userParse)
            } else {
                // digits ID not set, lets show the verify page
                initViewControllerID = "DigitsVerifyViewController"
            }
        } else {
            initViewControllerID = "LoginViewController"
        }
        
        let initialViewController = storyboard.instantiateViewControllerWithIdentifier(initViewControllerID)
        self.window?.rootViewController = initialViewController
        self.window?.makeKeyAndVisible()
        
        
        
        return true
    }
    
    func logUser(userP: PFUser?) {
        if let user = userP {
            Crashlytics.sharedInstance().setUserName(user.username)
            Crashlytics.sharedInstance().setUserEmail(user.email)
        }
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    // MARK: - Push notifications
    
    func application(application: UIApplication, didRegisterUserNotificationSettings notificationSettings: UIUserNotificationSettings) {
        print("registered for user notification settings")
    }
    
    func application(application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData) {
        print("device token: \(deviceToken)")
        PushNotificationHelper.setDeviceTokenForInstallation(deviceToken)
    }
    
    func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject]) {
        PFPush.handlePush(userInfo)
        print("got push notification")
    }
}

