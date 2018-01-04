//
//  UIConstants.swift
//  diyordernative
//
//  Created by Richard Lu on 2017-12-12.
//  Copyright © 2017 goopter. All rights reserved.
//

import Foundation
import CoreGraphics
import UIKit

struct UIConstants
{
    // MARK: - Colors
    
    private static let rgbRatio: CGFloat = 255.0
    
    static let appThemeColor = UIColor(red: 204 / rgbRatio, green: 43 / rgbRatio, blue: 0 / rgbRatio, alpha: 1)
    
    static let checkoutButtonColor = UIColor(red: 52 / rgbRatio, green: 152 / rgbRatio, blue: 219 / rgbRatio, alpha: 1)
    
    static let restaurantThemeColor = UIColor(red: 246 / rgbRatio, green: 140 / rgbRatio, blue: 25 / rgbRatio, alpha: 1)
    
    static let groupsaleThemeColor = UIColor(red: 46 / rgbRatio, green: 181 / rgbRatio, blue: 158 / rgbRatio, alpha: 1)
    
    static let travelThemeColor = UIColor(red: 122 / rgbRatio, green: 101 / rgbRatio, blue: 230 / rgbRatio, alpha: 1)
    
    static let serviceThemeColor = UIColor(red: 72 / rgbRatio, green: 138 / rgbRatio, blue: 230 / rgbRatio, alpha: 1)
    
    static let shoppingThemeColor = UIColor(red: 240 / rgbRatio, green: 80 / rgbRatio, blue: 48 / rgbRatio, alpha: 1)
    
    static let transparentBlackColor = UIColor.black.withAlphaComponent(0.6)
    
    static let generalLightBackgroundColor = UIColor(red: 240 / rgbRatio, green: 240 / rgbRatio, blue: 240 / rgbRatio, alpha: 1)
    
    // MARK: - Layout
    
    static let tableViewDefaultCellHeight: CGFloat = 46
}
