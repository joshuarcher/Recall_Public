//
//  LoginViewController.swift
//  Reecall
//
//  Created by Joshua Archer on 11/2/15.
//  Copyright © 2015 Joshua Archer. All rights reserved.
//

import UIKit
import Parse

class LoginViewController: UIViewController {
    
    private let toAppSegue = "loginToApp"
    private let toDigitsSegue = "loginToDigits"

    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    // MARK: - View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        if PFUser.currentUser() != nil {
            self.performSegueWithIdentifier(toAppSegue, sender: nil)
        }
    }
    
    @IBAction func unwindToLogin(segue: UIStoryboardSegue) {
        if let identifier = segue.identifier {
            print("Identifier \(identifier)")
        }
    }
    
    // MARK: - Touch methods
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        view.endEditing(true)
        super.touchesBegan(touches, withEvent: event)
    }
    
    @IBAction func loginButtonTapped(sender: AnyObject) {
        if usernameTextField.text?.characters.count != 0 &&
            passwordTextField.text?.characters.count != 0 {
                loginUser()
        } else {
            // show alert to fill out all fields
            showLoginAlert()
        }
    }
    
    // MARK: - Login Methods
    
    func loginUser() {
        guard let username = usernameTextField.text else {return}
        guard let password = passwordTextField.text else {return}
        PFUser.logInWithUsernameInBackground(username, password: password) { (user: PFUser?, error: NSError?) -> Void in
            if let error = error {
                print(error.description)
            } else {
                if let user = user {
                    print("user: \(user.username), logged in successfully..")
                }
                self.presentNextScreen()
            }
        }
    }
    
    // MARK: - Helper Methods
    
    func showLoginAlert() {
        let alertTitle = "Hey!"
        let message = "Please provide all required information!"
        let alert = UIAlertController(title: alertTitle, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "I'm a troll", style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    func presentNextScreen() {
        if let user = PFUser.currentUser() {
            if let _ = user["phone"] {
                performSegueWithIdentifier(toAppSegue, sender: self)
            } else {
                performSegueWithIdentifier(toDigitsSegue, sender: self)
            }
        }
        else {
            print("user is not logged in after login")
        }
    }
    
    // MARK: - Text Field Delegate
    
    func textFieldShouldReturn(textField: UITextField!) -> Bool {   //delegate method
        textField.resignFirstResponder()
        if textField == passwordTextField {
            loginUser()
        } else if textField == usernameTextField {
            passwordTextField.becomeFirstResponder()
        }
        
        return true
    }

}
