//
//  FindFriendsTableViewCell.swift
//  Reecall
//
//  Created by Joshua Archer on 3/19/16.
//  Copyright © 2016 Joshua Archer. All rights reserved.
//

import UIKit
import Contacts

class FindFriendsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var phoneNumberLabel: UILabel!
    
    var phoneContact: CNContact? {
        didSet {
            layoutContact()
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.selectedBackgroundView = UIView(frame: self.frame)
        self.selectedBackgroundView?.alpha = 0
    }
    
    private func layoutContact() {
        guard let phoneContact = phoneContact else {return}
        usernameLabel.text = "\(phoneContact.givenName) \(phoneContact.familyName)"
        if let phoneNumber: CNPhoneNumber = phoneContact.phoneNumbers[0].value as? CNPhoneNumber {
            phoneNumberLabel.text = phoneNumber.stringValue
        }
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
