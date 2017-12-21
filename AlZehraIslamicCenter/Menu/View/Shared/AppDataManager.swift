//
//  AppDataManager.swift
//  AlZehraIslamicCenter
//
//  Created by azicc-shabi.naqvi on 19/11/17.
//  Copyright © 2017 Shabi. All rights reserved.
//

import Foundation

class AppDataManager {
    
    static let shared = AppDataManager()
    
    //User login and profile data
    var userAccessToken: AZAuthTokenResponse?
    var userRole: String = "user"
    var userPassword: String?
    var userName: String?

    
    //Singleton class
    private init() {
    }
    
    
    func buildAppData() {
        self.userAccessToken = AZAuthTokenResponse.retrieveFromKeyChain()
    }
    
    
}
