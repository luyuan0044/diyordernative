//
//  Store.swift
//  diyordernative
//
//  Created by Richard Lu on 2018-01-02.
//  Copyright © 2018 goopter. All rights reserved.
//

import Foundation
import ObjectMapper

class Store: Mappable, Pagingable {
    var id: String?
    var storeCategoryIds: [Int]?
    var name: String?
    var latitude: Double?
    var longitude: Double?
    var rating: Float?
    var costLevel: Int?
    var meta: String?
    var imageUrl: String?
    var languages: [String]?
    var address: String?
    var menuIds: [String]?
    var displayStyle: Int?
    var pricePlan: Int?
    var detail: StoreDetail?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        self.id <- map["gid"]
        self.storeCategoryIds <- map["cids"]
        self.name <- map["nm"]
        self.latitude <- map["lat"]
        self.longitude <- map["lon"]
        self.rating <- map["rnk"]
        self.costLevel <- map["clv"]
        self.meta <- map["mt"]
        self.imageUrl <- map["iurl"]
        self.languages <- map["lans"]
        self.address <- map["adr"]
        self.menuIds <- map["ml"]
        self.displayStyle <- map["df"]
        self.pricePlan <- map["pp"]
        self.detail <- map["store_detail"]
    }
}

extension Store: IMapAnnotation {
    func getId () -> String {
        return self.id!
    }
    
    func getImageUrl () -> String? {
        return self.imageUrl
    }
    
    func getName() -> String? {
        return self.name
    }
    
    func getLatitude() -> Double? {
        return self.latitude
    }
    
    func getLongitude() -> Double? {
        return self.longitude
    }
}
