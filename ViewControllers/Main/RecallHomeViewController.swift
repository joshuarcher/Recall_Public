//
//  RecallHomeViewController.swift
//  Reecall
//
//  Created by Joshua Archer on 12/28/15.
//  Copyright © 2015 Joshua Archer. All rights reserved.
//

import UIKit

class RecallHomeViewController: UIViewController {
    
    private let capsuleViewNib = "CapsuleViewController"
    private let timelineViewNib = "RecallViewController"
    private let composeSegue = "showRecallCompose" // i think I'm done with this
    private let imagePickerSegue = "presentImagePicker"
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var cameraButton: UIButton!
    @IBOutlet weak var topBarView: UIView!
    
    @IBOutlet weak var labelRecall: UILabel!
    @IBOutlet weak var labelComing: UILabel!
    
    @IBOutlet weak var labelRecallCenterConstraint: NSLayoutConstraint!
    @IBOutlet weak var labelComingCenterConstraint: NSLayoutConstraint!
    
    private var profileButton: UIButton?
    
    weak var photoTakingHelper: PhotoTakingHelper?
    weak var imageToCompose: UIImage?
    
    enum Notifications {
        static let viewAppeared = "homeControllerAppeared"
    }
    
    // MARK: - View Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpView()
        self.setUpButtons()
        PushNotificationHelper.signUpForNotifications()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        subscribeToNotifications()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        unsubscribeToNotifications()
    }
    
    @IBAction func cameraButtonTapped(sender: AnyObject) {
        composeImage()
    }
    
    func composeImage() {
        if UIImagePickerController.isCameraDeviceAvailable(.Rear) {
            self.performSegueWithIdentifier(imagePickerSegue, sender: self)
        } else {
            self.performSegueWithIdentifier(composeSegue, sender: self)
        }
    }
    
    @IBAction func unwindToSegue(segue: UIStoryboardSegue) {
        
    }
    
    // MARK: - Helper Methods
    
    func setUpView() {
        
        let timelineView = RecallViewController(nibName: timelineViewNib, bundle: nil)
        
        // add to scrollView
        self.addChildViewController(timelineView)
        self.scrollView.addSubview(timelineView.view)
        timelineView.didMoveToParentViewController(self)
        
        let timeCapsuleView = CapsuleViewController(nibName: capsuleViewNib, bundle: nil)
        
        // set frame to be to the right of the capsule view
        var timeCapsuleFrame = timeCapsuleView.view.frame
        timeCapsuleFrame.origin.x = self.view.frame.size.width
        timeCapsuleView.view.frame = timeCapsuleFrame
        
        // add to scroll view
        self.addChildViewController(timeCapsuleView)
        self.scrollView.addSubview(timeCapsuleView.view)
        timelineView.didMoveToParentViewController(self)
        
        // two views wide, height does not include nav bar
        self.scrollView.contentSize = CGSizeMake(self.view.frame.size.width * 2, self.view.frame.size.height - 44)
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == composeSegue {
            // changed for new datepicker
            guard let datePickerView: DatePickerViewController = segue.destinationViewController as? DatePickerViewController else {return}
            if let imageForPicker = imageToCompose {
                datePickerView.capturedImage = imageForPicker
            }
        }
    }
    
    // MARK: Notifications
    
    func subscribeToNotifications() {
        let defaultCenter = NSNotificationCenter.defaultCenter()
        defaultCenter.addObserver(self, selector: #selector(RecallHomeViewController.scrollToCapsule), name: Notifications.viewAppeared, object: nil)
    }
    
    func unsubscribeToNotifications() {
        let defaultCenter = NSNotificationCenter.defaultCenter()
        defaultCenter.removeObserver(self)
    }
    
    func scrollToCapsule() {
        updateScrollViewOffset(0)
    }
    
    // MARK: - Button Methods
    
    func setUpButtons() {
        if profileButton == nil {
            
            // for labels as buttons
            let gestureRecall = UITapGestureRecognizer(target: self, action: #selector(RecallHomeViewController.labelRecallTapped))
            labelRecall.addGestureRecognizer(gestureRecall)
            labelRecall.userInteractionEnabled = true
            let gestureIncoming = UITapGestureRecognizer(target: self, action: #selector(RecallHomeViewController.labelIncomingTapped))
            labelComing.addGestureRecognizer(gestureIncoming)
            labelComing.userInteractionEnabled = true
            
            
            
            let profileButtonImage = UIImage(named: "ProfileButton")
            
            // set original frame on the left side
            let profileButtonFrame = CGRectMake(0, 0, 60, 44)
            profileButton = UIButton(frame: profileButtonFrame)
            if let profileButton = profileButton {
                topBarView.addSubview(profileButton)
                profileButton.setImage(profileButtonImage, forState: .Normal)
                let gesture = UITapGestureRecognizer(target: self, action: #selector(RecallHomeViewController.profileButtonTapped))
                profileButton.addGestureRecognizer(gesture)
                profileButton.imageEdgeInsets = UIEdgeInsetsMake(10, 10, 10 , 26)
                
            }
            
        }
    }
    
    // type 0
    func labelIncomingTapped() {
        print("first button Tapped")
        updateScrollViewOffset(0)
    }
    
    // type 1
    func labelRecallTapped() {
        print("second button Tapped")
        updateScrollViewOffset(1)
    }
    
    func profileButtonTapped() {
        print("profile button tapped")
        let nextVc: UserProfileViewController = UserProfileViewController(nibName: "UserProfileViewController", bundle: nil)
        self.presentViewController(nextVc, animated: true, completion: nil)
    }

}

extension RecallHomeViewController {
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        let scrollOffset = scrollView.contentOffset.x
        fadeProfileButton(scrollOffset)
        animateNavigationLabels(scrollOffset)
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
    
    // MARK: - Button Animation Methods
    // TODO: make this highly more efficient....
    
    func fadeProfileButton(scrollOffset: CGFloat) {
        guard let button = profileButton else {return}
        let barWidth = self.view.frame.width
        let fade = scrollOffset/(barWidth/4)
        button.alpha = 1 - fade
        moveProfileButton(scrollOffset, width: barWidth)
    }
    
    func moveProfileButton(scrollOffset: CGFloat, width: CGFloat) {
        guard let button = profileButton else {return}
        var buttonFrame = button.frame
        let endX = -width/4
        let spotToMove = (scrollOffset/width) * endX
        buttonFrame.origin.x = spotToMove
        button.frame = buttonFrame
    }
    
    // MARK: - NavLabel Animation
    
    func animateNavigationLabels(contentOffset: CGFloat) {
        let barWidth = self.view.frame.width
        var percentageScroll = contentOffset/barWidth
        if percentageScroll < 0 {
            percentageScroll = 0
        } else if percentageScroll > 1 {
            percentageScroll = 1
        }
        animateNavigationRecall(percentageScroll)
        animateNavigationIncoming(percentageScroll)
    }
    
    func animateNavigationRecall(percentage: CGFloat) {
        // move contstraint between 0 -> -74
        self.labelRecallCenterConstraint.constant = CGFloat(-74) * percentage
        self.labelRecall.alpha = CGFloat(1.4) - percentage
    }
    
    func animateNavigationIncoming(percentage: CGFloat) {
        // move constraint between +74 -> 0
        self.labelComingCenterConstraint.constant = CGFloat(74) - (CGFloat(74) * percentage)
        self.labelComing.alpha = CGFloat(0.4) + percentage
    }
}
