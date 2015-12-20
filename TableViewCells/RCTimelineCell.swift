//
//  RCTimelineCell.swift
//  Reecall
//
//  Created by Joshua Archer on 12/5/15.
//  Copyright © 2015 Joshua Archer. All rights reserved.
//

import UIKit

class RCTimelineCell: UITableViewCell {
    
    private var innerView = UIView.newAutoLayoutView()
    private var innerShadowView = UIView.newAutoLayoutView()
    private var recallImageView = UIImageView.newAutoLayoutView()
    private var senderLabel = UILabel.newAutoLayoutView()
    private var dateLabel = UILabel.newAutoLayoutView()
    
    var photoDisposable: DisposableType?
    
    var photo: Photo? {
        didSet {
            photoDisposable?.dispose()
            
            if let photo = photo {
                photoDisposable = photo.image.bindTo(recallImageView.bnd_image)
                if let user = photo.fromUser {
                    self.senderLabel.text = user.username
                }
                if let date = photo.createdAt {
                    if photo.objectId == "XT1ohbnpej" {
                        self.dateLabel.text = "troll days ago"
                    } else {
                        self.dateLabel.text = GenHelper.timeFromString(date, cell: "timeline")
                    }
                }
            }
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        layoutViews()
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

extension RCTimelineCell {
    
    func layoutViews() {
        self.backgroundColor = UIColor.recallOffWhite()
        
        self.addSubview(innerShadowView)
        innerShadowView.autoPinEdgeToSuperviewEdge(.Top, withInset: 4)
        innerShadowView.autoPinEdgeToSuperviewEdge(.Bottom, withInset: 4)
        innerShadowView.autoPinEdgeToSuperviewEdge(.Left, withInset: 8)
        innerShadowView.autoPinEdgeToSuperviewEdge(.Right, withInset: 8)
        innerShadowView.backgroundColor = UIColor.whiteColor()
        let innerShadowLayer = innerShadowView.layer
        innerShadowLayer.cornerRadius = 6
        innerShadowLayer.shadowOffset = CGSizeMake(0, 3)
        innerShadowLayer.shadowRadius = 6
        innerShadowLayer.shadowColor = UIColor.grayColor().CGColor
        innerShadowLayer.shadowOpacity = 0.33
        innerShadowLayer.masksToBounds = false
        
        self.addSubview(innerView)
        innerView.autoPinEdgeToSuperviewEdge(.Top, withInset: 4)
        innerView.autoPinEdgeToSuperviewEdge(.Bottom, withInset: 4)
        innerView.autoPinEdgeToSuperviewEdge(.Left, withInset: 8)
        innerView.autoPinEdgeToSuperviewEdge(.Right, withInset: 8)
        innerView.backgroundColor = UIColor.recallOffWhite()
        innerView.clipsToBounds = true
        let innerLayer = innerView.layer
        innerLayer.cornerRadius = 6
        
        innerView.addSubview(recallImageView)
        recallImageView.autoPinEdgeToSuperviewEdge(.Left)
        recallImageView.autoPinEdgeToSuperviewEdge(.Bottom)
        recallImageView.autoPinEdgeToSuperviewEdge(.Right)
        recallImageView.autoPinEdgeToSuperviewEdge(.Top, withInset: 40)
        recallImageView.contentMode = UIViewContentMode.ScaleAspectFill
        //recallImageView.layer.masksToBounds = true
        recallImageView.clipsToBounds = true
        
        innerView.addSubview(senderLabel)
        senderLabel.autoPinEdgeToSuperviewEdge(.Left, withInset: 8)
        senderLabel.autoPinEdgeToSuperviewEdge(.Top, withInset: 11)
        //senderLabel.font = senderLabel.font.fontWithSize(16)
        senderLabel.font = UIFont(name: ".SFUIText-SemiBold", size: 16)
        senderLabel.sizeToFit()
        senderLabel.textColor = UIColor.recallRed()
        
        innerView.addSubview(dateLabel)
        dateLabel.autoPinEdgeToSuperviewEdge(.Right, withInset: 8)
        dateLabel.autoPinEdgeToSuperviewEdge(.Top, withInset: 11)
        dateLabel.font = UIFont(name: ".SFUIText-SemiBold", size: 16)
        dateLabel.sizeToFit()
        dateLabel.textColor = UIColor.recallRed()
        
    }
    
}
