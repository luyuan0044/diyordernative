//
//  StoreSubCategoryDataSourceAndDelegate.swift
//  diyordernative
//
//  Created by Richard Lu on 2018-01-05.
//  Copyright © 2018 goopter. All rights reserved.
//

import Foundation
import UIKit

class StoreSubCategoryDataSourceAndDelegate: StoresViewControllerPopupViewSourceAndDelegate {
    
    var subcategories: [StoreSubCategory]? = nil
    
    var selectedSubcategory: StoreSubCategory? = nil
    
    override init() {
        super.init()
    }
    
    // MARK: - Implementation
    
    /**
     Set store subcategories and selected subcategories
     
     - parameter subcategories: all stores subcategories
     - parameter selectedSubcategory: selected store subcategory
     */
    func setSource (subcategories: [StoreSubCategory]?, selectedSubcategory: StoreSubCategory?) {
        self.subcategories = subcategories
        self.selectedSubcategory = selectedSubcategory
    }
    
    /**
     Set selected subcategories
     
     - parameter selectedSubcategory: selected store subcategory
     */
    func setSelectedSubCategory (selectedSubcategory: StoreSubCategory?) {
        self.selectedSubcategory = selectedSubcategory
    }
    
    // MARK: - UITableViewDataSource
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return subcategories == nil ? 0 : subcategories!.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "SubCategoryCell")
        
        if cell == nil {
            cell = UITableViewCell(style: .default, reuseIdentifier: "SubCategoryCell")
        }
        
        let subcategory = subcategories![indexPath.row]
        
        cell!.tintColor = StoreCategoryControl.shared.themeColor
        
        cell!.textLabel?.text = subcategory.name
        cell!.textLabel?.textColor = UIColor.darkGray
        cell!.textLabel?.font = UIFont.systemFont(ofSize: 14)
        
        let cellBackgroundColor = subcategory.id != nil
                                && selectedSubcategory != nil
                                && selectedSubcategory!.parentId != nil
                                && subcategory.id! == selectedSubcategory!.parentId!
                                && indexPath.row != 0
                                ? StoreCategoryControl.shared.themeColor.withAlphaComponent(0.2) : UIColor.white
        cell!.backgroundColor = cellBackgroundColor
        
        cell!.accessoryType = subcategory.children != nil && subcategory.children!.count > 0 ? .disclosureIndicator : .none
        if subcategory.children == nil || subcategory.children!.count == 0 {
            cell!.accessoryType = selectedSubcategory != nil && selectedSubcategory!.id == subcategory.id ? .checkmark : .none
        }
        
        return cell!
    }
    
    // MARK: - UITableViewDelegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let subcategory = subcategories![indexPath.row]
        
        tableView.visibleCells.forEach({
            cell in
            cell.backgroundColor = .white
        })
        let cell = tableView.cellForRow(at: indexPath)
        cell!.backgroundColor = StoreCategoryControl.shared.themeColor.withAlphaComponent(0.2)
        
        delegate?.onSubCategoryCellTapped(subcategory: subcategory)
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
