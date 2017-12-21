//
//  SKServiceConfigauration.swift
//  AlZehraIslamicCenter
//
//  Created by Shabi on 18/10/17.
//  Copyright © 2017 Shabi. All rights reserved.
//

import Foundation
import Alamofire
import AlamofireImage


class SKServiceConfigauration {
    
    var configuration: URLSessionConfiguration?
    
    func addCustomHeaders(customHeaders:[String: String]?) -> [String: String]? {
        
        var finalheaders: [String: String]
        let headers = Alamofire.SessionManager.defaultHTTPHeaders
        if let customHeaders = customHeaders {
            finalheaders = headers.merged(another: customHeaders)
        }else{
            finalheaders = headers
        }
        
        finalheaders["User-Agent"] = self.getUserAgentInfo()
        self.configuration = URLSessionConfiguration.default
        self.configuration?.timeoutIntervalForRequest = 60
        self.configuration?.httpAdditionalHeaders = finalheaders
        
        return finalheaders
    }
    
    func getSessionManager() -> SessionManager {
        return Alamofire.SessionManager(configuration: self.configuration!)
    }
    
    func getUserAgentInfo() -> String {
        if let info = Bundle.main.infoDictionary {
            let executable = info[kCFBundleExecutableKey as String] as? String ?? "Unknown"
            let bundle = info[kCFBundleIdentifierKey as String] as? String ?? "Unknown"
            let appVersion = info["CFBundleShortVersionString"] as? String ?? "Unknown"
            let deviceType: String = UIDevice.current.model.lowercased()
            let appBuild = info[kCFBundleVersionKey as String] as? String ?? "Unknown"
            let osNameVersion: String = {
                let version = ProcessInfo.processInfo.operatingSystemVersion
                let versionString = "\(version.majorVersion).\(version.minorVersion).\(version.patchVersion)"
                
                let osName: String = {
                    #if os(iOS)
                        return "iOS"
                    #elseif os(watchOS)
                        return "watchOS"
                    #elseif os(tvOS)
                        return "tvOS"
                    #elseif os(macOS)
                        return "OS X"
                    #elseif os(Linux)
                        return "Linux"
                    #else
                        return "Unknown"
                    #endif
                }()
                
                return "\(osName) \(versionString)"
            }()
            
            return "\(executable)-iOS/\(appVersion)/\(deviceType) (\(bundle); build:\(appBuild); \(osNameVersion))"
        }
        
        return "Al Zehra iOS"
    }
    
}
