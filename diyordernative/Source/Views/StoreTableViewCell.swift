//
//  StoreTableViewCell.swift
//  diyordernative
//
//  Created by Richard Lu on 2018-01-03.
//  Copyright © 2018 goopter. All rights reserved.
//

import UIKit

class StoreTableViewCell: UITableViewCell {
    
    static let key = "StoreTableViewCell"
    
    static let nib = UINib (nibName: key, bundle: nil)
    
    var defaultImage: UIImage {
        get {
            return StoreCategoryControl.shared.defaultStoreCategoryImageSmall
        }
    }
    
    @IBOutlet weak var iconImageView: UIImageView!
    
    @IBOutlet weak var storeNameLabel: UILabel!
    
    @IBOutlet weak var ratingImageView: UIImageView!
    
    @IBOutlet weak var addressLabel: UILabel!
    
    @IBOutlet weak var metaLabel: UILabel!
    
    @IBOutlet weak var distanceLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        iconImageView.contentMode = .scaleAspectFit
        iconImageView.layer.cornerRadius = 5
        iconImageView.clipsToBounds = true
        iconImageView.image = defaultImage
        
        storeNameLabel.textColor = UIColor.darkGray
        
        addressLabel.textColor = UIColor.gray
        metaLabel.textColor = UIColor.gray
        distanceLabel.textColor = UIColor.gray
        distanceLabel.isHidden = !LocationHelper.shared.isLocationAvaliable
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func update (store: Store) {
        storeNameLabel.text = store.name
        addressLabel.text = store.address
        metaLabel.text = store.meta
        
        if let lat = store.latitude, let lon = store.longitude, let distance = LocationHelper.shared.getDistanceToCurrentLocation(lat: lat, lon: lon) {
            
            if distance < 1000 {
                distanceLabel.text = String (format: "%.0f%@", distance, LanguageControl.shared.getLocalizeString(by: "metre"))
            } else {
                let distanceInKM = distance / 1000
                if distanceInKM < 100 {
                    distanceLabel.text = String (format: "%.2f%@", distanceInKM, LanguageControl.shared.getLocalizeString(by: "kilometre"))
                } else {
                    distanceLabel.text = ">100" + LanguageControl.shared.getLocalizeString(by: "kilometre")
                }
            }
        } else {
            distanceLabel.isHidden = true
        }
        
        if let imageUrl = store.imageUrl {
            let urlStr = ImageHelper.getFormattedImageUrl(imageId: imageUrl, size: iconImageView.frame.size)!
            if let url = URL (string: urlStr) {
                iconImageView.sd_setImage(with: url, placeholderImage: defaultImage)
            }
        }
    }
}
