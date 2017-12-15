//
//  ApiManager.swift
//  GoopterBiz
//
//  Created by Yuan Lu on 2017-05-15.
//  Copyright © 2017 Goopter Holdings Ltd. (http://www.goopter.com)
//

import Foundation
import Alamofire
import AlamofireObjectMapper
import OAuthSwiftAlamofire
import OAuthSwift
import SystemConfiguration

enum reachabilityStatus {
    case notReachable
    case reachableViaWWAN
    case reachableViaWiFi
}

class ApiManager {
    static var shared: ApiManager {
        return _shared
    }
    
    private static let _shared = ApiManager()
    
    private init() {
        
    }
    
    private let shouldDebugApi = true
    
    //Keypairs
    private var consumerKey = "8fb7ec71f8b4e1f2ec28d2f8c3f7785a"
    private var consumerSecret = "af035f0f340e090d5b51870f9a168acd"
    
    private var accessToken = ""
    private var accessTokenSecret = ""
    
    private var header = ["Accept": "application/json", "Content-Type":"application/json"]
    
    func setupConsumerKeypair(consumerKey: String, consumerSecret: String) {
        self.consumerKey = consumerKey
        self.consumerSecret = consumerSecret
    }
    
    func setupOauthKeypair (_ oauthKeypair: OauthKeyPair) {
        accessToken = oauthKeypair.token!
        accessTokenSecret = oauthKeypair.tokenSecret!
    }
    
    func getOauthClient () -> OAuthSwiftClient {
        let oauthClient = OAuthSwiftClient (consumerKey: consumerKey, consumerSecret: consumerSecret)
        oauthClient.credential.oauthToken = accessToken
        oauthClient.credential.oauthTokenSecret = accessTokenSecret
        oauthClient.sessionFactory.configuration.timeoutIntervalForRequest = 10
        
        return oauthClient
    }
    
    func startHttpApiRequest (path: String, method: HTTPMethod, body: [String: Any]? = nil, completion: @escaping (apiStatus, Any?) -> Void) {
        
        guard checkCurrentReachabilityStatus() != .notReachable else {
            completion (apiStatus.networkConnectionFailure, nil)
            return
        }
        
        //start time
        let start = DispatchTime.now()
        
        let manager = Alamofire.SessionManager.default
        manager.session.configuration.timeoutIntervalForRequest = 30
        
        manager.request(path, method: method, parameters: body, encoding: JSONEncoding.default, headers: nil).response(completionHandler: {
            response in
            
            if response.data != nil {
                do {
                    let jsonObject = try JSONSerialization.jsonObject(with: response.data!, options: .allowFragments)
                    
                    //end time
                    let end = DispatchTime.now()
                    
                    //debug log
                    if self.shouldDebugApi {
                        let duration = Double(end.uptimeNanoseconds - start.uptimeNanoseconds) / 1_000_000_000
                        self.Log(path: path, body: body, response: jsonObject, duration: duration)
                    }
                    
                    completion (.success, jsonObject)
                } catch {
                    completion (.unknownError, nil)
                }
            }
            else {
                completion (.unknownError, nil)
            }
        })
    }
    
    func startHttpApiRequestWithOauth (path: String, method: OAuthSwiftHTTPRequest.Method, body: [String: Any] = [:], completion: @escaping (apiStatus, Any?) -> Void) {
        
        guard checkCurrentReachabilityStatus() != .notReachable else {
            completion (.networkConnectionFailure, nil)
            return
        }
        
        let oauthClient = getOauthClient()
        
        //start time
        let start = DispatchTime.now()

        oauthClient.request(path, method: method, parameters: body, headers: self.header
            , body: nil, checkTokenExpiration: false, success: {
                response in
                do {
                    let jsonObject = try JSONSerialization.jsonObject(with: response.data, options: .allowFragments)
                    
                    //end time
                    let end = DispatchTime.now()
                    
                    //debug log
                    if self.shouldDebugApi {
                        let duration = Double(end.uptimeNanoseconds - start.uptimeNanoseconds) / 1_000_000_000
                        self.Log(path: path, body: body, response: jsonObject, duration: duration)
                    }
                    
                    completion (.success, jsonObject)
                } catch {
                    print("Error: \(error)")
                    completion (.unknownError, nil)
                }
        }, failure: {
            error in
            
            print("Response: \(error.description)    Code: \(error.errorCode) _Code: \(error._code) ")
            
            let userInfo = error.errorUserInfo
            
//            if error.description.contains("Code=-1001") {
//                completion (.timeout, nil)
//            } else if error.description.contains("Code=401") || (userInfo["Response-Body"] != nil && (userInfo["Response-Body"] as! String).contains("\(apiStatus.authenticationFailure.rawValue)") ) {
//                completion (.authenticationFailure, nil)
//
//                AccountManager.shared.kickout()
//            } else {
//                completion (.unknownError, nil)
//            }
        })
    }
    
    func checkCurrentReachabilityStatus () -> reachabilityStatus {
        
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(MemoryLayout<sockaddr_in>.size)
        zeroAddress.sin_family = sa_family_t(AF_INET)
        
        guard let defaultRouteReachability = withUnsafePointer(to: &zeroAddress, {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {
                SCNetworkReachabilityCreateWithAddress(nil, $0)
            }
        }) else {
            return .notReachable
        }
        
        var flags: SCNetworkReachabilityFlags = []
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags) {
            return .notReachable
        }
        
        if flags.contains(.reachable) == false {
            // The target host is not reachable.
            return .notReachable
        }
        else if flags.contains(.isWWAN) == true {
            // WWAN connections are OK if the calling application is using the CFNetwork APIs.
            return .reachableViaWWAN
        }
        else if flags.contains(.connectionRequired) == false {
            // If the target host is reachable and no connection is required then we'll assume that you're on Wi-Fi...
            return .reachableViaWiFi
        }
        else if (flags.contains(.connectionOnDemand) == true || flags.contains(.connectionOnTraffic) == true) && flags.contains(.interventionRequired) == false {
            // The connection is on-demand (or on-traffic) if the calling application is using the CFSocketStream or higher APIs and no [user] intervention is needed
            return .reachableViaWiFi
        }
        else {
            return .notReachable
        }
    }
    
    func Log(path: String, body: [String: Any]?, response: Any?, duration: TimeInterval) {
        if body != nil && body!.count != 0 {
            
            print("==========Api Log Start==========\nUrl: \(path) \nDuration: \(duration)s \nPost: \(body ?? [:]) \nResponse: \(response ?? "") \n==========Api Log End==========")
        } else {
            print("==========Api Log Start==========\nUrl: \(path) \nDuration: \(duration)s \nResponse: \(response ?? "")  \n==========Api Log End==========")
        }
    }
    
    //Clean up access key pairs
    func cleanup () {
        accessToken = ""
        accessTokenSecret = ""
    }
}
