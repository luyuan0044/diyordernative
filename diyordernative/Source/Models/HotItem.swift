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
    var rating: Float?
    var reviewCount: Int?
    var imageUrl: String?
    var stockQuantity: Int?
    var storeUrl: String?
    var storeName: String?
    var latitude: String?
    var longtitude: String?
    var currency: Int?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        self.storeCategory <- map["cid"]
        self.groupId <- map["gid"]
        self.productId <- map["pid"]
        self.price <- map["pc"]
        self.specialPrice <- map["spc"]
        self.startDateTime <- map["sdt"]
        self.endDateTime <- map["edt"]
        self.name <- map["nm"]
        self.soldCount <- map["scnt"]
        self.rating <- map["rat"]
        self.reviewCount <- map["rcnt"]
        self.imageUrl <- map["iurl"]
        self.stockQuantity <- map["sq"]
        self.storeUrl <- map["url"]
        self.storeName <- map["snm"]
        self.latitude <- map["lat"]
        self.longtitude <- map["lon"]
        self.currency <- map["cc"]
    }
}

extension HotItem {
    private static let specialPriceStartAndEndDateFormat = "yyyy/mm/dd HH:mm:ss"
    
    func hasSpecialPriceProvide () -> Bool {
        return self.specialPrice != nil && self.specialPrice! * 100 != 0
    }
    
    func getSpecialPriceStartDate () -> Date? {
        if self.startDateTime == nil { return nil }
        
        let dateFormatter = DateFormatter ()
        dateFormatter.dateFormat = HotItem.specialPriceStartAndEndDateFormat
        
        return dateFormatter.date(from: self.startDateTime!)
    }
    
    func getSpecialPriceEndDate () -> Date? {
        if self.endDateTime == nil { return nil }
        
        let dateFormatter = DateFormatter ()
        dateFormatter.dateFormat = HotItem.specialPriceStartAndEndDateFormat
        
        return dateFormatter.date(from: self.endDateTime!)
    }
    
    func shouldInvokeSpecialPrice () -> Bool {
        let startDate = getSpecialPriceStartDate()
        let endDate = getSpecialPriceEndDate()
        
        let currentDate = Date()
        
        return hasSpecialPriceProvide() && currentDate.isBetween(date: startDate, and: endDate)
    }
    
    func getDiscountPercentage () -> Double {
        if hasSpecialPriceProvide() { return 0 }
        
        return (price! - specialPrice!) / price! * 100
    }
}
