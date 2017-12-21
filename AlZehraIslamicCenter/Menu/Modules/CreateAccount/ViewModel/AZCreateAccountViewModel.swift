//
//  AZCreateAccountViewModel.swift
//  AlZehraIslamicCenter
//
//  Created by Shabi on 29/10/17.
//  Copyright © 2017 Shabi. All rights reserved.
//

import Foundation
import SwiftyJSON

class AZCreateAccountViewModel {
    
    var createAccountAPI: AZCreateAccountAPI?
    weak var viewController: ViewController?
    var createAccountRequest: AZCreateAccountRequest?
    var createAccountResponse: AZCreateAccountResponse?
    
    init(viewController: ViewController) {
        self.viewController = viewController
    }
    
    func craeteUser() {
        self.createAccountAPI = AZCreateAccountAPI(type: .createAccount, delegateViewModel: self, newUser: createAccountRequest!)
        self.createAccountAPI?.fetchData()
        AZProgressView.shared.showProgressView((self.viewController as! UIViewController).view)
    }
}

extension AZCreateAccountViewModel: APIDelegateViewModel {
    
    func apiSuccess(serviceType: String, model: Any?) {
        
        if let info = model as? String, info == "201" {
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

