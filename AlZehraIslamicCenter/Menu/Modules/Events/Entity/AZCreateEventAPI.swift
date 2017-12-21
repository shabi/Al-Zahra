//
//  AZCreateEventAPI.swift
//  AlZehraIslamicCenter
//
//  Created by azicc-shabi.naqvi on 17/11/17.
//  Copyright © 2017 Shabi. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class AZCreateEventAPI {
    
    weak var viewModelDelegate: APIDelegateViewModel?
    let createEventModel: AZCreateEventModel?
    
    enum EventType {
        case createEvents
        case removeEvents
    }
    
    let eventType: EventType
    
    init(type: EventType, delegateViewModel: APIDelegateViewModel, newEvent: AZCreateEventModel) {
        self.eventType = type
        self.viewModelDelegate = delegateViewModel
        self.createEventModel = newEvent
    }
    
    
    func event() -> NSNotification.Name {
        return AZUtility.notificationName(name: ApiConstants.PostNotify.createEvents)
    }
    
    func errorEvent() -> NSNotification.Name {
        return AZUtility.notificationName(name: ApiConstants.PostNotify.createEventsError)
    }
    
    func makeModel(json: JSON) -> ModelMappable? {
        return nil
    }
    
    func fetchCreateEvent() {
        self.fetchEventData()
    }
    
    fileprivate func fetchEventData() {
        SKServiceManager(dataSource: self, delegate: self, serviceType: ApiConstants.ServiceType.createEvent.rawValue)
    }
}

extension AZCreateEventAPI: SKServiceManagerDelegate {
    
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
        
        if let response = headerResponse, response.statusCode == 200 {
            self.viewModelDelegate?.apiSuccess(serviceType: serviceType, model: "200")
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

extension AZCreateEventAPI: SKServiceManagerDataSource {
    func requestParameters(serviceType: String) -> [String : AnyObject]? {
        print("requestParameters")
        
        let reqParameterDic = ["eventName": self.createEventModel?.eventName  as AnyObject, "fromDate": self.createEventModel?.fromDate  as AnyObject,
                               "toDate": self.createEventModel?.toDate  as AnyObject, "organisedBy": self.createEventModel?.organisedBy  as AnyObject,
                               "speaker": self.createEventModel?.speaker  as AnyObject, "comments": self.createEventModel?.comments  as AnyObject,
                               "createdBy": self.createEventModel?.createdBy  as AnyObject, "isNiyaz": self.createEventModel?.isNiyaz  as AnyObject,
                               "pOC": self.createEventModel?.pOC  as AnyObject, "pOCNumber": self.createEventModel?.pOCNumber  as AnyObject,
                               "active": self.createEventModel?.active  as AnyObject, "scheduler": self.createEventModel?.scheduler  as AnyObject]
        
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
            
//            http://api.azicc.org/api/events/archieveevent?Id=1
            var urlAndMethodType: (url: String?, methodType: SKConstant.HTTPMethod?)
            urlAndMethodType.url = "http://api.azicc.org/api/events/create"
            urlAndMethodType.methodType = .post
            return urlAndMethodType
    }
}

