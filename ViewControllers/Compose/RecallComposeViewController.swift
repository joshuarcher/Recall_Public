//
//  RecallComposeViewController.swift
//  Reecall
//
//  Created by Joshua Archer on 10/14/15.
//  Copyright © 2015 Joshua Archer. All rights reserved.
//

import UIKit
import Parse
import Crashlytics

class RecallComposeViewController: UIViewController {
    
    private let tagFriendsSegue = "showTagFriends"
    
    // MARK: - Class Variables
    
    var photoTakingHelper: PhotoTakingHelper?
    
    var imageTaken: UIImage?
    
    var taggedFriends: [String]! {
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
    
    convenience init(withImage image: UIImage) {
        self.init()
        self.imageTaken = image
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // set image from picture taker
        
        if let imageTaken = imageTaken {
//            recallPostImage = UIImageView(image: imageTaken)
            recallPostImage.image = imageTaken
        }
        
        if imageTaken == nil {
            imageTaken = UIImage(named: "JayDronah")
        }
        
        if taggedFriends == nil {
            taggedFriends = []
        }
        
        for button in dateButtonCollection {
            button.addTarget(self, action: #selector(RecallComposeViewController.handleDatePicker(_:)), forControlEvents: .TouchUpInside)
        }

        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        print(taggedFriends)
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
        photo.taggedFriends.value = taggedFriends
        // need to add relationship from strings of objectIds
        // photo.tagged.value = taggedFriends
        photo.dateDisplay.value = getDateToSend()
        photo.uploadPost()
        
    }
    
    @IBAction func tagFriendsTapped(sender: AnyObject) {
        print("tag friends tapped")
        self.performSegueWithIdentifier(tagFriendsSegue, sender: sender)
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
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        guard let ident = segue.identifier else { return }
        if ident == tagFriendsSegue {
            let nextVc = segue.destinationViewController as! TagFriendsViewController
            nextVc.taggedFriends = self.taggedFriends
        }
    }

}

// MARK: - Helper Methods

extension RecallComposeViewController {
    
    func showCustomDateAlert() {
        let alertTitle = "NOPE!"
        let message = "Custom date picking is coming soon :)"
        let alert = UIAlertController(title: alertTitle, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "I'm a troll", style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    func getDateToSend() -> NSDate {
        var index: Int = 0
        var daysToAdd: Double = 1
        for i in 0 ..< self.dateButtonCollection.count {
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
