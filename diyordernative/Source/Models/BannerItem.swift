//
//  BannerItem.swift
//  diyordernative
//
//  Created by Richard Lu on 2017-12-13.
//  Copyright © 2017 goopter. All rights reserved.
//

import Foundation
import ObjectMapper

class BannerItem: Mappable {
    var groupId: Int?
    var productId: Int?
    var storeCategory: Int?
    var width: Int?
    var format: Int?
    var title: String?
    var rating: Int?
    var city: String?
    var imageUrl: String?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        self.groupId <- map["g_id"]
        self.productId <- map["p_id"]
        self.storeCategory <- map["c_id"]
        self.width <- map["width"]
        self.format <- map["f_id"]
        self.title <- map["name"]
        self.rating <- map["rank"]
        self.city <- map["city"]
        self.imageUrl <- map["img_url"]
    }
}
