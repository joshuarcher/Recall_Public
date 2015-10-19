//
//  CapsuleTableViewCell.swift
//  Reecall
//
//  Created by Joshua Archer on 10/16/15.
//  Copyright © 2015 Joshua Archer. All rights reserved.
//

import UIKit

class CapsuleTableViewCell: UITableViewCell {
    
    @IBOutlet weak var senderLabel: UILabel!
    @IBOutlet weak var recallImageView: UIImageView!
    @IBOutlet weak var timeLabel: UILabel!
    
    
    var photoDisposable: DisposableType?
    
    var photo: Photo? {
        didSet {
            photoDisposable?.dispose()
            
            if let photo = photo {
                // bind image of the post to the 'postImage' view
                photoDisposable = photo.image.bindTo(recallImageView.bnd_image)
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // blur effect
        let visEffect = UIVisualEffectView(effect: UIBlurEffect(style: .Light)) as UIVisualEffectView
        visEffect.frame = self.frame
        self.contentView.insertSubview(visEffect, atIndex: 2)
        // lable
        self.timeLabel.alpha = 0
        let timeLayer = self.timeLabel.layer
        timeLayer.shadowOffset = CGSize(width: 2, height: 2)
        timeLayer.shadowOpacity = 0.6
        timeLayer.shadowRadius = 5
        
        self.selectionStyle = UITableViewCellSelectionStyle.None
        
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
