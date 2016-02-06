//
//  Message.swift
//  Reecall
//
//  Created by Joshua Archer on 10/23/15.
//  Copyright © 2015 Joshua Archer. All rights reserved.
//

import Foundation
import Parse

class Message: PFObject, PFSubclassing {
    
    // For Observables
    
    @NSManaged var fromUser: PFUser?
    @NSManaged var messageText: String?
    @NSManaged var parentPhoto: Photo?
    
    // MARK: - Observable properties
    
    var mText: Observable<String?> = Observable(nil)
    
    // MARK: - PFSubclassing protocol
    
    static func parseClassName() -> String {
        return ParseHelper.ParseMessageClass
    }
    
    override class func initialize() {
        var onceToken: dispatch_once_t = 0
        
        dispatch_once(&onceToken) {
            self.registerSubclass()
        }
    }
    
    convenience init(withText text: String, andPhoto photo: Photo) {
        self.init()
        self.messageText = text
        self.parentPhoto = photo
    }
    
    // MARK: - Helper functions
    
    func sendMessageSelf() {
        self.fromUser = PFUser.currentUser()
        guard let parentPhoto = parentPhoto else {print("what the fuck");return}
        
        saveInBackgroundWithBlock({ (success: Bool, error: NSError?) -> Void in
            if success {
                print("message saved successfully")
                let message = "\(self.fromUser!.username!) said: \(self.messageText!)"
                PushNotificationHelper.sendMessagePushNotification(forPhoto: parentPhoto, withMessage: message)
                let relation = parentPhoto.relationForKey("messages")
                relation.addObject(self)
                parentPhoto.saveInBackgroundWithBlock({ (seccess: Bool, error: NSError?) -> Void in
                    if success {
                        print("relation saved successfully")
                    }
                })
            }
            if let error = error {
                NSLog("error saving message: %@", error)
            }
        })
    }
    
    func sendMessageForPhoto(photo: Photo) {
        if let mText = mText.value {
            
            fromUser = PFUser.currentUser()
            parentPhoto = photo
            messageText = mText
            
            saveInBackgroundWithBlock({ (success: Bool, error: NSError?) -> Void in
                if success {
                    print("message saved successfully")
                    let message = "\(self.fromUser!.username!) said: \(mText)"
                    PushNotificationHelper.sendMessagePushNotification(forPhoto: photo, withMessage: message)
                    let relation = photo.relationForKey("messages")
                    relation.addObject(self)
                    photo.saveInBackgroundWithBlock({ (seccess: Bool, error: NSError?) -> Void in
                        if success {
                            print("relation saved successfully")
                        }
                    })
                }
                if let error = error {
                    NSLog("error saving message: %@", error)
                }
            })
            
        }
    }
    
}
