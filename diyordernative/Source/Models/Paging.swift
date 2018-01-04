//
//  Paging.swift
//  diyordernative
//
//  Created by Yuan Lu on 2018-01-03.
//  Copyright © 2018 goopter. All rights reserved.
//

import Foundation
import ObjectMapper

class Paging: Mappable {
    var page: Int?
    var end: Int?
    var start: Int?
    var limit: Int?
    var total: Int?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        self.page <- map["page"]
        self.end <- map["pageEnd"]
        self.start <- map["pageStart"]
        self.limit <- map["perPage"]
        self.total <- map["total"]
    }
}
