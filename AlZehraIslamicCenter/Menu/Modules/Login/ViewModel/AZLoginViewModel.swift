//
//  AZLoginViewModel.swift
//  AlZehraIslamicCenter
//
//  Created by Shabi on 29/10/17.
//  Copyright © 2017 Shabi. All rights reserved.
//

import Foundation
import SwiftyJSON


class AZLoginViewModel {
    
    var loginAPI: AZLoginAPI?
    weak var viewController: ViewController?
    var loginResponse: AZAuthTokenResponse?
    var errResponse: String?
    
    init(viewController: ViewController, requestDic: [String: String]) {
        self.viewController = viewController
        self.errResponse = nil
        self.loginAPI = AZLoginAPI(type: .login, delegateViewModel: self)
        self.loginAPI?.loginRequestParameter = AZAuthTokenRequest(dictionary: requestDic as NSDictionary)
    }
    
    func fetchUserInfo() {
        self.loginAPI?.fetchData()
        AZProgressView.shared.showProgressView((self.viewController as! UIViewController).view)
    }
    
}

extension AZLoginViewModel: APIDelegateViewModel {
    
    func apiSuccess(serviceType: String, model: Any?) {
        
        if let info = model as? AZAuthTokenResponse {
            self.loginResponse = info
            info.saveInKeyChain()
            DispatchQueue.main.async {                
                self.errResponse = nil
                self.viewController?.updateView()
            }
        }
        self.viewController?.updateView()
        print("success")
        AZProgressView.shared.hideProgressView()
    }
    
    func apiFailure(serviceType: String, error: Error) {
        if ApiConstants.Errors.credentialFailed == error.localizedDescription {
            self.errResponse = ApiConstants.Errors.credentialFailed
            self.viewController?.updateView()
        }
        print("failue")
        AZProgressView.shared.hideProgressView()
    }
    
}
