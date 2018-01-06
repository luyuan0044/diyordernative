//
//  StoreFilterOptionCell.swift
//  diyordernative
//
//  Created by Richard Lu on 2018-01-05.
//  Copyright © 2018 goopter. All rights reserved.
//

import UIKit

class StoreFilterOptionCell: UICollectionViewCell {

    static let key = "StoreFilterOptionCell"
    
    static let nib = UINib (nibName: key, bundle: nil)
    
    @IBOutlet weak var actionButton: UIButton!
    
    let defaultBackGroundColor = UIColor.groupTableViewBackground
    
    let selectedBackGroundColor = StoreCategoryControl.shared.themeColor
    
    let defaultTitleColor = UIColor.darkGray
    
    let selectedTitleColor = UIColor.white
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        actionButton.backgroundColor = defaultBackGroundColor
        actionButton.setTitleColor(UIColor.darkGray, for: .normal)
        actionButton.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        actionButton.titleLabel?.numberOfLines = 2
        actionButton.titleLabel?.minimumScaleFactor = 8
        actionButton.titleLabel?.textAlignment = .center
        actionButton.layer.cornerRadius = 5
    }
    
    func update (title: String?, isSelected: Bool) {
        actionButton.setTitle(title, for: .normal)
        
        let bColor = isSelected ? selectedBackGroundColor : defaultBackGroundColor
        actionButton.backgroundColor = bColor
        let titleColor = isSelected ? selectedTitleColor : defaultTitleColor
        actionButton.setTitleColor(titleColor, for: .normal)
    }
}
