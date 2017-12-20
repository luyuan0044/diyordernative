//
//  ImageHelper.swift
//  diyordernative
//
//  Created by Richard Lu on 2017-12-14.
//  Copyright © 2017 goopter. All rights reserved.
//

import Foundation
import CoreGraphics
import UIKit

class ImageHelper {
    
    static func getFormattedImageUrl (imageId: String, size: CGSize) -> String? {
        return CloudinaryHelper.getUrl(imageId: imageId, size: size)
    }
    
    /**
     Get rating image , if the rating is nil will return defaul image
     
     - parameter rating: rating value of Float
     
     - returns: rating star image
     */
    static func getRatingStartImage (by rating: Float?) -> UIImage {
        if rating == nil {
            return #imageLiteral(resourceName: "icon_rating_star_0")
        }
        
        var ratingValue: Float = 0
        
        let floor = floorf(rating!)
        let ceiling = ceilf(rating!)
        
        let toFloor = rating! - floor
        let toCeiling = ceiling - rating!
        
        if toFloor > toCeiling {
            ratingValue = floor
        } else if toCeiling > toFloor {
            ratingValue = ceiling
        } else {
            ratingValue = rating!
        }
        
        let intRatingValue = Int(ratingValue * 10)
        
        let imageUrl = "icon_rating_star_\(intRatingValue)"
        if let image = UIImage (named: imageUrl) {
            return image
        }
        
        return #imageLiteral(resourceName: "icon_rating_star_0")
    }
}
