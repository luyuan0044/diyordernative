//
//  HotItemRightSlideTableViewMainDataSourceAndDelegate.swift
//  diyordernative
//
//  Created by Yuan Lu on 2017-12-19.
//  Copyright © 2017 goopter. All rights reserved.
//

import Foundation
import UIKit

class HotItemRightSlideTableViewMainDataSourceAndDelegate: NSObject, UITableViewDataSource, UITableViewDelegate {
    
    var selectedCategoryTitle: String?
    
    var hasChildren: Bool = false
    
    var delegate: HotItemRightSlideTableViewMainDataSourceAndDelegateDelegate? = nil
    
    // MARK: - UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "CategorySelectionCell")
        
        if cell == nil {
            cell = UITableViewCell (style: .value1, reuseIdentifier: "CategorySelectionCell")
        }
        
        cell!.textLabel?.text = LanguageControl.shared.getLocalizeString(by: "category")
        cell!.textLabel?.font = UIFont.systemFont(ofSize: 14)
        cell!.textLabel?.textColor = UIColor.gray
        
        cell!.detailTextLabel?.text = selectedCategoryTitle
        cell!.detailTextLabel?.font = UIFont.systemFont(ofSize: 14)
        cell!.detailTextLabel?.textColor = UIColor.lightGray
        
        cell!.accessoryType = hasChildren ? .disclosureIndicator : .none
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if hasChildren {
            delegate?.onCategoryCellTapped()
        }
    }
}

