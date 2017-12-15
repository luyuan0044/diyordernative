//
//  BaseApiResponse.swift
//  diyordernative
//
//  Created by Richard Lu on 2017-12-13.
//  Copyright © 2017 goopter. All rights reserved.
//

import Foundation
import ObjectMapper

class BaseApiResponse : Mappable {
    var rc: Int?
    var message: String?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        self.rc <- map["RC"]
        self.message <- map["msg"]
    }
}

extension BaseApiResponse {
    func getStatus () -> apiStatus {
        if self.rc == nil {
            return apiStatus.unknownError
        }
        
        var result = apiStatus (rawValue: self.rc!)
        
        if result == nil {
           result = apiStatus.unknownError
        }
        
        return result!
    }
}
