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
    
    let numberOfItemsPerPage: CGFloat = 5
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        subCategoryScrollView.backgroundColor = UIColor.lightGray
        subCategoryScrollView.bounces = false
        subCategoryScrollView.showsVerticalScrollIndicator = false
        subCategoryScrollView.showsHorizontalScrollIndicator = false
        subCategoryScrollView.isPagingEnabled = true
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    func setSource (subcategories: [StoreSubCategory]?) {
        self.subcategories = subcategories
        
        guard self.subcategories != nil else {
            return
        }
        
        //setup scroll view items
        let itemWidth = subCategoryScrollView.frame.width / numberOfItemsPerPage
        let itemHeight = subCategoryScrollView.frame.height
        
        subCategoryScrollView.contentSize = CGSize (width: itemWidth * CGFloat(self.subcategories!.count), height: 0)
        
        var offsetX: CGFloat = 0
        for subcategory in self.subcategories! {
            let iconLabelButtonView = IconLabelButtonView (frame: CGRect (x: offsetX, y: 0, width: itemWidth, height: itemHeight))
            iconLabelButtonView.update(item: subcategory)
            iconLabelButtonView.backgroundColor = UIColor.yellow
            subCategoryScrollView.addSubview(iconLabelButtonView)
            offsetX += itemWidth
        }
    }
}
