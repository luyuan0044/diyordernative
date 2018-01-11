//
//  StoreFilterSorterControl.swift
//  diyordernative
//
//  Created by Richard Lu on 2018-01-03.
//  Copyright © 2018 goopter. All rights reserved.
//

import Foundation

class StoreFilterSorterControl {
    
    // MARK: - Properties
    
    private(set) var subcategories: [StoreSubCategory]?
    
    private(set) var filterSubcategories: [StoreSubCategory]?
    
    private(set) var sorts: [Sort]?
    
    private(set) var filters: [StoreFilter]?
    
    private(set) var selectedSubCategory: StoreSubCategory? = nil
    
    private(set) var selectedSort: Sort? = nil
    
    private(set) var selectedSwitchFilterId: [Int]? = nil
    
    private(set) var selectedSelectionFilter: [Int: [Int]]? = nil
    
    // MARK: - Implementation
    
    /**
     Set store subcategories to controller
     
     - parameter subcategories: store subcategories display in scroll header
     */
    func setSubcategories (_ subcategories: [StoreSubCategory]?) {
        self.subcategories = subcategories
    }
    
    /**
     Set store subcategories to controller
     
     - parameter subcategories: store subcategories display in drop down
     */
    func setFilterSubcategories (_ subcategories: [StoreSubCategory]?) {
        self.filterSubcategories = subcategories
    }
    
    /**
     Set store sort items to controller
     
     - parameter sorts: store sort items display in drop down
     */
    func setSorts (_ sorts: [Sort]?) {
        self.sorts = sorts
    }
    
    /**
     Set store filters to controller
     
     - parameter filters: store filter items display in drop down
     */
    func setFilters (_ filters: [StoreFilter]?) {
        self.filters = filters
    }
    
    func selectSubcateogry (_ subcategory: StoreSubCategory) {
        selectedSubCategory = subcategory
    }
    
    func selectSort (_ sort: Sort) {
        selectedSort = sort
    }
    
    func hasFilterSelected () -> Bool {
        return selectedSwitchFilterId != nil && selectedSwitchFilterId!.count > 0 && selectedSelectionFilter != nil && selectedSelectionFilter!.count > 0
    }
    
    func isSwitchFilterSelected (id: Int) -> Bool {
        guard let ids = selectedSwitchFilterId else {
            return false
        }
        
        return ids.contains(id)
    }
    
    func isSelectionFilterOptionSelected (id: Int, optionId: Int) -> Bool {
        guard let dict = selectedSelectionFilter else {
            return false
        }
        
        return dict.contains(where: {
                key, values in
            
                return key == id && values.contains(optionId)
            })
    }
    
    func setSelectedFilters (switchFilterId: [Int]?, selectionFilterIds: [Int: [Int]]?) {
        selectedSwitchFilterId = switchFilterId
        selectedSelectionFilter = selectionFilterIds
    }
    
    func resetFilters () {
        selectedSwitchFilterId = nil
        selectedSelectionFilter = nil
    }
    
    func getUrlParams () -> [String: String]? {
        var urlparams: [String: String]? = nil
        
        if let subcategory = selectedSubCategory, let id = subcategory.id {
            if urlparams == nil {
                urlparams = [:]
            }
            urlparams!["t_id"] = "\(id)"
        }
        
        if let sort = selectedSort, let id = sort.id {
            if urlparams == nil {
                urlparams = [:]
            }
            urlparams!["sort_id"] = "\(id)"
        }
        
        if let switchs = selectedSwitchFilterId, let selections = selectedSelectionFilter {
            var result: [String] = []
            for id in 1...filters!.count {
                let filter = filters!.filter({$0.id! == id}).first!
                if filter.getFilterType() == .switcher {
                    let isOn = switchs.contains(id) ? "1" : "0"
                    result.append(isOn)
                } else {
                    var optionIdsStr = "0"
                    if let selected = selections.filter({$0.key == id}).first {
                        var optionResult: [String] = []
                        for optionId in 1...filter.options!.count {
                            let isOn = selected.value.contains(optionId) ? "1" : "0"
                            optionResult.append(isOn)
                        }
                        optionIdsStr = optionResult.joined()
                    } else {
                        optionIdsStr = String (repeating: "0", count: filter.options!.count)
                    }
                    result.append(optionIdsStr)
                }
            }
            
            if urlparams == nil {
                urlparams = [:]
            }
            urlparams!["flag"] = result.joined(separator: ",")
        }
        
        return urlparams
    }
}
