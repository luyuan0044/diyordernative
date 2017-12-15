//
//  BannerItemCell.swift
//  diyordernative
//
//  Created by Richard Lu on 2017-12-14.
//  Copyright © 2017 goopter. All rights reserved.
//

import UIKit
import SDWebImage

class BannerItemCell: UICollectionViewCell {
    
    static let key = "BannerItemCell"
    
    static let nib = UINib (nibName: key, bundle: nil)
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var ratingImageView: UIImageView!
    
    @IBOutlet weak var cityLabel: UILabel!
    
    @IBOutlet weak var itemImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        titleLabel.textColor = UIColor.white
        cityLabel.textColor = UIColor.white
        
        itemImageView.clipsToBounds = true
        ratingImageView.clipsToBounds = true
    }
    
    func update (item: BannerItem)
    {
        titleLabel.text = item.title
        cityLabel.text = item.city
        
        let imageUrl = ImageHelper.getFormattedImageUrl (imageId: item.imageUrl!, size: itemImageView.frame.size)
        itemImageView.sd_setImage(with:URL (string: imageUrl!)!)
        
        let ratingImage = ImageHelper.getRatingStartImage (by: item.rating)
        ratingImageView.image = ratingImage
    }
}
