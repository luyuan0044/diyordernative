//
//  StoreDetail.swift
//  diyordernative
//
//  Created by Richard Lu on 2018-01-02.
//  Copyright © 2018 goopter. All rights reserved.
//

import Foundation
import ObjectMapper

class StoreDetail: Mappable {
    var phoneNumber: String?
    var openHours: String?
    var deliveryHours: String?
    var description: String?
    var images: [String]?
    var timezone: String?
    var website: String?
    var flags: [Float]?
    var shippingFlags: [Bool]?
    var paymentFlags: [Bool]?
    var discountInfo: String?
    var publicAnnouncement: String?
    var shouldPagination: Int?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        self.phoneNumber <- map["phone"]
        self.openHours <- map["hours"]
        self.deliveryHours <- map["dh"]
        self.description <- map["desc"]
        self.images <- map["imgs"]
        self.timezone <- map["tz"]
        self.website <- map["url"]
        self.flags <- map["flg"]
        self.shippingFlags <- map["sflg"]
        self.paymentFlags <- map["pflg"]
        self.discountInfo <- map["di"]
        self.publicAnnouncement <- map["pa"]
        self.shouldPagination <- map["pagination"]
    }
}
