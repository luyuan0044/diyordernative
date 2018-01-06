//
//  StoreFilterDataSourceAndDelegate.swift
//  diyordernative
//
//  Created by Richard Lu on 2018-01-05.
//  Copyright © 2018 goopter. All rights reserved.
//

import Foundation
import UIKit

class StoreFilterDataSourceAndDelegate: StoresViewControllerPopupViewSourceAndDelegate {
    
    var switchFitlers: [StoreFilter]? = nil
    
    var selectionFilters: [StoreFilter]? = nil
    
    private var numberOfRows = 0
    
    override init() {
        super.init()
    }
    
    func setSource (filters: [StoreFilter]?) {
        guard let fts = filters else {
            return
        }
        
        switchFitlers = fts.filter({$0.getFilterType() == .switcher})
        selectionFilters = fts.filter({$0.getFilterType() == .mutiSelect || $0.getFilterType() == .singleSelect})
        if switchFitlers != nil {
            numberOfRows += 1
        }
        if selectionFilters != nil {
            numberOfRows += selectionFilters!.count
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return numberOfRows
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: StoreFilterCell.key) as! StoreFilterCell
        
        if indexPath.row == 0 && switchFitlers != nil {
            cell.setSwitchFilters(switchFitlers!)
        } else {
            let dataOffset = switchFitlers == nil ? 0 : 1
            let selectionFilter = selectionFilters![indexPath.row - dataOffset]
            cell.setSelectionFilter(selectionFilter)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UIConstants.tableViewDefaultCellHeight
    }
}

extension StoreFilterDataSourceAndDelegate {
    
}
