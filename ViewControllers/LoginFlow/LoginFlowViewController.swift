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
    
    enum Alert {
        static let passwordLength = "Your password must be at least 6 letters long, please try again :)"
        static let usernameLength = "Your username must be at least 3 letters long and contain no spaces, please try again :)"
        static let usernameExists = "This username already exists, please choose a new one and try again :)"
        static let credentialsLoginFull = "Not all Login credentials were filled in, please try again :)"
        static let credentialsSignupFull = "Not all Sign Up credentials were filled in, please try again :)"
        static let loginFail = "Whoops\nincorrect username and password combination, please try again :)"
        static let emailCorrect = "Whoops\ninvalid email address, please try again!"
    }
    
    enum ErrorType {
        static let password = "passwordLength"
        static let username: String = "usernameLength"
        static let credentialLogin = "credentialsLoginFull"
        static let credentialSignup = "credentialsSignupFull"
        static let email = "emailCorrect"
    }
    
    // Notification
    enum Notifications {
        static let alertNotifaction = "alertNotification"
    }
    
    // segues
    private let toAppSegue = "loginFlowToApp"
    private let toDigitsSegue = "loginFlowToDigits"
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    private var hourGlassImage: UIImageView?
    //= UIImageView.newAutoLayoutView()
    
    private var activitySpinner: UIActivityIndicatorView?
    
    var userSignUpEmail: String?
    var userSignUpPassword: String?
    var userSignUpUsername: String?
    
    var userLoginUsername: String?
    var userLoginPassword: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpScrollView()
        setUpHourGlass()
        
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        let defaultCenter = NSNotificationCenter.defaultCenter()
        defaultCenter.addObserver(self, selector: #selector(LoginFlowViewController.receiveAlertNotifcation(_:)), name: Notifications.alertNotifaction, object: nil)
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        let defaultCenter = NSNotificationCenter.defaultCenter()
        defaultCenter.removeObserver(self)
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    // Home -> Password
    func animateHourGlass() {
        guard let hourGlassImage = hourGlassImage else {return}
        UIView.animateWithDuration(0.5) { () -> Void in
            var frame = hourGlassImage.frame
            frame.size.width *= 0.5
            frame.size.height *= 0.5
            let diffX = frame.size.width - hourGlassImage.frame.size.width
            frame.origin.x -= diffX/2
            hourGlassImage.frame = frame
            self.scrollView.contentOffset = CGPoint(x: self.view.frame.size.width, y: 0)
        }
    }
    
    func backwardsAnimateHourGlass() {
        guard let hourGlassImage = hourGlassImage else {return}
        UIView.animateWithDuration(0.5) { () -> Void in
            var frame = hourGlassImage.frame
            frame.size.width *= 2
            frame.size.height *= 2
            let diffX = frame.size.width - hourGlassImage.frame.size.width
            frame.origin.x -= diffX/2
            hourGlassImage.frame = frame
            self.scrollView.contentOffset = CGPoint(x: 0, y: 0)
        }
    }
    
    // Password -> Username
    func scrollToUsername() {
        UIView.animateWithDuration(0.5) { () -> Void in
            self.scrollView.contentOffset = CGPoint(x: self.view.frame.size.width * 2, y: 0)
        }
    }
    
    func backwardsScrollToUsername() {
        UIView.animateWithDuration(0.5) { () -> Void in
            self.scrollView.contentOffset = CGPoint(x: self.view.frame.size.width, y: 0)
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
                let errorMessage = error.localizedDescription
                self.showAlert(withMessage: errorMessage)
            } else {
                // present next screen
                if success {
                    print("successfully signed up user")
                    self.presentNextScreen()
                }
            }
        })
    }
    
    func loginUser() {
        guard let username = userLoginUsername else {print("no username set");return}
        guard let password = userLoginPassword else {print("no password set");return}
        // start spinner
        self.startActivity()
        PFUser.logInWithUsernameInBackground(username, password: password) { (user: PFUser?, error: NSError?) -> Void in
            // end spinner
            self.stopActivity()
            if let error = error {
                NSLog("Error logging in: %@", error)
                let errorCode = error.code
                if errorCode == 101 {
                    self.showAlert(withMessage: Alert.loginFail)
                } else {
                    let errorMessage = error.localizedDescription
                    self.showAlert(withMessage: errorMessage)
                }
            } else {
                if let user = user {
                    print("user: \(user.username), logged in successfully..")
                    self.presentNextScreen()
                }
                // segue to next screen
            }
        }
    }
    
    
    // MARK: - Alerts
    // show if the credentials aren't fit for login
    func showLoginAlert() {
        let alertTitle = "Hey!"
        let message = "Please provide all required information!"
        let alert = UIAlertController(title: alertTitle, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "I'm a troll", style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    func showAlert(withMessage message: String) {
        let alertTitle = "Hey!"
        let alert = UIAlertController(title: alertTitle, message: message, preferredStyle: .Alert)
        let action = UIAlertAction(title: "Got it!", style: .Default, handler: nil)
        alert.addAction(action)
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    func receiveAlertNotifcation(notification: NSNotification) {
        guard let errorType = notification.userInfo!["errorType"] as? String else {return}
        print(errorType)
        var message = "unknown error occured"
        
        // Set message based on error type
        if errorType == ErrorType.username {
            message = Alert.usernameLength
        } else if errorType == ErrorType.password {
            message = Alert.passwordLength
        } else if errorType == ErrorType.email {
            message = Alert.emailCorrect
        }
        
        showAlert(withMessage: message)
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
    
    // MARK: - Activity Methods
    
    func startActivity() {
        if activitySpinner == nil {
            activitySpinner = UIActivityIndicatorView(activityIndicatorStyle: .WhiteLarge)
        }
        guard let spinner = activitySpinner else {return}
        spinner.color = UIColor.recallRed()
        spinner.center = CGPoint(x: self.view.frame.width/2, y: self.view.frame.height/2)
        spinner.hidesWhenStopped = true
        self.view.addSubview(spinner)
        self.view.bringSubviewToFront(spinner)
        spinner.startAnimating()
        
    }
    
    func stopActivity() {
        if let spinner = activitySpinner {
            spinner.stopAnimating()
        }
    }
    
    // MARK: - Setup Methods
    
    func setUpHourGlass() {
        if hourGlassImage == nil {
            let image = UIImage(named: "HourGlassRecall")
            hourGlassImage = UIImageView(image: image)
        }
        guard let hourGlass = hourGlassImage else {return}
        hourGlass.contentMode = .ScaleAspectFit
        let hourGlassX = self.view.frame.width/2 - 81
        let hourGlassFrame = CGRect(x: hourGlassX, y: 20, width: 162, height: 300)
        hourGlass.frame = hourGlassFrame
        self.view.addSubview(hourGlass)
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
