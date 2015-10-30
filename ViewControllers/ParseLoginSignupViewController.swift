//
//  ParseLoginSignupViewController.swift
//  Reecall
//
//  Created by Joshua Archer on 10/22/15.
//  Copyright © 2015 Joshua Archer. All rights reserved.
//

import UIKit
import Parse
import ParseUI

class ParseLoginSignupViewController: UIViewController, PFSignUpViewControllerDelegate, PFLogInViewControllerDelegate {

    var loginViewController: PFLogInViewController!
    var signupViewController: PFSignUpViewController!
    
    let recallRed: UIColor = UIColor(red: 0.918, green: 0.345, blue: 0.345, alpha: 1)
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(animated: Bool) {
        let currentUser = PFUser.currentUser()
        
        if currentUser != nil {
            // TODO present next screen
            presentNextViewController()
        }
        else {
            self.loginViewController = PFLogInViewController()
            self.loginViewController.logInView!.logo = nil
            self.loginViewController.signUpController?.signUpView?.logo = nil
            self.loginViewController.delegate = self
            
            self.signupViewController = PFSignUpViewController()
            self.signupViewController.signUpView!.logo = nil
            signupViewController.delegate = self
            
            self.presentViewController(self.loginViewController, animated: true, completion: nil)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    // MARK: - Login View Controller
    
    func logInViewController(logInController: PFLogInViewController, shouldBeginLogInWithUsername username: String, password: String) -> Bool {
        if (username.characters.count != 0 && password.characters.count != 0) {
            return true
            // begin login
        }
        
        let title = NSLocalizedString("Missing info", comment: "")
        let messsage = NSLocalizedString("Fill out all info", comment: "")
        let cancelButtonTitle = NSLocalizedString("OK", comment: "")
        
        UIAlertView(title: title, message: messsage, delegate: nil, cancelButtonTitle: cancelButtonTitle).show()
        
        return false
    }
    
    func logInViewController(logInController: PFLogInViewController, didLogInUser user: PFUser) {
        self.dismissViewControllerAnimated(true, completion: nil)
        
        // TODO present next screen
        presentNextViewController()
    }
    
    func logInViewController(logInController: PFLogInViewController, didFailToLogInWithError error: NSError?) {
        if let description = error?.localizedDescription {
            let cancelButton = NSLocalizedString("OK", comment: "")
            UIAlertView(title: description, message: nil, delegate: nil, cancelButtonTitle: cancelButton).show()
        }
    }
    
    // MARK: - Sign up controller
    
    func signUpViewController(signUpController: PFSignUpViewController, shouldBeginSignUp info: [NSObject : AnyObject]) -> Bool {
        var infoComplete = true
        
        for (key, _) in info {
            if let field = info[key] as? String {
                if field.characters.count == 0 {
                    infoComplete = false
                    break
                }
            }
        }
        
        if (!infoComplete) {
            let title = NSLocalizedString("Missing info", comment: "")
            let messsage = NSLocalizedString("Fill out all info", comment: "")
            let cancelButtonTitle = NSLocalizedString("OK", comment: "")
            
            UIAlertView(title: title, message: messsage, delegate: nil, cancelButtonTitle: cancelButtonTitle).show()
        }
        
        return infoComplete
    }
    
    
    func signUpViewController(signUpController: PFSignUpViewController, didSignUpUser user: PFUser) {
        self.dismissViewControllerAnimated(true, completion: nil)
        
        // TODO present next screen
        presentNextViewController()
    }
    
    func signUpViewController(signUpController: PFSignUpViewController, didFailToSignUpWithError error: NSError?) {
        if let description = error?.localizedDescription {
            let cancelButton = NSLocalizedString("OK", comment: "")
            UIAlertView(title: description, message: nil, delegate: nil, cancelButtonTitle: cancelButton).show()
        }
    }
    
    func presentNextViewController() {
        self.performSegueWithIdentifier("showRecall", sender: nil)
    }
    
    

}
