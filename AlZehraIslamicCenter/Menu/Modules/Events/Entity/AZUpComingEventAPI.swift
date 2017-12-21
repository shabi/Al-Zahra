//
//  AZUpComingEventAPI.swift
//  AlZehraIslamicCenter
//
//  Created by Shabi on 29/10/17.
//  Copyright © 2017 Shabi. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

enum EventType {
    case fetchEvents
    case removeEvents
}

class AZUpComingEventAPI {
    
    weak var viewModelDelegate: APIDelegateViewModel?
    var eventId: Int?
    let eventType: EventType
    
    init(type: EventType, delegateViewModel: APIDelegateViewModel) {
        self.eventType = type
        self.viewModelDelegate = delegateViewModel
    }
    
    
    func event() -> NSNotification.Name {
        return AZUtility.notificationName(name: ApiConstants.PostNotify.upComingEvents)
    }
    
    func errorEvent() -> NSNotification.Name {
        return AZUtility.notificationName(name: ApiConstants.PostNotify.upComingEventsError)
    }
    
    func makeModel(json: JSON) -> ModelMappable? {
        return nil
    }
    
    func fetchData() {
        
        if self.eventType == .fetchEvents {
            SKServiceManager(dataSource: self, delegate: self, serviceType: ApiConstants.ServiceType.events.rawValue)
        } else if self.eventType == .removeEvents {
            SKServiceManager(dataSource: self, delegate: self, serviceType: ApiConstants.ServiceType.removeEvent.rawValue)
        }
    }
    
    fileprivate func fetchEventData() {
        SKServiceManager(dataSource: self, delegate: self, serviceType: ApiConstants.ServiceType.events.rawValue)
    }
}

extension AZUpComingEventAPI: SKServiceManagerDelegate {
    
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
            if self.eventType == .fetchEvents {
                let upComingEventModel = AZUpComingEventModel.modelsFromDictionaryArray(array: (response as? NSArray) ?? [])
                self.viewModelDelegate?.apiSuccess(serviceType: serviceType, model: upComingEventModel)
            } else if self.eventType == .removeEvents {
                self.viewModelDelegate?.apiSuccess(serviceType: serviceType, model: "200")
            }
           
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

extension AZUpComingEventAPI: SKServiceManagerDataSource {
    func requestParameters(serviceType: String) -> [String : AnyObject]? {
        print("requestParameters")
        
        var reqParameterDic: Dictionary<String, AnyObject>?
        
        if self.eventType == .fetchEvents {
            reqParameterDic = nil//[:]
        } else if self.eventType == .removeEvents {
            reqParameterDic = ["roles": ["SuperAdmin", "Admin"]  as AnyObject]
        }
        
        return reqParameterDic
        
    }
    
    func requestHeaders(serviceType: String) -> [String : String]? {
        print("requestHeaders")
        
        var requestHeaders: Dictionary<String, AnyObject>?
        
        if self.eventType == .fetchEvents {
            requestHeaders = ["Content-Type": "application/json" as AnyObject]
        } else if self.eventType == .removeEvents {
            let token = "Bearer" + " " + Keychain.loadValueFromKeychain(key: Constants.KeyChain.accessToken)!
            
            requestHeaders = ["Content-Type": "application/json" as AnyObject, "Authorization": token as AnyObject]
        }
        
        return requestHeaders as? [String : String]
    }
    
    
    // MARK: ServiceKit Datasource
    func requestUrlandHttpMethodType(serviceType: String) -> (url: String?,
        methodType: SKConstant.HTTPMethod?) {
            
            var urlAndMethodType: (url: String?, methodType: SKConstant.HTTPMethod?)
            
            if self.eventType == .fetchEvents {
                urlAndMethodType.url = "http://api.azicc.org/api/events/AllEvents"
                urlAndMethodType.methodType = .get
                
            } else if self.eventType == .removeEvents {
                urlAndMethodType.url = "http://api.azicc.org/api/events/archieveevent?Id=" +  String(self.eventId!)
                urlAndMethodType.methodType = .post
            }
            return urlAndMethodType
    }
}
