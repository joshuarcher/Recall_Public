//
//  GenHelper.swift
//  Reecall
//
//  Created by Joshua Archer on 10/22/15.
//  Copyright © 2015 Joshua Archer. All rights reserved.
//

import Foundation
import UIKit

class GenHelper {
    // MARK: - DatePicking
    /*
    component 0: number 1-x
    component 1: hours, days, weeks, months
    */
    
    static func getDateToSend(pickerTuple: (Int,Int)) -> NSDate {
        let numberInterval = pickerTuple.0 + 1
        var timeInterval: Double = 1/24
        switch (pickerTuple.1) {
        case 0:
            timeInterval = 1/24
            break;
        case 1:
            timeInterval = 1
            break;
        case 2:
            timeInterval = 7
            break;
        case 3:
            timeInterval = 5
            break;
        case 4:
            timeInterval = 30
            break;
        default:
            break;
        }
        
        // ex: 11 days picked -> (10, 1)
        //  -> 86400(seconds in day) * 11 * 1
        // ex: 2 weeks picked -> (1, 2)
        //  -> 86400 * 2 * 7
        let secondsToAdd = Double(86400 * Double(numberInterval) * timeInterval)
        
        return NSDate().dateByAddingTimeInterval(secondsToAdd)
    }
    
    static func timeFromString(event: NSDate, cell: String) -> String {
        var toReturn: String = ""
        let now = NSDate()
        switch (cell) {
        case "timeline":
            let hoursAgo: Int = now.hoursFrom(event)
            if hoursAgo < 72 {
                toReturn = "\(hoursAgo.description) hours ago"
            } else {
                let daysAgo: Int = now.daysFrom(event)
                toReturn = "\(daysAgo.description) days ago"
            }
            break
        case "capsule":
            let minutesUntil: Int = event.minutesFrom(now)
            if minutesUntil < 60 {
                toReturn = "\(minutesUntil.description) minutes\nand counting..."
            } else if minutesUntil < 4320 {
                let hoursUntil: Int = event.hoursFrom(now)
                toReturn = "\(hoursUntil.description) hours\nand counting..."
            } else {
                let daysUntil: Int = event.daysFrom(now)
                toReturn = "\(daysUntil.description) days\nand counting..."
            }
            break
        default:
            toReturn = "troll"
            break
        }
        return toReturn
    }
    
    static func delay(timeDelay: Double, completion: () -> Void) {
        dispatch_after(
            dispatch_time(
                DISPATCH_TIME_NOW,
                Int64(timeDelay * Double(NSEC_PER_SEC))
            ),
            dispatch_get_main_queue(), completion)
    }
    
}

// MARK: - Range array extenstion

protocol ArrayRepresentable {
    associatedtype ArrayType
    
    func toArray() -> [ArrayType]
}

extension Range : ArrayRepresentable {
    func toArray() -> [Element] {
        return [Element](self)
    }
}

// MARK: - Tap Gesture Extension for Terms & Privacy

extension UITapGestureRecognizer {
    
    // from @samwize http://stackoverflow.com/questions/1256887/create-tap-able-links-in-the-nsattributedtext-of-a-uilabel
    
    func didTapAttributedTextInLabel(label: UILabel, inRange targetRange: NSRange) -> Bool {
        // Create instances of NSLayoutManager, NSTextContainer and NSTextStorage
        let layoutManager = NSLayoutManager()
        let textContainer = NSTextContainer(size: CGSize.zero)
        let textStorage = NSTextStorage(attributedString: label.attributedText!)
        
        // Configure layoutManager and textStorage
        layoutManager.addTextContainer(textContainer)
        textStorage.addLayoutManager(layoutManager)
        
        // Configure textContainer
        textContainer.lineFragmentPadding = 0.0
        textContainer.lineBreakMode = label.lineBreakMode
        textContainer.maximumNumberOfLines = label.numberOfLines
        let labelSize = label.bounds.size
        textContainer.size = labelSize
        
        // Find the tapped character location and compare it to the specified range
        let locationOfTouchInLabel = self.locationInView(label)
        let textBoundingBox = layoutManager.usedRectForTextContainer(textContainer)
        let textContainerOffset = CGPointMake((labelSize.width - textBoundingBox.size.width) * 0.5 - textBoundingBox.origin.x,
            (labelSize.height - textBoundingBox.size.height) * 0.5 - textBoundingBox.origin.y);
        let locationOfTouchInTextContainer = CGPointMake(locationOfTouchInLabel.x - textContainerOffset.x,
            locationOfTouchInLabel.y - textContainerOffset.y);
        let indexOfCharacter = layoutManager.characterIndexForPoint(locationOfTouchInTextContainer, inTextContainer: textContainer, fractionOfDistanceBetweenInsertionPoints: nil)
        
        return NSLocationInRange(indexOfCharacter, targetRange)
    }
    
}

