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

    @IBOutlet weak var usernameTextField: UITextField!
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
    
    @IBAction func unwindToLogin(segue: UIStoryboardSegue) {
        
        if let identifier = segue.identifier {
            print("Identifier \(identifier)")
        }
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
                self.performSegueWithIdentifier("loginToApp", sender: self)
            }
        }
    }
    
    func showLoginAlert() {
        let alertTitle = "Hey!"
        let message = "Please provide all required information!"
        let alert = UIAlertController(title: alertTitle, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "I'm a troll", style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
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
