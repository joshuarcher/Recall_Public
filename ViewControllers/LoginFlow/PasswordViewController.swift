//
//  PasswordViewController.swift
//  Reecall
//
//  Created by Joshua Archer on 12/10/15.
//  Copyright © 2015 Joshua Archer. All rights reserved.
//

import UIKit

class PasswordViewController: UIViewController {
    
    enum Notifications {
        static let signUpPressed = "signUpButtonPressed"
        static let loginPressed = "loginButtonPressed"
    }
    
    private var email = "enter email"
    private var passwordEmail = "choose password"
    private var buttonNext = "NEXT"
    private var username = "enter username"
    private var passwordUsername = "enter password"
    private var buttonLogin = "LOGIN"
    private var login: Bool = false
    
    private var credentialView = UIView.newAutoLayoutView()
    private var emailTextField = UITextField.newAutoLayoutView()
    private var passwordTextField = UITextField.newAutoLayoutView()
    private var nextButton = UIButton.newAutoLayoutView()

    override func viewDidLoad() {
        super.viewDidLoad()
        subscribeToNotifications()
        setUpView()
        initializeTargets()
        // Do any additional setup after loading the view.
    }

    func updatePlaceHolders(notifaction: NSNotification) {
        guard let yes = notifaction.object as? Bool else {
            print("couldn't grab notification object")
            return
        }
        if yes {
            emailTextField.placeholder = username
            passwordTextField.placeholder = passwordUsername
            nextButton.setTitle(buttonLogin, forState: .Normal)
            self.login = true
        }
        else if !yes {
            emailTextField.placeholder = email
            passwordTextField.placeholder = passwordEmail
            nextButton.setTitle(buttonNext, forState: .Normal)
            self.login = false
        }
    }
    
    func subscribeToNotifications() {
        let notificationCenter = NSNotificationCenter.defaultCenter()
        notificationCenter.addObserver(self, selector: "updatePlaceHolders:", name: Notifications.loginPressed, object: nil)
        notificationCenter.addObserver(self, selector: "updatePlaceHolders:", name: Notifications.signUpPressed, object: nil)
    }
    
    func initializeTargets() {
        self.passwordTextField.addTarget(self, action: "showNextButton", forControlEvents: .EditingChanged)
        self.nextButton.addTarget(self, action: "buttonPressed:", forControlEvents: .TouchUpInside)
    }
    
    func showNextButton() {
        if let usernameText = emailTextField.text, passwordText = passwordTextField.text {
            if usernameText.characters.count > 0 && passwordText.characters.count > 0 {
                UIView.animateWithDuration(0.25, animations: { () -> Void in
                    self.nextButton.layer.opacity = 1
                })
            } else {
                self.nextButton.layer.opacity = 0
            }
        }
    }
    
    // email Text is actually the username when it's the login controller
    // email is email when it's the signup controller
    func buttonPressed(sender: UIButton!) {
        if let emailText = emailTextField.text, passwordText = passwordTextField.text {
            if emailText.characters.count >= 4 && passwordText.characters.count >= 4 {
                setUserCredentials()
                if !login {
                    showNextView()
                } else if login {
                    print("login the fucking user already")
                    loginFromParentViewController()
                }
            } else {
                print("not enough characters")
            }
        }
    }
    
    func loginFromParentViewController() {
        guard let loginFlow = self.parentViewController as? LoginFlowViewController else {
            print("error grabbing loginFlow loginFromParentViewController")
            return
        }
        loginFlow.loginUser()
    }
    
    func setUserCredentials() {
        guard let loginFlow = self.parentViewController as? LoginFlowViewController else {
            print("Error in grabbing loginFlow setUserCredentials")
            return
        }
        if login {
            loginFlow.userLoginUsername = self.emailTextField.text
            loginFlow.userLoginPassword = self.passwordTextField.text
        } else if !login {
            loginFlow.userSignUpEmail = self.emailTextField.text
            loginFlow.userSignUpPassword = self.passwordTextField.text
        }
    }
    
    func showNextView() {
        if let topView = self.parentViewController as? LoginFlowViewController {
            topView.scrollToUsername()
        }
    }
    
    func setUpView() {
        
        credentialView.backgroundColor = UIColor.recallOffWhite()
        self.view.addSubview(credentialView)
        credentialView.autoSetDimension(.Height, toSize: 100)
        credentialView.autoPinEdgeToSuperviewEdge(.Top, withInset: 220)
        credentialView.autoPinEdgeToSuperviewEdge(.Left)
        credentialView.autoPinEdgeToSuperviewEdge(.Right)
        
        emailTextField.placeholder = email
        emailTextField.textAlignment = .Center
        emailTextField.textAlignment = .Center
        emailTextField.autocapitalizationType = .None
        emailTextField.autocorrectionType = .No
        emailTextField.spellCheckingType = .No
        if login {
            emailTextField.keyboardType = .Default
        } else {
            emailTextField.keyboardType = .EmailAddress
        }
        emailTextField.keyboardAppearance = .Dark
        emailTextField.returnKeyType = .Next
        self.credentialView.addSubview(emailTextField)
        emailTextField.autoSetDimension(.Height, toSize: 40)
        emailTextField.autoPinEdgeToSuperviewEdge(.Top, withInset: 5)
        emailTextField.autoPinEdgeToSuperviewEdge(.Left)
        emailTextField.autoPinEdgeToSuperviewEdge(.Right)
        
        passwordTextField.placeholder = passwordEmail
        passwordTextField.textAlignment = .Center
        passwordTextField.autocapitalizationType = .None
        passwordTextField.autocorrectionType = .No
        passwordTextField.spellCheckingType = .No
        passwordTextField.keyboardType = .Default
        passwordTextField.keyboardAppearance = .Dark
        passwordTextField.returnKeyType = .Next
        passwordTextField.secureTextEntry = true
        self.credentialView.addSubview(passwordTextField)
        passwordTextField.autoSetDimension(.Height, toSize: 40)
        passwordTextField.autoPinEdge(.Top, toEdge: .Bottom, ofView: emailTextField, withOffset: 10)
        passwordTextField.autoPinEdgeToSuperviewEdge(.Left)
        passwordTextField.autoPinEdgeToSuperviewEdge(.Right)
        
        nextButton.layer.opacity = 0
        nextButton.backgroundColor = UIColor.recallRedLight()
        nextButton.setTitleColor(UIColor.grayColor(), forState: .Normal)
        nextButton.setTitle(buttonNext, forState: .Normal)
        self.view.addSubview(nextButton)
        nextButton.autoSetDimension(.Height, toSize: 40)
        nextButton.autoPinEdge(.Top, toEdge: .Bottom, ofView: credentialView)
        nextButton.autoPinEdgeToSuperviewEdge(.Left)
        nextButton.autoPinEdgeToSuperviewEdge(.Right)
        
    }

}
