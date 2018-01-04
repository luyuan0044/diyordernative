//
//  StoreListManager.swift
//  diyordernative
//
//  Created by Richard Lu on 2018-01-03.
//  Copyright © 2018 goopter. All rights reserved.
//

import Foundation

class StoreListManager {
    
    // MARK: - Instances management
    
    static private var instances: [storeCategoryType: StoreListManager] = [:]
    
    static func sharedOf (type :storeCategoryType) -> StoreListManager {
        let key = type
        if let shared = (instances[key]) {
            return shared
        }
        let type = key
        let shared = StoreListManager (storeCategoryType: type)
        instances[key] = shared
        return shared
    }
    
    // MARK: - Properties
    
    private init(storeCategoryType: storeCategoryType) {
        self.storeCategoryType = storeCategoryType
    }
    
    private var storeCategoryType: storeCategoryType
    
    private var stores: [Store]? = nil
    
    // MARK: - Implementation
    
    func loadStores (force: Bool, urlparams: [String: String]? = nil, completion: @escaping (apiStatus, [Store]?) -> Void) {
        if stores == nil || force {
            var status = apiStatus.unknownError
            
            var _urlparams: [String: String]? = urlparams
            if _urlparams == nil {
                _urlparams = [:]
            }
            _urlparams!["c_id"] = "\(storeCategoryType.rawValue)"
            
            StoreDataLoader.startRequestStores(urlparams: _urlparams, completion: {
                _status, _stores in
                
                status = _status
                if status == .success {
                    if self.stores == nil {
                        self.stores = []
                    }
                    
                    self.stores!.append(contentsOf: _stores!)
                }
                
                completion (status, self.stores)
            })
        } else {
            completion (.success, self.stores)
        }
    }
}
