//
//  StoreFilterHeaderView.swift
//  diyordernative
//
//  Created by Richard Lu on 2018-01-11.
//  Copyright © 2018 goopter. All rights reserved.
//

import UIKit

class StoreFilterHeaderView: UICollectionReusableView {
    
    static let key = "StoreFilterHeaderView"
    
    static let nib = UINib (nibName: key, bundle: nil)

    @IBOutlet weak var titleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        titleLabel.textColor = UIColor.darkGray
        titleLabel.font = UIFont.systemFont(ofSize: 14)
    }
    
    func update (titleText: String?) {
        titleLabel.text = titleText
    }
}
