//
//  AZUtility.swift
//  AlZehraIslamicCenter
//
//  Created by Shabi on 18/10/17.
//  Copyright © 2017 Shabi. All rights reserved.
//

import Foundation
import UIKit
import Security

class AZUtility: NSObject {
    
    static let sharedDelegate = UIApplication.shared.delegate as! AppDelegate
    
    // MARK: Background Service Call Check
    
    public class func isBackgroundServiceCallRequired(hours: Int) -> Bool {
        if let date = UserDefaults.standard.object(forKey: Constants.UserDefault.lastBackgroundServiceCall) as? Date {
            if Date().hours(from: date) > hours {
                return true
            }
        } else {
            return true
        }
        return false
    }
    
    // MARK: To get current time stamp
    
    public class func getCurrentTimeStamp() -> NSNumber {
        // this will overflow a (32-bit) ‘UInt’ on a 32-bit system (i.e. iPad 2), so we need to explicitly use a UInt64
        let msecSinceEpoch = UInt64(Date().timeIntervalSince1970 * 1000)
        
        // since UInt64 can’t be cast to AnyObject, return an NSNumber so that we can seamlessly put it in an array/dictionary
        return NSNumber(value: msecSinceEpoch as UInt64)
        //        return Int(Date().timeIntervalSince1970 * 1000)
    }
    
    // MARK: To get Notification Name
    
    public class func notificationName(name: String) -> Notification.Name {
        return NSNotification.Name(rawValue: name)
    }
    
    // MARK: Validating regex, returns boolean true or false
    
    public class func checkRegex(data: String, regex: String) -> Bool {
        if let regex = try? NSRegularExpression(pattern: regex, options: []) {
            return regex.matches(in: data, options: [],
                                 range: NSRange(location: 0, length: data.characters.count)).count > 0
        }
        return false
    }
    
    // MARK: Check whether current device is iphone 5s or earlier
    
    public class func isDeviceLessThanSix() -> Bool {
        let deviceType: String = UIDevice.current.model.lowercased()
        return self.checkRegex(data: deviceType, regex: Constants.deviceLessThanSix)
    }
    
    // MARK: Check if its a iPad Device
    
    public class func isIpadDevice() -> Bool {
        let deviceType: String = UIDevice.current.model.lowercased()
        return self.checkRegex(data: deviceType, regex: Constants.iPadDeviceRgx)
    }
    
    // MARK: Check if its a New Device
    
    public class func isNewDevice() -> Bool {
        let deviceType: String = UIDevice.current.model.lowercased()
        return self.checkRegex(data: deviceType, regex: Constants.newDeviceRgx)
    }
    
    // MARK: Color from hex
    
    public class func readJson(fileName: String) -> Any? {
        do {
            if let file = Bundle.main.url(forResource: fileName, withExtension: "json") {
                let data = try Data(contentsOf: file)
                let json = try JSONSerialization.jsonObject(with: data, options: [])
                return json
            }
        } catch { print(error.localizedDescription) }
        return nil
    }
    
    
    public class func getUrlDomain(server: String?, port: String? = nil,
                                   version: String? = "", urlProtocol: String? = nil) -> String {
        var validUrlProtocol: String? = urlProtocol
        if urlProtocol == nil {
            validUrlProtocol = AZUtility.getBaseProtocol()
        }
        if port == nil {
            return "\(validUrlProtocol! )://\(server ?? "")/\(version ?? "")/"
        }
        return "\(validUrlProtocol!)://\(server ?? ""):\(port ?? "")/\(version ?? "")/"
    }
    
    fileprivate class func getBaseProtocol() -> String {
//        if case Environment.production = Configuration.appEnvironment {
//            return "https"
//        }
//        return "http"
        return ""
    }
    
