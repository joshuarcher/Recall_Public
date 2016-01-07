//
//  JSQMessage.swift
//  Reecall
//
//  Created by Joshua Archer on 10/30/15.
//  Copyright © 2015 Joshua Archer. All rights reserved.
//

import Foundation

class JMessage: NSObject, JSQMessageData {
    var text_: String
    var sender_: String
    var date_: NSDate
    var imageUrl_: String?
    
    convenience init(text: String?, sender: String?) {
        self.init(text: text, sender: sender, imageUrl: nil)
    }
    
    convenience init(photoObject: Photo) {
        var sender = ""
        var imageUrl = ""
        if let photoSender = photoObject.fromUser {
            if let name = photoSender.username {
                sender = name
            }
        }
        if let image = photoObject.imageSent {
            if let url = image.url {
                imageUrl = url
            }
        }
        self.init(text: "", sender: sender, imageUrl: imageUrl)
    }
    
    init(text: String?, sender: String?, imageUrl: String?) {
        self.text_ = text!
        self.sender_ = sender!
        self.date_ = NSDate()
        self.imageUrl_ = imageUrl
    }
    
    func text() -> String! {
        return text_;
    }
    
    func sender() -> String! {
        return sender_;
    }
    
    func date() -> NSDate! {
        return date_;
    }
    
    func imageUrl() -> String? {
        return imageUrl_;
    }
}
