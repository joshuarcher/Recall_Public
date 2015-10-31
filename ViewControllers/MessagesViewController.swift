//
//  MessagesViewController.swift
//  Reecall
//
//  Created by Joshua Archer on 10/30/15.
//  Copyright © 2015 Joshua Archer. All rights reserved.
//

import UIKit
import Parse

class MessagesViewController: UIViewController {
    
    var photo: Photo?
    
    var messages: [Message]?
    
    var jMessages: [JMessage]?
    
    // MARK: - View Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        let _ = Message()
        setTitle()
        guard let photo = photo else {return}
        getMessagesFromParse(photo)
        
//        let formatter = NSDateFormatter()
//        formatter.dateStyle = .ShortStyle
//        guard let photo = photo else {return}
//        self.navigationItem.title = formatter.stringFromDate(photo.createdAt!)
        // Do any additional setup after loading the view.
        
//        ParseHelper.findMessagesForPhoto(photo, completionBlock: { (results: [PFObject]?, error: NSError?) -> Void in
//            let newMessages: [Message] = results as? [Message] ?? []
//            self.messages = newMessages
//        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        print("hey I just appeared")
        
    }
    
    // MARK: - Helper methods
    
    func setTitle() {
        let formatter = NSDateFormatter()
        formatter.dateStyle = .ShortStyle
        guard let photo = photo else {return}
        self.navigationItem.title = formatter.stringFromDate(photo.createdAt!)
    }
    
    func getMessagesFromParse(photo: Photo) {
        ParseHelper.findMessagesForPhoto(photo, completionBlock: { (results: [PFObject]?, error: NSError?) -> Void in
            let newMessages: [Message] = results as? [Message] ?? []
            self.messages = newMessages
            print(self.messages)
        })
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
