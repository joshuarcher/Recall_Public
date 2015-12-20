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
    
    private var overlayView = UIView.newAutoLayoutView()
    private var overlayButtonOne: UIButton?
    private var overlayButtonTwo: UIButton?

    override func viewDidLoad() {
        super.viewDidLoad()
        print("hey, nav loaded")
        // Do any additional setup after loading the view.
    }
    
    func subscribeNotifications() {
        let notificationCenter = NSNotificationCenter.defaultCenter()
        // this notification is from the scroll view scrolling
        notificationCenter.addObserver(self, selector: "receiveNotification:", name: scrollUpdateNotification, object: nil)
    }
    
    func receiveNotification(notification: NSNotification) {
        print("hey")
        if let userInfo = notification.userInfo {
            guard let contentOffset = userInfo["contentOffset"] as? CGFloat else {print("nope");return}
//            updateButton(contentOffset)
//            updateButtonTwo(contentOffset)
//            print(self.overlayButtonTwo?.frame)
            print(contentOffset)
        }
    }
    // Not receiving the notification... but page is loading
}


