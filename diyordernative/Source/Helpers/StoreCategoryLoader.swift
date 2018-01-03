//
//  StoreCategoryLoader.swift
//  diyordernative
//
//  Created by Yuan Lu on 2017-12-15.
//  Copyright © 2017 goopter. All rights reserved.
//

import Foundation
import ObjectMapper

class StoreCategoryLoader {
    static func startRequestStoreCategory (completion: @escaping (apiStatus, [StoreCategory]?) -> Void) {
        let language = LanguageControl.shared.getAppLanguage().serverKey
        let urlparams = ["lan": language, "city": "1"]
        let formattedUrlParams = UrlHelper.getFormattedUrlParams(urlparams: urlparams)
        let path = SysConstants.REST_PATH_STORE_CATEGORY + formattedUrlParams
        
        var status = apiStatus.unknownError
        var items: [StoreCategory]? = nil
        ApiManager.shared.startHttpApiRequest(path: path, method: .get, completion: {
            _status, jsonObject in
            
            status = _status
            
            if status == .success, let object = Mapper<ListApiResponse<StoreCategory>>().map(JSON: jsonObject as! [String : Any]) {
                
                status = object.getStatus()
                if status == .success {
                    items = object.records
                }
            }
            
            completion (status, items)
        })
    }
    
    static func startRequestStoreSubCategory (storeCategoryType: storeCategoryType, completion: @escaping (apiStatus, [StoreSubCategory]?) -> Void) {
        let language = LanguageControl.shared.getAppLanguage().serverKey
        let urlparams = ["lan": language, "c_id": "\(storeCategoryType.rawValue)", "city": "1"]
        let formattedUrlParams = UrlHelper.getFormattedUrlParams(urlparams: urlparams)
        let path = SysConstants.REST_PATH_STORE_SUBCATEGORY + formattedUrlParams
        
        var status = apiStatus.unknownError
        var items: [StoreSubCategory]? = nil
        ApiManager.shared.startHttpApiRequest(path: path, method: .get, completion: {
            _status, jsonObject in
            
            status = _status
            
            if status == .success, let object = Mapper<ListApiResponse<StoreSubCategory>>().map(JSON: jsonObject as! [String: Any]) {
                status = object.getStatus()
                if status == .success {
                    items = object.records
                }
            }
            
            completion (status, items)
        })
    }
    
    static func startRequestStoreFilterSubCategory (storeCategoryType: storeCategoryType, completion: @escaping (apiStatus, [StoreSubCategory]?) -> Void) {
        let language = LanguageControl.shared.getAppLanguage().serverKey
        let urlparams = ["lan": language, "c_id": "\(storeCategoryType.rawValue)", "city": "1"]
        let formattedUrlParams = UrlHelper.getFormattedUrlParams(urlparams: urlparams)
        let path = SysConstants.REST_PATH_STORE_FILTER_SUBCATEGORY + formattedUrlParams
        
        var status = apiStatus.unknownError
        var items: [StoreSubCategory]? = nil
        ApiManager.shared.startHttpApiRequest(path: path, method: .get, completion: {
            _status, jsonObject in
            
            status = _status
            
            if status == .success, let object = Mapper<ListApiResponse<StoreSubCategory>>().map(JSON: jsonObject as! [String: Any]) {
                status = object.getStatus()
                if status == .success {
                    items = object.records
                }
            }
            
            completion (status, items)
        })
    }
}
