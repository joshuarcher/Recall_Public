//
//  DatePickerView.swift
//  Reecall
//
//  Created by Joshua Archer on 3/10/16.
//  Copyright © 2016 Joshua Archer. All rights reserved.
//

import UIKit
import PureLayout

class DatePickerView: UIPickerView {
    
    var delayLabel = UILabel.newAutoLayoutView()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        delayLabel.text = "recall in"
        delayLabel.textColor = UIColor.recallRed()
        delayLabel.font = UIFont.boldSystemFontOfSize(20)
        delayLabel.alpha = 0.8
        addSubview(delayLabel)
        delayLabel.autoPinEdgeToSuperviewEdge(.Leading, withInset: 20)
        delayLabel.autoAlignAxisToSuperviewAxis(.Horizontal)
        self.backgroundColor = UIColor.recallOffWhite()
    }
    
//    override func rowSizeForComponent(component: Int) -> CGSize {
//        return CGSize(width: 100, height: 40)
//    }
    
}
