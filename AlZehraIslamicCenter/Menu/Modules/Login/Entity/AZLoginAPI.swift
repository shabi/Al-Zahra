//
//  AZLoginAPI.swift
//  AlZehraIslamicCenter
//
//  Created by Shabi on 29/10/17.
//  Copyright © 2017 Shabi. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class AZLoginAPI {
    
    weak var viewModelDelegate: APIDelegateViewModel?
    var loginRequestParameter: AZAuthTokenRequest?
    
    enum EventType {
        case login
    }
    
    let eventType: EventType
    
    init(type: EventType, delegateViewModel: APIDelegateViewModel) {
        self.eventType = type
        self.viewModelDelegate = delegateViewModel
    }
    
    func event() -> NSNotification.Name {
        return AZUtility.notificationName(name: ApiConstants.PostNotify.login)
    }
    
    func errorEvent() -> NSNotification.Name {
        return AZUtility.notificationName(name: ApiConstants.PostNotify.loginError)
    }
    
    func makeModel(json: JSON) -> ModelMappable? {
        return nil
    }
    
    func fetchData() {
        self.fetchLoginData()
    }
    
    fileprivate func fetchLoginData() {
        SKServiceManager(dataSource: self, delegate: self, serviceType: ApiConstants.ServiceType.login.rawValue)
    }
}

extension AZLoginAPI: SKServiceManagerDelegate {
    
    func didReceiveError(serviceType: String, theError: Error?, failureResponse: Any?) -> [String : String]? {
        
        if let response = failureResponse {
            serviceResponse(response: response)
            print("failureResponse")
            self.viewModelDelegate?.apiFailure(serviceType: serviceType, error: theError!)
        } 
        AZProgressView.shared.hideProgressView()
        print("didReceiveError")
        return [:]
    }
    
    func didReceiveResponse(serviceType: String, headerResponse: HTTPURLResponse?,
                            finalResponse:Any?) {
        
        if let response = finalResponse, headerResponse?.statusCode != 400 {
            
            let loginResponse = AZAuthTokenResponse.init(dictionary: response as! NSDictionary)
            
            AppDataManager.shared.userName = self.loginRequestParameter?.username
            AppDataManager.shared.userPassword = self.loginRequestParameter?.password
            self.viewModelDelegate?.apiSuccess(serviceType: serviceType, model: loginResponse)
            print("finalResponse")
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

extension AZLoginAPI: SKServiceManagerDataSource {
    func requestParameters(serviceType: String) -> [String : AnyObject]? {
        print("requestParameters")
        
        let reqParameter = ["username": self.loginRequestParameter?.username as AnyObject,
         "password": self.loginRequestParameter?.password as AnyObject,
         "grant_type": self.loginRequestParameter?.grant_type as AnyObject]
        return reqParameter
        
    }
    
    func requestHeaders(serviceType: String) -> [String : String]? {
        print("requestHeaders")
        
        let requestHeaders = ["Content-Type": "application/x-www-form-urlencoded"]
        return requestHeaders
    }
    
    // MARK: ServiceKit Datasource
    func requestUrlandHttpMethodType(serviceType: String) -> (url: String?,
        methodType: SKConstant.HTTPMethod?) {
            
            var urlAndMethodType: (url: String?, methodType: SKConstant.HTTPMethod?)
            urlAndMethodType.url = "http://api.azicc.org/oauth/token"
            urlAndMethodType.methodType = .post
            return urlAndMethodType
    }
}

