//
//  ApiResponse.swift
//  diyordernative
//
//  Created by Richard Lu on 2017-12-13.
//  Copyright © 2017 goopter. All rights reserved.
//

import Foundation
import ObjectMapper

class ApiResponse<T : Mappable>: BaseApiResponse {
    var records: T?
    
    required init?(map: Map) {
        super.init(map: map)
    }
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        
        self.records <- map["records"]
    }
}
