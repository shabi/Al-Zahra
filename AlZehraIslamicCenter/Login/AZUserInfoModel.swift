//
//  AZUserInfoModel.swift
//  AlZehraIslamicCenter
//
//  Created by Shabi on 24/09/17.
//  Copyright © 2017 Shabi. All rights reserved.
//

import Foundation

class AZUserInfoModel: NSObject {
    
    var userName:String?
    var userEmail:String?
    var userImageURL:URL?
    var isUserHasImage: Bool
    
    init(userName: String?, userEmail: String?, userImageURL: URL?, isUserHasImage: Bool = false) {
        self.userName = userName
        self.userEmail = userEmail
        self.userImageURL = userImageURL
        self.isUserHasImage = isUserHasImage
        
    }
}
