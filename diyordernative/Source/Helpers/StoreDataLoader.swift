//
//  StoreDataLoader.swift
//  diyordernative
//
//  Created by Richard Lu on 2018-01-03.
//  Copyright © 2018 goopter. All rights reserved.
//

import Foundation
import ObjectMapper

class StoreDataLoader {
    /**
     Request stores from server
     
     - parameter urlparams: url parameters to append with url
     - parameter completion: completion handler with 'apiStatus' and array of 'Store' items and 'Paging' information which could be nil
     */
    static func startRequestStores (urlparams: [String: String]? = nil, completion: @escaping (apiStatus, [Store]?, Paging?) -> Void) {
        var _urlparams: [String: String]? = urlparams
        if urlparams == nil {
            _urlparams = [:]
        }
        let language = LanguageControl.shared.getAppLanguage().serverKey
        _urlparams!["lan"] = language
        
        let formattedUrlParams = UrlHelper.getFormattedUrlParams(urlparams: _urlparams!)
        let path = SysConstants.REST_PATH_STORES + formattedUrlParams
        
        var status = apiStatus.unknownError
        var stores: [Store]? = nil
        var paging: Paging? = nil
        ApiManager.shared.startHttpApiRequest(path: path, method: .get, completion: {
            _status, jsonObject in
            
            status = _status
            
            if status == .success, let object = Mapper<ListApiResponse<Store>>().map(JSON: jsonObject as! [String : Any]) {
                status = object.getStatus()
                
                if status == .success {
                    stores = object.records
                    paging = object.paging
                }
            }
            
            completion (status, stores, paging)
        })
    }
    
    /**
     Request store from server by store url
     
     - parameter url: request store information url
     - parameter completion: completion handler with 'apiStatus' and 'Store'
     */
    static func startRequestStore (by url: String, completion: @escaping (apiStatus, Store?) -> Void) {
        completion (.sourceNotFound, nil)
    }
}
