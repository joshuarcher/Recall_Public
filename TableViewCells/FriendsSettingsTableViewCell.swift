//
//  FriendsSettingsTableViewCell.swift
//  Reecall
//
//  Created by Joshua Archer on 2/26/16.
//  Copyright © 2016 Joshua Archer. All rights reserved.
//

import UIKit
import Parse

class FriendsSettingsTableViewCell: UITableViewCell {

    var realmContact: ContactRealm? {
        didSet {
            if let realmContact = realmContact {
                usernameLabel.text = realmContact.parseUsername
            }
        }
    }
    
    var realmUser: AllUsersRealm? {
        didSet {
            if let realmUser = realmUser {
                usernameLabel.text = realmUser.parseUsername
            }
        }
    }
    
    var cellUser: PFUser?
    
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var addFriendButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    /*
    if let button = sender as? UIButton {
    if !button.selected {
    if let contact = realmContact {
    ParseHelper.addContactRealmFriendRelation(contact)
    } else if let user = realmUser {
    ParseHelper.addAllUserRealmFriendRelation(user)
    }
    button.selected = true
    print("hey")
    }
    }
    */
    
    @IBAction func addFriendButtonTapped(sender: AnyObject) {
        if let button = sender as? UIButton {
            if !button.selected {
                addRelation()
                button.selected = true
                print("Hey")
            }
        }
    }
    
    func addRelation() {
        if let contact = realmContact {
            ParseHelper.addContactRealmFriendRelation(contact)
        } else if let user = realmUser {
            ParseHelper.addAllUserRealmFriendRelation(user)
        }
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
