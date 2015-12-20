//
//  LoginFlowViewController.swift
//  Reecall
//
//  Created by Joshua Archer on 12/10/15.
//  Copyright © 2015 Joshua Archer. All rights reserved.
//

import UIKit
import Parse

class LoginFlowViewController: UIViewController {
    
    // segues
    private let toAppSegue = "loginFlowToApp"
    private let toDigitsSegue = "loginFlowToDigits"

    @IBOutlet weak var scrollView: UIScrollView!
    
    private var hourGlassImage = UIImageView.newAutoLayoutView()
    
    var userSignUpEmail: String?
    var userSignUpPassword: String?
    var userSignUpUsername: String?
    
    var userLoginUsername: String?
    var userLoginPassword: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpScrollView()
        setUpAutoLayout()
        // Do any additional setup after loading the view.
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    // Home -> Password
    func animateHourGlass() {
        UIView.animateWithDuration(0.5) { () -> Void in
            var frame = self.hourGlassImage.frame
            frame.size.width *= 0.5
            frame.size.height *= 0.5
            let diffX = frame.size.width - self.hourGlassImage.frame.size.width
            frame.origin.x -= diffX/2
            self.hourGlassImage.frame = frame
            self.scrollView.contentOffset = CGPoint(x: self.view.frame.size.width, y: 0)
        }
    }
    
    // Password -> Username
    func scrollToUsername() {
        UIView.animateWithDuration(0.5) { () -> Void in
            self.scrollView.contentOffset = CGPoint(x: self.view.frame.size.width * 2, y: 0)
        }
    }
    
    // MARK: - Login/Signup Methods
    
    func signUpUser() {
        let newUser = PFUser()
        guard let username = userSignUpUsername else {print("no username set");return}
        guard let email = userSignUpEmail else {print("no email set");return}
        guard let password = userSignUpPassword else {print("no password set");return}
        
        newUser.username = username
        newUser.email = email
        newUser.password = password
        newUser.signUpInBackgroundWithBlock({ (success: Bool, error: NSError?) -> Void in
            if let error = error {
                NSLog("Error signing up: %@", error)
            } else {
                // present next screen
                if success {
                    print("successfully signed up user")
                }
            }
        })
    }
    
    func loginUser() {
        guard let username = userLoginUsername else {print("no username set");return}
        guard let password = userLoginPassword else {print("no password set");return}
        PFUser.logInWithUsernameInBackground(username, password: password) { (user: PFUser?, error: NSError?) -> Void in
            if let error = error {
                print(error.description)
            } else {
                if let user = user {
                    print("user: \(user.username), logged in successfully..")
                    self.presentNextScreen()
                }
                // segue to next screen
            }
        }
    }
    
    // show if the credentials aren't fit for login
    func showLoginAlert() {
        let alertTitle = "Hey!"
        let message = "Please provide all required information!"
        let alert = UIAlertController(title: alertTitle, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "I'm a troll", style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    func presentNextScreen() {
        if let user = PFUser.currentUser() {
            if let _ = user["digitsID"] {
                performSegueWithIdentifier(toAppSegue, sender: self)
            } else {
                performSegueWithIdentifier(toDigitsSegue, sender: self)
            }
        }
        else {
            print("user is not logged in after login")
        }
    }
    
    func setUpAutoLayout() {
        self.view.addSubview(hourGlassImage)
        hourGlassImage.image = UIImage(named: "HourGlassRecall")
        hourGlassImage.contentMode = .ScaleAspectFit
        hourGlassImage.autoAlignAxisToSuperviewAxis(.Vertical)
        hourGlassImage.autoPinEdgeToSuperviewEdge(.Top, withInset: 20)
        hourGlassImage.autoSetDimensionsToSize(CGSize(width: 162, height: 300))
    }
    
    func setUpScrollView() {
        
        // logo and login/SignUp buttons
        let homeView = HomeViewController(nibName: "HomeViewController", bundle: nil)
        
        self.addChildViewController(homeView)
        self.scrollView.addSubview(homeView.view)
        homeView.didMoveToParentViewController(self)
        
        // small logo and email or username + password.. depending on signup or signup
        let signOneView = PasswordViewController(nibName: "PasswordViewController", bundle: nil)
        
        var signOneFrame = signOneView.view.frame
        signOneFrame.origin.x = self.view.frame.size.width
        signOneView.view.frame = signOneFrame
        
        self.addChildViewController(signOneView)
        self.scrollView.addSubview(signOneView.view)
        signOneView.didMoveToParentViewController(self)
        
        // small logo and username for signup
        let signTwo = UsernameViewController(nibName: "UsernameViewController", bundle: nil)
        
        var signTwoFrame = signTwo.view.frame
        signTwoFrame.origin.x = self.view.frame.size.width * 2
        signTwo.view.frame = signTwoFrame
        
        self.addChildViewController(signTwo)
        self.scrollView.addSubview(signTwo.view)
        signOneView.didMoveToParentViewController(self)
        
        self.scrollView.contentSize = CGSizeMake(self.view.frame.size.width * 3, self.view.frame.size.width)
    }

}
