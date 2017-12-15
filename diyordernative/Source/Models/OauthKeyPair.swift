//
//  OauthKeyPair.swift
//  GoopterBiz
//
//  Created by Yuan Lu on 2017-05-12.
//  Copyright © 2017 Goopter Holdings Ltd. (http://www.goopter.com)
//

import Foundation
import ObjectMapper

class OauthKeyPair : Mappable {
    
    //Properties
    var token: String?
    var tokenSecret: String?
    
    required init(map: Map) {
        
    }
    
    func mapping(map: Map) {
        token <- map["token"]
        tokenSecret <- map["secret"]
    }
}
