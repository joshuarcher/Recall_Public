//
//  SettingsViewController.swift
//  Reecall
//
//  Created by Joshua Archer on 1/11/16.
//  Copyright © 2016 Joshua Archer. All rights reserved.
//

import UIKit
import SafariServices

class SettingsViewController: UIViewController {
    
    private let cellNibName: String = "SettingsTableViewCell"
    private let cellReuseId: String = "settingsCell"

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerCellForTableView()
        // Do any additional setup after loading the view.
    }
    
    private func registerCellForTableView() {
        let nib = UINib(nibName: cellNibName, bundle: nil)
        tableView.registerNib(nib, forCellReuseIdentifier: cellReuseId)
    }

    @IBAction func dismissButtonPressed(sender: AnyObject) {
//        self.dismissViewControllerAnimated(true, completion: nil)
        self.presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Alert
    func showLogoutAlert() {
        let alertController = UIAlertController(title: "Hey now", message: "Are you sure you want to log out?", preferredStyle: .Alert)
        
        let logoutAction = UIAlertAction(title: "Log Out", style: .Destructive) { (action) -> Void in
            ParseHelper.logoutCurrentUser()
            let delegate = UIApplication.sharedApplication().delegate as! AppDelegate
            delegate.escapeToLogin()
        }
        alertController.addAction(logoutAction)
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
        alertController.addAction(cancelAction)
        
        presentViewController(alertController, animated: true, completion: nil)
    }

}

extension SettingsViewController: UITableViewDelegate {
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: false)
        var nextVC: UIViewController!

        switch indexPath.section {
        case 0:
            if indexPath.row == 0 {
                // Add contact
                nextVC = FriendsSettingsViewController(nibName: "FriendsSettingsViewController", bundle: nil)
            } else if indexPath.row == 1 {
                // Add others
            }
            break
        case 10: // taking out account section for launch
            if indexPath.row == 0 {
                // Edit (username, profile picture)
            } else if indexPath.row == 1 {
                // Change Password
            }
            break
        case 1:
            if indexPath.row == 0 {
                // Privacy Policy and terms
                nextVC = SFSafariViewController(URL: NSURL(string: "http://recall-that.com/privacy_policy.html")!)
            } else if indexPath.row == 1 {
                // Open source libraries
            }
            break
        case 2:
            if indexPath.row == 0 {
                // Logout
                showLogoutAlert()
                return
            }
            break
        default:
            break
        }
        self.presentViewController(nextVC, animated: true, completion: nil)
    }
    
    
    
}

extension SettingsViewController: UITableViewDataSource {
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // All but last section have 2
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCellWithIdentifier(cellReuseId) as? SettingsTableViewCell else {
            return UITableViewCell()
        }
        
        cell.textLabel?.font = UIFont.boldSystemFontOfSize(17)
        cell.accessoryType = .DisclosureIndicator
        
        var labelText = "Default"
        switch indexPath.section {
        case 0:
            if indexPath.row == 0 {
                labelText = "From Contacts"
            } else if indexPath.row == 1 {
                labelText = "From All Users"
            }
            break
        case 10: // taking out account section for launch
            if indexPath.row == 0 {
                labelText = "Edit"
            } else if indexPath.row == 1 {
                labelText = "Change Password"
            }
            break
        case 1:
            if indexPath.row == 0 {
                labelText = "Privacy Policy and Terms"
            } else if indexPath.row == 1 {
                labelText = "Open Source Libraries"
            }
            break
        case 2:
            if indexPath.row == 0 {
                labelText = "Logout"
                cell.textLabel?.textColor = UIColor.recallRed()
                cell.textLabel?.font = UIFont.systemFontOfSize(19)
            }
            break
        default:
            break
        }
        
        cell.textLabel?.text = labelText
        
        return cell
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 64.0
        }
        return 44.0
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "Find Friends"
        } else if section == 1 {
            return "About"
        } else if section == 2 {
            return ""
        }
        return ""
    }
    
}