//
//  SKServiceManager.swift
//  AlZehraIslamicCenter
//
//  Created by Shabi on 18/10/17.
//  Copyright © 2017 Shabi. All rights reserved.
//

import Foundation
import Alamofire
import AlamofireImage

class Session  {
    fileprivate var httpMethod: Alamofire.HTTPMethod?
    fileprivate var url: String?
    
    fileprivate var headers: [String : String]?
    fileprivate var parameters : [String : AnyObject]?
    fileprivate var serviceType: String = ""
    
    public init(httpMethod: Alamofire.HTTPMethod? = nil, url: String? = nil,
                headers: [String : String]?, parameters: [String : AnyObject]?, serviceType: String = "") {
        self.httpMethod = httpMethod
        self.url = url
        self.headers = headers
        self.parameters = parameters
        self.serviceType = serviceType
    }
}

public class SKServiceManager {
    
    //MARK: - Properties
    private var configuration = SKServiceConfigauration()
    private var sessionManager: Alamofire.SessionManager?
    private var currentRequest: Alamofire.Request?
    private var tokenRefreshRequest: Alamofire.Request?
    
    private var serviceType: String = ""
    private var delegate: SKServiceManagerDelegate?
    private var datasource: SKServiceManagerDataSource?
    private var isTokenRefreshed = false
    
    private var session: Session?
    
    /// Reachability status of network calls
    weak public private(set) var reachability = NetworkReachabilityManager(host: "www.apple.com")
    
    //MARK: - Initializer method
    
    /// Initializer method for Service Manager class
    @discardableResult
    public init(dataSource: SKServiceManagerDataSource? = nil, delegate: SKServiceManagerDelegate? = nil,
                serviceType: String) {
        
        // Initializations
        self.initializeNetworkReachability()
        
        self.serviceType = serviceType
        self.datasource = dataSource
        self.delegate = delegate
        
        // URL
        let requestURLAndMethodType = self.datasource?.requestUrlandHttpMethodType(serviceType: serviceType)
        let url = requestURLAndMethodType?.url
        
        // HTTP Method
        var httpMethodType : Alamofire.HTTPMethod? = .get
        if let requestMethodType = requestURLAndMethodType?.methodType {
            httpMethodType = Alamofire.HTTPMethod(rawValue: requestMethodType.rawValue)
        }
        
        // Headers
        let headers: [String: String]? = configuration.addCustomHeaders(customHeaders: self.datasource?.requestHeaders(serviceType: serviceType))
        
        // Parameters
        let parameters: [String: AnyObject]? = self.datasource?.requestParameters(serviceType: serviceType)
        
        if Utility.isNilOrEmpty(string: url as NSString?) {
            self.handleFailure(error: Utility.createErrorInstance(title: "Improper URL", message: "Please check the url you have requested", errorCode: 401))
        } else {
            self.session = Session(httpMethod: httpMethodType, url: url, headers: headers, parameters: parameters, serviceType: self.serviceType)
            self.processServiceRequest(method: httpMethodType, url: url, headers: headers, parameters: parameters)
        }
        self.datasource = nil
    }
    
    fileprivate func initializeNetworkReachability() {
        
        self.reachability?.listener = { [weak self] status in
            print("Network Status Changed: \(status)")
            guard let strongSelf = self else {
                return
            }
            switch status {
            case .notReachable:
                print("Not Reachable")
                strongSelf.cancelRequest(message: "Please check your internet connection or try again later")
            case .unknown:
                print("UnKnown")
            case .reachable(let connectionType):
                
                if connectionType == .ethernetOrWiFi {
                    print("Reachable Wifi")
                }
                else {
                    print("Reachable wwan")
                }
            }
        }
        
        self.reachability?.startListening()
    }
    
    //MARK: - Service Request - Alamofire
    
    /// This method creates a ‘Request’
    ///
    /// - Parameters:
    ///   - method: Alamofire http type
    ///   - url: URL to be processed
    ///   - headers: A dictionary containing all the additional headers
    ///   - parameters: A dictionary containing all the necessary options
    
