//
//  UsernameViewController.swift
//  Reecall
//
//  Created by Joshua Archer on 12/10/15.
//  Copyright © 2015 Joshua Archer. All rights reserved.
//

import UIKit

class UsernameViewController: UIViewController {
    
    enum ErrorType {
        static let password = "passwordLength"
        static let username = "usernameLength"
        static let credentialLogin = "credentialsLoginFull"
        static let credentialSignup = "credentialsSignupFull"
    }
    
    enum Notifications {
        static let alertNotifaction = "alertNotification"
    }
    
    private var username = "choose username"
    private var buttonSignup = "SIGN UP"
    
    private var credentialView = UIView.newAutoLayoutView()
    private var usernameTextField = UITextField.newAutoLayoutView()
    private var signUpButton = UIButton.newAutoLayoutView()
    private var backButton = UIButton.newAutoLayoutView()

    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setUpView()
        initializeTargets()
    }
    
    func initializeTargets() {
        self.usernameTextField.addTarget(self, action: #selector(UsernameViewController.showSignUpButton), forControlEvents: .EditingChanged)
        self.signUpButton.addTarget(self, action: #selector(UsernameViewController.signUpButtonPressed(_:)), forControlEvents: .TouchUpInside)
        self.backButton.addTarget(self, action: #selector(UsernameViewController.backButtonPressed(_:)), forControlEvents: .TouchUpInside)
    }
    
    func showSignUpButton() {
        if let usernameText = usernameTextField.text {
            if usernameText.characters.count > 0 {
                UIView.animateWithDuration(0.25, animations: { () -> Void in
                    self.signUpButton.layer.opacity = 1
                })
            } else {
                self.signUpButton.layer.opacity = 0
            }
        }
    }
    
    func setUsernameCredential() {
        guard let loginFlow = self.parentViewController as? LoginFlowViewController else {
            print("Error in grabbing loginFlow setUserCredentials")
            return
        }
        loginFlow.userSignUpUsername = self.usernameTextField.text
    }
    
    func signUpButtonPressed(sender: UIButton!) {
        if let usernameText = usernameTextField.text {
            if usernameText.characters.count >= 3 && !usernameText.containsSpaces() {
                // set credentials and sign up
                setUsernameCredential()
                signUpFromParentViewController()
            } else {
                // not enough characters for username
                print("not enough characters")
                sendNotification(forError: ErrorType.username)
            }
        }
        print("sign up button pressed")
    }
    
    func backButtonPressed(sender: UIButton!) {
        if let topView = self.parentViewController as? LoginFlowViewController {
            topView.backwardsScrollToUsername()
        }
        // clear credentials
        usernameTextField.text = ""
        usernameTextField.endEditing(true)
        showSignUpButton()
    }
    
    func signUpFromParentViewController() {
        guard let loginFlow = self.parentViewController as? LoginFlowViewController else {
            print("error grabbing loginFlow signUpFromParentViewController")
            return
        }
        loginFlow.signUpUser()
    }
    
    func sendNotification(forError errorType: String) {
        let object = ["errorType": errorType]
        let defaultCenter = NSNotificationCenter.defaultCenter()
        defaultCenter.postNotificationName(Notifications.alertNotifaction, object: nil, userInfo: object)
    }
    
    // MARK - Setup Methods
    
    func setUpView() {
        credentialView.backgroundColor = UIColor.recallOffWhite()
        self.view.addSubview(credentialView)
        credentialView.autoSetDimension(.Height, toSize: 100)
        credentialView.autoPinEdgeToSuperviewEdge(.Top, withInset: 220)
        credentialView.autoPinEdgeToSuperviewEdge(.Left)
        credentialView.autoPinEdgeToSuperviewEdge(.Right)
        
        if let buttonImage = UIImage(named: "BackCircle") {
            backButton.setImage(buttonImage, forState: .Normal)
        }
        self.view.addSubview(backButton)
        backButton.autoSetDimension(.Height, toSize: 40)
        backButton.autoSetDimension(.Width, toSize: 40)
        backButton.autoPinEdgeToSuperviewEdge(.Left, withInset: 8)
        backButton.autoPinEdge(.Bottom, toEdge: .Top, ofView: credentialView, withOffset: -8)
        
        usernameTextField.placeholder = username
        usernameTextField.textAlignment = .Center
        usernameTextField.autocapitalizationType = .None
        usernameTextField.autocorrectionType = .No
        usernameTextField.spellCheckingType = .No
        usernameTextField.keyboardType = .Default
        usernameTextField.keyboardAppearance = .Dark
        // TODO: next button on keyboard triggers signup
        self.credentialView.addSubview(usernameTextField)
        usernameTextField.autoSetDimension(.Height, toSize: 40)
        usernameTextField.autoAlignAxisToSuperviewAxis(.Horizontal)
        usernameTextField.autoPinEdgeToSuperviewEdge(.Left)
        usernameTextField.autoPinEdgeToSuperviewEdge(.Right)
        
        signUpButton.layer.opacity = 0
        signUpButton.backgroundColor = UIColor.recallRedLight()
        signUpButton.setTitleColor(UIColor.grayColor(), forState: .Normal)
        signUpButton.setTitle(buttonSignup, forState: .Normal)
        self.view.addSubview(signUpButton)
        signUpButton.autoSetDimension(.Height, toSize: 40)
        signUpButton.autoPinEdge(.Top, toEdge: .Bottom, ofView: credentialView)
        signUpButton.autoPinEdgeToSuperviewEdge(.Left)
        signUpButton.autoPinEdgeToSuperviewEdge(.Right)
        
        
        
        
    }

}
