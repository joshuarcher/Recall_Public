//
//  FriendsSettingsViewController.swift
//  Reecall
//
//  Created by Joshua Archer on 2/26/16.
//  Copyright © 2016 Joshua Archer. All rights reserved.
//

import UIKit
import Parse
import RealmSwift

class FriendsSettingsViewController: UIViewController {

    private let cellNibName: String = "FriendsSettingsTableViewCell"
    private let cellReuseId: String = "friendsSettingsCell"
    
    @IBOutlet weak var tableView: UITableView!
    
    var contactsRealm: Results<ContactRealm>?
    var usersRealm: Results<AllUsersRealm>?
    
    var digitUsers: [String]? {
        didSet {
            // query for new section
            print("digits string numbers found")
        }
    }
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerCellForTableView()
    }
    
    private func registerCellForTableView() {
        let nib = UINib(nibName: cellNibName, bundle: nil)
        tableView.registerNib(nib, forCellReuseIdentifier: cellReuseId)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        getContactsFromRealm()
        getUsersFromRealm()
        syncFabricParseWithContacts()
        syncParseWithUsers()
    }
    
    func getContactsFromRealm() {
        self.contactsRealm = RealmHelper.getContacts()
        tableView.reloadData()
    }
    
    func syncFabricParseWithContacts() {
        FabricHelper.findFriends { (digitUsers) -> Void in
            if let digitUsers = digitUsers {
                
                ParseHelper.addressBookFriendsForCurrentUser(digitUsers, completionBlock: { (results: [PFObject]?, error: NSError?) -> Void in
                    let users = results as? [PFUser] ?? []
                    RealmHelper.saveContactsFromParse(users)
                })
            }
        }
    }
    
    func getUsersFromRealm() {
        self.usersRealm = RealmHelper.getAllUsers()
        tableView.reloadData()
    }
    
    func syncParseWithUsers() {
        ParseHelper.addFriendsRequestForCurrentUser { [unowned self] (results: [PFObject]?, error: NSError?) -> Void in
            let users = results as? [PFUser] ?? []
            RealmHelper.saveAllUsersFromParse(users)
            self.getUsersFromRealm()
        }
    }

    @IBAction func dismissButtonTapped(sender: AnyObject) {
        self.presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
    }
}

extension FriendsSettingsViewController: UITableViewDataSource {
    
    // Table view shows 2 sections: Contacts and All Users
    // Contacts gets loaded after All users, therefore there may be only one section
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        if contactsRealm?.count > 0 {
            return 2
        }
        return 1
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if tableView.numberOfSections == 1 {
            return "all users"
        } else if tableView.numberOfSections == 2 {
            if section == 0 {
                return "users in contacts"
            } else if section == 1 {
                return "all users"
            }
        }
        return "error?"
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView.numberOfSections == 1 {
            guard let realmUsers = usersRealm else {return 0}
            return realmUsers.count
        } else if tableView.numberOfSections == 2 {
            if section == 0 {
                guard let realmContacts = contactsRealm else {return 0}
                return realmContacts.count
            } else if section == 1 {
                guard let realmUsers = usersRealm else {return 0}
                return realmUsers.count
            }
        }
        return 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCellWithIdentifier(cellReuseId) as? FriendsSettingsTableViewCell else {
            return UITableViewCell()
        }
        if tableView.numberOfSections == 1 {
            if let realmUsers = usersRealm {
                cell.realmUser = realmUsers[indexPath.row]
            }
        } else if tableView.numberOfSections == 2 {
            if indexPath.section == 0 {
                if let realmContacts = contactsRealm {
                    cell.realmContact = realmContacts[indexPath.row]
                }
            } else if indexPath.section == 1 {
                if let realmUsers = usersRealm {
                    cell.realmUser = realmUsers[indexPath.row]
                }
            }
        }
        return cell
    }
}
