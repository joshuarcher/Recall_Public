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
    
    @IBOutlet weak var recallPostImage: UIImageView!
    @IBOutlet weak var uploadButoon: UIButton!
    
    // MARK: - View Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let imageTaken = imageTaken {
            recallPostImage.image = imageTaken
        }
        
        

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func uploadButtonTapped(sender: AnyObject) {
        let photo = Photo()
        photo.image.value = imageTaken
        photo.uploadPost()
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
