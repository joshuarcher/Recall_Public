//
//  RCCapsuleCell.swift
//  Reecall
//
//  Created by Joshua Archer on 11/19/15.
//  Copyright © 2015 Joshua Archer. All rights reserved.
//

import UIKit
import QuartzCore
import Bond

class RCCapsuleCell: UITableViewCell {
    
    private var innerView = UIView.newAutoLayoutView()
    private var innerShadowView = UIView.newAutoLayoutView()
    private var recallImageView = UIImageView.newAutoLayoutView()
    private var timeLabel = UILabel.newAutoLayoutView()
    private var recallDate: NSDate?
    private var timer: NSTimer?
    
    var photoDisposable: DisposableType?
    
    var photo: Photo? {
        didSet {
            photoDisposable?.dispose()
            if let photo = photo {
                // bind image of the post to the 'postImage' view
                photoDisposable = photo.image.bindTo(recallImageView.bnd_image)
                if let date = photo.displayDate {
                    // self.timeLabel.text = GenHelper.timeFromString(date, cell: "capsule")
                    self.recallDate = date
                    startUpdates()
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
    
    func startUpdates() {
        if let recallDate = recallDate {
            let timeHours = (NSDate().timeIntervalSinceDate(recallDate) * -1) / 3600
            if timeHours < 1 {
                if true {
                    //let selector: Selector = "updateLabel"
                    self.timer = NSTimer.scheduledTimerWithTimeInterval(0.5, target: self, selector: #selector(RCCapsuleCell.updateLabel), userInfo: nil, repeats: true)
                    let time = self.timer
                    NSRunLoop.mainRunLoop().addTimer(time!, forMode: NSRunLoopCommonModes)
                }
            } else {
                if self.timer != nil {
                    self.timer?.invalidate()
                    self.timer = nil
                }
                self.timeLabel.text = GenHelper.timeFromString(recallDate, cell: "capsule")
            }
        }
    }
    
    func updateLabel() {
        if let recallDate = recallDate {
            
            var timeInt: Double = NSDate().timeIntervalSinceDate(recallDate) * -1
            
            let hours = Int(timeInt / 3600)
            
            if hours < 1 {
                timeInt -= NSTimeInterval(hours) * 3600
                
                let minutes = Int(timeInt / 60)
                timeInt -= NSTimeInterval(minutes) * 60
                
                let seconds = Int(timeInt)
                
                let strMinutes = String(format: "%02d", minutes)
                let strSeconds = String(format: "%02d", seconds)
                
                self.timeLabel.text = "\(strMinutes):\(strSeconds)"
            }
        }
    }
    
}

extension RCCapsuleCell {
    
    func layoutViews() {
        self.backgroundColor = UIColor.clearColor()
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
        innerShadowLayer.shadowOffset = CGSizeMake(0, 1)
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
        innerView.layer.cornerRadius = 6
        innerView.clipsToBounds = true
        
        innerView.addSubview(recallImageView)
        recallImageView.autoPinEdgeToSuperviewEdge(.Left)
        recallImageView.autoPinEdgeToSuperviewEdge(.Top)
        recallImageView.autoPinEdgeToSuperviewEdge(.Right)
        recallImageView.autoPinEdgeToSuperviewEdge(.Bottom, withInset: 40)
        recallImageView.contentMode = UIViewContentMode.ScaleAspectFill
        recallImageView.clipsToBounds = true
        let blurEffect = UIBlurEffect(style: .Light)
        let blurView = UIVisualEffectView(effect: blurEffect)
        blurView.translatesAutoresizingMaskIntoConstraints = false
        blurView.frame = recallImageView.bounds
        recallImageView.insertSubview(blurView, atIndex: 0)
        blurView.autoPinEdgesToSuperviewEdges()
        let vibrancy = UIVibrancyEffect(forBlurEffect: blurEffect)
        let vibrancyView = UIVisualEffectView(effect: vibrancy)
        vibrancyView.translatesAutoresizingMaskIntoConstraints = false
        blurView.contentView.addSubview(vibrancyView)
        vibrancyView.autoPinEdgesToSuperviewEdges()
        
        self.addSubview(timeLabel)
        timeLabel.autoAlignAxisToSuperviewAxis(.Vertical)
        timeLabel.autoPinEdgeToSuperviewEdge(.Bottom, withInset: 11)
        timeLabel.textColor = UIColor.recallRed()
        timeLabel.font = UIFont.boldSystemFontOfSize(20)
        //visualEffect()
    }
    
    func visualEffect() {
        // lable
        self.timeLabel.alpha = 0.1
        let timeLayer = self.timeLabel.layer
        timeLayer.shadowOffset = CGSize(width: 2, height: 2)
        timeLayer.shadowOpacity = 0.6
        timeLayer.shadowRadius = 5
        
        let gesture: UILongPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(RCCapsuleCell.longPressed(_:)))
        gesture.minimumPressDuration = 0.09
        //visEffect.addGestureRecognizer(gesture)
    }
    
    func animateLabel() {
        UIView.animateWithDuration(3.0, animations: { () -> Void in
            self.timeLabel.alpha = 0
        })
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