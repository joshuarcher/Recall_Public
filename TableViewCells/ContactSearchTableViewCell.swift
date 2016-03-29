//
//  ContactSearchTableViewCell.swift
//  Reecall
//
//  Created by Joshua Archer on 3/13/16.
//  Copyright © 2016 Joshua Archer. All rights reserved.
//

import UIKit
import Contacts

class ContactSearchTableViewCell: UITableViewCell {
    
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var addFriendImage: UIImageView!
    @IBOutlet weak var phoneNumberLabel: UILabel!
    
    @IBOutlet weak var constrainCenterUsernameLabel: NSLayoutConstraint!
    
    var realmContact: RealmUser? {
        didSet {
            if let realmContact = realmContact {
                usernameLabel.text = realmContact.parseUsername
                phoneNumberLabel.text = ""
            }
        }
    }
    
    var phoneContact: CNContact? {
        didSet {
            layoutContact()
        }
    }
    
    private func layoutContact() {
        guard let phoneContact = phoneContact else {return}
        constrainCenterUsernameLabel.constant = -8
        usernameLabel.text = "\(phoneContact.givenName) \(phoneContact.familyName)"
        if let phoneNumber: CNPhoneNumber = phoneContact.phoneNumbers[0].value as? CNPhoneNumber {
            phoneNumberLabel.text = phoneNumber.stringValue
        }
        self.layoutIfNeeded()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.selectedBackgroundView = UIView(frame: self.frame)
        self.selectedBackgroundView?.alpha = 0
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
