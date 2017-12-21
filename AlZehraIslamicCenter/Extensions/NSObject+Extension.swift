//
//  NSObject+Extension.swift
//  AlZehraIslamicCenter
//
//  Created by Shabi on 23/09/17.
//  Copyright © 2017 Shabi. All rights reserved.
//

import Foundation

extension NSObject {

    public class var className: String {
        return NSStringFromClass(self).components(separatedBy: ".").last ?? ""
    }

}
