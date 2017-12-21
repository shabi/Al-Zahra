//
//  AZUserDetailViewModel.swift
//  AlZehraIslamicCenter
//
//  Created by azicc-shabi.naqvi on 24/11/17.
//  Copyright © 2017 Shabi. All rights reserved.
//

import Foundation
import SwiftyJSON


class AZUserDetailViewModel {
    
    var userDetailAPI: AZUserDetailAPI?
    weak var viewController: ViewController?
    var userResponse: AZAllUserResponse?
    var paymentHistoryArray: [PaymentDetail]?
    
    
    init(viewController: ViewController) {
        self.viewController = viewController
    }
    
    func fetchUserInfo() {
        
        self.userDetailAPI = AZUserDetailAPI(type: .fetchUser, delegateViewModel: self)
        self.userDetailAPI?.fetchData()
        AZProgressView.shared.showProgressView((self.viewController as! UIViewController).view)
    }
    
    func fetchUserPaymentHistory() {
        
        self.userDetailAPI = AZUserDetailAPI(type: .fetchUserPaymentHistory, delegateViewModel: self)
        self.userDetailAPI?.fetchData()
        AZProgressView.shared.showProgressView((self.viewController as! UIViewController).view)
    }
}

extension AZUserDetailViewModel: APIDelegateViewModel {
    
    func apiSuccess(serviceType: String, model: Any?) {
        
        if serviceType == ApiConstants.ServiceType.user.rawValue {
            if let info = model as? AZAllUserResponse {
                self.userResponse = info
                DispatchQueue.main.async {
                    self.viewController?.updateView()
                }
            }
        } else if serviceType == ApiConstants.ServiceType.userPaymentHistory.rawValue {
            
            if let info = model as? [PaymentDetail] {
                self.paymentHistoryArray = info
                DispatchQueue.main.async {
                    self.viewController?.updateView()
                }
            }
            
            DispatchQueue.main.async {
                //TODO:- show list of payment history
                self.viewController?.updateView()
            }
        }
        
        AZProgressView.shared.hideProgressView()
        print("success")
    }
    
    func apiFailure(serviceType: String, error: Error) {
        print("failue")
        AZProgressView.shared.hideProgressView()
    }
    
}
