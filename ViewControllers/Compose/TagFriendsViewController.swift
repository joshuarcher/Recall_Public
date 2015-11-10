//
//  TagFriendsViewController.swift
//  Reecall
//
//  Created by Joshua Archer on 10/21/15.
//  Copyright © 2015 Joshua Archer. All rights reserved.
//

import UIKit
import Parse

class TagFriendsViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tagFriendsButton: UIButton!
    
    
    var usersToTag: [PFUser]? {
        didSet {
            tableView.reloadData()
        }
    }
    
    var taggedUsers: [PFUser]! {
        didSet {
            updateTagButton()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if taggedUsers == nil {
            taggedUsers = []
        }
        
        ParseHelper.findFriendsRequestForCurrentUser { (results: [PFObject]?, error: NSError?) -> Void in
            if let relations = results {
                self.usersToTag = relations.map {
                    $0.objectForKey(ParseHelper.ParseFriendTouser) as! PFUser
                }
            }
        }
        // show button if there are tagged users
        updateTagButton()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        if let composeController = self.navigationController?.viewControllers[1] as? RecallComposeViewController {
            composeController.taggedFriends = taggedUsers
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
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

extension TagFriendsViewController: UITableViewDataSource {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let usersToTag = usersToTag else {return 0}
        return usersToTag.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell: TagFriendTableViewCell = self.tableView.dequeueReusableCellWithIdentifier("tagFriendCell") as! TagFriendTableViewCell
        if let usersToTag = usersToTag {
            cell.cellUser = usersToTag[indexPath.row]
        }
        return cell
    }
}

extension TagFriendsViewController: UITableViewDelegate {
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if let usersToTag = usersToTag {
            taggedUsers.append(usersToTag[indexPath.row])
        }
    }
    
    func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
        if let usersToTag = usersToTag {
            taggedUsers.removeObject(usersToTag[indexPath.row])
        }
    }
}
