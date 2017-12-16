//
//  HotItemCategory.swift
//  diyordernative
//
//  Created by Richard Lu on 2017-12-15.
//  Copyright © 2017 goopter. All rights reserved.
//

import Foundation
import ObjectMapper

class HotItemCategory: Mappable {
    var id: Int?
    var name: String?
    var children: [HotItemCategory]?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        self.id <- map["id"]
        self.name <- map["name"]
        self.children <- map["children"]
    }
}
