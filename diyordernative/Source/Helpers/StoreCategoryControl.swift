//
//  StoreCategoryControl.swift
//  diyordernative
//
//  Created by Richard Lu on 2018-01-03.
//  Copyright © 2018 goopter. All rights reserved.
//

import Foundation
import UIKit

class StoreCategoryControl {
    
    static var shared: StoreCategoryControl {
        return _shared
    }
    
    private static let _shared = StoreCategoryControl()
    
    private init() { }
    
    // MARK: - Properties
    
    private(set) var currentStoreCategory: storeCategoryType? = nil
    
    private let defaultImageFormat = "image_%@_"
    
    private let smallImageSuffix = "small"
    
    private let mediumImageSuffix = "medium"
    
    private let largeImageSuffix = "large"
    
    var defaultStoreCategoryImageSmall: UIImage {
        get {
            guard let storecategory = currentStoreCategory else {
                return #imageLiteral(resourceName: "image_restaurant_small")
            }
            
            let filename = String (format: defaultImageFormat, arguments: ["\(storecategory)"]) + smallImageSuffix
            if let image = UIImage (named: filename) {
                return image
            }
            
            return #imageLiteral(resourceName: "image_restaurant_small")
        }
    }
    
    var defaultStoreCategoryImageMedium: UIImage {
        get {
            guard let storecategory = currentStoreCategory else {
                return #imageLiteral(resourceName: "image_restaurant_medium")
            }
            
            let filename = String (format: defaultImageFormat, arguments: ["\(storecategory)"]) + mediumImageSuffix
            if let image = UIImage (named: filename) {
                return image
            }
            
            return #imageLiteral(resourceName: "image_restaurant_medium")
        }
    }
    
    var defaultStoreCategoryImageLarge: UIImage {
        get {
            guard let storecategory = currentStoreCategory else {
                return #imageLiteral(resourceName: "image_restaurant_large")
            }
            
            let filename = String (format: defaultImageFormat, arguments: ["\(storecategory)"]) + largeImageSuffix
            if let image = UIImage (named: filename) {
                return image
            }
            
            return #imageLiteral(resourceName: "image_restaurant_large")
        }
    }
    
    var themeColor: UIColor {
        get {
            guard let storecategory = currentStoreCategory else {
                return UIConstants.appThemeColor
            }
            
            switch storecategory {
            case .restaurant:
                return UIConstants.restaurantThemeColor
            case .groupsale:
                return UIConstants.groupsaleThemeColor
            case .travel:
                return UIConstants.travelThemeColor
            case .service:
                return UIConstants.serviceThemeColor
            case .shopping:
                return UIConstants.shoppingThemeColor
            }
        }
    }
    
    // MARK: - Implementation
    
    func enterStoreCategory (_ storeCategoryType: storeCategoryType) {
        self.currentStoreCategory = storeCategoryType
    }
    
    func resetStoreCategory () {
        self.currentStoreCategory = nil
    }
}
