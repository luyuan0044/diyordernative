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
}
