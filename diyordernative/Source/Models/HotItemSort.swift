//
//  HotItemSort.swift
//  diyordernative
//
//  Created by Richard Lu on 2017-12-19.
//  Copyright © 2017 goopter. All rights reserved.
//

import Foundation
import ObjectMapper

class HotItemSort: Sort {
    var type: String?
    
    required init?(map: Map) {
        super.init(map: map)
    }
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        
        self.type <- map["type"]
    }
}
