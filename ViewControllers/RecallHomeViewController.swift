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
    private let composeSegue = "showRecallCompose"
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var cameraButton: UIButton!
    @IBOutlet weak var topBarView: UIView!
    
    private var overlayButtonOne: UIButton?
    private var overlayButtonTwo: UIButton?
    private var profileButton: UIButton?
    
    var photoTakingHelper: PhotoTakingHelper?
    var imageToCompose: UIImage?
    
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
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
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
    
    // MARK: - Helper Methods
    
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
        self.scrollView.contentSize = CGSizeMake(self.view.frame.size.width * 2, self.view.frame.size.height - 44)
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == composeSegue {
            let composeView: RecallComposeViewController = segue.destinationViewController as! RecallComposeViewController
            if let imageTo = imageToCompose {
                composeView.imageTaken = imageTo
            }
        }
    }
    
    func sendAppearNotification() {
        
    }
    
    // MARK: - Button Methods
    
    func setUpButtons() {
        if overlayButtonOne == nil && overlayButtonTwo == nil && profileButton == nil {
            // image for buttons
            let image = UIImage(named: "CustomTabBarHourGlassImage")
            
            // set original frame on right side
            let buttonX = self.view.frame.width - 40
            let buttonFrame = CGRectMake(buttonX, 2, 40, 40)
            overlayButtonOne = UIButton(frame: buttonFrame)
            if let button = overlayButtonOne {
                topBarView.addSubview(button)
                button.setImage(image, forState: .Normal)
                let gesture = UITapGestureRecognizer(target: self, action: "firstButtonTapped")
                button.addGestureRecognizer(gesture)
            }
            
            // set original frame in the middle of the nav bar
            let buttonTwoX = (self.view.frame.width/2) - 20
            let buttonTwoFrame = CGRectMake(buttonTwoX, 2, 40, 40)
            overlayButtonTwo = UIButton(frame: buttonTwoFrame)
            if let buttonTwo = overlayButtonTwo {
                topBarView.addSubview(buttonTwo)
                buttonTwo.alpha = 0
                buttonTwo.setImage(image, forState: .Normal)
                let gesture = UITapGestureRecognizer(target: self, action: "secondButtonTapped")
                buttonTwo.addGestureRecognizer(gesture)
            }
            
            let profileButtonImage = UIImage(named: "ProfileButton")
            
            // set original frame on the left side
            let profileButtonFrame = CGRectMake(0, 0, 60, 44)
            profileButton = UIButton(frame: profileButtonFrame)
            if let profileButton = profileButton {
                topBarView.addSubview(profileButton)
                profileButton.setImage(profileButtonImage, forState: .Normal)
                let gesture = UITapGestureRecognizer(target: self, action: "profileButtonTapped")
                profileButton.addGestureRecognizer(gesture)
                profileButton.imageEdgeInsets = UIEdgeInsetsMake(4, 0, 4, 14)
            }
            
        }
    }
    
    // type 0
    func firstButtonTapped() {
        print("first button Tapped")
        updateScrollViewOffset(0)
    }
    
    // type 1
    func secondButtonTapped() {
        print("second button Tapped")
        updateScrollViewOffset(1)
    }
    
    func profileButtonTapped() {
        print("profile button tapped")
        let nextVc: UserProfileViewController = UserProfileViewController(nibName: "UserProfileViewController", bundle: nil)
        presentViewController(nextVc, animated: true) { () -> Void in
            print("presented")
        }
    }

}

extension RecallHomeViewController {
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        let scrollOffset = scrollView.contentOffset.x
        updateButton(scrollOffset)
        updateButtonTwo(scrollOffset)
        fadeProfileButton(scrollOffset)
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
    
    func updateButton(contentOffset: CGFloat) {
        let barWidth = self.view.frame.width
        let endxDistance = (barWidth / 2) - 20
        let startxDistance = barWidth - 40
        let difference = startxDistance - endxDistance
        let spotToMove = barWidth - ((difference * (contentOffset/barWidth)) + 40)
        let animationPercatage = contentOffset/(barWidth/4)
        fadeButton(animationPercatage)
        moveButton(spotToMove)
    }
    
    func updateButtonTwo(contentOffset: CGFloat) {
        let barWidth = self.view.frame.width
        let startxDistance = barWidth/2 - 20
        let difference = startxDistance - 0
        let spotToMove = (1 - (contentOffset/barWidth)) * difference
        let animationPercentage = contentOffset/(barWidth/4)
        fadeButtonTwo(animationPercentage)
        moveButtonTwo(spotToMove)
    }
    
    func fadeButton(animatedPercFade: CGFloat) {
        guard let button = overlayButtonOne else {return}
        button.alpha = 1 - animatedPercFade
    }
    
    func fadeButtonTwo(animatedPercFade: CGFloat) {
        guard let button = overlayButtonTwo else {return}
        button.alpha = -3 + animatedPercFade
    }
    
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
    
    func moveButton(buttonLocation: CGFloat) {
        let max = self.view.frame.width - 40
        guard let button = overlayButtonOne else {return}
        let frame = button.frame
        // don't over-move
        if buttonLocation > max {
            button.frame = CGRectMake(max, frame.origin.y, frame.width, frame.height)
        } else {
            button.frame = CGRectMake(buttonLocation, frame.origin.y, frame.width, frame.height)
        }
    }
    
    func moveButtonTwo(buttonLocation: CGFloat) {
        guard let button = overlayButtonTwo else {return}
        let frame = button.frame
        // don't over-move
        if buttonLocation < 0 {
            button.frame = CGRectMake(0, frame.origin.y, frame.width, frame.height)
        } else {
            button.frame = CGRectMake(buttonLocation, frame.origin.y, frame.width, frame.height)
        }
    }
}
