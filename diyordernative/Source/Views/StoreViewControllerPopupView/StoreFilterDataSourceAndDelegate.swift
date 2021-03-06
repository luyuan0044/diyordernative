//
//  StoreFilterDataSourceAndDelegate.swift
//  diyordernative
//
//  Created by Richard Lu on 2018-01-05.
//  Copyright © 2018 goopter. All rights reserved.
//

import Foundation
import UIKit

class StoreFilterDataSourceAndDelegate: StoresViewControllerPopupViewSourceAndDelegate, StoreFilterCellDelegate, StoreViewControllerPopupResetAndConfirmViewDelegate {
    var switchFitlers: [StoreFilter]? = nil
    
    var selectionFilters: [StoreFilter]? = nil
    
    private var selectedSwitchFilterIds: [Int]? = nil
    
    private var selectedSelectionFilterOptionIds: [Int: [Int]]? = nil
    
    override init() {
        super.init()
    }
    
    // MARK: - Implementation
    
    /**
     Set store filters
     
     - parameter sorts: all stores filters
     */
    func setSource (filters: [StoreFilter]?) {
        guard let fts = filters else {
            return
        }
        
        // seperate filters by type
        switchFitlers = fts.filter({$0.getFilterType() == .switcher})
        selectionFilters = fts.filter({$0.getFilterType() == .mutiSelect || $0.getFilterType() == .singleSelect})
    }
    
    /**
     Set switch type selected ids
     
     - parameter ids: switch type selected ids
     */
    func setSelectedSwitchFilterIds (_ ids: [Int]?) {
        selectedSwitchFilterIds = ids
    }
    
    /**
     Set selection type selected ids
     
     - parameter ids: selection type selected ids
     */
    func setSelectedSelectionFilterIds (_ ids: [Int: [Int]]?) {
        selectedSelectionFilterOptionIds = ids
    }
    
    /**
     Handle on switch filter selected.
     
     - parameter id: selected switch filter id
     */
    private func selectSwitchFilter (id: Int) {
        if !isSwitchSelected(id: id) {
            if selectedSwitchFilterIds == nil {
                selectedSwitchFilterIds = []
            }
            
            selectedSwitchFilterIds!.append(id)
        } else {
            if selectedSwitchFilterIds == nil {
                return
            }
            
            if let idx = selectedSwitchFilterIds!.index(of: id) {
                selectedSwitchFilterIds!.remove(at: idx)
            }
        }
    }
    
    /**
     Handle on selection filter selected
     
     - parameter id: selected switch filter id
     - parameter optionId: selected switch filter option id
     */
    private func selectSelectionFilter (id: Int, optionId: Int) {
        if !isSelectionSelected(id: id, optionId: optionId) {
            if selectedSelectionFilterOptionIds == nil {
                selectedSelectionFilterOptionIds = [:]
            }
            
            let filter = selectionFilters!.filter({$0.id! == id}).first!
            if filter.getFilterType() == .mutiSelect {
                if selectedSelectionFilterOptionIds!.keys.contains(id) {
                    var optionIds = selectedSelectionFilterOptionIds![id]!
                    optionIds.append(optionId)
                    selectedSelectionFilterOptionIds![id] = optionIds
                } else {
                    selectedSelectionFilterOptionIds![id] = [optionId]
                }
            } else {
                selectedSelectionFilterOptionIds![id] = [optionId]
            }
        } else {
            var optionIds = selectedSelectionFilterOptionIds![id]!
            if let idx = optionIds.index(of: optionId) {
                optionIds.remove(at: idx)
            }
            selectedSelectionFilterOptionIds![id] = optionIds
        }
    }
    
    /**
     Check switch filter of id is selected
     
     - parameter id: id of switch filter gonna check
     
     - returns: true if id of switch filter is selected
     */
    func isSwitchSelected (id: Int) -> Bool {
        guard let ids = selectedSwitchFilterIds else {
            return false
        }
        
        return ids.contains(id)
    }
    
    /**
     Check selected filter of id is selected
     
     - parameter id: id of selected filter gonna check
     
     - returns: true if id of selected filter is selected
     */
    func isSelectionSelected (id: Int, optionId: Int) -> Bool {
        guard let dict = selectedSelectionFilterOptionIds else {
            return false
        }
        
        return dict.contains(where: {
            key, values in
            
            return key == id && values.contains(optionId)
        })
    }
    
    // MARK: - UITableViewSource
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: StoreFilterCell.key) as! StoreFilterCell
        
        cell.setFilterSource(switchFilters: switchFitlers, selectionFilters: selectionFilters)
        cell.delegate = self
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UIConstants.tableViewDefaultCellHeight
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footer = tableView.dequeueReusableHeaderFooterView(withIdentifier: StoreViewControllerPopupResetAndConfirmView.key) as! StoreViewControllerPopupResetAndConfirmView
        
        footer.delegate = self
        
        return footer
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 50
    }
    
    //MARK: - StoreFilterCellDelegate
    
    func onSwitchFilterTapped(id: Int) {
        selectSwitchFilter(id: id)
    }
    
    func onSelectionFilterOptionTapped(id: Int, optionId: Int) {
        selectSelectionFilter(id: id, optionId: optionId)
    }
    
    func isSwitchFilterSelected(id: Int) -> Bool {
        return isSwitchSelected(id: id)
    }
    
    func isSelectionFilterOptionSelected(id: Int, optionId: Int) -> Bool {
        return isSelectionSelected(id: id, optionId: optionId)
    }
    
    // MARK: - StoreViewControllerPopupResetAndConfirmViewDelegate
    
    func onConfirmButtonTapped() {
        delegate?.onConfirmButtonTapped(switchFilterId: selectedSwitchFilterIds, selectionFilterIds: selectedSelectionFilterOptionIds)
    }
    
    func onResetButtonTapped() {
        delegate?.onResetButtonTapped()
    }
}
