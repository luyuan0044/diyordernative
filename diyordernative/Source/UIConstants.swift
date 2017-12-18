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
    private static let rgbRatio: CGFloat = 255.0
    
    static let appThemeColor: UIColor = UIColor(red: 204 / rgbRatio, green: 43 / rgbRatio, blue: 0 / rgbRatio, alpha: 1)
    
    static let restaurantThemeColor: UIColor = UIColor(red: 246 / rgbRatio, green: 140 / rgbRatio, blue: 25 / rgbRatio, alpha: 1)
    
    static let transparentBlackColor: UIColor = UIColor.white.withAlphaComponent(0.6)
}
