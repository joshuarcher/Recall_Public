//
//  RecallComposeViewController.swift
//  Reecall
//
//  Created by Joshua Archer on 10/14/15.
//  Copyright © 2015 Joshua Archer. All rights reserved.
//

import UIKit

class RecallComposeViewController: UIViewController {
    
    // MARK: - Class Variables
    
    var photoTakingHelper: PhotoTakingHelper?
    
    var imageTaken: UIImage?
    
    
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
    
    // MARK: - Touch events
    
    @IBAction func uploadButtonTapped(sender: AnyObject) {
        let photo = Photo()
        photo.image.value = imageTaken
        photo.uploadPost()
    }
    
    @IBAction func tagFriendsTapped(sender: AnyObject) {
        print("tag friends tapped")
        self.performSegueWithIdentifier("showTagFriends", sender: sender)
    }
    
    func handleDatePicker(sender: UIButton!) {
        for button in dateButtonCollection {
            if button == sender {
                button.selected = true
            }
            else {
                button.selected = false
            }
        }
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
