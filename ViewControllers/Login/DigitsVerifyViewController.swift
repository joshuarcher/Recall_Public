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

    @IBOutlet weak var digitsVerifyButton: DGTAuthenticateButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
//        if let _ = KeychainHelper.getKeychainUserPhone() {
//            let success = PFUser.setCurrentUserPhone()
//            if success {print("saved current user's phone")} else {print("did not save current user's phone")}
//            presentNextView()
//        }
    }
    
    @IBAction func digitsVerifyButtonTapped(sender: AnyObject) {
        FabricHelper.verifyUserPhoneNumber { (success: Bool, number: String?) -> Void in
            if success {
                if let userDigitsID = FabricHelper.getDigitsUserID() {
                    PFUser.setCurrentUserDigitsID(userDigitsID)
                    self.presentNextView()
                }
            }
        }
    }
    
    func presentNextView() {
        self.performSegueWithIdentifier("digitsToApp", sender: self)
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
