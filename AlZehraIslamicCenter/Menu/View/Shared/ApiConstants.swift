//
//  ApiConstants.swift
//  AlZehraIslamicCenter
//
//  Created by Shabi on 18/10/17.
//  Copyright © 2017 Shabi. All rights reserved.
//

import Foundation
import UIKit

class ApiConstants: NSObject {
    
    public enum ServiceType: String {
        case none
        case userStatus
        case events
        case login
        case createAccount
        case prayerTiming
        case createEvent
        case offlinePayment
        case allUsers
        case user
        case userPaymentHistory
        case removeEvent
        
    }
    
        enum Version {
            static let one = "v1"
        }
        
        enum Results {
            static let model = "model"
            static let errorModel = "errorModel"
        }
        
        enum ApiUrls {
            static let userUrlStr = "http://azapi.baselinematters.com/api/accounts/userbyemailid/taiseer.joudeh@gmail.com"
//            static let accessToken = "https://\(Constants.LoggedInDetails.authServerURL)/auth/oauth2/token"
        }
        
        enum ServiceHeaders {
            static let contentType = "Content-Type"
            static let cartId = "cart_id"
        }
        
        enum ServiceHeaderValues {
            static let contentType = "application/json"
        }
        
        enum StatusCode {
            static let successStart = 200
            static let successEnd = 300
            static let authTokenExpired = 419
            static let contentNotModified = 304
            static let conflictError = 409
        }
        
        enum APIState: String {
            case started
            case success
            case failed
            case inqueue
        }
        
        enum FailureResponseJsonKey {
            static let statusCode = "statusCode"
            static let error = "error"
            static let message = "message"
            
        }
        
        enum PostNotify {
            static let userProfile = "postNotifUserProfile"
            static let userProfileError = "postNotifUserProfileError"
            static let productDetail = "postNotifProductDetail"
            static let userStatus = "userStatusDetail"
            static let upComingEvents = "upComingEvents"
            static let upComingEventsError = "upComingEventsError"
            static let userStatusError = "userStatusError"
            static let login = "login"
            static let loginError = "loginError"
            static let createAccount = "createAccount"
            static let createAccountError = "createAccountError"
            static let prayerTiming = "prayerTiming"
            static let prayerTimingError = "prayerTimingError"
            static let createEvents = "createEvents"
            static let createEventsError = "createEventsError"
            static let offlinePayment = "offlinePayment"
            static let offlinePaymentError = "offlinePaymentError"
            static let allUser = "allUser"
            static let allUserError = "allUserError"
            static let user = "user"
            static let userError = "userError"
            static let removeEvent = "removeEvent"
            static let removeEventError = "removeEventError"
        }
        
        enum Errors {
            static let orderNotReady = "order-not-ready"
            static let orderSubmissionFailed = "OrderSubmissionFailed"
            static let credentialFailed = "user name or password is incorrect."
            
        }
}




open class AZProgressView {
    
    var containerView = UIView()
    var progressView = UIView()
    var activityIndicator = UIActivityIndicatorView()
    
    open class var shared: AZProgressView {
        struct Static {
            static let instance: AZProgressView = AZProgressView()
        }
        return Static.instance
    }
    
    open func showProgressView(_ view: UIView) {
        containerView.frame = view.frame
        containerView.center = view.center
        containerView.backgroundColor = UIColor(hex: 0xffffff, alpha: 0.3)
        
        progressView.frame = CGRect(x: 0, y: 0, width: 80, height: 80)
        progressView.center = view.center
        progressView.backgroundColor = UIColor(hex: 0x444444, alpha: 0.7)
        progressView.clipsToBounds = true
        progressView.layer.cornerRadius = 10
        
        activityIndicator.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        activityIndicator.activityIndicatorViewStyle = .whiteLarge
        activityIndicator.center = CGPoint(x: progressView.bounds.width / 2, y: progressView.bounds.height / 2)
        
        progressView.addSubview(activityIndicator)
        containerView.addSubview(progressView)
        view.addSubview(containerView)
        
        activityIndicator.startAnimating()
    }
    
    open func hideProgressView() {
        activityIndicator.stopAnimating()
        containerView.removeFromSuperview()
    }
}

extension UIColor {
    
    convenience init(hex: UInt32, alpha: CGFloat) {
        let red = CGFloat((hex & 0xFF0000) >> 16)/256.0
        let green = CGFloat((hex & 0xFF00) >> 8)/256.0
        let blue = CGFloat(hex & 0xFF)/256.0
        
        self.init(red: red, green: green, blue: blue, alpha: alpha)
    }
}
