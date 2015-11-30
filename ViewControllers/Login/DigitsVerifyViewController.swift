//
//  DigitsVerifyViewController.swift
//  Reecall
//
//  Created by Joshua Archer on 11/7/15.
//  Copyright © 2015 Joshua Archer. All rights reserved.
//

import UIKit
import DigitsKit
import Parse

class DigitsVerifyViewController: UIViewController {

    private let toAppSegue = "digitsToApp"
    
    @IBOutlet weak var digitsVerifyButton: DGTAuthenticateButton!
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
//        if let _ = KeychainHelper.getKeychainUserPhone() {
//            let success = PFUser.setCurrentUserPhone()
//            if success {print("saved current user's phone")} else {print("did not save current user's phone")}
//            presentNextView()
//        }
    }
    
    // MARK: - Button actions
    
    @IBAction func digitsVerifyButtonTapped(sender: AnyObject) {
        FabricHelper.verifyUserPhoneNumber { (success: Bool, number: String?) -> Void in
            if success {
                if let userDigitsID = FabricHelper.getDigitsUserID(), number = number {
                    PFUser.setCurrentUserDigitsID(userDigitsID)
                    PFUser.setCurrentUserPhone(number)
                    self.presentNextView()
                }
            } else {
                self.presentDigitsFailAlert()
            }
        }
    }
    
    @IBAction func noButtonTapped(sender: AnyObject) {
        presentNextView()
    }
    
    // MARK: - Helper methods
    
    func presentDigitsFailAlert() {
        let alert = UIAlertController(title: "Failed to Verify", message: "Something went wrong when verifying your phone number.  Please try again next time you open the app!", preferredStyle: .Alert)
        let action = UIAlertAction(title: "Got it!", style: .Default) { (action) -> Void in
            self.presentNextView()
        }
        alert.addAction(action)
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    func presentNextView() {
        self.performSegueWithIdentifier(toAppSegue, sender: self)
    }
    
}
