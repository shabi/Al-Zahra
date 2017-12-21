//
//  String+Extension.swift
//  AlZehraIslamicCenter
//
//  Created by Shabi on 18/10/17.
//  Copyright © 2017 Shabi. All rights reserved.
//

import Foundation
import UIKit

extension String {
    
    func heightFitsWith(font: UIFont, width: CGFloat, margin: CGFloat) -> CGFloat {
        return self.boundingRect(with:
            CGSize(width:width - margin, height: CGFloat.greatestFiniteMagnitude),
                                 options: .usesLineFragmentOrigin,
                                 attributes: [NSFontAttributeName: font], context: nil).height
    }
    
    static func getBasicAuthenticationString(appkey: String, appSecret: String) -> String {
        let authenticationString = String(format: "%@:%@", appkey, appSecret)
        let authenticationData = authenticationString.data(using: String.Encoding.utf8)!
        return authenticationData.base64EncodedString()
    }
    
    func localized(comments: String = "") -> String {
        return NSLocalizedString(self, comment: comments)
    }
    
    var htmlAttributedString: NSAttributedString? {
        do {
            return try NSAttributedString(
                data: data(using: .unicode, allowLossyConversion: true)!,
                options: [NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType, NSCharacterEncodingDocumentAttribute: String.Encoding.utf8.rawValue],
                documentAttributes: nil)
            
        } catch {
            return NSAttributedString(string: self)
        }
    }
    
    func asyncHtmlAttributedString(completionHandler : @escaping (NSAttributedString?) -> () ) {
        
        DispatchQueue.main.async {
            return completionHandler(self.htmlAttributedString)
        }
        
    }
    
    var utfHtmlAttributedString: NSAttributedString? {
        do {
            return try NSAttributedString(data: data(using: String.Encoding.utf8)!,
                                          options: [NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType],
                                          documentAttributes: nil)
        } catch {
            return NSAttributedString(string: self)
        }
    }
    
    func getHtmlString(forWebView webView: UIWebView, font: UIFont, hexColor: String) -> String {
        let htmlString = String(format: "<html><head><style type=\"text/css\">body {font-family: \"%@\"; font-size: %f; color: %@;}</style></head><body>%@</body></html>", font.fontName,
                                                                                                                                                                                       font.pointSize, hexColor, self)
        webView.scrollView.isScrollEnabled = false
        webView.scrollView.showsVerticalScrollIndicator = false
        
        return htmlString
    }
    
    
    func getDateWithFormat(format: DateFormat) -> Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = format.rawValue
        let date = formatter.date(from: self)
        return date
    }
    
    func trimFirst3Digit() -> String {
        return self.substring(to:self.index(self.startIndex, offsetBy: 3))
    }
    
    func trimLastNDigit(value: Int) -> String {
        return self.substring(from:self.index(self.endIndex, offsetBy: value))
    }
    
    mutating func addCurrentCurrencySymbol() -> String {
        
        guard let currencySymbol = Locale.current.currencySymbol else { return self }
        return currencySymbol + self
    }
    
    static func currentCurrencySymbol() -> String {
        return Locale.current.currencySymbol ?? ""
    }
    
    func checkIfFilePathHasImageExtension() -> Bool {
        if self.contains(".png") || self.contains(".jpg") || self.contains(".jpeg") {
            return true
        }
        return false
    }
    
    var isNumber : Bool {
        get{
            return !self.isEmpty && self.rangeOfCharacter(from: CharacterSet.decimalDigits.inverted) == nil
        }
    }
}

extension Float
{
    var cleanValue: String
    {
        return self.truncatingRemainder(dividingBy: 1) == 0 ? String(format: "%.0f", self) : String(self)
    }
}

//extension UILabel {
//    
//    func setHTMLAttributedStringAsync(htmlString : String, withFont font: UIFont) {
//        htmlString.asyncHtmlAttributedString { [weak self] (attrString) in
//            self?.attributedText = attrString?.withAttributes([font])
//        }
//    }
//    
//}

extension Sequence where Iterator.Element: Hashable {
    func unique() -> [Iterator.Element] {
        var seen: [Iterator.Element: Bool] = [:]
        return self.filter { seen.updateValue(true, forKey: $0) == nil }
    }
}