    public class func getServiceType(value: String) -> ApiConstants.ServiceType {
        if let type = ApiConstants.ServiceType(rawValue: value) {
            return type
        } else {
            return .none
        }
    }
    
    
    // MARK: Email Validation
    public class func isValidEmail(text: String) -> Bool {
        // print("validate calendar: \(testStr)")
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: text)
    }
    
    // MARK: ZipCode Validation
    public class func checkZipCodeCharacters(text: String, range: NSRange, string: String) -> Bool {
        
        let currentCharacterCount = text.characters.count
        if (range.length + range.location > currentCharacterCount){
            return false
        }
        let newLength = currentCharacterCount + string.characters.count - range.length
        return newLength <= 5
    }
    
    public class func isValidZipCode(zip: String) -> Bool {
        do {
            if let file = Bundle.main.url(forResource: "USZipcodes", withExtension: "json") {
                let data = try Data(contentsOf: file)
                let json = try JSONSerialization.jsonObject(with: data, options: [])
                if let zipArray = json as? NSArray {
                    print(zipArray.count)
                    if zipArray.contains(zip) {
                        return true
                    }
                }
            }
        } catch { print(error.localizedDescription) }
        return false
    }
    
    // MARK: SSN Validation
    public class func checkSSNCharacters(textField: UITextField, range: NSRange, string: String) -> Bool {
        
        let currentCharacterCount = textField.text?.characters.count
        if (range.length + range.location > currentCharacterCount!){
            return false
        }
        let newLength = currentCharacterCount! + string.characters.count - range.length
        let char = string.cString(using: .utf8)
        let isBackSpace = strcmp(char, "\\b")
        
        if (newLength == 4 || newLength == 7) && isBackSpace != -92 {
            if let textContent = textField.text {
                textField.text = "\(textContent)-"
            }
        }
        
        return newLength <= 11
    }
    
    
    // MARK: Date of birth Validation
    public class func checkDateOfBirthCharacters(textField: UITextField, range: NSRange, string: String) -> Bool {
        
        let currentCharacterCount = textField.text?.characters.count
        if (range.length + range.location > currentCharacterCount!){
            return false
        }
        let newLength = currentCharacterCount! + string.characters.count - range.length
        let char = string.cString(using: .utf8)
        let isBackSpace = strcmp(char, "\\b")
        /// MM-dd-yyyy
        if (newLength == 3 || newLength == 6) && isBackSpace != -92 {
            if let textContent = textField.text {
                textField.text = "\(textContent)-"
            }
        }
        
        return newLength <= 10
    }
    
    // MARK: Date of birth Validation
    public class func checkAbove18years(dateOfBirth: String) -> Bool {
        
        if let dateOfBirthDate = dateOfBirth.getDateWithFormat(format: .dateOfBirthFormat) {
            let gregorian = NSCalendar(calendarIdentifier: .gregorian)
            
            if let age = gregorian?.components([.year], from: dateOfBirthDate, to: Date(), options: []) {
                if age.year! > 18 {
                    return true
                }
            }
        }
        return false
    }
    
    // MARK: CVV Validation
    public class func checkCVVCharacters(text: String, range: NSRange, string: String) -> Bool {
        
        let currentCharacterCount = text.characters.count
        if (range.length + range.location > currentCharacterCount){
            return false
        }
        let newLength = currentCharacterCount + string.characters.count - range.length
        return newLength <= 3
    }
    
    
    // MARK: Month and Year validations
    
    class func checkMonthYearRange(monthYear: String) -> Bool {
        if AZUtility.isMonthWithinRange(monthYear: monthYear) && AZUtility.isYearWithinRange(monthYear: monthYear) {
            return true
        }
        return false
    }
    class func isMonthWithinRange(monthYear: String) -> Bool {
        let splittedArray = monthYear.components(separatedBy: "/")
        if let month = Int(splittedArray.first!) {
            if 1...12 ~= month {
                return true
            }
        }
        return false
    }
    class func isYearWithinRange(monthYear: String) -> Bool {
        let splittedArray = monthYear.components(separatedBy: "/")
        if let year = Int(splittedArray.last!) {
            if 0...99 ~= year {
                return true
            }
        }
        return false
    }
    
    class func compareWithCurrentYear(monthYear: String) -> Bool {
        let splittedArray = monthYear.components(separatedBy: "/")
        let calendar = Calendar.autoupdatingCurrent
        let components = calendar.dateComponents([.month,.year], from: Date())
        let currentYear = components.year
        let currentMonth = components.month
        if let year = Int(splittedArray.last!) {
            if year >= currentYear!%100 {
                if year == currentYear!%100 {
                    if let month = Int(splittedArray.first!) {
                        if month >= currentMonth! {
                            return true
                        } else {
                            return false
                        }
                    }
                }
                return true
            }
        }
        return false
    }
    class func compareWithCurrentMonthAndYear(monthYear: String) -> Bool {
        
        if AZUtility.compareWithCurrentYear(monthYear: monthYear) {
            return true
        }
        return false
    }
    public class func validateMonthYear(monthYear: String) -> Bool {
        
        if AZUtility.checkMonthYearRange(monthYear: monthYear)
            && AZUtility.compareWithCurrentMonthAndYear(monthYear: monthYear) {
            return true
        }
        return false
    }
    
    // MARK: Get Month and Year - Checkout section
    public class func getMonth(monthYear: String) -> String {
        if self.compareWithCurrentYear(monthYear: monthYear) {
            let splittedArray = monthYear.components(separatedBy: "/")
            return splittedArray.first ?? ""
        }
        return ""
        
        
    }
    
    public class func getCurrentDayMonthYear() -> (day: Int, month: Int, year: Int) {
        let date = Date()
        let calendar = Calendar.current
        
        var currentDate: (day: Int, month: Int, year: Int)
        let year = calendar.component(.year, from: date)
        let month = calendar.component(.month, from: date)
        let day = calendar.component(.day, from: date)
        currentDate.day = day
        currentDate.month = month
        currentDate.year = year
        return currentDate
    }
    
    public class func getYear(monthYear: String) -> String {
        if self.compareWithCurrentYear(monthYear: monthYear) {
            let splittedArray = monthYear.components(separatedBy: "/")
            return splittedArray.last ?? ""
        }
        return ""
    }
    
    // MARK: CVV Validation
    public class func checkPhoneNumberCharacters(text: String, range: NSRange, string: String) -> Bool {
        
        let currentCharacterCount = text.characters.count
        if (range.length + range.location > currentCharacterCount){
            return false
        }
        let newLength = currentCharacterCount + string.characters.count - range.length
        return newLength <= 10
    }
    
    // MARK: AlertView
    
    public class func showAlert(title: String? = "", message: String?, actionTitles:String?...,
        actions:[((UIAlertAction) -> Void)?]?) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        for (index, title) in actionTitles.enumerated() {
            let action = UIAlertAction(title: title, style: .default, handler: actions?[index])
            alert.addAction(action)
        }
        sharedDelegate.window?.rootViewController?.present(alert, animated: true, completion: nil)
    }
    
    public class func displayAlertInController(controller: UIViewController?,
                                               title: String? = "", message: String?, actionTitles:String?...,
        actions:[((UIAlertAction) -> Void)?]?) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        for (index, title) in actionTitles.enumerated() {
            let action = UIAlertAction(title: title, style: .default, handler: actions?[index])
            alert.addAction(action)
        }
        controller?.present(alert, animated: true, completion: nil)
    }
    
    // MARK: Count Occurences of String
    public class func countOccurrencesOfKey(_ key: String, inArray a: [String]) -> Int {
        func leftBoundary() -> Int {
            var low = 0
            var high = a.count
            while low < high {
                let midIndex = low + (high - low)/2
                if a[midIndex] < key {
                    low = midIndex + 1
                } else {
                    high = midIndex
                }
            }
            return low
        }
        
        func rightBoundary() -> Int {
            var low = 0
            var high = a.count
            while low < high {
                let midIndex = low + (high - low)/2
                if a[midIndex] > key {
                    high = midIndex
                } else {
                    low = midIndex + 1
                }
            }
            return low
        }
        
        return rightBoundary() - leftBoundary()
    }
    
    //TODO:- Need To Handle Currency Localization Properly, Currently Hard Coded for en_US
    public class func priceFormattedString(price: Double) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = NumberFormatter.Style.currency
        formatter.locale = Locale(identifier: "en_US")
        if let formattedPrice = formatter.string(for: price) {
            return formattedPrice
        }
        return "$\(String(format: "%.2f", price))"
    }
    
    public class func random(_ range:Range<Int>) -> Int
    {
        return range.lowerBound + Int(arc4random_uniform(UInt32(range.upperBound - range.lowerBound)))
    }
    
    
    public class func changeDateFormatofDOB(dateText: String) -> String {
        if let date = dateText.getDateWithFormat(format: .dateOfBirthFormat) {
            return date.getStringWithFormat(format: .dateOfBirthServiceFormat) ?? ""
        }
        return ""
    }
}

