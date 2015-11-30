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

// MARK: - Colors

extension UIColor {
    static func recallRed() -> UIColor {
        return UIColor(red: 0.918, green: 0.345, blue: 0.345, alpha: 1)
    }
    static func recallOffWhite() -> UIColor {
        return UIColor(red: 0.973, green: 0.973, blue: 0.973, alpha: 1)
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