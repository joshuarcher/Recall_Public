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
    
    var taggedFriends: [String]!
    
    var cellsToSelect: [NSIndexPath]!
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if taggedFriends == nil {
            taggedFriends = []
        }
        if cellsToSelect == nil {
            cellsToSelect = []
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
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        updateSelectedCells()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        // if dissapearing to compose screen, pass it the friends it needs (lolz)
        // this is going to have to change when I change around the navigation controller
        if let composeController = self.navigationController?.viewControllers[1] as? RecallComposeViewController {
            composeController.taggedFriends = taggedFriends
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
                var users: [PFUser] = []
                
                for relation in relations {
                    // to user could be nil, so check for that
                    if let friendUser = relation.objectForKey(ParseHelper.ParseFriendTouser) as? PFUser {
                        users.append(friendUser)
                    }
                }
                
                RealmHelper.saveFriendsFromParse(users)
                self.tableView.reloadData()
            }
        }
    }
    
    func updateTagButton() {
        guard let taggedFriends = taggedFriends else {return}
        if taggedFriends.count == 0 {
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
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell: TagFriendTableViewCell = self.tableView.dequeueReusableCellWithIdentifier(tagFriendCellReuseId) as! TagFriendTableViewCell
        if let realmFriends = realmFriends {
            cell.usernameLabel.text = realmFriends[indexPath.row].parseUsername
            
            if let taggedFriends = taggedFriends, objId = realmFriends[indexPath.row].parseObjectId {
                if taggedFriends.contains(objId) {
                    cellsToSelect.append(indexPath)
                }
            }
        }
        return cell
    }
    
    
}

extension TagFriendsViewController: UITableViewDelegate {
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if let realmFriends = realmFriends {
            guard let taggedObjectId = realmFriends[indexPath.row].parseObjectId else {
                print("No object Id for realmFriends in didSelectRowAtIndexPath")
                return
            }
            addToTagged(taggedObjectId)
            updateTagButton()
        }
    }
    
    func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
        if let realmFriends = realmFriends {
            guard let taggedObjectId = realmFriends[indexPath.row].parseObjectId else {
                print("No object Id for realmFriends in didDeselectRowAtIndexPath")
                return
            }
            taggedFriends.removeObject(taggedObjectId)
            updateTagButton()
        }
    }
    
    func addToTagged(objectId: String) {
        if !taggedFriends.contains(objectId) {
            taggedFriends.append(objectId)
        }
    }
    
    func updateSelectedCells() {
        
        for cell in cellsToSelect {
            tableView.selectRowAtIndexPath(cell, animated: true, scrollPosition: .None)
        }
    }
    
}
