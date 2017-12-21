//
//  UserStatusViewModel.swift
//  AlZehraIslamicCenter
//
//  Created by Shabi on 18/10/17.
//  Copyright © 2017 Shabi. All rights reserved.
//

import Foundation
import SwiftyJSON


class UserStatusViewModel {

    var userStatusAPI: UserStatusAPI?
    weak var viewController: ViewController?
    var userInfo: [UserInfoModel]?
    
    
    init(viewController: ViewController) {
        self.viewController = viewController
    }
    
    func fetchUserInfo() {
        
        self.userStatusAPI = UserStatusAPI(type: .fetchUserStatus, delegateViewModel: self)
        self.userStatusAPI?.fetchData()
        AZProgressView.shared.showProgressView((self.viewController as! UIViewController).view)
        
    }
    
//    @objc func refreshData(notification: NSNotification) {
//        
//        self.userInfo = notification.userInfo?["userInfo"] as? UserInfoModel
//        DispatchQueue.main.async {
//            
//            self.viewController?.updateView()
//        }
//        
//    }
}

extension UserStatusViewModel: APIDelegateViewModel {
    
    func apiSuccess(serviceType: String, model: Any?) {
        
        if let info = model as? [UserInfoModel] {
            self.userInfo = info
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
