//
//  Utils.swift
//  diyordernative
//
//  Created by Yuan Lu on 2017-12-16.
//  Copyright © 2017 goopter. All rights reserved.
//

import Foundation

class Utils {
    /**
     Check given text is match regular expression
     
     - parameter regex: regular expression
     - parameter text: check match text
     
     - returns: is match or not
     */
    static func isMatch (regex: String, text: String) -> Bool {
        return text.range(of: regex, options: .regularExpression, range: nil, locale: nil) != nil
    }
}

extension Date {
    /**
     Check a 'Date' is between a specified date range.
     If any of start date or end date is nil, will return false
     
     - parameter lhs: lower bound of time rang
     - parameter rhs: upper bound of time range
     
     - returns: within range returns true, otherwise false
     */
    func isBetween (date lhs: Date?, and rhs: Date?) -> Bool {
        if lhs == nil || rhs == nil {
            return false
        }
        
        return lhs!.compare(self).rawValue * self.compare(rhs!).rawValue >= 0
    }
}
