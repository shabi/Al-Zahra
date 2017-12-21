//
//  Date+Extension.swift
//  AlZehraIslamicCenter
//
//  Created by Shabi on 18/10/17.
//  Copyright © 2017 Shabi. All rights reserved.
//

import Foundation

enum DateFormat: String {
    case dateFormat = "MM/dd/yyyy"
    case monthYearFormat = "dd/yy"
    case dateTimeFormat = "yyyy-MM-dd HH:mm:ss"
    case dayMonthYearTimeFormat = "EEEE, MMMM d, yyyy"
    case timeFormat = "hh:mm a"
    case monthDayFormat = "MMM dd, yyyy"
    case dateTimeTZFormat = "yyyy-MM-dd’T’HH:mm:ss.SSS’Z’"
    case dateOfBirthFormat = "MM-dd-yyyy"
    case dateOfBirthServiceFormat = "yyyy-dd-MM"
    case dateTimeTFormat = "yyyy-MM-dd'T'HH:mm:ss"
    case monthDayYearTimeFormat = "MM-dd-yyyy HH:mm:ss"
}

extension Date {
    /// Returns the amount of years from another date
    func years(from date: Date) -> Int {
        return Calendar.current.dateComponents([.year], from: date, to: self).year ?? 0
    }
    /// Returns the amount of months from another date
    func months(from date: Date) -> Int {
        return Calendar.current.dateComponents([.month], from: date, to: self).month ?? 0
    }
    /// Returns the amount of weeks from another date
    func weeks(from date: Date) -> Int {
        return Calendar.current.dateComponents([.weekOfMonth], from: date, to: self).weekOfMonth ?? 0
    }
    /// Returns the amount of days from another date
    func days(from date: Date) -> Int {
        return Calendar.current.dateComponents([.day], from: date, to: self).day ?? 0
    }
    /// Returns the amount of hours from another date
    func hours(from date: Date) -> Int {
        return Calendar.current.dateComponents([.hour], from: date, to: self).hour ?? 0
    }
    /// Returns the amount of minutes from another date
    func minutes(from date: Date) -> Int {
        return Calendar.current.dateComponents([.minute], from: date, to: self).minute ?? 0
    }
    /// Returns the amount of seconds from another date
    func seconds(from date: Date) -> Int {
        return Calendar.current.dateComponents([.second], from: date, to: self).second ?? 0
    }
    
    func getStringWithFormat(format: DateFormat) -> String? {
        let formatter = DateFormatter()
        formatter.dateFormat = format.rawValue
        let date = formatter.string(from: self)
        return date
    }
}
