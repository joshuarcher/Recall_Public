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
    
    // MARK: - Helper functions
    
    func sendMessageForPhoto(photo: Photo) {
        if let mText = mText.value {
            
            fromUser = PFUser.currentUser()
            parentPhoto = photo
            messageText = mText
            
            saveInBackgroundWithBlock({ (success: Bool, error: NSError?) -> Void in
                if success {
                    print("message saved successfully")
                    let relation = photo.relationForKey("messages")
                    relation.addObject(self)
                    photo.saveInBackgroundWithBlock({ (seccess: Bool, error: NSError?) -> Void in
                        if success {
                            print("relation saved successfully")
                        }
                    })
                }
            })
            
        }
    }
    
}
