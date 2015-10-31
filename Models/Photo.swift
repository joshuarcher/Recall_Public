//
//  Photo.swift
//  Reecall
//
//  Created by Joshua Archer on 10/15/15.
//  Copyright © 2015 Joshua Archer. All rights reserved.
//

import Foundation
import Parse

class Photo: PFObject, PFSubclassing {
    
    // MARK: - Parse Class Properties
    
    @NSManaged var imageSent: PFFile?
    @NSManaged var fromUser: PFUser?
    @NSManaged var taggedUsers: PFRelation?
    @NSManaged var displayDate: NSDate?
    
    var photoUploadTask: UIBackgroundTaskIdentifier?
    
    var image: Observable<UIImage?> = Observable(nil)
    var tagged: Observable<[PFUser]?> = Observable(nil)
    var dateDisplay: Observable<NSDate?> = Observable(nil)
    
    // MARK: - PFSublclassing Protocol
    
    static func parseClassName() -> String {
        return ParseHelper.ParsePhotoClass
    }
    
    override init() {
        super.init()
    }
    
    override class func initialize() {
        var onceToken: dispatch_once_t = 0
        
        dispatch_once(&onceToken) {
            self.registerSubclass()
        }
    }
    
    // MARK: - Helper functions
    
    func uploadPost() {
        // access image's UIImage property by .value
        if let image = image.value {
            
            photoUploadTask = UIApplication.sharedApplication().beginBackgroundTaskWithExpirationHandler({ () -> Void in
                UIApplication.sharedApplication().endBackgroundTask(self.photoUploadTask!)
            })
            
            let imageData = UIImageJPEGRepresentation(image, 0.8)
            let imageFile = PFFile(data: imageData!)
            if let imageFile = imageFile {
                imageFile.saveInBackgroundWithBlock(nil)
            }
            fromUser = PFUser.currentUser()
            self.imageSent = imageFile
            if let users = tagged.value {
                for user in users {
                    taggedUsers?.addObject(user)
                }
            }
            displayDate = dateDisplay.value
            saveInBackgroundWithBlock { (success: Bool, error: NSError?) -> Void in
                UIApplication.sharedApplication().endBackgroundTask(self.photoUploadTask!)
            }
        }
    }
    
    func downloadImage() {
        // if the image isn't downloaded yet, get it
        if (image.value == nil) {
            imageSent?.getDataInBackgroundWithBlock({ (data: NSData?, error: NSError?) -> Void in
                if let data = data {
                    let image = UIImage(data: data, scale: 1.0)!
                    print("received image")
                    
                    //let blurredImage = self.blurImage(image)
                    
                    self.image.value = image
                }
                else {
                    print("didn't get image")
                }
            })
        }
        
    }
    
}