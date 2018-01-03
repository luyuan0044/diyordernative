//
//  StoreSubCategoryHeaderView.swift
//  diyordernative
//
//  Created by Richard Lu on 2018-01-02.
//  Copyright © 2018 goopter. All rights reserved.
//

import UIKit

class StoreSubCategoryHeaderView: UITableViewHeaderFooterView {
    
    //MARK: - Properties
    
    static let key = "StoreSubCategoryHeaderView"
    
    static let nib = UINib (nibName: key, bundle: nil)
    
    @IBOutlet weak var subCategoryScrollView: UIScrollView!
    
    var subcategories: [StoreSubCategory]?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setSource (subcategories: [StoreSubCategory]) {
        self.subcategories = subcategories
    }
}
