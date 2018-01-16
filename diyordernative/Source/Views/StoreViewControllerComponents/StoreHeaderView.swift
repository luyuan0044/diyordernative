//
//  StoreHeaderView.swift
//  diyordernative
//
//  Created by Richard Lu on 2018-01-16.
//  Copyright © 2018 goopter. All rights reserved.
//

import UIKit

class StoreHeaderView: UITableViewHeaderFooterView {

    // MARK: - Properties
    
    static let key = "StoreHeaderView"
    
    static let nib = UINib (nibName: key, bundle: nil)
    
    @IBOutlet weak var storeIconImageView: UIImageView!
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var addressLabel: UILabel!
    
    @IBOutlet weak var openHourLabel: UILabel!
    
    let defaultImage = StoreCategoryControl.shared.defaultStoreCategoryImageSmall
    
    var store: Store!
    
    // MARK: - Implementation
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        backgroundColor = UIColor.clear
        contentView.backgroundColor = UIColor.clear
        
        nameLabel.textColor = UIColor.white
        
        addressLabel.textColor = UIColor.white
        
        openHourLabel.textColor = UIColor.white
        
        storeIconImageView.contentMode = .scaleAspectFit
        storeIconImageView.layer.cornerRadius = 5
        storeIconImageView.clipsToBounds = true
        storeIconImageView.image = defaultImage
    }
    
    func update (store: Store) {
        self.store = store
        
        nameLabel.text = store.name
        addressLabel.text = store.address
        
        if let imageUrl = store.imageUrl {
            let urlStr = ImageHelper.getFormattedImageUrl(imageId: imageUrl, size: storeIconImageView.frame.size)!
            if let url = URL (string: urlStr) {
                storeIconImageView.sd_setImage(with: url, placeholderImage: defaultImage)
            }
        }
    }
}
