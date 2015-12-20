//
//  HomeViewController.swift
//  Reecall
//
//  Created by Joshua Archer on 12/10/15.
//  Copyright © 2015 Joshua Archer. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {
    
    private var buttonLogin = "LOGIN"
    private var buttonSignup = "SIGN UP"
    
    private var recallHourGlass = UIImageView.newAutoLayoutView()
    private var signupButton = UIButton.newAutoLayoutView()
    private var loginButton = UIButton.newAutoLayoutView()
    
    enum Notifications {
        static let signUpPressed = "signUpButtonPressed"
        static let loginPressed = "loginButtonPressed"
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
        // Do any additional setup after loading the view.
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
    
    func setUpView() {
        
        loginButton.backgroundColor = UIColor.recallRedLight()
        loginButton.setTitleColor(UIColor.grayColor(), forState: .Normal)
        loginButton.setTitle("LOGIN", forState: .Normal)
        loginButton.addTarget(self, action: "loginButtonPressed:", forControlEvents: .TouchUpInside)
        self.view.addSubview(loginButton)
        loginButton.autoPinEdgeToSuperviewEdge(.Bottom)
        loginButton.autoPinEdgeToSuperviewEdge(.Left)
        loginButton.autoPinEdgeToSuperviewEdge(.Right)
        loginButton.autoSetDimension(.Height, toSize: 50)
        
        signupButton.backgroundColor = UIColor.recallOffWhite()
        signupButton.setTitleColor(UIColor.grayColor(), forState: .Normal)
        signupButton.setTitle("SIGN UP", forState: .Normal)
        signupButton.addTarget(self, action: "signUpButtonPressed:", forControlEvents: .TouchUpInside)
        self.view.addSubview(signupButton)
        signupButton.autoSetDimension(.Height, toSize: 50)
        signupButton.autoPinEdge(.Bottom, toEdge: .Top, ofView: loginButton)
        signupButton.autoPinEdgeToSuperviewEdge(.Left)
        signupButton.autoPinEdgeToSuperviewEdge(.Right)
        
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
}
