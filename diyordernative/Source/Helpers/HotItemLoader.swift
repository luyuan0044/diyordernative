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
    /**
     Request hot items from server
     
     - parameter _urlparams: Dictionary of urlparams
     - parameter completion: api request task completion callback (api status and array of hot items as input)
     */
    static func startRequestHotItems (_urlparams: [String: String]?, completion: @escaping (apiStatus, [HotItem]?, Paging?) -> Void) {
        var urlParams = _urlparams
        if urlParams == nil {
            urlParams = [:]
        }
        urlParams!["lan"] = LanguageControl.shared.getAppLanguage().serverKey
        if let latlonStr = UrlHelper.getFormattedUrlLatAndLon(coordinate: LocationHelper.shared.getCurrentLatAndLon()) {
            urlParams!["latlon"] = latlonStr
        }
        let formattedUrlParams = UrlHelper.getFormattedUrlParams(urlparams: urlParams!)
        let path = SysConstants.REST_PATH_HOT_ITEM + formattedUrlParams
        
        var status = apiStatus.unknownError
        var items: [HotItem]? = nil
        var paging: Paging? = nil
        ApiManager.shared.startHttpApiRequest(path: path, method: .get, completion: {
            _status, jsonObject in
            
            status = _status
            
            if status == .success, let object = Mapper<ListApiResponse<HotItem>>().map(JSON: jsonObject as! [String : Any]) {
                status = object.getStatus()
                
                if status == .success {
                    items = object.records
                    paging = object.paging
                }
            }
            
            completion (status, items, paging)
        })
    }
    
    /**
     Request hot item categories from server
     
     - parameter completion: api request task completion callback (api status and array of hot item categories as input)
     */
    static func startRequestHotItemCategory (completion: @escaping (apiStatus, [HotItemCategory]?) -> Void) {
        let urlParams = ["lan" : LanguageControl.shared.getAppLanguage().serverKey]
        
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
    
    /**
     Request hot item sort from local .json file
     
     - parameter completion: api request task completion callback (array of hot item sort as input)
     */
    static func startLoadHotItemSort (completion: @escaping ([HotItemSort]?) -> Void) {
        if let path = Bundle.main.path(forResource: SysConstants.HOT_ITEM_SORT_ITEMS_JSON_FILE, ofType: "json") {
            do {
                let data = try Data (contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                let jsonObject = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
                let object = Mapper<ListApiResponse<HotItemSort>>().map(JSON: jsonObject as! [String : Any])
                completion(object!.records)
            } catch {
                completion(nil)
            }
        }
    }
}