extension NSDate {
    func yearsFrom(date:NSDate) -> Int{
        return NSCalendar.currentCalendar().components(NSCalendarUnit.Year, fromDate: date, toDate: self, options: .MatchFirst).year
        //return NSCalendar.currentCalendar().components(NSCalendarUnit.NSYearCalendarUnit, fromDate: date, toDate: self, options: nil).year
    }
    func monthsFrom(date:NSDate) -> Int{
        return NSCalendar.currentCalendar().components(NSCalendarUnit.Month, fromDate: date, toDate: self, options: .MatchFirst).month
        //return NSCalendar.currentCalendar().components(NSCalendarUnit.NSMonthCalendarUnit, fromDate: date, toDate: self, options: nil).month
    }
    func weeksFrom(date:NSDate) -> Int{
        return NSCalendar.currentCalendar().components(NSCalendarUnit.WeekOfYear, fromDate: date, toDate: self, options: .MatchFirst).weekOfYear
        //return NSCalendar.currentCalendar().components(NSCalendarUnit.CalendarUnitWeekOfYear, fromDate: date, toDate: self, options: nil).weekOfYear
    }
    func daysFrom(date:NSDate) -> Int{
        return NSCalendar.currentCalendar().components(NSCalendarUnit.Day, fromDate: date, toDate: self, options: .MatchFirst).day
    }
    func hoursFrom(date:NSDate) -> Int{
        return NSCalendar.currentCalendar().components(NSCalendarUnit.Hour, fromDate: date, toDate: self, options: .MatchFirst).hour
    }
    func minutesFrom(date:NSDate) -> Int{
        return NSCalendar.currentCalendar().components(NSCalendarUnit.Minute, fromDate: date, toDate: self, options: .MatchFirst).minute
    }
    func secondsFrom(date:NSDate) -> Int{
        return NSCalendar.currentCalendar().components(NSCalendarUnit.Second, fromDate: date, toDate: self, options: .MatchFirst).second
    }
    func offsetFrom(date:NSDate) -> String {
        if yearsFrom(date)   > 0 { return "\(yearsFrom(date))y"   }
        if monthsFrom(date)  > 0 { return "\(monthsFrom(date))M"  }
        if weeksFrom(date)   > 0 { return "\(weeksFrom(date))w"   }
        if daysFrom(date)    > 0 { return "\(daysFrom(date))d"    }
        if hoursFrom(date)   > 0 { return "\(hoursFrom(date))h"   }
        if minutesFrom(date) > 0 { return "\(minutesFrom(date))m" }
        if secondsFrom(date) > 0 { return "\(secondsFrom(date))s" }
        return ""
    }
}

extension NSDate {
    func isGreaterThanDate(dateToCompare: NSDate) -> Bool {
        //Declare Variables
        var isGreater = false
        
        //Compare Values
        if self.compare(dateToCompare) == NSComparisonResult.OrderedDescending {
            isGreater = true
        }
        
        //Return Result
        return isGreater
    }
    
    func isLessThanDate(dateToCompare: NSDate) -> Bool {
        //Declare Variables
        var isLess = false
        
        //Compare Values
        if self.compare(dateToCompare) == NSComparisonResult.OrderedAscending {
            isLess = true
        }
        
        //Return Result
        return isLess
    }
    
    func equalToDate(dateToCompare: NSDate) -> Bool {
        //Declare Variables
        var isEqualTo = false
        
        //Compare Values
        if self.compare(dateToCompare) == NSComparisonResult.OrderedSame {
            isEqualTo = true
        }
        
        //Return Result
        return isEqualTo
    }
    
    func addDays(daysToAdd: Int) -> NSDate {
        let secondsInDays: NSTimeInterval = Double(daysToAdd) * 60 * 60 * 24
        let dateWithDaysAdded: NSDate = self.dateByAddingTimeInterval(secondsInDays)
        
        //Return Result
        return dateWithDaysAdded
    }
    
    func addHours(hoursToAdd: Int) -> NSDate {
        let secondsInHours: NSTimeInterval = Double(hoursToAdd) * 60 * 60
        let dateWithHoursAdded: NSDate = self.dateByAddingTimeInterval(secondsInHours)
        
        //Return Result
        return dateWithHoursAdded
    }
}

// MARK: - Colors

extension UIColor {
    static func recallRed() -> UIColor {
        return UIColor(red: 0.918, green: 0.345, blue: 0.345, alpha: 1)
    }
    static func recallOffWhite() -> UIColor {
        return UIColor(red: 0.973, green: 0.973, blue: 0.973, alpha: 1)
    }
    static func recallRedLight() -> UIColor {
        return UIColor(red:1.00, green:0.68, blue:0.68, alpha:1.0)
    }
    static func recallOffGray() -> UIColor {
        return UIColor(red:0.408, green:0.455, blue:0.463, alpha:1.0)
    }
}
//[UIColor colorWithRed:0.408 green:0.455 blue:0.463 alpha:1] /*#687476*/

extension String {
    func containsSpaces() -> Bool {
        // returns range in which string has spaces
        let range = self.rangeOfCharacterFromSet(NSCharacterSet.whitespaceCharacterSet())
        
        // if range is nil, no whitespace
        if let _ = range {
            return true
        } else {
            return false
        }
        
    }
}
// MARK: - Device Properties

struct Device {
    struct Screen {
        static let width = UIScreen.mainScreen().bounds.size.width
        static let height = UIScreen.mainScreen().bounds.size.height
    }
    
    enum Kind { case iPhone4, iPhone5, iPhone6, iPhone6P, iPad }
    
    static var type: Kind {
        if UIDevice.currentDevice().userInterfaceIdiom == .Phone {
            switch max(Screen.width, Screen.height) {
            case 568:
                return .iPhone5
            case 667:
                return .iPhone6
            case 736.0:
                return .iPhone6P
            default:
                return .iPhone4
            }
        } else {
            return .iPad
        }
    }
}