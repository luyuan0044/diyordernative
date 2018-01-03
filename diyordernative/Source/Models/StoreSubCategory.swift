//
//  StoreSubCategory.swift
//  diyordernative
//
//  Created by Richard Lu on 2018-01-02.
//  Copyright © 2018 goopter. All rights reserved.
//

import Foundation
import ObjectMapper

class StoreSubCategory: Mappable {
    var id: Int?
    var name: String?
    var image: String?
    var level: Int?
    var children: [StoreSubCategory]?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        self.id <- map["id"]
        self.name <- map["name"]
        self.image <- map["img"]
        self.level <- map["level"]
        self.children <- map["children"]
    }
}
