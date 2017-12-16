//
//  HotItem.swift
//  diyordernative
//
//  Created by Richard Lu on 2017-12-13.
//  Copyright © 2017 goopter. All rights reserved.
//

import Foundation
import ObjectMapper

class HotItem: Mappable {
    var storeCategory: Int?
    var groupId: String?
    var productId: Int?
    var price: Double?
    var specialPrice: Double?
    var startDateTime: String?
    var endDateTime: String?
    var name: String?
    var soldCount: Int?
    var rating: Double?
    var reviewCount: Int?
    var imageUrl: String?
    var stockQuantity: Int?
    var storeUrl: String?
    var storeName: String?
    var latitude: String?
    var longtitude: String?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        
    }
}
