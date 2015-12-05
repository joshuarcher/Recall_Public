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
        let digitsVerified = UserDefaultsHelper.isDigitsVerified()
        if digitsVerified {
            self.presentNextView()
        } else {
            self.checkDigits()
        }
    }
    
    // MARK: - Button actions
    
    @IBAction func digitsVerifyButtonTapped(sender: AnyObject) {
        verifyUserPhoneNumber()
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
    
    func verifyUserPhoneNumber() {
        FabricHelper.verifyUserPhoneNumber { (success: Bool, number: String?) -> Void in
            if success {
                if let userDigitsID = FabricHelper.getDigitsUserID(), number = number {
                    PFUser.setCurrentUserDigitsID(userDigitsID)
                    PFUser.setCurrentUserPhone(number)
                    UserDefaultsHelper.verifyDigits()
                }
            } else {
                self.presentDigitsFailAlert()
            }
        }
    }
    
    func checkDigits() {
        FabricHelper.getDigitsData { (success, phoneNumber, digitsUserId) -> Void in
            if success {
                if let phoneNumber = phoneNumber, digitsUserId = digitsUserId {
                    PFUser.setCurrentUserPhone(phoneNumber)
                    PFUser.setCurrentUserDigitsID(digitsUserId)
                    UserDefaultsHelper.verifyDigits()
                    // Parse user data is saved, continue to next screen
                    self.presentNextView()
                }
            } else {
                print("User doesn't have a session, button should work..")
            }
        }
    }
    
    func presentNextView() {
        self.performSegueWithIdentifier(toAppSegue, sender: self)
    }
    
}