// MARK: Keychain Storage
class Keychain {
    
    class func saveValueInKeychain(value: String, key: String) {
        KeychainWrapper.standard.set(value, forKey: key)
    }
    
    class func loadValueFromKeychain(key: String) -> String? {
        return KeychainWrapper.standard.string(forKey: key)
    }
    
    class func removeValueFromKeychain(key: String) {
        KeychainWrapper.standard.removeObject(forKey: key)
    }
}

// MARK: User Defaults Storage
class UserDefaultsWrapper {
    
    class func getObject(key: String) -> Any? {
        return UserDefaults.standard.object(forKey: key)
    }
    
    class func getInt(key: String) -> Int {
        return UserDefaults.standard.integer(forKey: key)
    }
    
    class func getBool(key: String) -> Bool {
        return UserDefaults.standard.bool(forKey: key)
    }
    
    class func getFloat(key: String) -> Float {
        return UserDefaults.standard.float(forKey: key)
    }
    
    class func getString(key: String) -> String? {
        return UserDefaults.standard.string(forKey: key)
    }
    
    // MARK: Get value with default value
    
    class func getObject(key: String, defaultValue: Any) -> Any? {
        if getObject(key: key) == nil {
            return defaultValue
        }
        return getObject(key: key) as Any
    }
    
