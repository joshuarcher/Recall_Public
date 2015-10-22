//
//  AddFriendTableViewCell.swift
//  Reecall
//
//  Created by Joshua Archer on 10/22/15.
//  Copyright © 2015 Joshua Archer. All rights reserved.
//

import UIKit
import Parse

class AddFriendTableViewCell: UITableViewCell {
    
    var cellUser: PFUser! {
        didSet {
            usernameLabel.text = cellUser.username
        }
    }

    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var addFriendButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    @IBAction func addFriendButtonTapped(sender: AnyObject) {
        if let button = sender as? UIButton, cellUser = cellUser {
            if !button.selected {
                ParseHelper.addFriendsWithRelationForCurrentUser(cellUser)
                button.selected = true
                print("hey")
            }
        }
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
