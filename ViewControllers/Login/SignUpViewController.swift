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

    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
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
    
    func signUpUser() {
        let newUser = PFUser()
        newUser.username = usernameTextField.text
        newUser.email = emailTextField.text
        newUser.password = passwordTextField.text
        if let phoneNo = KeychainHelper.getKeychainUserPhone() {
            newUser["phone"] = phoneNo
        }
        newUser.signUpInBackgroundWithBlock({ (success: Bool, error: NSError?) -> Void in
            if let error = error {
                print(error.description)
            } else {
                print("successfully signed up user")
                // present next screen
                self.presentNextScreen()            }
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
                self.performSegueWithIdentifier("signUpToApp", sender: self)
            } else {
                self.performSegueWithIdentifier("signUpToDigits", sender: self)
            }
        }
        else {
            print("user is not logged in after signup...")
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}