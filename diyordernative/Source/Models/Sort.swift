//
//  Sort.swift
//  diyordernative
//
//  Created by Richard Lu on 2017-12-19.
//  Copyright © 2017 goopter. All rights reserved.
//

import Foundation
import ObjectMapper

class Sort: Mappable {
    var id: Int?
    var name: String?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        self.id <- map["id"]
        self.name <- map["name"]
    }
}
