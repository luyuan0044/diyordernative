//
//  StoreFilterDataSourceAndDelegate.swift
//  diyordernative
//
//  Created by Richard Lu on 2018-01-05.
//  Copyright © 2018 goopter. All rights reserved.
//

import Foundation
import UIKit

class StoreFilterDataSourceAndDelegate: StoresViewControllerPopupViewSourceAndDelegate, StoreFilterCellDelegate {
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
        
        cell.delegate = self
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UIConstants.tableViewDefaultCellHeight
    }
    
    //MARK: - StoreFilterCellDelegate
    
    func onSwitchFilterTapped(id: Int) {
        delegate?.onSwitchFilterTapped(id: id)
    }
    
    func onSelectionFilterOptionTapped(id: Int, optionId: Int) {
        delegate?.onSelectionFilterOptionTapped(id: id, optionId: optionId)
    }
    
    func isSwitchFilterSelected(id: Int) -> Bool {
        return delegate?.isSwitchFilterSelected(id: id) ?? false
    }
    
    func isSelectionFilterOptionSelected(id: Int, optionId: Int) -> Bool {
        return delegate?.isSelectionFilterOptionSelected(id: id, optionId: optionId) ?? false
    }
}

extension StoreFilterDataSourceAndDelegate {
    
}
