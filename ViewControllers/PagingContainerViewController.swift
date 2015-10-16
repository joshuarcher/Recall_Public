//
//  PagingContainerViewController.swift
//  Reecall
//
//  Created by Joshua Archer on 10/8/15.
//  Copyright © 2015 Joshua Archer. All rights reserved.
//

import UIKit

class PagingContainerViewController: UIViewController {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var cameraButton: UIButton!
    
    var photoTakingHelper: PhotoTakingHelper?
    var imageToCompose: UIImage?
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpView()
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Actions
    
    @IBAction func cameraButtonTapped(sender: AnyObject) {
        print("Camera button tapped lessgooo")
        
        photoTakingHelper = PhotoTakingHelper(viewController: self, callback: { (image: UIImage?) -> Void in
            print("image captured")
            self.imageToCompose = image
            self.performSegueWithIdentifier("showRecallCompose", sender: sender)
        })
    }
    
    @IBAction func unwindToSegue(segue: UIStoryboardSegue) {
        
        if let identifier = segue.identifier {
            print("Identifier \(identifier)")
        }
    }
    
    // MARK: - Helper methods
    
    func setUpView() {
        
        //let timeCapsuleView = TimeCapsuleTableViewController(nibName: "TimeCapsuleTableViewController", bundle: nil)
        let timeCapsuleView = CapsuleViewController(nibName: "CapsuleViewController", bundle: nil)
        
        
        self.addChildViewController(timeCapsuleView)
        self.scrollView.addSubview(timeCapsuleView.view)
        timeCapsuleView.didMoveToParentViewController(self)
        
        //let timelineView = TimelineTableViewController(nibName: "TimelineTableViewController", bundle: nil)
        let timelineView = RecallViewController(nibName: "RecallViewController", bundle: nil)
        
        var timelineFrame = timelineView.view.frame
        timelineFrame.origin.x = self.view.frame.size.width
        timelineView.view.frame = timelineFrame
        
        self.addChildViewController(timelineView)
        self.scrollView.addSubview(timelineView.view)
        timelineView.didMoveToParentViewController(self)
        
        self.scrollView.contentSize = CGSizeMake(self.view.frame.size.width * 2, self.view.frame.size.height - 66)
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showRecallCompose" {
            let composeView: RecallComposeViewController = segue.destinationViewController as! RecallComposeViewController
            if let imageToCompose = imageToCompose {
                composeView.imageTaken = imageToCompose
            }
//            composeView.photoTakingHelper = PhotoTakingHelper(viewController: self, callback: { (image: UIImage?) in
//                print("picked the image")
//                composeView.imageTaken = image
//            })
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
