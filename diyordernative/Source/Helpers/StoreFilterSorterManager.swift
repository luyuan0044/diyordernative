//
//  StoreFilterSorterManager.swift
//  diyordernative
//
//  Created by Richard Lu on 2018-01-02.
//  Copyright © 2018 goopter. All rights reserved.
//

import Foundation
import ObjectMapper

class StoreFilterSorterManager {
    
    // MARK: - Instances management
    
    static private var instances: [storeCategoryType: StoreFilterSorterManager] = [:]
    
    static func sharedOf (type :storeCategoryType) -> StoreFilterSorterManager {
        let key = type
        if let shared = (instances[key]) {
            return shared
        }
        let type = key
        let shared = StoreFilterSorterManager (storeCategoryType: type)
        instances[key] = shared
        return shared
    }
    
    private init(storeCategoryType: storeCategoryType) {
        self.storeCategoryType = storeCategoryType
    }
    
    // MARK: - Properties
    
    var storeCategoryType: storeCategoryType
    
    private var subcategories: [StoreSubCategory]?
    
    private var filterSubcategories: [StoreSubCategory]?
    
    private var sorts: [Sort]?
    
    private var filters: [StoreFilter]?
    
    /**
     Load store sub-categories
     
     - parameter completion: api request task completion callback (api status and array of store subcategories as input)
     */
    func loadSubCategories (completion: @escaping (apiStatus, [StoreSubCategory]?) -> Void) {
        var status = apiStatus.unknownError
        
        if self.subcategories == nil {
            StoreCategoryLoader.startRequestStoreSubCategory(storeCategoryType: self.storeCategoryType, completion: {
                _status, _subcategories in
                
                status = _status
                
                if status == .success {
                    // cache data
                    self.subcategories = _subcategories
                }
                
                completion (status, self.subcategories)
            })
            return
        }
        
        status = .success
        completion (status, self.subcategories)
    }
    
    /**
     Load store sub-categories in filter drop down
     
     - parameter completion: api request task completion callback (api status and array of store subcategories as input)
     */
    func loadFilterSubCategoies (completion: @escaping (apiStatus, [StoreSubCategory]?) -> Void) {
        var status = apiStatus.unknownError
        
        if self.filterSubcategories == nil {
            StoreCategoryLoader.startRequestStoreFilterSubCategory(storeCategoryType: self.storeCategoryType, completion: {
                _status, _subcategories in
                
                status = _status
                
                if status == .success {
                    // cache data
                    self.filterSubcategories = _subcategories
                }
                
                completion (status, self.filterSubcategories)
            })
            return
        }
        
        status = .success
        completion (status, self.filterSubcategories)
    }
    
    func loadSortItems (completion: @escaping (apiStatus, [Sort]?) -> Void) {
        var status = apiStatus.unknownError
        
        if self.sorts == nil {
            StoreFilterSorterManager.startRequestStoreSorts (storeCategoryType: self.storeCategoryType, completion: {
                _status, _sorts in
                
                status = _status
                
                if status == .success {
                    // cache data
                    self.sorts = _sorts
                }
                
                completion (status, self.sorts)
            })
            return
        }
        
        status = .success
        completion (status, self.sorts)
    }
    
    static private func startRequestStoreSorts (storeCategoryType: storeCategoryType, completion: @escaping (apiStatus, [Sort]?) -> Void) {
        let language = LanguageControl.shared.getAppLanguage().serverKey
        let urlparams = ["lan": language, "c_id": "\(storeCategoryType.rawValue)", "city": "1"]
        let formattedUrlParams = UrlHelper.getFormattedUrlParams(urlparams: urlparams)
        let path = SysConstants.REST_PATH_STORE_SORT + formattedUrlParams
        
        var status = apiStatus.unknownError
        var items: [Sort]? = nil
        ApiManager.shared.startHttpApiRequest(path: path, method: .get, completion: {
            _status, jsonObject in
            
            status = _status
            
            if status == .success, let object = Mapper<ListApiResponse<Sort>>().map(JSON: jsonObject as! [String: Any]) {
                status = object.getStatus()
                if status == .success {
                    items = object.records
                }
            }
            
            completion (status, items)
        })
    }
    
    func loadFilterItems (completion: @escaping (apiStatus, [StoreFilter]?) -> Void) {
        var status = apiStatus.unknownError
        
        if self.filters == nil {
            StoreFilterSorterManager.startRequestFilterItems (storeCategoryType: self.storeCategoryType, completion: {
                _status, _filters in
                
                status = _status
                
                if status == .success {
                    // cache data
                    self.filters = _filters
                }
                
                completion (status, self.filters)
            })
            return
        }
        
        status = .success
        completion (status, self.filters)
    }
    
    static private func startRequestFilterItems (storeCategoryType: storeCategoryType, completion: @escaping (apiStatus, [StoreFilter]?) -> Void) {
        let language = LanguageControl.shared.getAppLanguage().serverKey
        let urlparams = ["lan": language, "c_id": "\(storeCategoryType.rawValue)", "city": "1"]
        let formattedUrlParams = UrlHelper.getFormattedUrlParams(urlparams: urlparams)
        let path = SysConstants.REST_PATH_STORE_FILTER + formattedUrlParams
        
        var status = apiStatus.unknownError
        var items: [StoreFilter]? = nil
        ApiManager.shared.startHttpApiRequest(path: path, method: .get, completion: {
            _status, jsonObject in
            
            status = _status
            
            if status == .success, let object = Mapper<ListApiResponse<StoreFilter>>().map(JSON: jsonObject as! [String: Any]) {
                status = object.getStatus()
                if status == .success {
                    items = object.records
                }
            }
            
            completion (status, items)
        })
    }
}
