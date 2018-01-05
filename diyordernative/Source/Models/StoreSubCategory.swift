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
    var parentId: Int?
    var name: String?
    var imageUrl: String?
    var level: Int?
    var children: [StoreSubCategory]?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        self.id <- map["id"]
        self.parentId <- map["parent_id"]
        self.name <- map["name"]
        self.imageUrl <- map["img"]
        self.level <- map["level"]
        self.children <- map["children"]
    }
}

extension StoreSubCategory: IconLabelButtonViewItem {
    func getId() -> Int? {
        return id
    }
    
    func getImageUrl() -> String? {
        return imageUrl
    }
    
    func getTitleText() -> String? {
        return name
    }
}
