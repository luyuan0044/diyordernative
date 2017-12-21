//
//  HotItemRightSlideTableViewMainDataSourceAndDelegate.swift
//  diyordernative
//
//  Created by Yuan Lu on 2017-12-19.
//  Copyright © 2017 goopter. All rights reserved.
//

import Foundation
import UIKit

class HotItemRightSlideTableViewMainDataSourceAndDelegate: NSObject, UITableViewDataSource, UITableViewDelegate, FilterPriceRangeCellDelegate {
    
    var selectedCategoryTitle: String?
    
    var hasChildren: Bool = false
    
    var delegate: HotItemRightSlideTableViewMainDataSourceAndDelegateDelegate? = nil
    
    // MARK: - UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            var cell = tableView.dequeueReusableCell(withIdentifier: FilterPriceRangeCell.key) as? FilterPriceRangeCell
            
            if cell == nil {
                cell = FilterPriceRangeCell.create()
            }
            
            cell!.update(priceRange: delegate?.getPriceRangeSetting())
            cell!.delegate = self
            
            return cell!
        } else {
            var cell = tableView.dequeueReusableCell(withIdentifier: "CategorySelectionCell")
            
            if cell == nil {
                cell = UITableViewCell (style: .value1, reuseIdentifier: "CategorySelectionCell")
            }
            
            cell!.textLabel?.text = LanguageControl.shared.getLocalizeString(by: "category")
            cell!.textLabel?.font = UIFont.systemFont(ofSize: 14)
            cell!.textLabel?.textColor = UIColor.darkGray
            
            cell!.detailTextLabel?.text = selectedCategoryTitle
            cell!.detailTextLabel?.font = UIFont.systemFont(ofSize: 14)
            cell!.detailTextLabel?.textColor = UIColor.lightGray
            
            cell!.accessoryType = hasChildren ? .disclosureIndicator : .none
            
            return cell!
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 1 {
            if hasChildren {
                delegate?.onCategoryCellTapped()
            }
            
            tableView.deselectRow(at: indexPath, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 46
    }
    
    // MARK: - FilterPriceRangeCellDelegate
    
    func onPriceRangeLowerBoundChanged(lower: String?) {
        delegate?.onPriceRangeLowerBoundChanged(lower: lower)
    }
    
    func onPriceRangeUpperBoundChanged(upper: String?) {
        delegate?.onPriceRangeUpperBoundChanged(upper: upper)
    }
}

protocol HotItemRightSlideTableViewMainDataSourceAndDelegateDelegate {
    func onCategoryCellTapped ()
    func onPriceRangeLowerBoundChanged (lower: String?)
    func onPriceRangeUpperBoundChanged (upper: String?)
    func getPriceRangeSetting () -> (String?, String?)?
}