    class func getInt(key: String, defaultValue: Int) -> Int {
        if getObject(key: key) == nil {
            return defaultValue
        }
        return getInt(key: key)
    }
    
    class func getBool(key: String, defaultValue: Bool) -> Bool {
        if getObject(key: key) == nil {
            return defaultValue
        }
        return getBool(key: key)
    }
    
    class func getFloat(key: String, defaultValue: Float) -> Float {
        if getObject(key: key) == nil {
            return defaultValue
        }
        return getFloat(key: key)
    }
    
    class func getString(key: String, defaultValue: String) -> String? {
        if getObject(key: key) == nil {
            return defaultValue
        }
        return getString(key: key)
    }
    
    
    // MARK: Set value
    
    class func setObject(key: String, value: Any?) {
        if value == nil {
            UserDefaults.standard.removeObject(forKey: key)
        } else {
            UserDefaults.standard.set(value, forKey: key)
        }
        UserDefaults.standard.synchronize()
    }
    
    class func setModel(key: String, value: Any?) {
        if value == nil {
            UserDefaults.standard.removeObject(forKey: key)
        } else {
            UserDefaults.standard.dictionary(forKey: key)
        }
        UserDefaults.standard.synchronize()
    }
    
    class func setInt(key: String, value: Int) {
        UserDefaults.standard.set(value, forKey: key)
        UserDefaults.standard.synchronize()
    }
    
    class func setBool(key: String, value: Bool) {
        UserDefaults.standard.set(value, forKey: key)
        UserDefaults.standard.synchronize()
    }
    
    class func setFloat(key: String, value: Float) {
        UserDefaults.standard.set(value, forKey: key)
        UserDefaults.standard.synchronize()
    }
    
    class func setString(key: String, value: String?) {
        if value == nil {
            UserDefaults.standard.removeObject(forKey: key)
        } else {
            UserDefaults.standard.set(value, forKey: key)
        }
        UserDefaults.standard.synchronize()
    }
    
    // MARK: Synchronize
    
    class func sync() {
        UserDefaults.standard.synchronize()
    }
}

