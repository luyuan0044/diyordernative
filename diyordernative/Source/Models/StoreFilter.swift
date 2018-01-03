//
//  StoreFilter.swift
//  diyordernative
//
//  Created by Richard Lu on 2018-01-02.
//  Copyright © 2018 goopter. All rights reserved.
//

import Foundation
import ObjectMapper

class StoreFilter: Mappable {
    
    var id: Int?
    var type: Int?
    var name: String?
    var options: [StoreFilterOption]?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        self.id <- map["id"]
        self.type <- map["type"]
        self.name <- map["name"]
        self.options <- map["options"]
    }
}

class StoreFilterOption: Mappable {
    
    var id: Int?
    var name: String?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        self.id <- map["value"]
        self.name <- map["name"]
    }
}
