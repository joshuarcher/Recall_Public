//
//  UsernameSearchTableViewCell.swift
//  Reecall
//
//  Created by Joshua Archer on 3/13/16.
//  Copyright © 2016 Joshua Archer. All rights reserved.
//

import UIKit
import Parse

class UsernameSearchTableViewCell: UITableViewCell {

    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var addFriendImage: UIImageView!
    
    var user: PFUser? {
        didSet {
            usernameLabel.text = user?.username
        }
    }
    
    var canFollow: Bool? = true {
        didSet {
            /*
            Change the state of the follow button based on whether or not
            it is possible to follow a user.
            */
            if let canFollow = canFollow {
                self.selected = !canFollow
            }
        }
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.selectedBackgroundView = UIView(frame: self.frame)
        self.selectedBackgroundView?.alpha = 0
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
//        canFollow = !selected
        // Configure the view for the selected state
    }

}
