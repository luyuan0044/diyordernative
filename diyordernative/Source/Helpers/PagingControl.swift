//
//  PagingControl.swift
//  diyordernative
//
//  Created by Yuan Lu on 2018-01-03.
//  Copyright © 2018 goopter. All rights reserved.
//

import Foundation

protocol Pagingable { }

class PagingControl {
    
    init(limit: Int) {
        self.limit = limit
    }
    
    // MARK: - Properties
    
    private var limit: Int
    
    private var currentPage: Int = 0
    
    private var status: apiStatus = .success
    
    private var total: Int! = 0
    
    private var totalPage: Int {
        get {
            return Int(ceil(Double(total / limit)))
        }
    }
    
    var hasMore: Bool {
        get {
            return status != .success || (status == .success && currentPage < totalPage)
        }
    }
    
    // MARK: - Implementation
    
    /**
     Perform pagination loading task and calculate paging information
     
     - parameter urlparams: urlparams to append with url
     - parameter completion: completion handler with 'apiStatus' and array of 'Paginable' item which could be nil
     - parameter task: loading task
     */
    func loadPagingData<T> (urlparams: [String: String]? = nil,
                            completion: @escaping (apiStatus, [T]?) -> Void,
                            task: ([String: String]?, @escaping (apiStatus, [T]?, Paging?) -> Void) -> Void) where T : Pagingable {
        var _urlparams = urlparams
        if _urlparams == nil {
            _urlparams = [:]
        }
        //attach pagiantion url params
        _urlparams!["limit"] = "\(limit)"
        _urlparams!["page"] = "\(currentPage + 1)"
        
        task (_urlparams, {
            _status, _records, _paging in
            
            if _status == .success {
                self.status = _status
                self.total = _paging!.total!
                self.currentPage += 1
            }
            
            completion (_status, _records)
        })
    }
    
    /**
     Reset pagination information
     */
    func reset () {
        currentPage = 0
        status = .success
        total = 0
    }
}
