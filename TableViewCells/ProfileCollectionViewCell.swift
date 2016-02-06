//
//  ProfileCollectionViewCell.swift
//  Reecall
//
//  Created by Joshua Archer on 1/9/16.
//  Copyright © 2016 Joshua Archer. All rights reserved.
//

import UIKit

class ProfileCollectionViewCell: UICollectionViewCell {

//    @IBOutlet weak var leftConstraint: NSLayoutConstraint!
//    @IBOutlet weak var rightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var leftConstraint: NSLayoutConstraint!
    @IBOutlet weak var rightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var imageView: UIImageView!
    
    var realmPhoto: PhotoProfileRealm?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
