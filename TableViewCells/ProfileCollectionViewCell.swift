//
//  ProfileCollectionViewCell.swift
//  Reecall
//
//  Created by Joshua Archer on 1/9/16.
//  Copyright © 2016 Joshua Archer. All rights reserved.
//

import UIKit
import Bond

class ProfileCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var leftConstraint: NSLayoutConstraint!
    @IBOutlet weak var rightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var imageView: UIImageView!
    
    // removed this to focus on shipping. just used convenience kit instead
    // var realmPhoto: PhotoProfileRealm?
    
    var photoDisposable: DisposableType?
    
    var photo: Photo? {
        didSet {
            photoDisposable?.dispose()
            
            if let photo = photo {
                photoDisposable = photo.image.bindTo(imageView.bnd_image)
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }


}
