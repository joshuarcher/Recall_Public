//
//  TimelineTableViewCell.swift
//  Reecall
//
//  Created by Joshua Archer on 10/18/15.
//  Copyright © 2015 Joshua Archer. All rights reserved.
//

import UIKit

class TimelineTableViewCell: UITableViewCell {
    
    @IBOutlet weak var senderLabel: UILabel!
    @IBOutlet weak var recallImageView: UIImageView!
    
    var photoDisposable: DisposableType?
    
    var photo: Photo? {
        didSet {
            photoDisposable?.dispose()
            
            if let photo = photo {
                photoDisposable = photo.image.bindTo(recallImageView.bnd_image)
            }
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
