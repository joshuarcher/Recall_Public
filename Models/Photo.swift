//
//  Photo.swift
//  Reecall
//
//  Created by Joshua Archer on 10/15/15.
//  Copyright © 2015 Joshua Archer. All rights reserved.
//

import Foundation
import Parse
import Bond

class Photo: PFObject, PFSubclassing {
    
    // MARK: - Parse Class Properties
    
    @NSManaged var imageSent: PFFile?
    @NSManaged var fromUser: PFUser?
    @NSManaged var taggedUsers: PFRelation?
    @NSManaged var displayDate: NSDate?
    @NSManaged var usersSaved: PFRelation?
    
    var photoUploadTask: UIBackgroundTaskIdentifier?
    
    var image: Observable<UIImage?> = Observable(nil)
    var tagged: Observable<[PFUser]?> = Observable(nil)
    var taggedFriends: Observable<[String]?> = Observable(nil)
    var dateDisplay: Observable<NSDate?> = Observable(nil)
    var saved: Observable<Bool?> = Observable(nil)
    
    enum Notifications {
        static let viewAppeared = "homeControllerAppeared"
    }
    
    // MARK: - PFSublclassing Protocol
    
    static func parseClassName() -> String {
        return ParseHelper.ParsePhotoClass
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
            if let taggedFriendsArray = taggedFriends.value {
                let users = parseUsers(fromStrings: taggedFriendsArray)
                for user in users {
                    taggedUsers?.addObject(user)
                }
            }
            
            displayDate = dateDisplay.value
            saveInBackgroundWithBlock { (success: Bool, error: NSError?) -> Void in
                UIApplication.sharedApplication().endBackgroundTask(self.photoUploadTask!)
                if success {
                    self.reloadCapsuleView()
                }
            }
        }
    }
    
    func reloadCapsuleView() {
        let defaultCenter = NSNotificationCenter.defaultCenter()
        defaultCenter.postNotificationName(Notifications.viewAppeared, object: nil)
    }
    
    func parseUsers(fromStrings objectIds: [String]) -> [PFUser] {
        var users: [PFUser] = []
        for userId in objectIds {
            let user: PFUser = PFUser(outDataWithObjectId: userId)
            users.append(user)
        }
        
        return users
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
    
    func fetchSaves() {
        if (saved.value != nil) {
            return
        }
        
        ParseHelper.didUserSavePhoto(self) { (results: [PFObject]?, error: NSError?) -> Void in
            if let results = results {
                var doesIt = false
                for result in results {
                    if let userObjId = result[ParseHelper.ParseSavedUser].objectId, currentUserId = PFUser.currentUser()?.objectId {
                        if userObjId == currentUserId {
                            print("matched\n\(userObjId) : \(currentUserId)")
                            doesIt = true
                            break
                        }
                    }
                }
                self.saved.value = doesIt
            }
            if let error = error {
                NSLog("Error checking if usersavedphoto. \nError: %@", error)
            }
        }
    }
    
    func toggleSave() {
        if let isSaved = self.saved.value {
            if isSaved {
                // unSave it TODO
            } else {
                // save it
                self.saved.value = true
                ParseHelper.saveRelationshipSaved(forPhotoId: self.objectId!)
            }
        } else {
            self.saved.value = true
            ParseHelper.saveRelationshipSaved(forPhotoId: self.objectId!)
        }
    }
    
}