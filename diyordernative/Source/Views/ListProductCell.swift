//
//  ListProductCell.swift
//  diyordernative
//
//  Created by Yuan Lu on 2017-12-17.
//  Copyright © 2017 goopter. All rights reserved.
//

import UIKit

class ListProductCell: UICollectionViewCell {
    
    static let key = "ListProductCell"
    
    static let nib = UINib (nibName: key, bundle: nil)
    
    let defaultImage = #imageLiteral(resourceName: "image_shopping_medium")
    
    @IBOutlet weak var productImageView: UIImageView!
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var storeNameLabel: UILabel!
    
    @IBOutlet weak var ratingImageView: UIImageView!
    
    @IBOutlet weak var currentPriceLabel: UILabel!
    
    @IBOutlet weak var priceLabel: UILabel!
    
    @IBOutlet weak var reviewCountLabel: UILabel!
    
    @IBOutlet weak var soldCountLabel: UILabel!
    
    @IBOutlet weak var discountPercentageLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        contentView.backgroundColor = UIColor.white
        
        productImageView.contentMode = .scaleAspectFit
        productImageView.clipsToBounds = true
        productImageView.image = defaultImage
        
        nameLabel.textColor = UIColor.darkGray
        
        storeNameLabel.textColor = UIColor.gray
        
        currentPriceLabel.textColor = UIConstants.appThemeColor
        
        priceLabel.textColor = UIColor.lightGray
        
        reviewCountLabel.textColor = UIColor.lightGray
        
        soldCountLabel.textColor = UIColor.lightGray
    }
    
    func update (hotItem: HotItem) {
        nameLabel.text = hotItem.name
        
        storeNameLabel.text = hotItem.storeName
        
        if let numberOfReviews = hotItem.reviewCount, numberOfReviews != 0 {
            reviewCountLabel.text = "(\(numberOfReviews))"
            reviewCountLabel.isHidden = false
        } else {
            reviewCountLabel.isHidden = true
        }
        
        if let soldCount = hotItem.soldCount, soldCount != 0 {
            soldCountLabel.text = "\(soldCount) sold"
            soldCountLabel.isHidden = false
        } else {
            soldCountLabel.isHidden = true
        }
        
        if let imageUrl = hotItem.imageUrl {
            let urlStr = ImageHelper.getFormattedImageUrl(imageId: imageUrl, size: productImageView.frame.size)!
            if let url = URL (string: urlStr) {
                productImageView.sd_setImage(with: url, placeholderImage: defaultImage)
            }
        }
        
        let price = hotItem.price != nil ? "\(hotItem.price!)" : "0"
        if hotItem.shouldInvokeSpecialPrice () {
            discountPercentageLabel.backgroundColor = UIColor.black.withAlphaComponent(0.6)
            discountPercentageLabel.isHidden = false
            discountPercentageLabel.text = " -\(Int(hotItem.getDiscountPercentage()))% "
            priceLabel.isHidden = false
            let priceAttributeString = NSAttributedString (string: price, attributes: [NSAttributedStringKey.strikethroughStyle : NSNumber(integerLiteral: NSUnderlineStyle.styleSingle.rawValue)])
            priceLabel.attributedText = priceAttributeString
            currentPriceLabel.text = "\(hotItem.specialPrice!)"
        } else {
            discountPercentageLabel.isHidden = true
            priceLabel.isHidden = true
            currentPriceLabel.text = price
        }
        
        ratingImageView.image = ImageHelper.getRatingStartImage(by: hotItem.rating).withRenderingMode(UIImageRenderingMode.alwaysTemplate)
        ratingImageView.tintColor = UIConstants.appThemeColor
    }
}
