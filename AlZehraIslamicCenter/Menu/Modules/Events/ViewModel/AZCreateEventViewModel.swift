//
//  AZCreateEventViewModel.swift
//  AlZehraIslamicCenter
//
//  Created by azicc-shabi.naqvi on 19/11/17.
//  Copyright © 2017 Shabi. All rights reserved.
//

import Foundation
import SwiftyJSON


class AZCreateEventViewModel {
    
    var createEventAPI: AZCreateEventAPI?
    weak var viewController: ViewController?
    var createEventModel: AZCreateEventModel?
    
    init(viewController: ViewController) {
        self.viewController = viewController
    }
    
    func fetchEventInfo() {
        
        self.createEventAPI = AZCreateEventAPI(type: .createEvents, delegateViewModel: self, newEvent: self.createEventModel!)
        self.createEventAPI?.fetchCreateEvent()
        AZProgressView.shared.showProgressView((self.viewController as! UIViewController).view)
    }
}

extension AZCreateEventViewModel: APIDelegateViewModel {
    
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

