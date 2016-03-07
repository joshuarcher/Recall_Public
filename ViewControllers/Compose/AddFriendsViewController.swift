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
    
    var realmUsers: Results<AllUsersRealm>?
    
    var digitUsers: [String]? {
        didSet {
            // query for new section
            print("digits string numbers found")
        }
    }
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        ParseHelper.addFriendsRequestForCurrentUser { (results: [PFObject]?, error: NSError?) -> Void in
//            let users = results as? [PFUser] ?? []
//            self.usersToAdd = users
//        }
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        getContactsFromRealm()
        getUsersFromRealm()
        syncFabricParseWithContacts()
        syncParseWithUsers()
    }
    
    func getContactsFromRealm() {
        self.realmContacts = RealmHelper.getContacts()
        tableView.reloadData()
    }
    
    func syncFabricParseWithContacts() {
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
    
    func getUsersFromRealm() {
        self.realmUsers = RealmHelper.getAllUsers()
        tableView.reloadData()
    }
    
    func syncParseWithUsers() {
        ParseHelper.addFriendsRequestForCurrentUser { (results: [PFObject]?, error: NSError?) -> Void in
            let users = results as? [PFUser] ?? []
//            print(users)
//            print("hey")
            
            RealmHelper.saveAllUsersFromParse(users)
            self.getUsersFromRealm()
//            print(self.realmUsers)
        }
    }
    
    

}

extension AddFriendsViewController: UITableViewDataSource {
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        if realmContacts?.count > 0 {
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
            guard let realmUsers = realmUsers else {return 0}
            return realmUsers.count
        } else if tableView.numberOfSections == 2 {
            if section == 0 {
                guard let realmContacts = realmContacts else {return 0}
                return realmContacts.count
            } else if section == 1 {
                guard let realmUsers = realmUsers else {return 0}
                return realmUsers.count
            }
        }
        return 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell: AddFriendTableViewCell = self.tableView.dequeueReusableCellWithIdentifier(addFriendReuseId) as! AddFriendTableViewCell
        
        if tableView.numberOfSections == 1 {
            if let realmUsers = realmUsers {
                cell.realmUser = realmUsers[indexPath.row]
            }
        } else if tableView.numberOfSections == 2 {
            if indexPath.section == 0 {
                if let realmContacts = realmContacts {
                    cell.realmContact = realmContacts[indexPath.row]
                }
            } else if indexPath.section == 1 {
                if let realmUsers = realmUsers {
                    cell.realmUser = realmUsers[indexPath.row]
                }
            }
        }
        
        if let user = cell.realmUser {
//            print("_____________________________")
//            print(user)
//            print(user.parseUsername)
//            print("~~~~~~~~~~~~~~~~~~~~~~~~~~~~~")
        }
        
        return cell
    }
}
