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
    private let scrollButtonTappedNotification = "scrollButtonTapped"
    private let hideNavButtonsNotification = "hideNavButtons"
    
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
        subscribeNotifications()
        // Do any additional setup after loading the view.
    }

    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        postDissappearNotification(true)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        postDissappearNotification(false)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
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
    
    func subscribeNotifications() {
        let notificationCenter = NSNotificationCenter.defaultCenter()
        // this notification is from the button being tapped
        notificationCenter.addObserver(self, selector: "receiveButtonNotification:", name: scrollButtonTappedNotification, object: nil)
    }
    
    func receiveButtonNotification(notification: NSNotification) {
        if let userInfo = notification.userInfo {
            guard let buttonType = userInfo["buttonType"] as? Int else {print("nope");return}
            // 0 -> right button
            // 1 -> left button
            print(buttonType)
            updateScrollViewOffset(buttonType)
        }
    }
    
    func updateScrollViewOffset(buttonType: Int) {
        let screenWidth = self.view.frame.size.width
        let offsetY = self.scrollView.contentOffset.y
        var scrollPoint: CGPoint?
        
        if buttonType == 0 {
            scrollPoint = CGPointMake(screenWidth, offsetY)
        } else if buttonType == 1 {
            scrollPoint = CGPointMake(0, offsetY)
        }
        
        guard let point = scrollPoint else {return}
        self.scrollView.setContentOffset(point, animated: true)
    }
    
    func postDissappearNotification(dissappearing: Bool) {
        let notificationCenter = NSNotificationCenter.defaultCenter()
        let dictionary: NSDictionary = NSDictionary(object: dissappearing, forKey: "dissappearing")
        
        notificationCenter.postNotificationName(hideNavButtonsNotification, object: nil, userInfo: dictionary as [NSObject : AnyObject])
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
