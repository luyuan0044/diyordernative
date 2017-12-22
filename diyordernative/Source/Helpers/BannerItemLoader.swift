//
//  BannerItemLoader.swift
//  diyordernative
//
//  Created by Richard Lu on 2017-12-14.
//  Copyright © 2017 goopter. All rights reserved.
//

import Foundation
import ObjectMapper

class BannerItemLoader {
    
    /**
     Request banner items from server
     
     - parameter completion: completion handler with 'apiStatus' and array of 'BannerItem' which could be nil
     */
    static func startRequestBannerItem (completion: @escaping (apiStatus, [BannerItem]?) -> Void) {
        let language = LanguageControl.shared.getAppLanguage().serverKey
        let urlparams = ["lan": language, "city": "vancouver"]
        let formattedUrlParams = UrlHelper.getFormattedUrlParams(urlparams: urlparams)
        let path = SysConstants.REST_PATH_BANNER_ITEM + formattedUrlParams
        
        var status = apiStatus.unknownError
        var items: [BannerItem]? = nil
        ApiManager.shared.startHttpApiRequest (path: path, method: .get, completion: {
            _status, jsonObject in
            
            status = _status
            
            if status == .success, let object = Mapper<ListApiResponse<BannerItem>> ().map(JSON: jsonObject as! [String : Any]) {
                
                status = object.getStatus()
                if status == .success {
                    items = object.records
                }
            }
            
            completion (status, items)
        })
    }
}
