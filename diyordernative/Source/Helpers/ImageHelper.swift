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
    
    static func getRatingStartImage (by rating: Int?) -> UIImage {
        if rating == nil {
            return #imageLiteral(resourceName: "icon_rating_star_0")
        }
        
        let imageUrl = "icon_rating_star_\(rating!)"
        if let image = UIImage (named: imageUrl) {
            return image
        }
        
        return #imageLiteral(resourceName: "icon_rating_star_0")
    }
}
