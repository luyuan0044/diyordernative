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
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var addressLabel: UILabel!
    
    @IBOutlet weak var openHourLabel: UILabel!
    
    let defaultImage = StoreCategoryControl.shared.defaultStoreCategoryImageSmall
    
    var store: Store!
    
    // MARK: - Implementation
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        nameLabel.textColor = UIColor.black
        
        addressLabel.textColor = UIColor.black
        
        openHourLabel.textColor = UIColor.black
        
        contentView.backgroundColor = UIColor.white
    }
    
    func update (store: Store) {
        self.store = store
        
        nameLabel.text = store.name
        addressLabel.text = store.address
    }
}
