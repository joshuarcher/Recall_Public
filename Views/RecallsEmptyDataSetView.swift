//
//  RecallsEmptyDataSetView.swift
//  Reecall
//
//  Created by Joshua Archer on 3/18/16.
//  Copyright © 2016 Joshua Archer. All rights reserved.
//

import UIKit

class RecallsEmptyDataSetView: UIView {
    
//    // Our custom view from the XIB file
//    var view: UIView!
//    
//    override init(frame: CGRect) {
//        // 1. setup any properties here
//        
//        // 2. call super.init(frame:)
//        super.init(frame: frame)
//        
//        // 3. Setup view from .xib file
//        xibSetup()
//    }
//    
//    required init?(coder aDecoder: NSCoder) {
//        // 1. setup any properties here
//        
//        // 2. call super.init(coder:)
//        super.init(coder: aDecoder)
//        
//        // 3. Setup view from .xib file
//        xibSetup()
//    }
//    
//    func xibSetup() {
//        view = loadViewFromNib()
//        
//        // use bounds not frame or it'll be offset
//        view.frame = bounds
//        
//        // Make the view stretch with containing view
//        view.autoresizingMask = [UIViewAutoresizing.FlexibleWidth, UIViewAutoresizing.FlexibleHeight]
//        
//        // Adding custom subview on top of our view (over any custom drawing > see note below)
//        addSubview(view)
//    }
//    
//    func loadViewFromNib() -> UIView {
//        let bundle = NSBundle(forClass: self.dynamicType)
//        let nib = UINib(nibName: "RecallsEmptyDataSetView", bundle: bundle)
//        
//        // Assumes UIView is top level and only object in CustomView.xib file
//        let view = nib.instantiateWithOwner(self, options: nil)[0] as! UIView
//        return view
//    }
    
//    required init(coder aDecoder: NSCoder) {
//        super.init(coder: aDecoder)
//        NSBundle.mainBundle().loadNibNamed("RecallsEmptyDataSetView", owner: self, options: nil)
//        self.addSubview(self.view);    // adding the top level view to the view hierarchy
//    }
    
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        loadViewFromNib()
//    }
//    
//    required init?(coder aDecoder: NSCoder) {
//        super.init(coder: aDecoder)
//        loadViewFromNib()
//    }
//    
//    func loadViewFromNib() {
//        let bundle = NSBundle(forClass: self.dynamicType)
//        let nib = UINib(nibName: "RecallsEmptyDataSetView", bundle: bundle)
//        let view = nib.instantiateWithOwner(self, options: nil)[0] as! UIView
//        view.frame = bounds
//        view.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
//        self.addSubview(view);
//    }

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

}
