//
//  StoreSortDataSourceAndDelegate.swift
//  diyordernative
//
//  Created by Richard Lu on 2018-01-05.
//  Copyright © 2018 goopter. All rights reserved.
//

import Foundation
import UIKit

class StoreSortDataSourceAndDelegate: StoresViewControllerPopupViewSourceAndDelegate {
    
    var sorts: [Sort]? = nil
    
    private var selectedSort: Sort? = nil
    
    override init() {
        super.init()
    }
    
    // MARK: - Implementation
    
    /**
     Set store sorts and selected sort
     
     - parameter sorts: all stores sorts
     - parameter selectedSort: selected store sort
     */
    func setSource (sorts: [Sort]?, selectedSort: Sort?) {
        self.sorts = sorts
        self.selectedSort = selectedSort
    }
    
    /**
     Set selected sort
     
     - parameter selectedSort: selected store sort
     */
    func setSelectedSort (selectedSort: Sort?) {
        self.selectedSort = selectedSort
    }
    
    // MARK: - UITableViewSource
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sorts == nil ? 0 : sorts!.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "SortCell")
        
        if cell == nil {
            cell = UITableViewCell (style: .default, reuseIdentifier: "SortCell")
        }
        
        let sort = sorts![indexPath.row]
        
        cell!.textLabel?.text = sort.name
        cell!.textLabel?.textColor = UIColor.darkGray
        cell!.textLabel?.font = UIFont.systemFont(ofSize: 14)
        cell!.tintColor = StoreCategoryControl.shared.themeColor
        
        cell!.accessoryType = selectedSort != nil && sort.id == selectedSort?.id ? .checkmark : .none
        
        return cell!
    }
    
    // MARK: - UITableViewDelegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let sort = sorts![indexPath.row]
        delegate?.onSortCelltapped(sort: sort)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
