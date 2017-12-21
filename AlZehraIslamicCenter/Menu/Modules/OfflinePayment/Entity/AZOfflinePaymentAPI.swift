//
//  AZOfflinePaymentAPI.swift
//  AlZehraIslamicCenter
//
//  Created by azicc-shabi.naqvi on 19/11/17.
//  Copyright © 2017 Shabi. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class AZOfflinePaymentAPI {
    
    weak var viewModelDelegate: APIDelegateViewModel?
    let offlinePaymentRequest: AZOfflineResponse?
    
    enum EventType {
        case offlinePayment
    }
    
    let eventType: EventType
    
    init(type: EventType, delegateViewModel: APIDelegateViewModel, offlineInfo: AZOfflineResponse) {
        self.eventType = type
        self.viewModelDelegate = delegateViewModel
        self.offlinePaymentRequest = offlineInfo
    }
    
    
    func event() -> NSNotification.Name {
        return AZUtility.notificationName(name: ApiConstants.PostNotify.offlinePayment)
    }
    
    func errorEvent() -> NSNotification.Name {
        return AZUtility.notificationName(name: ApiConstants.PostNotify.offlinePaymentError)
    }
    
    func makeModel(json: JSON) -> ModelMappable? {
        return nil
    }
    
    func fetchOfflinePayment() {
        self.fetchOfflineData()
    }
    
    fileprivate func fetchOfflineData() {
        SKServiceManager(dataSource: self, delegate: self, serviceType: ApiConstants.ServiceType.offlinePayment.rawValue)
    }
}

extension AZOfflinePaymentAPI: SKServiceManagerDelegate {
    
    func didReceiveError(serviceType: String, theError: Error?, failureResponse: Any?) -> [String : String]? {
        
        if let response = failureResponse {
            serviceResponse(response: response)
            self.viewModelDelegate?.apiFailure(serviceType: serviceType, error: theError!)
            print("failureResponse")
        } else {
            AZProgressView.shared.hideProgressView()
        }
        print("didReceiveError")
        return [:]
    }
    
    func didReceiveResponse(serviceType: String, headerResponse: HTTPURLResponse?,
                            finalResponse:Any?) {
        
        if let _ = finalResponse, headerResponse?.statusCode == 200 {
            self.viewModelDelegate?.apiSuccess(serviceType: serviceType, model: String(describing: 200))
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

extension AZOfflinePaymentAPI: SKServiceManagerDataSource {
    func requestParameters(serviceType: String) -> [String : AnyObject]? {
        print("requestParameters")
        
        let reqParameterDic = ["UserId": self.offlinePaymentRequest?.userId  as AnyObject,
                               "TransDate": self.offlinePaymentRequest?.transDate  as AnyObject,
                               "Amount": self.offlinePaymentRequest?.amount  as AnyObject,
                               "Comments": self.offlinePaymentRequest?.comments  as AnyObject,
                               "DbCr": self.offlinePaymentRequest?.dbCr  as AnyObject,
                               "Deleted": self.offlinePaymentRequest?.deleted  as AnyObject,
                               "CreatedBy": self.offlinePaymentRequest?.createdBy  as AnyObject]
        
        return reqParameterDic
        
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
            urlAndMethodType.url = "http://api.azicc.org/api/overdues/create"
            urlAndMethodType.methodType = .post
            return urlAndMethodType
    }
}
