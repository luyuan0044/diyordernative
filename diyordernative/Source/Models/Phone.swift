//
//  Phone.swift
//  diyordernative
//
//  Created by Richard Lu on 2017-12-21.
//  Copyright © 2017 goopter. All rights reserved.
//

import Foundation
import ObjectMapper

class Phone: Mappable {
    var countryCode: String?
    var number: String?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        self.countryCode <- map["countryCode"]
        self.number <- map["number"]
    }
}
