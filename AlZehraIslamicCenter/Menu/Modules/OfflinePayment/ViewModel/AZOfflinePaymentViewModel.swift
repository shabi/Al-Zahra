//
//  AZOfflinePaymentViewModel.swift
//  AlZehraIslamicCenter
//
//  Created by azicc-shabi.naqvi on 19/11/17.
//  Copyright © 2017 Shabi. All rights reserved.
//

import Foundation
import SwiftyJSON


class AZOfflinePaymentViewModel {
    
    var offlinePaymentAPI: AZOfflinePaymentAPI?
    weak var viewController: ViewController?
    var offlineResponse: AZOfflineResponse?
    
    
    
    init(viewController: ViewController) {
        self.viewController = viewController
    }
    
    func payOffline() {
        
        self.offlinePaymentAPI = AZOfflinePaymentAPI(type: .offlinePayment, delegateViewModel: self, offlineInfo: offlineResponse!)
        self.offlinePaymentAPI?.fetchOfflinePayment()
        AZProgressView.shared.showProgressView((self.viewController as! UIViewController).view)
    }
}

extension AZOfflinePaymentViewModel: APIDelegateViewModel {
    
    func apiSuccess(serviceType: String, model: Any?) {
        
        if let info = model as? String, info == "200" {
            DispatchQueue.main.async {
                
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

