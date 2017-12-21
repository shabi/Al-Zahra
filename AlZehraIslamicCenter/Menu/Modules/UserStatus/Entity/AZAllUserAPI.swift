//
//  AZAllUserAPI.swift
//  AlZehraIslamicCenter
//
//  Created by azicc-shabi.naqvi on 20/11/17.
//  Copyright © 2017 Shabi. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class AZAllUserAPI {
    
    weak var viewModelDelegate: APIDelegateViewModel?
    enum EventType {
        case fetchAllUsers
    }
    
    let eventType: EventType
    
    init(type: EventType, delegateViewModel: APIDelegateViewModel) {
        self.eventType = type
        self.viewModelDelegate = delegateViewModel
    }
    
    
    func event() -> NSNotification.Name {
        return AZUtility.notificationName(name: ApiConstants.PostNotify.allUser)
    }
    
    func errorEvent() -> NSNotification.Name {
        return AZUtility.notificationName(name: ApiConstants.PostNotify.allUserError)
    }
    
    func makeModel(json: JSON) -> ModelMappable? {
        return nil
    }
    
    func fetchData() {
        self.fetchAllUserData()
    }
    
    fileprivate func fetchAllUserData() {
        SKServiceManager(dataSource: self, delegate: self, serviceType: ApiConstants.ServiceType.allUsers.rawValue)
    }
}

extension AZAllUserAPI: SKServiceManagerDelegate {
    
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
            let upComingEventModel = AZAllUserResponse.modelsFromDictionaryArray(array: (response as? NSArray) ?? [])
            self.viewModelDelegate?.apiSuccess(serviceType: serviceType, model: upComingEventModel)
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

extension AZAllUserAPI: SKServiceManagerDataSource {
    func requestParameters(serviceType: String) -> [String : AnyObject]? {
        print("requestParameters")
        return nil //[:]
        
    }
    
    func requestHeaders(serviceType: String) -> [String : String]? {
        print("requestHeaders")
        let token = "Bearer" + " " + Keychain.loadValueFromKeychain(key: Constants.KeyChain.accessToken)!
        
        let requestHeaders = ["Content-Type": "application/json", "Authorization": token]
        return requestHeaders
    }
    
    
    // MARK: ServiceKit Datasource
    func requestUrlandHttpMethodType(serviceType: String) -> (url: String?,
        methodType: SKConstant.HTTPMethod?) {
            
            var urlAndMethodType: (url: String?, methodType: SKConstant.HTTPMethod?)
            urlAndMethodType.url = "http://api.azicc.org/api/accounts/allusers"
            urlAndMethodType.methodType = .get
            return urlAndMethodType
    }
}
