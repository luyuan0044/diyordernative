//
//  HotItemManager.swift
//  diyordernative
//
//  Created by Richard Lu on 2017-12-13.
//  Copyright © 2017 goopter. All rights reserved.
//

import Foundation

class HotItemManager {
    
    static let shared = { HotItemManager() } ()
    
    var filterManager: HotItemFilterManager
    
    init() {
        filterManager = HotItemFilterManager()
    }
}
