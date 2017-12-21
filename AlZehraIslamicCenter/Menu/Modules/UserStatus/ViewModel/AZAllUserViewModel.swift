//
//  AZAllUserViewModel.swift
//  AlZehraIslamicCenter
//
//  Created by azicc-shabi.naqvi on 20/11/17.
//  Copyright © 2017 Shabi. All rights reserved.
//

import Foundation
import SwiftyJSON


class AZAllUserViewModel {
    
    var allUserAPI: AZAllUserAPI?
    weak var viewController: ViewController?
    var allUserResponse: [AZAllUserResponse]?
    
    
    init(viewController: ViewController) {
        self.viewController = viewController
    }
    
    func fetchEventInfo() {
        
        self.allUserAPI = AZAllUserAPI(type: .fetchAllUsers, delegateViewModel: self)
        self.allUserAPI?.fetchData()
        AZProgressView.shared.showProgressView((self.viewController as! UIViewController).view)
    }
}

extension AZAllUserViewModel: APIDelegateViewModel {
    
    func apiSuccess(serviceType: String, model: Any?) {
        
        if let info = model as? [AZAllUserResponse] {
            self.allUserResponse = info
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
