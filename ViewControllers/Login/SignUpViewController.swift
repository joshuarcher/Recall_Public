//
//  SignUpViewController.swift
//  Reecall
//
//  Created by Joshua Archer on 11/2/15.
//  Copyright © 2015 Joshua Archer. All rights reserved.
//

import UIKit
import Parse

class SignUpViewController: UIViewController {
    
    private let toAppSegue = "signUpToApp"
    private let toDigitsSegue = "signUpToDigits"

    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Touch Events
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        view.endEditing(true)
        super.touchesBegan(touches, withEvent: event)
    }
    
    @IBAction func signUpButtonTapped(sender: AnyObject) {
        if usernameTextField.text?.characters.count != 0 &&
            emailTextField.text?.characters.count != 0 &&
            passwordTextField.text?.characters.count != 0 {
                signUpUser()
        } else {
            // show alert to fill out all fields
            showSignUpAlert()
        }
    }
    
    // MARK: - Helper methods
    
    func signUpUser() {
        let newUser = PFUser()
        newUser.username = usernameTextField.text
        newUser.email = emailTextField.text
        newUser.password = passwordTextField.text
        newUser.signUpInBackgroundWithBlock({ (success: Bool, error: NSError?) -> Void in
            if let error = error {
                NSLog("Error signing up: %@", error)
            } else {
                // present next screen
                self.presentNextScreen()
            }
        })
    }
    
    func showSignUpAlert() {
        let alertTitle = "Hey!"
        let message = "Please provide all required information!"
        let alert = UIAlertController(title: alertTitle, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "I'm a troll", style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    func presentNextScreen() {
        if let _ = PFUser.currentUser() {
            if let _ = KeychainHelper.getKeychainUserPhone() {
                self.performSegueWithIdentifier(toAppSegue, sender: self)
            } else {
                self.performSegueWithIdentifier(toDigitsSegue, sender: self)
            }
        }
        else {
            print("user is not logged in after signup...")
        }
    }

}
