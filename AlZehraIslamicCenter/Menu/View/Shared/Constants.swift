//
//  Constants.swift
//  AlZehraIslamicCenter
//
//  Created by Shabi on 18/10/17.
//  Copyright © 2017 Shabi. All rights reserved.
//

import Foundation
import UIKit

class Constants {
    
    static let coreDataModel = "ShopSamsung"
    
    static let deviceLessThanSix: String = "(ipod touch 5|iphone 4|iphone 4s|iphone 5|iphone 5c|iphone 5s | iphone se)"
    static let iPadDeviceRgx: String = "(ipad)"
    static let newDeviceRgx: String = "(iphone 6|iphone 7|iphone 8|iphone 9|iphone 10)"
    
    static let authorize = "authorize"
    
    
    enum CheckDeviceType {
        static var isDeviceLessThanSix: Bool = AZUtility.isDeviceLessThanSix()
        static var isIpadDevice: Bool = AZUtility.isIpadDevice()
        static var isNewDevice: Bool = AZUtility.isNewDevice()
    }
    
    enum LoggedInDetails {
//        static var authServerURL: String {
//            get {
//                if let authServerURL = Keychain.loadValueFromKeychain(key: Constants.KeyChain.authServerURL) {
//                    return authServerURL
//                }
//                return ""
//            }
//        }

        static var userId: String? {
            get {
                var testId: String?
                if let userId = testId /*Keychain.loadValueFromKeychain(key: Constants.KeyChain.userID)*/ {
                    return userId
                }
                return nil
            }
        }
        
    }
    
    enum Nib {
        static let shopCollectionViewCell = "SSShopCollectionViewCell"
        static let mySamsungProductsCollectionViewCell = "MySamsungProductsCollectionViewCell"
        
        
    }
    
    enum ReUseIdentifiers {
        static let shopCollectionViewCell = "shopCollectionViewCell"
        static let colorsCollectionViewCell = "colorsView"
        static let mySamsungProductsCollectionViewCell = "myProductsViewCell"
        
    }
    
    enum UserDefault {
        static let lastBackgroundServiceCall = "lastBackgroundServiceCall"
        static let hasLaunched = "hasLaunched"
        static let searchHistory = "searchHistory"
    }
    
    enum KeyChain {
        static let apiServerURL = "apiServerURL"
        static let authServerURL = "authServerURL"
        static let accessToken = "access_token"
        static let tokenType = "token_type"
        static let expiresIn = "expires_in"
        static let userName = "userName"
        static let role = "role"
        static let issued = ".issued"
        static let expires = ".expires"
        static let userId = "userId"
        static let password = "password"
        
                
    }
    
    enum DeepLink {
        static let openCategory = "opencategory"
        
    }
    
    enum FinancingDetails {
        static let checkoutFooter = "http://mweb.ecom-mobile-samsung.com/financing/eip_deferred/index.html"
        static let terms1Url = "http://d1ptcuca2no1cq.cloudfront.net/financing_content/esign.html"
        
        
    }
    
    enum Notification {
        static let search = "search"
        static let fetchshoppingcartData = "fetchshoppingcartData"
        
        
    }
    
    enum ParameterKeys {
        
        static let firstName = "firstName"
        static let lastName = "lastName"
        static let address = "address"
        
    }
    
    enum SerializationKeys {
        static let color = "color"
        
        static let financeInfo = "financeInfo"
    }
    
    enum AlertText {
        static let defaultOk = "OK"
    }
}
