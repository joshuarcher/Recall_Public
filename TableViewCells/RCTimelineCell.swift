//
//  RCTimelineCell.swift
//  Reecall
//
//  Created by Joshua Archer on 12/5/15.
//  Copyright © 2015 Joshua Archer. All rights reserved.
//

import UIKit
import Bond

class RCTimelineCell: UITableViewCell {
    
    private var innerView = UIView.newAutoLayoutView()
    private var innerShadowView = UIView.newAutoLayoutView()
    private var recallImageView = UIImageView.newAutoLayoutView()
    private var senderLabel = UILabel.newAutoLayoutView()
    private var dateLabel = UILabel.newAutoLayoutView()
    private var savedButton = UIButton.newAutoLayoutView()
    
    var photoDisposable: DisposableType?
    var saveDisposable: DisposableType?
    
    var photo: Photo? {
        didSet {
            photoDisposable?.dispose()
            saveDisposable?.dispose()
            
            if let photo = photo {
                photoDisposable = photo.image.bindTo(recallImageView.bnd_image)
                saveDisposable = photo.saved.observe({ (value: Bool?) -> Void in
                    if let value = value {
                        self.savedButton.selected = value
                    } else {
                        self.savedButton.selected = false
                    }
                })
                if let user = photo.fromUser {
                    self.senderLabel.text = user.username
                }
                if let date = photo.displayDate {
                    self.dateLabel.text = GenHelper.timeFromString(date, cell: "timeline")
                }
            }
        }
    }
    
    var photoSaved: Bool = false {
        didSet {
            if photoSaved {
                savedButton.selected = photoSaved
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
    
    func saveButtonPressed(sender: AnyObject) {
        if let button = sender as? UIButton {
            if button == savedButton {
                if !button.selected {
                    saveToProfile()
                    if let photo = photo {
                        // save relationship to Parse and updateObject
                        photo.toggleSave()
                    }
                }
            }
        }
    }
    
    // save photo to realm
    func saveToProfile() {
        if let photo = photo, image = photo.image.value {
            let newObject = PhotoProfileRealm(photo: photo, image: image)
            newObject.saveSelf()
        }
    }

}

extension RCTimelineCell {
    
    func layoutViews() {
        self.backgroundColor = UIColor.recallOffWhite()
        let innerViewHeight: CGFloat = 282
        
        self.addSubview(innerShadowView)
        innerShadowView.autoSetDimension(.Height, toSize: innerViewHeight)
        //innerShadowView.autoPinEdgeToSuperviewEdge(.Top, withInset: 4)
        innerShadowView.autoPinEdgeToSuperviewEdge(.Bottom, withInset: 4)
        innerShadowView.autoPinEdgeToSuperviewEdge(.Left, withInset: 8)
        innerShadowView.autoPinEdgeToSuperviewEdge(.Right, withInset: 8)
        innerShadowView.backgroundColor = UIColor.whiteColor()
        let innerShadowLayer = innerShadowView.layer
        innerShadowLayer.cornerRadius = 6
        innerShadowLayer.shadowOffset = CGSizeMake(0, 1)//CGSizeMake(0, 3)
        innerShadowLayer.shadowRadius = 1
        innerShadowLayer.shadowColor = UIColor.grayColor().CGColor
        innerShadowLayer.shadowOpacity = 0.66
        innerShadowLayer.masksToBounds = false
        
        self.addSubview(innerView)
        innerView.autoSetDimension(.Height, toSize: innerViewHeight)
        //innerView.autoPinEdgeToSuperviewEdge(.Top, withInset: 4)
        innerView.autoPinEdgeToSuperviewEdge(.Bottom, withInset: 4)
        innerView.autoPinEdgeToSuperviewEdge(.Left, withInset: 8)
        innerView.autoPinEdgeToSuperviewEdge(.Right, withInset: 8)
        innerView.backgroundColor = UIColor.recallOffWhite()
        innerView.clipsToBounds = true
        let innerLayer = innerView.layer
        innerLayer.cornerRadius = 6
        
        innerView.addSubview(recallImageView)
        recallImageView.autoPinEdgeToSuperviewEdge(.Left)
        recallImageView.autoPinEdgeToSuperviewEdge(.Top)
        recallImageView.autoPinEdgeToSuperviewEdge(.Right)
        recallImageView.autoPinEdgeToSuperviewEdge(.Bottom, withInset: 40)
        recallImageView.contentMode = UIViewContentMode.ScaleAspectFill
        //recallImageView.layer.masksToBounds = true
        recallImageView.clipsToBounds = true
        
        innerView.addSubview(senderLabel)
        senderLabel.autoPinEdgeToSuperviewEdge(.Left, withInset: 8)
        senderLabel.autoPinEdgeToSuperviewEdge(.Bottom, withInset: 11)
        //senderLabel.font = senderLabel.font.fontWithSize(16)
        senderLabel.font = UIFont(name: ".SFUIText-SemiBold", size: 16)
        senderLabel.sizeToFit()
        senderLabel.textColor = UIColor.recallRed()
        
        innerView.addSubview(dateLabel)
        dateLabel.autoPinEdgeToSuperviewEdge(.Right, withInset: 8)
        dateLabel.autoPinEdgeToSuperviewEdge(.Bottom, withInset: 11)
        dateLabel.font = UIFont(name: ".SFUIText-SemiBold", size: 16)
        dateLabel.sizeToFit()
        dateLabel.textColor = UIColor.recallRed()
        
        let normalImage = UIImage(named: "JournalUnsaved")
        let selectedImage = UIImage(named: "JournalSaved")
        savedButton.setImage(normalImage, forState: .Normal)
        savedButton.setImage(selectedImage, forState: .Selected)
        savedButton.imageEdgeInsets = UIEdgeInsetsMake(2, 4, 2, 28)
        savedButton.addTarget(self, action: "saveButtonPressed:", forControlEvents: .TouchUpInside)
        innerView.addSubview(savedButton)
        savedButton.autoSetDimension(.Height, toSize: 44)
        savedButton.autoSetDimension(.Width, toSize: 60)
        savedButton.autoPinEdgeToSuperviewEdge(.Left, withInset: 0)
        savedButton.autoPinEdgeToSuperviewEdge(.Top, withInset: 0)
        
    }
    
}
