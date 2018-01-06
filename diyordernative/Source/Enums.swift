//
//  Enums.swift
//  diyordernative
//
//  Created by Richard Lu on 2017-12-14.
//  Copyright © 2017 goopter. All rights reserved.
//

import Foundation

enum apiStatus: Int {
    case networkConnectionFailure   = -2
    case timeout                    = -1
    case unknownError               = 0
    
    case newAccount                 = 5
    case serverDBError              = 42
    
    case success                    = 200
    case noData                     = 204
    
    case accountLocked              = 243
    
    case emailNotConfirmed          = 303
    
    case invalidRequest             = 400
    case accessDenied               = 401
    case forbidden                  = 403
    case sourceNotFound             = 404
    
    case expired                    = 408
    case tooManyRequest             = 429
    case alreadyExist               = 452
    case authenticationFailure      = 4011
    
    case internalServerError        = 500
    
    case itemOutOfStock             = 1000
}

enum colletionViewDisplayStyle {
    case grid
    case list
}

enum hotItemSortType: String {
    case list = "List"
    case tab = "Tab"
}

enum storeCategoryType: Int {
    case restaurant = 1
    case groupsale
    case travel
    case shopping
    case service
}

enum storeFilterType: Int {
    case switcher = 1
    case mutiSelect
    case singleSelect
}
