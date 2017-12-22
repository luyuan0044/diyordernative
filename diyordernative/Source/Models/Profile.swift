//
//  Profile.swift
//  diyordernative
//
//  Created by Richard Lu on 2017-12-21.
//  Copyright © 2017 goopter. All rights reserved.
//

import Foundation
import ObjectMapper

class Profile: Mappable {
    var id: Int?
    var firstName: String?
    var lastName: String?
    var nickName: String?
    var countryCode: String?
    var dob: String?
    var gender: Int?
    var email: String?
    var phone: Phone?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        self.id <- map["user_id"]
        self.firstName <- map["first_name"]
        self.lastName <- map["last_name"]
        self.nickName <- map["nick_name"]
        self.countryCode <- map["country_code"]
        self.dob <- map["date_of_birth"]
        self.gender <- map["gender"]
        self.email <- map["email"]
        self.phone <- map["phone"]
    }
}
