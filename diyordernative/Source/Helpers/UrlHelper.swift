//
//  UrlHelper.swift
//  diyordernative
//
//  Created by Richard Lu on 2017-12-14.
//  Copyright © 2017 goopter. All rights reserved.
//

import Foundation
import CoreLocation

class UrlHelper {
    
    /**
     Get string of formatted url params which can be appended at the end of url string
     
     - parameter urlparams: Dictionary of urlparams
     */
    static func getFormattedUrlParams (urlparams: [String:String]) -> String {
        var result = ""
        
        for (key, value) in urlparams {
            if result.isEmpty {
                result.append("?\(key)=\(value)")
            }
            else {
                result.append("&\(key)=\(value)")
            }
        }
        
        return result
    }
    
    /**
     Get string of formatted latitude and longtitude in string for api use
     
     - parameter coordinate: CLLocationCoordinate2D
     
     - returns: latitude and longtitude in string format
     */
    static func getFormattedUrlLatAndLon (coordinate: CLLocationCoordinate2D?) -> String? {
        guard coordinate != nil else {
            return nil
        }
        
        return "\(coordinate!.latitude),\(coordinate!.longitude)"
    }
}