    func processServiceRequest(method: Alamofire.HTTPMethod?, url : String?,
                               headers: [String : String]?,
                               parameters : [String : AnyObject]?) {
        
        
        
        let escapedString = url?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        let destinationURL = URL(string: escapedString!)
        print("Service Type: \(self.serviceType)")
        print("Service: \(destinationURL!)")
        print("\(headers)")
        print("Parameters: \(parameters)")
        self.currentRequest =  Alamofire.request(destinationURL!, method: method!, parameters: parameters,
                                                 encoding: self.serviceType == "login" ? URLEncoding.httpBody : JSONEncoding.default, headers: headers)
            .responseString { response in
                switch(response.result) {
                case .success:
                    if let urlResponse = response.response, let stringResult = response.result.value {
                        let serializer = DataRequest.jsonResponseSerializer()
                        var data = stringResult.data(using: .utf8)!
                        if stringResult.count <= 0 {
                            data = "{}".data(using: .utf8)!
                        }
                        let result = serializer.serializeResponse(response.request, response.response, data, nil)
                        if result.isSuccess {
                            //If Authorization failed or token expired :: Refresh token
                            if urlResponse.statusCode == 401 {
                                self.currentRequest = nil
                                self.refreshToken()
                            } else {
                                self.processSuccessResponse(header: urlResponse, response: result.value)
                            }

                        } else {
                            self.handleFailure(error: result.error, failureResponse: response)
                        }
                    }
                case .failure(let error):
                    self.handleFailure(error: error, failureResponse: response)
                }
                self.currentRequest = nil
        }
    }
    

    //MARK: - Refresh expired token
    func refreshToken() {
        let reqParameter = ["username": Keychain.loadValueFromKeychain(key: Constants.KeyChain.userName) as AnyObject,
                            "password": Keychain.loadValueFromKeychain(key: Constants.KeyChain.password)as AnyObject,
                            "grant_type": "password" as AnyObject]
        
        // download code.
        self.tokenRefreshRequest = Alamofire.request("http://api.azicc.org/oauth/token", method: .post, parameters: reqParameter,
                          encoding: URLEncoding.httpBody, headers: ["Content-Type": "application/x-www-form-urlencoded"])
            .responseString { response in
                switch(response.result) {
                case .success:
                    if let urlResponse = response.response, let stringResult = response.result.value {
                        let serializer = DataRequest.jsonResponseSerializer()
                        var data = stringResult.data(using: .utf8)!
                        if stringResult.count <= 0 {
                            data = "{}".data(using: .utf8)!
                        }
                        let result = serializer.serializeResponse(response.request, response.response, data, nil)
                        if result.isSuccess {
                            let loginResponse = AZAuthTokenResponse.init(dictionary: result.value as! NSDictionary)
                            loginResponse?.saveInKeyChain()
                            self.isTokenRefreshed = true
                            self.session?.headers!["Authorization"] = "Bearer " +  Keychain.loadValueFromKeychain(key: Constants.KeyChain.accessToken)!
                            self.refreshSession(session: self.session)
                        } else {
                            //Return error
                            self.isTokenRefreshed = false
                            AZUtility.showAlert(title: "Error", message: result.error?.localizedDescription, actionTitles: "OK", actions: nil)
                        }
                    }
                case .failure(let error):
                    print("Token fail")
                    AZUtility.showAlert(title: "Error", message: error.localizedDescription, actionTitles: "OK", actions: nil)
                }
                self.tokenRefreshRequest = nil
        }
    }
    
    //MARK: - Refresh failed session
    func refreshSession(session: Session?) {
        self.processServiceRequest(method: session?.httpMethod, url: session?.url, headers: session?.headers, parameters: session?.parameters)
    }
    
    //MARK: - Image Download - Alamofire
    
    ///  This method creates a ‘Request’
    ///
    /// - Parameters:
    ///   - delegate:
    ///   - method: Alamofire http type
    ///   - imageURL: URL of the image to be processed
    
    public class func downoadImage(imageURL: String?, completionHandler: ((UIImage?) -> Void)?) {
        
        Alamofire.request(imageURL!, method: .get).responseImage { response in
            
            if let responseImage = response.result.value {
                completionHandler?(responseImage)
            }
        }
    }
    
    //MARK: - Success and Failure - Alamofire
    
    func processSuccessResponse(header: HTTPURLResponse?, response: Any?) {
        self.delegate?.didReceiveResponse(serviceType: self.serviceType, headerResponse: header, finalResponse: response)
        self.delegate = nil
    }
    
    func handleFailure(error:Error?, failureResponse: Any? = nil) {
        self.delegate?.didReceiveError(serviceType: self.serviceType, theError: error, failureResponse: failureResponse)
        self.delegate = nil
    }
    
    //MARK: - Cancelling requests - Alamofire
    
    public func cancelRequest(message: String = "Something went wrong, Kindly retry after sometime.") {
        self.currentRequest?.cancel()
        self.currentRequest = nil
    }
    
    
}
