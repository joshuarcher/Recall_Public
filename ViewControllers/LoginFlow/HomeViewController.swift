//
//  HomeViewController.swift
//  Reecall
//
//  Created by Joshua Archer on 12/10/15.
//  Copyright © 2015 Joshua Archer. All rights reserved.
//

import UIKit
import SafariServices

class HomeViewController: UIViewController {
    
    private var buttonLogin = "LOGIN"
    private var buttonSignup = "SIGN UP"
    
    private var recallHourGlass = UIImageView.newAutoLayoutView()
    private var signupButton = UIButton.newAutoLayoutView()
    private var loginButton = UIButton.newAutoLayoutView()
    private var termsLabel = UILabel.newAutoLayoutView()
    private let gestureText = UITapGestureRecognizer()
    
    enum Notifications {
        static let signUpPressed = "signUpButtonPressed"
        static let loginPressed = "loginButtonPressed"
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
        setUpText()
        // Do any additional setup after loading the view.
    }
    
    func setUpText() {
        let attributedString = NSMutableAttributedString(string: "By tapping sign up, you agree to the Terms of Service and Privacy Policy.")//37-53
        attributedString.addAttribute(NSLinkAttributeName, value: "http://terms", range: NSMakeRange(37, 16))
        attributedString.addAttribute(NSLinkAttributeName, value: "http://privacy", range: NSMakeRange(58, 14))
        termsLabel.attributedText = attributedString
        termsLabel.numberOfLines = 2
        termsLabel.textColor = UIColor.recallOffWhite()
        termsLabel.textAlignment = .Center
        termsLabel.font = UIFont.systemFontOfSize(12)
        gestureText.addTarget(self, action: #selector(HomeViewController.termsTextTapped(_:)))
        gestureText.numberOfTapsRequired = 1
        termsLabel.addGestureRecognizer(gestureText)
        termsLabel.userInteractionEnabled = true
    }

    func loginButtonPressed(sender: UIButton!) {
        print("login button pressed")
        sendLoginNotification()
        presentNextView()
    }
    
    func signUpButtonPressed(sender: UIButton!) {
        print("sign up button pressed")
        sendSignUpNotification()
        presentNextView()
    }
    
    func sendLoginNotification() {
        let notificationCenter = NSNotificationCenter.defaultCenter()
        // true for true to login
        notificationCenter.postNotificationName(Notifications.loginPressed, object: true)
    }
    
    func sendSignUpNotification() {
        let notificationCenter = NSNotificationCenter.defaultCenter()
        // flase for false to login
        notificationCenter.postNotificationName(Notifications.signUpPressed, object: false)
    }
    
    func presentNextView() {
        if let topView = self.parentViewController as? LoginFlowViewController {
            topView.animateHourGlass()
        }
    }
    
    func termsTextTapped(sender: UITapGestureRecognizer) {
        let nextVc: UIViewController!
        if sender.didTapAttributedTextInLabel(self.termsLabel, inRange: NSMakeRange(37, 16)) {
            print("Terms Tapped")
            nextVc = SFSafariViewController(URL: NSURL(string: "http://recall-that.com/terms.html")!)
            self.presentViewController(nextVc, animated: true, completion: nil)
        } else if sender.didTapAttributedTextInLabel(self.termsLabel, inRange: NSMakeRange(56, 14)) {
            print("Privacy Tapped")
            nextVc = SFSafariViewController(URL: NSURL(string: "http://recall-that.com/privacy_policy.html")!)
            self.presentViewController(nextVc, animated: true, completion: nil)
        }
    }
    
    func setUpView() {
        
        loginButton.backgroundColor = UIColor.recallRedLight()
        loginButton.setTitleColor(UIColor.grayColor(), forState: .Normal)
        loginButton.setTitle("LOGIN", forState: .Normal)
        loginButton.addTarget(self, action: #selector(HomeViewController.loginButtonPressed(_:)), forControlEvents: .TouchUpInside)
        self.view.addSubview(loginButton)
        loginButton.autoPinEdgeToSuperviewEdge(.Bottom)
        loginButton.autoPinEdgeToSuperviewEdge(.Left)
        loginButton.autoPinEdgeToSuperviewEdge(.Right)
        loginButton.autoSetDimension(.Height, toSize: 50)
        
        signupButton.backgroundColor = UIColor.recallOffWhite()
        signupButton.setTitleColor(UIColor.grayColor(), forState: .Normal)
        signupButton.setTitle("SIGN UP", forState: .Normal)
        signupButton.addTarget(self, action: #selector(HomeViewController.signUpButtonPressed(_:)), forControlEvents: .TouchUpInside)
        self.view.addSubview(signupButton)
        signupButton.autoSetDimension(.Height, toSize: 50)
        signupButton.autoPinEdge(.Bottom, toEdge: .Top, ofView: loginButton)
        signupButton.autoPinEdgeToSuperviewEdge(.Left)
        signupButton.autoPinEdgeToSuperviewEdge(.Right)
        
        self.view.addSubview(termsLabel)
        termsLabel.autoSetDimension(.Height, toSize: 50)
        termsLabel.autoPinEdge(.Bottom, toEdge: .Top, ofView: signupButton)
        termsLabel.autoPinEdgeToSuperviewEdge(.Left, withInset: 20)
        termsLabel.autoPinEdgeToSuperviewEdge(.Right, withInset: 20)
//        termsLabel.autoPinEdgeToSuperviewEdge(.Left)
//        termsLabel.autoPinEdgeToSuperviewEdge(.Right)
        
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
}
