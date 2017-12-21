//
//  AZCreateAccountAPI.swift
//  AlZehraIslamicCenter
//
//  Created by Shabi on 29/10/17.
//  Copyright © 2017 Shabi. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class AZCreateAccountAPI {
    
    weak var viewModelDelegate: APIDelegateViewModel?
    var newUser: AZCreateAccountRequest?
    
    enum EventType {
        case createAccount
    }
    
    let eventType: EventType
    
    init(type: EventType, delegateViewModel: APIDelegateViewModel, newUser: AZCreateAccountRequest) {
        self.eventType = type
        self.viewModelDelegate = delegateViewModel
        self.newUser = newUser
    }
    
    func event() -> NSNotification.Name {
        return AZUtility.notificationName(name: ApiConstants.PostNotify.createAccount)
    }
    
    func errorEvent() -> NSNotification.Name {
        return AZUtility.notificationName(name: ApiConstants.PostNotify.createAccountError)
    }
    
    func makeModel(json: JSON) -> ModelMappable? {
        return nil
    }
    
    func fetchData() {
        self.fetchCreateAccountData()
    }
    
    fileprivate func fetchCreateAccountData() {
        SKServiceManager(dataSource: self, delegate: self, serviceType: ApiConstants.ServiceType.createAccount.rawValue)
    }
}

extension AZCreateAccountAPI: SKServiceManagerDelegate {
    
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
        
        if let _ = finalResponse, headerResponse?.statusCode == 201 {
            self.viewModelDelegate?.apiSuccess(serviceType: serviceType, model: String(describing: 201))
            print("finalResponse")
        } else if headerResponse?.statusCode == 400 {
            AZUtility.showAlert(title: "Failed to create Account", message: "Try with different username and email id.", actionTitles: "OK", actions: nil)
            AZProgressView.shared.hideProgressView()
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

extension AZCreateAccountAPI: SKServiceManagerDataSource {
    func requestParameters(serviceType: String) -> [String : AnyObject]? {
        print("requestParameters")
        
        let reqParameter = ["email": self.newUser?.email as AnyObject,
                            "userName": self.newUser?.userName as AnyObject,
                            "firstName": self.newUser?.firstName as AnyObject,
                            "lastName": self.newUser?.lastName as AnyObject,
                            "password": self.newUser?.password as AnyObject,
                            "confirmPassword": self.newUser?.confirmPassword as AnyObject,
                            "phoneNumber": self.newUser?.phoneNumber as AnyObject,
                            "roleName": self.newUser?.roleName as AnyObject,
                            
                            "address": self.newUser?.address as AnyObject,
                            "city": self.newUser?.city as AnyObject,
                            "stateCode": self.newUser?.stateCode as AnyObject,
                            "zipCode": self.newUser?.zipCode as AnyObject,
                            "amount": self.newUser?.amount as AnyObject]
        
        return reqParameter
        
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
            urlAndMethodType.url = "http://api.azicc.org/api/accounts/create"

            urlAndMethodType.methodType = .post
            return urlAndMethodType
    }
}
