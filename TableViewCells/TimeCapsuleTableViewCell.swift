//
//  TimeCapsuleTableViewCell.swift
//  Reecall
//
//  Created by Joshua Archer on 10/18/15.
//  Copyright © 2015 Joshua Archer. All rights reserved.
//

import UIKit

class TimeCapsuleTableViewCell: UITableViewCell {

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
                if let date = photo.displayDate {
                    self.timeLabel.text = GenHelper.timeFromString(date, cell: "capsule")
                }
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
        self.timeLabel.alpha = 0.1
        let timeLayer = self.timeLabel.layer
        timeLayer.shadowOffset = CGSize(width: 2, height: 2)
        timeLayer.shadowOpacity = 0.6
        timeLayer.shadowRadius = 5
        
        let gesture: UILongPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: "longPressed:")
        gesture.minimumPressDuration = 0.09
        visEffect.addGestureRecognizer(gesture)
        // Initialization code
    }
    
    
//  return [image applyBlurWithRadius:30 tintColor:[UIColor colorWithWhite:1 alpha:0.2] saturationDeltaFactor:1.5 maskImage:nil];
//    theImageView.image = theImageView.image!.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate)
//    theImageView.tintColor = UIColor.redColor()
    
    //UIView *overlay = [[UIView alloc] initWithFrame:[originalImageView frame]];
    //
    //UIImageView *maskImageView = [[UIImageView alloc] initWithImage:myImage];
    //[maskImageView setFrame:[overlay bounds]];
    //
    //[[overlay layer] setMask:[maskImageView layer]];
    //
    //[overlay setBackgroundColor:[UIColor redColor]];
    
    func animateLabel() {
        UIView.animateWithDuration(3.0, animations: { () -> Void in
            self.timeLabel.alpha = 0
        })
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    func longPressed(sender: UIGestureRecognizer) {
        if (sender.state == UIGestureRecognizerState.Ended) {
            print("ended")
            UIView.animateWithDuration(3.0, animations: { () -> Void in
                self.timeLabel.alpha = 0
            })
        }
        else if (sender.state == UIGestureRecognizerState.Began) {
            print("started")
            self.timeLabel.alpha = 1
        }
    }

    
}

//        let cell: TimeCapsuleTableViewCell = self.tableView.cellForRowAtIndexPath(indexPath) as! TimeCapsuleTableViewCell
//        UIView.animateWithDuration(3.0, animations: { () -> Void in
//            cell.timeLabel.alpha = 1
//            cell.timeLabel.alpha = 0
//            }) { (finished: Bool) -> Void in
//        }
