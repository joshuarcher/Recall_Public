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
import Contacts

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    var contactStore = CNContactStore()

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        
        Fabric.with([Digits.self, Crashlytics.self, Answers.self])
        
        Parse.setApplicationId("BWQm6KKz966A5aH0PLNufiBd5BoHobddqnxj5ZBC", clientKey: "uCDKJNDJOSIC12YVQimx9NzrR98ARS3OCkE60eQD")
        
        // changing ACL default
        let acl = PFACL()
        acl.publicReadAccess = true
        PFACL.setDefaultACL(acl, withAccessForCurrentUser: true)
        
        application.statusBarHidden = true
        self.window = UIWindow(frame: UIScreen.mainScreen().bounds)
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        var initViewControllerID = "LoginFlowViewController"
        
        
        if let userParse = PFUser.currentUser() {
            if userParse["digitsID"] != nil {
                // user logged in and has phone number, show app
                initViewControllerID = "RecallHomeNavigationController"
                self.logUser(userParse)
            } else {
                // digits ID not set, lets show the verify page
                initViewControllerID = "DigitsVerifyViewController"
            }
        } else {
            initViewControllerID = "LoginFlowViewController"
        }
        
//        initViewControllerID = "DatePickerViewController"
        
        let initialViewController = storyboard.instantiateViewControllerWithIdentifier(initViewControllerID)
        self.window?.rootViewController = initialViewController
        self.window?.makeKeyAndVisible()
        
        RealmHelper.purgeNullPhotos()
//        PFUser.requestPasswordResetForEmailInBackground("me@dja.io")
        
        return true
    }
    
    func logUser(userP: PFUser?) {
        if let user = userP {
            Crashlytics.sharedInstance().setUserName(user.username)
            Crashlytics.sharedInstance().setUserEmail(user.email)
        }
    }

    func escapeToLogin() {
        let appDomain = NSBundle.mainBundle().bundleIdentifier
        NSUserDefaults.standardUserDefaults().removePersistentDomainForName(appDomain!)
        
        RealmHelper.deleteAllObjects()
        
        let initViewControllerID = "LoginFlowViewController"
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let initialViewController = storyboard.instantiateViewControllerWithIdentifier(initViewControllerID)
        self.window?.rootViewController = initialViewController
        self.window?.makeKeyAndVisible()
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
        Answers.logCustomEventWithName("App Open", customAttributes: nil)
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    // MARK: - Push notifications
    
    func application(application: UIApplication, didRegisterUserNotificationSettings notificationSettings: UIUserNotificationSettings) {
        print("registered for user notification settings")
    }
    
    func application(application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: NSError) {
        NSLog("Failed to register for remote notifications.. error: %@", error)
    }
    
    func application(application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData) {
        print("device token: \(deviceToken)")
        PushNotificationHelper.setDeviceTokenForInstallation(deviceToken)
    }
    
    func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject]) {
        
        if (application.applicationState == .Active) {
            // reload messages
            print("helloooooo")
            let defaultCenter = NSNotificationCenter.defaultCenter()
            defaultCenter.postNotificationName(Notifications.pushReceived, object: nil)
        } else {
            print(userInfo)
            PFPush.handlePush(userInfo)
        }
        print("got push notification")
    }
    
    enum Notifications {
        static let pushReceived = "PushNotificationReceived"
    }
    
    // MARK: - Methods for contacts
    
    class func getAppDelegate() -> AppDelegate {
        return UIApplication.sharedApplication().delegate as! AppDelegate
    }
    
    func showMessage(message: String) {
        let alertController = UIAlertController(title: "Recall", message: message, preferredStyle: UIAlertControllerStyle.Alert)
        
        let dismissAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default) { (action) -> Void in
        }
        
        alertController.addAction(dismissAction)
        
        let pushedViewControllers = (self.window?.rootViewController as! UINavigationController).viewControllers
        let presentedViewController = pushedViewControllers[pushedViewControllers.count - 1]
        
        presentedViewController.presentViewController(alertController, animated: true, completion: nil)
    }
    
    func requestForAccess(completionHandler: (accessGranted: Bool) -> Void) {
        let authorizationStatus = CNContactStore.authorizationStatusForEntityType(CNEntityType.Contacts)
        
        switch authorizationStatus {
        case .Authorized:
            completionHandler(accessGranted: true)
            
        case .Denied, .NotDetermined:
            self.contactStore.requestAccessForEntityType(CNEntityType.Contacts, completionHandler: { (access, accessError) -> Void in
                if access {
                    completionHandler(accessGranted: access)
                }
                else {
                    if authorizationStatus == CNAuthorizationStatus.Denied {
                        dispatch_async(dispatch_get_main_queue(), { () -> Void in
                            let message = "\(accessError!.localizedDescription)\n\nPlease allow the app to access your contacts through the Settings."
                            self.showMessage(message)
                        })
                    }
                }
            })
            
        default:
            completionHandler(accessGranted: false)
        }
    }
}

