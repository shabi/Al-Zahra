//
//  AZUserDetailAPI.swift
//  AlZehraIslamicCenter
//
//  Created by azicc-shabi.naqvi on 24/11/17.
//  Copyright © 2017 Shabi. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class AZUserDetailAPI {
    
    weak var viewModelDelegate: APIDelegateViewModel?
    enum EventType {
        case fetchUser
        case fetchUserPaymentHistory
    }
    
    let eventType: EventType
    
    init(type: EventType, delegateViewModel: APIDelegateViewModel) {
        self.eventType = type
        self.viewModelDelegate = delegateViewModel
    }
    
    
    func event() -> NSNotification.Name {   
        return AZUtility.notificationName(name: ApiConstants.PostNotify.user)
    }
    
    func errorEvent() -> NSNotification.Name {
        return AZUtility.notificationName(name: ApiConstants.PostNotify.userError)
    }
    
    func makeModel(json: JSON) -> ModelMappable? {
//        if self.eventType == .fetchUser {
//            return ShopingCartListModel(json:json[ApiConstants.Results.result])
//        }else if self.eventType == .fetchUserPaymentHistory {
//            return ShopingCartListModel(json: json)
//        }
        return nil
    }
    
    func fetchData() {
        var serviceType: String = ""
        if self.eventType == .fetchUser {
            serviceType = ApiConstants.ServiceType.user.rawValue
        } else if self.eventType == .fetchUserPaymentHistory {
            serviceType = ApiConstants.ServiceType.userPaymentHistory.rawValue
        }
        
//        self.fetchUserData()
        SKServiceManager(dataSource: self, delegate: self, serviceType: serviceType)
    }
    
    fileprivate func fetchUserData() {
        SKServiceManager(dataSource: self, delegate: self, serviceType: ApiConstants.ServiceType.user.rawValue)
    }
}

extension AZUserDetailAPI: SKServiceManagerDelegate {
    
    func didReceiveError(serviceType: String, theError: Error?, failureResponse: Any?) -> [String : String]? {
        
        if let response = failureResponse {
            serviceResponse(response: response)
            print("failureResponse")
            self.viewModelDelegate?.apiFailure(serviceType: serviceType, error: theError!)
        } else {
            AZProgressView.shared.hideProgressView()
        }
        print("didReceiveError")
        return [:]
    }
    
    func didReceiveResponse(serviceType: String, headerResponse: HTTPURLResponse?,
                            finalResponse:Any?) {
        
        if let response = finalResponse {
            if self.eventType == .fetchUser {
                let userInfo = AZAllUserResponse.modelFromDictionary(info: response as! NSDictionary)
                self.viewModelDelegate?.apiSuccess(serviceType: serviceType, model: userInfo)
            }else if self.eventType == .fetchUserPaymentHistory {
                
                let userInfo = AZAllUserResponse.paymentHistoryArray(paymentHistoryArray: response as! [[String : Any]])
                self.viewModelDelegate?.apiSuccess(serviceType: serviceType, model: userInfo)
            }
        } else {
            if let errorMessage = (finalResponse as! NSDictionary)["error_description"] {
                AZUtility.showAlert(title: "Error", message: errorMessage as? String, actionTitles: "OK", actions: nil)
            }
            AZProgressView.shared.hideProgressView()
        }
        print("didReceiveResponse")
    }
    
    fileprivate func serviceResponse(response: Any) {
        print("serviceResponse")
        print("response")
    }
}

extension AZUserDetailAPI: SKServiceManagerDataSource {
    func requestParameters(serviceType: String) -> [String : AnyObject]? {
        print("requestParameters")
        return nil //[:]
        
    }
    
    func requestHeaders(serviceType: String) -> [String : String]? {
        print("requestHeaders")
        let requestHeaders = ["Content-Type": "application/json"]
        return requestHeaders
    }
    
    
    // MARK: ServiceKit Datasource
    func requestUrlandHttpMethodType(serviceType: String) -> (url: String?,
        methodType: SKConstant.HTTPMethod?) {
            
            var urlAndMethodType: (url: String?, methodType: SKConstant.HTTPMethod?)
            
            if self.eventType == .fetchUser {
                urlAndMethodType.url = "http://api.azicc.org/api/accounts/userbyId?userId=" + Keychain.loadValueFromKeychain(key: Constants.KeyChain.userId)!
                urlAndMethodType.methodType = .get
                
            } else if self.eventType == .fetchUserPaymentHistory {
                urlAndMethodType.url = "http://api.azicc.org/api/overdues/lastpaymentsinfo?userId=" + Keychain.loadValueFromKeychain(key: Constants.KeyChain.userId)!
                urlAndMethodType.methodType = .get
            }
            
            return urlAndMethodType
    }
}
