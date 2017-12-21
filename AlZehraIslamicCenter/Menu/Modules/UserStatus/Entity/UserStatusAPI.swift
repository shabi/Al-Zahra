//
//  UserStatusAPI.swift
//  AlZehraIslamicCenter
//
//  Created by Shabi on 18/10/17.
//  Copyright © 2017 Shabi. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class UserStatusAPI {
    
    weak var viewModelDelegate: APIDelegateViewModel?
    enum EventType {
        case fetchUserStatus
    }
    
    let eventType: EventType
    
    init(type: EventType, delegateViewModel: APIDelegateViewModel) {
        self.eventType = type
        self.viewModelDelegate = delegateViewModel
    }
    
    
    func event() -> NSNotification.Name {
        return AZUtility.notificationName(name: ApiConstants.PostNotify.userStatus)
    }
    
    func errorEvent() -> NSNotification.Name {
        return AZUtility.notificationName(name: ApiConstants.PostNotify.userStatusError)
    }
    
    func makeModel(json: JSON) -> ModelMappable? {
        return nil
    }
    
    func fetchData() {
        self.fetchUserData()
    }
    
    fileprivate func fetchUserData() {
        SKServiceManager(dataSource: self, delegate: self, serviceType: ApiConstants.ServiceType.userStatus.rawValue)
    }
}

extension UserStatusAPI: SKServiceManagerDelegate {
    
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
            let userModel = UserInfoModel.modelsFromDictionaryArray(array: (response as? NSArray) ?? [])
            self.viewModelDelegate?.apiSuccess(serviceType: serviceType, model: userModel)
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

extension UserStatusAPI: SKServiceManagerDataSource {
    func requestParameters(serviceType: String) -> [String : AnyObject]? {
        print("requestParameters")
//        return ["userbyemailid": "taiseer.joudeh@gmail.com" as AnyObject]
        return nil //[:]
        
    }

    func requestHeaders(serviceType: String) -> [String : String]? {
        print("requestHeaders")
        
        
        return ["Content-Type": "application/json", "Connection": "keep-alive"]
    }

    
    // MARK: ServiceKit Datasource
    func requestUrlandHttpMethodType(serviceType: String) -> (url: String?,
        methodType: SKConstant.HTTPMethod?) {
            
            let currentDate = AZUtility.getCurrentDayMonthYear()
            var urlAndMethodType: (url: String?, methodType: SKConstant.HTTPMethod?)            
            urlAndMethodType.url = "http://praytime.info/getprayertimes.php?lat=35.2263714&lon=-80.79901849999999&gmt=-300&d=\(currentDate.day)&m=\(currentDate.month)&y=\(currentDate.year)&school=0"

            urlAndMethodType.methodType = .post
//            urlAndMethodType.url = "http://azapi.baselinematters.com/api/accounts/userbyemailid/taiseer.joudeh@gmail.com"
            return urlAndMethodType
    }
}
