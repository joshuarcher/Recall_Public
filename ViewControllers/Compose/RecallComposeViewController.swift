//
//  RecallComposeViewController.swift
//  Reecall
//
//  Created by Joshua Archer on 10/14/15.
//  Copyright © 2015 Joshua Archer. All rights reserved.
//

import UIKit
import Parse

class RecallComposeViewController: UIViewController {
    
    // MARK: - Class Variables
    
    var photoTakingHelper: PhotoTakingHelper?
    
    var imageTaken: UIImage?
    
    var taggedFriends: [PFUser]! {
        didSet {
            taggedFriendsCountLabel.text = String(taggedFriends.count)
        }
    }
    
    
    @IBOutlet var dateButtonCollection: Array<UIButton>!
    @IBOutlet weak var recallPostImage: UIImageView!
    @IBOutlet weak var uploadButoon: UIButton!
    @IBOutlet weak var tagFriendsView: UIView!
    @IBOutlet weak var taggedFriendsCountLabel: UILabel!
    
    // MARK: - View Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // set image from picture taker
        if let imageTaken = imageTaken {
            recallPostImage.image = imageTaken
        }
        
        if taggedFriends == nil {
            taggedFriends = []
        }
        
        for button in dateButtonCollection {
            button.addTarget(self, action: "handleDatePicker:", forControlEvents: .TouchUpInside)
        }

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewWillDisappear(animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
        super.viewWillDisappear(animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func unwindOneSegue(segue: UIStoryboardSegue) {
        if let identifier = segue.identifier {
            print("Identifier \(identifier)")
        }
    }
    
    
    // MARK: - Touch events
    
    @IBAction func uploadButtonTapped(sender: AnyObject) {
        let photo = Photo()
        photo.image.value = imageTaken
//        if let taggedFriends = taggedFriends {
//            
//        }
        photo.tagged.value = taggedFriends
        photo.dateDisplay.value = getDateToSend()
        photo.uploadPost()
        
    }
    
    @IBAction func tagFriendsTapped(sender: AnyObject) {
        print("tag friends tapped")
        self.performSegueWithIdentifier("showTagFriends", sender: sender)
    }
    
    func handleDatePicker(sender: UIButton!) {
        for button in dateButtonCollection {
            if button == sender {
                if button.restorationIdentifier != "CustomDay" {
                    button.selected = true
                }
                else {
                    showCustomDateAlert()
                }
            }
            else {
                button.selected = false
            }
        }
        print(String(getDateToSend()))
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

// MARK: - Helper Methods

extension RecallComposeViewController {
    
    func showCustomDateAlert() {
        let alertTitle = "NOPE!"
        let message = "Custom date picking is coming soon :)\n-Josh"
        let alert = UIAlertController(title: alertTitle, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "I'm a troll", style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    func getDateToSend() -> NSDate {
        var index: Int = 0
        var daysToAdd: Double = 1
        for (var i = 0; i < self.dateButtonCollection.count; i++) {
            if self.dateButtonCollection[i].selected {
                index = i
            }
        }
        switch (index) {
        case 0:
            daysToAdd = 0.5
            break;
        case 1:
            daysToAdd = 1
            break;
        case 2:
            daysToAdd = 3
            break;
        case 3:
            daysToAdd = 5
            break;
        case 4:
            daysToAdd = 7
            break;
        default:
            break;
        }
        return NSDate().dateByAddingTimeInterval(86400*daysToAdd)
    }
}
