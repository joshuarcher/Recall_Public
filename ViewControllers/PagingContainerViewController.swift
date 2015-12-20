//
//  PagingContainerViewController.swift
//  Reecall
//
//  Created by Joshua Archer on 10/8/15.
//  Copyright © 2015 Joshua Archer. All rights reserved.
//

import UIKit

class PagingContainerViewController: UIViewController {
    
    private let scrollUpdateNotification = "scrollDidScroll"
    
    private let capsuleViewNib = "CapsuleViewController"
    private let timelineViewNib = "RecallViewController"
    private let composeSegue = "showRecallCompose"

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var cameraButton: UIButton!
    
    var photoTakingHelper: PhotoTakingHelper?
    var imageToCompose: UIImage?
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpView()
        UIApplication.sharedApplication().statusBarHidden = true
        PushNotificationHelper.signUpForNotifications()
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Actions
    
    @IBAction func cameraButtonTapped(sender: AnyObject) {
        if UIImagePickerController.isCameraDeviceAvailable(.Rear) {
            photoTakingHelper = PhotoTakingHelper(viewController: self, callback: { (image: UIImage?) -> Void in
                self.imageToCompose = image
                self.performSegueWithIdentifier(self.composeSegue, sender: sender)
            })
        } else {
            self.performSegueWithIdentifier(composeSegue, sender: sender)
        }
        
    }
    
    @IBAction func unwindToSegue(segue: UIStoryboardSegue) {
        if let identifier = segue.identifier {
            print("Identifier \(identifier)")
        }
    }
    
    // MARK: - NSNotifications for scroll view
    
    func postButtonNotification() {
        let notificationCenter = NSNotificationCenter.defaultCenter()
        // post to update on nav bar
        let contentOffset: CGFloat = self.scrollView.contentOffset.x
        let dictionary: NSDictionary = NSDictionary(object: contentOffset, forKey: "contentOffset")
        notificationCenter.postNotificationName(scrollUpdateNotification, object: self.scrollView, userInfo: dictionary as [NSObject : AnyObject])
        // print("posting notification")
    }
    
    // MARK: - Helper methods
    
    func setUpView() {
        
        let timeCapsuleView = CapsuleViewController(nibName: capsuleViewNib, bundle: nil)
        
        // add to scrollView
        self.addChildViewController(timeCapsuleView)
        self.scrollView.addSubview(timeCapsuleView.view)
        timeCapsuleView.didMoveToParentViewController(self)
        
        let timelineView = RecallViewController(nibName: timelineViewNib, bundle: nil)
        
        // set frame to be to the right of the capsule view
        var timelineFrame = timelineView.view.frame
        timelineFrame.origin.x = self.view.frame.size.width
        timelineView.view.frame = timelineFrame
        
        // add to scroll view
        self.addChildViewController(timelineView)
        self.scrollView.addSubview(timelineView.view)
        timelineView.didMoveToParentViewController(self)
        
        // two views wide, height does not include nav bar
        self.scrollView.contentSize = CGSizeMake(self.view.frame.size.width * 2, self.view.frame.size.height - 66)
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == composeSegue {
            let composeView: RecallComposeViewController = segue.destinationViewController as! RecallComposeViewController
            if let imageTo = imageToCompose {
                composeView.imageTaken = imageTo
            }
        }
    }

}

extension PagingContainerViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(scrollView: UIScrollView) {
        postButtonNotification()
    }
}
