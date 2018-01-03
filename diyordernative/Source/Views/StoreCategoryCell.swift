//
//  StoreCategoryCell.swift
//  diyordernative
//
//  Created by Yuan Lu on 2017-12-15.
//  Copyright © 2017 goopter. All rights reserved.
//

import UIKit

class StoreCategoryCell: UICollectionViewCell {
    
    // MARK: - Properties
    
    @IBOutlet weak var iconLabelButtonView: IconLabelButtonView!
    
    static let key = "StoreCategoryCell"
    
    static let nib = UINib (nibName: key, bundle: nil)
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    func update (storeCategory: StoreCategory) {
        iconLabelButtonView.update(item: storeCategory)
    }
}
