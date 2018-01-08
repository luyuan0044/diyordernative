//
//  StoresViewControllerPopupViewSourceAndDelegate.swift
//  diyordernative
//
//  Created by Richard Lu on 2018-01-05.
//  Copyright © 2018 goopter. All rights reserved.
//

import Foundation
import UIKit

protocol StoreSubCategoryDataSourceAndDelegateDelegate {
    func onSubCategoryCellTapped (subcategory: StoreSubCategory)
    func onSortCelltapped (sort: Sort)
    func onSwitchFilterTapped (id: Int)
    func onSelectionFilterOptionTapped (id: Int, optionId: Int)
    func isSwitchFilterSelected (id: Int) -> Bool
    func isSelectionFilterOptionSelected (id: Int, optionId: Int) -> Bool
}

class StoresViewControllerPopupViewSourceAndDelegate: NSObject, UITableViewDataSource, UITableViewDelegate {
    
    var delegate: StoreSubCategoryDataSourceAndDelegateDelegate? = nil
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}
