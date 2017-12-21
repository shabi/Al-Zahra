//
//  SKUtility.swift
//  AlZehraIslamicCenter
//
//  Created by Shabi on 18/10/17.
//  Copyright © 2017 Shabi. All rights reserved.
//

import Foundation

class Utility {
    
    class func isNilOrEmpty(string: NSString?) -> Bool {
        switch string {
        case .some(let nonNilString): return nonNilString.length == 0
        default:                      return true
        }
    }
    
    class func isEmptyLists(dict: [String: [String]]) -> Bool {
        for list in dict.values {
            if !list.isEmpty { return false }
        }
        return true
    }
    
    class func createErrorInstance(title:String? , message: String? , errorCode: Int) -> Error {
        let userInfo: [AnyHashable: Any] = [
            NSLocalizedDescriptionKey:  NSLocalizedString(title!, value: message!, comment: ""),
            NSLocalizedFailureReasonErrorKey: NSLocalizedString(title!, value: message!, comment: "")
        ]
        return NSError(domain: "ServiceManagerHttpResponseErrorDomain", code: errorCode, userInfo: userInfo)
    }
}

extension Dictionary {
    func merged(another: [Key: Value]) -> Dictionary {
        var result: [Key: Value] = [:]
        for (key, value) in self {
            result[key] = value
        }
        for (key, value) in another {
            result[key] = value
        }
        return result
    }
}

extension Dictionary where Value: RangeReplaceableCollection {
    func merged(another: [Key: Value]) -> [Key: Value] {
        var result: [Key: Value] = [:]
        for (key, value) in self {
            result[key] = value
        }
        for (key, value) in another {
            if let collection = result[key] {
                result[key] = collection + value
            } else {
                result[key] = value
            }
            
        }
        return result
    }
}
