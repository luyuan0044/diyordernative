//
//  StoreCategory.swift
//  diyordernative
//
//  Created by Yuan Lu on 2017-12-15.
//  Copyright © 2017 goopter. All rights reserved.
//

import Foundation
import ObjectMapper

class StoreCategory: Mappable {
    var id: Int?
    var sequense: Int?
    var name: String?
    var imageUrl: String?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        self.id <- map["cid"]
        self.sequense <- map["seq"]
        self.name <- map["name"]
        self.imageUrl <- map["img"]
    }
}
