//
//  UsernameViewController.swift
//  Reecall
//
//  Created by Joshua Archer on 12/10/15.
//  Copyright © 2015 Joshua Archer. All rights reserved.
//

import UIKit

class UsernameViewController: UIViewController {
    
    private var username = "choose username"
    private var buttonSignup = "SIGN UP"
    
    private var credentialView = UIView.newAutoLayoutView()
    private var usernameTextField = UITextField.newAutoLayoutView()
    private var signUpButton = UIButton.newAutoLayoutView()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setUpView()
        initializeTargets()
    }
    
    func initializeTargets() {
        self.usernameTextField.addTarget(self, action: "showSignUpButton", forControlEvents: .EditingChanged)
        self.signUpButton.addTarget(self, action: "signUpButtonPressed:", forControlEvents: .TouchUpInside)
    }
    
    func showSignUpButton() {
        if let emailText = usernameTextField.text {
            if emailText.characters.count > 0 {
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
            if usernameText.characters.count > 4 {
                // set credentials and sign up
                setUsernameCredential()
                signUpFromParentViewController()
            } else {
                // not enough characters for username
                print("not enough characters")
            }
        }
        print("sign up button pressed")
    }
    
    func signUpFromParentViewController() {
        guard let loginFlow = self.parentViewController as? LoginFlowViewController else {
            print("error grabbing loginFlow signUpFromParentViewController")
            return
        }
        loginFlow.signUpUser()
    }
    
    func setUpView() {
        credentialView.backgroundColor = UIColor.recallOffWhite()
        self.view.addSubview(credentialView)
        credentialView.autoSetDimension(.Height, toSize: 100)
        credentialView.autoPinEdgeToSuperviewEdge(.Top, withInset: 220)
        credentialView.autoPinEdgeToSuperviewEdge(.Left)
        credentialView.autoPinEdgeToSuperviewEdge(.Right)
        
        usernameTextField.placeholder = username
        usernameTextField.textAlignment = .Center
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
