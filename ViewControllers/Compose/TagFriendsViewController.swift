//
//  TagFriendsViewController.swift
//  Reecall
//
//  Created by Joshua Archer on 10/21/15.
//  Copyright © 2015 Joshua Archer. All rights reserved.
//

import UIKit
import Parse
import RealmSwift

class TagFriendsViewController: UIViewController {
    
    private let tagFriendCellReuseId = "tagFriendCell"

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tagFriendsButton: UIButton!
    
    var realmFriends: Results<FriendRealm>?
    
    var usersToTag: [PFUser]? {
        didSet {
            // commenting for trying realm
            // tableView.reloadData()
        }
    }
    
    var taggedUsers: [PFUser]! {
        didSet {
            // commenting for trying realm
            // updateTagButton()
        }
    }
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if taggedUsers == nil {
            taggedUsers = []
        }
        
        //parseRequestFriends()
        // show button if there are tagged users
        updateTagButton()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        getFriendsFromRealm()
        parseRequestFriends()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        // if dissapearing to compose screen, pass it the friends it needs (lolz)
        if let composeController = self.navigationController?.viewControllers[1] as? RecallComposeViewController {
            composeController.taggedFriends = taggedUsers
        }
    }
    
    // MARK: - Helper Functions
    
    func getFriendsFromRealm() {
        self.realmFriends = RealmHelper.getFriends()
    }
    
    // get friends from parse, then save them in Realm, reload view (Replace with synchronizer?)
    func parseRequestFriends() {
        ParseHelper.findFriendsRequestForCurrentUser { (results: [PFObject]?, error: NSError?) -> Void in
            if let relations = results {
                let users: [PFUser] = relations.map {
                    $0.objectForKey(ParseHelper.ParseFriendTouser) as! PFUser
                }
                RealmHelper.saveFriendsFromParse(users)
                self.tableView.reloadData()
            }
        }
    }
    
    func updateTagButton() {
        guard let taggedUsers = taggedUsers else {return}
        if taggedUsers.count == 0 {
            tagFriendsButton.hidden = true
        }
        else {
            tagFriendsButton.hidden = false
        }
    }

}

// MARK: - Tableview Methods

extension TagFriendsViewController: UITableViewDataSource {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let realmFriends = realmFriends else {return 0}
        return realmFriends.count
        // commenting out to test realm
//        guard let usersToTag = usersToTag else {return 0}
//        return usersToTag.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell: TagFriendTableViewCell = self.tableView.dequeueReusableCellWithIdentifier(tagFriendCellReuseId) as! TagFriendTableViewCell
        if let realmFriends = realmFriends {
            cell.usernameLabel.text = realmFriends[indexPath.row].parseUsername
        }
        // commenting out to test realm
//        if let usersToTag = usersToTag {
//            cell.cellUser = usersToTag[indexPath.row]
//        }
        return cell
    }
}

extension TagFriendsViewController: UITableViewDelegate {
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        // commenting to test realm
//        if let usersToTag = usersToTag {
//            taggedUsers.append(usersToTag[indexPath.row])
//        }
    }
    
    func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
        // commenting to test realm
//        if let usersToTag = usersToTag {
//            taggedUsers.removeObject(usersToTag[indexPath.row])
//        }
    }
}
