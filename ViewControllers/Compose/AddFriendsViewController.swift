//
//  AddFriendsViewController.swift
//  Reecall
//
//  Created by Joshua Archer on 10/21/15.
//  Copyright © 2015 Joshua Archer. All rights reserved.
//

import UIKit
import Parse
import RealmSwift

class AddFriendsViewController: UIViewController {
    
    private let addFriendReuseId = "addFriendCell"

    @IBOutlet weak var tableView: UITableView!
    
    var realmContacts: Results<ContactRealm>?
    
    var digitUsers: [String]? {
        didSet {
            // query for new section
            print("digits string numbers found")
        }
    }
    
    var usersInAddressBook: [PFUser]? {
        didSet {
            print("users in address:\(usersInAddressBook?.count)")
            tableView.reloadData()
            print(tableView.numberOfSections)
        }
    }
    
    
    
    var usersToAdd: [PFUser]? {
        didSet {
            tableView.reloadData()
        }
    }
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ParseHelper.addFriendsRequestForCurrentUser { (results: [PFObject]?, error: NSError?) -> Void in
            let users = results as? [PFUser] ?? []
            self.usersToAdd = users
        }
        FabricHelper.findFriends { (digitUsers) -> Void in
            if let digitUsers = digitUsers {
                ParseHelper.addressBookFriendsForCurrentUser(digitUsers, completionBlock: { (results: [PFObject]?, error: NSError?) -> Void in
                    let users = results as? [PFUser] ?? []
                    self.usersInAddressBook = users
                })
                self.digitUsers = digitUsers
            }
        }
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        getContactsFromRealm()
    }
    
    func getContactsFromRealm() {
        self.realmContacts = RealmHelper.getContacts()
        tableView.reloadData()
    }
    
    func syncFabricParseWithRealm() {
        FabricHelper.findFriends { (digitUsers) -> Void in
            if let digitUsers = digitUsers {
                ParseHelper.addressBookFriendsForCurrentUser(digitUsers, completionBlock: { (results: [PFObject]?, error: NSError?) -> Void in
                    let users = results as? [PFUser] ?? []
                    RealmHelper.saveContactsFromParse(users)
                    self.getContactsFromRealm()
                })
            }
        }
    }

}

extension AddFriendsViewController: UITableViewDataSource {
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        if realmContacts?.count > 0 {
            return 2
        }
        // commenting for trying realm
//        if usersInAddressBook?.count > 0 {
//            return 2
//        }
        return 1
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if tableView.numberOfSections == 1 {
            return "all users"
        } else if tableView.numberOfSections == 2 {
            if section == 0 {
                return "trolls in contacts"
            } else if section == 1 {
                return "all users"
            }
        }
        return "error?"
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView.numberOfSections == 1 {
            guard let usersToAdd = usersToAdd else {return 0}
            return usersToAdd.count
        } else if tableView.numberOfSections == 2 {
            if section == 0 {
                guard let realmContacts = realmContacts else {return 0}
                return realmContacts.count
                // commenting for trying realm
//                guard let usersInAddressBook = usersInAddressBook else {return 0}
//                return usersInAddressBook.count
            } else if section == 1 {
                guard let usersToAdd = usersToAdd else {return 0}
                return usersToAdd.count
            }
        }
        return 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell: AddFriendTableViewCell = self.tableView.dequeueReusableCellWithIdentifier(addFriendReuseId) as! AddFriendTableViewCell
        
        if tableView.numberOfSections == 1 {
            if let usersToAdd = usersToAdd {
                cell.cellUser = usersToAdd[indexPath.row] as PFUser
            }
        } else if tableView.numberOfSections == 2 {
            if indexPath.section == 0 {
                if let realmContacts = realmContacts {
                    cell.usernameLabel.text = realmContacts[indexPath.row].parseUsername
                }
                // commenting for trying realm
//                if let usersInAddressBook = usersInAddressBook {
//                    cell.cellUser = usersInAddressBook[indexPath.row] as PFUser
//                }
            } else if indexPath.section == 1 {
                if let usersToAdd = usersToAdd {
                    cell.cellUser = usersToAdd[indexPath.row] as PFUser
                }
            }
        }
        
        return cell
    }
}
