//
//  HotItemLoader.swift
//  diyordernative
//
//  Created by Richard Lu on 2017-12-15.
//  Copyright © 2017 goopter. All rights reserved.
//

import Foundation
import ObjectMapper

class HotItemLoader {
    
    static func startRequestHotItems (urlparams: [String: String], completion: @escaping (apiStatus, [HotItem]?) -> Void) {
        let language = LanguageControl.shared.getAppLanguage().serverKey
        var urlParams = urlparams
        urlParams["lan"] = language
        urlParams["page"] = "1"
        urlParams["limit"] = "20"
        let formattedUrlParams = UrlHelper.getFormattedUrlParams(urlparams: urlParams)
        let path = SysConstants.REST_PATH_HOT_ITEM + formattedUrlParams
        
        var status = apiStatus.unknownError
        var items: [HotItem]? = nil
        ApiManager.shared.startHttpApiRequest(path: path, method: .get, completion: {
            _status, jsonObject in
            
            status = _status
            
            if status == .success, let object = Mapper<ListApiResponse<HotItem>>().map(JSON: jsonObject as! [String : Any]) {
                status = object.getStatus()
                
                if status == .success {
                    items = object.records
                }
            }
            
            completion (status, items)
        })
    }
    
    static func startRequestHotItemCategory (completion: @escaping (apiStatus, [HotItemCategory]?) -> Void) {
        let language = LanguageControl.shared.getAppLanguage().serverKey
        let urlParams = ["lan" : language]
        
        let formattedUrlParams = UrlHelper.getFormattedUrlParams(urlparams: urlParams)
        let path = SysConstants.REST_PATH_HOT_ITEM_CATEGORY + formattedUrlParams
        
        var status = apiStatus.unknownError
        var items: [HotItemCategory]? = nil
        ApiManager.shared.startHttpApiRequest(path: path, method: .get, completion: {
            _status, jsonObject in
            
            status = _status
            
            if status == .success, let object = Mapper<ListApiResponse<HotItemCategory>>().map(JSON: jsonObject as! [String : Any]) {
                status = object.getStatus()
                
                if status == .success {
                    items = object.records
                }
            }
            
            completion (status, items)
        })
    }
}
