//
//  TagFriendTableViewCell.swift
//  Reecall
//
//  Created by Joshua Archer on 10/22/15.
//  Copyright © 2015 Joshua Archer. All rights reserved.
//

import UIKit
import Parse

class TagFriendTableViewCell: UITableViewCell {
    
    var cellUser: PFUser! {
        didSet{
            usernameLabel.text = cellUser.username
        }
    }
    
    @IBOutlet weak var usernameLabel: UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
