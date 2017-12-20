//
//  HotItemRightSlideTableViewDataSourceAndDelegate.swift
//  diyordernative
//
//  Created by Yuan Lu on 2017-12-19.
//  Copyright © 2017 goopter. All rights reserved.
//

import Foundation
import UIKit

class HotItemRightSlideTableViewDataSourceAndDelegate: NSObject, UITableViewDataSource, UITableViewDelegate {
    
    var items: [HotItemCategory]? = nil
    
    var delegate: HotItemRightSlideTableViewDataSourceAndDelegateDelegate?
    
    // MARK: - UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items!.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "HotItemCategoryCell")
        
        if cell == nil {
            cell = UITableViewCell (style: .default, reuseIdentifier: "HotItemCategoryCell")
        }
        
        let item = items![indexPath.row]
        
        cell!.textLabel?.text = item.name
        cell!.textLabel?.textColor = UIColor.gray
        cell!.textLabel?.font = UIFont.systemFont(ofSize: 14)
        cell!.accessoryType = item.hasChildren() ? .disclosureIndicator : .none
        
        return cell!
    }
    
    // MARK: - UITableViewDelegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = items![indexPath.row]
        
        delegate?.onHotItemCategoryCellTapped(hotItemCategory: item)
    }
}
