//
//  HomeNavigationViewController.swift
//  Reecall
//
//  Created by Joshua Archer on 12/19/15.
//  Copyright © 2015 Joshua Archer. All rights reserved.
//

import UIKit

class HomeNavigationViewController: UINavigationController {
    
    private let scrollUpdateNotification = "scrollDidScroll"
    private let scrollButtonTappedNotification = "scrollButtonTapped"
    private let hideNavButtonsNotification = "hideNavButtons"
    
    private var overlayView = UIView.newAutoLayoutView()
    private var overlayButtonOne: UIButton?
    private var overlayButtonTwo: UIButton?

    override func viewDidLoad() {
        super.viewDidLoad()
        subscribeNotifications()
        setUpNavOverlay()
        initButtons()
        // Do any additional setup after loading the view.
    }
    
    // MARK: - Notification Methods
    
    func subscribeNotifications() {
        let notificationCenter = NSNotificationCenter.defaultCenter()
        // this notification is from the scroll view scrolling
        notificationCenter.addObserver(self, selector: "receiveNotification:", name: scrollUpdateNotification, object: nil)
        notificationCenter.addObserver(self, selector: "receiveNavBarNotification:", name: hideNavButtonsNotification, object: nil)
    }
    
    func receiveNavBarNotification(notification: NSNotification) {
        print("received nav bar notification")
        if let userInfo = notification.userInfo {
            guard let isDissappearing = userInfo["dissappearing"] as? Bool else {return}
            print(isDissappearing)
            updateOverlayView(withBool: isDissappearing)
        }
    }
    
    func receiveNotification(notification: NSNotification) {
        if let userInfo = notification.userInfo {
            guard let contentOffset = userInfo["contentOffset"] as? CGFloat else {print("nope");return}
            updateButton(contentOffset)
            updateButtonTwo(contentOffset)
        }
    }
    
    func postButtonNotification(withType type: Int) {
        let notificationCenter = NSNotificationCenter.defaultCenter()
        // post to update on nav bar
        let dictionary: NSDictionary = NSDictionary(object: type, forKey: "buttonType")
        notificationCenter.postNotificationName(scrollButtonTappedNotification, object: self, userInfo: dictionary as [NSObject : AnyObject])
        // print("posting notification")
    }
    
    // Not receiving the notification... but page is loading
    // fixed by runn subscribe notifications in viewDidLoad....
    
    // MARK: - Button Actions
    
    // right button -> 0
    func firstButtonTapped() {
        print("button tapped")
        postButtonNotification(withType: 0)
    }
    
    // left button -> 1
    func secondButtonTapped() {
        print("button two tapped")
        postButtonNotification(withType: 1)
    }
    
    // MARK: - View Layout Methods
    
    func setUpNavOverlay() {
        overlayView.backgroundColor = UIColor.clearColor()
        self.view.addSubview(overlayView)
        overlayView.autoPinEdgeToSuperviewEdge(.Left)
        overlayView.autoPinEdgeToSuperviewEdge(.Right)
        overlayView.autoPinEdgeToSuperviewEdge(.Top)
        let navHeight = self.navigationBar.frame.size.height
        overlayView.autoSetDimension(.Height, toSize: navHeight)
    }
    
    func initButtons() {
        if overlayButtonOne == nil && overlayButtonTwo == nil {
            // image for buttons
            let image = UIImage(named: "CustomTabBarHourGlassImage")
            
            // set original frame on right side
            let buttonX = self.navigationBar.frame.width - 40
            let buttonFrame = CGRectMake(buttonX, 2, 40, 40)
            overlayButtonOne = UIButton(frame: buttonFrame)
            if let button = overlayButtonOne {
                overlayView.addSubview(button)
                button.setImage(image, forState: .Normal)
                let gesture = UITapGestureRecognizer(target: self, action: "firstButtonTapped")
                button.addGestureRecognizer(gesture)
            }
            
            // set original frame in the middle of the nav bar
            let buttonTwoX = (self.navigationBar.frame.width/2 - 20)
            let buttonTwoFrame = CGRectMake(buttonTwoX, 2, 40, 40)
            overlayButtonTwo = UIButton(frame: buttonTwoFrame)
            if let buttonTwo = overlayButtonTwo {
                overlayView.addSubview(buttonTwo)
                buttonTwo.alpha = 0
                buttonTwo.setImage(image, forState: .Normal)
                let gesture = UITapGestureRecognizer(target: self, action: "secondButtonTapped")
                buttonTwo.addGestureRecognizer(gesture)
            }
        }
    }
    
    // MARK: - Animation methods
    
    func updateOverlayView(withBool isDissappearing: Bool) {
        if isDissappearing {
            self.overlayView.alpha = 0
        } else if !isDissappearing {
            self.overlayView.alpha = 1
            self.view.bringSubviewToFront(self.overlayView)
        }
    }
    
    func updateButton(contentOffset: CGFloat) {
        let navBarWidth = self.navigationBar.frame.width
        let endxDistance = (navBarWidth / 2) - 20
        let startxDistance = navBarWidth - 40
        let difference = startxDistance - endxDistance
        let spotToMove = navBarWidth - ((difference * (contentOffset/navBarWidth)) + 40)
        let animationPercatage = contentOffset/navBarWidth
        fadeButton(animationPercatage)
        moveButton(spotToMove)
    }
    
    func updateButtonTwo(contentOffset: CGFloat) {
        let navBarWidth = self.navigationBar.frame.width
        let startxDistance = navBarWidth/2 - 20
        let difference = startxDistance - 0
        let spotToMove = (1 - (contentOffset/navBarWidth)) * difference
        let animationPercentage = contentOffset/navBarWidth
        fadeButtonTwo(animationPercentage)
        moveButtonTwo(spotToMove)
    }
    
    func fadeButton(animatedPercFade: CGFloat) {
        guard let button = overlayButtonOne else {return}
        button.alpha = 1 - animatedPercFade
    }
    
    func fadeButtonTwo(animatedPercFade: CGFloat) {
        guard let button = overlayButtonTwo else {return}
        button.alpha = animatedPercFade
    }
    
    func moveButton(buttonLocation: CGFloat) {
        let max = self.navigationBar.frame.width - 40
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


