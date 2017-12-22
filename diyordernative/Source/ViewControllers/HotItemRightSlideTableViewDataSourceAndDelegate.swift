//
//  HotItemRightSlideTableViewDataSourceAndDelegate.swift
//  diyordernative
//
//  Created by Yuan Lu on 2017-12-19.
//  Copyright © 2017 goopter. All rights reserved.
//

import Foundation
import UIKit

protocol HotItemRightSlideTableViewDataSourceAndDelegateDelegate {
    func onHotItemCategoryCellTapped (hotItemCategory: HotItemCategory)
    func onBackCategoryHeaderTapped ()
    func getCurrentSelectedCategoryId () -> String?
    func getTemporySelectedCategoryId () -> String?
}

class HotItemRightSlideTableViewDataSourceAndDelegate: NSObject, UITableViewDataSource, UITableViewDelegate {
    
    var parentItem: HotItemCategory? = nil
    
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
        
        let currentSelectedId = delegate?.getCurrentSelectedCategoryId ()
        cell!.accessoryType = currentSelectedId == item.id ? .checkmark : .none
        
        return cell!
    }
    
    // MARK: - UITableViewDelegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = items![indexPath.row]
        
        delegate?.onHotItemCategoryCellTapped(hotItemCategory: item)
        
        let cell = tableView.cellForRow(at: indexPath)!
        let temporySelectedId = delegate?.getTemporySelectedCategoryId()
        cell.accessoryType = item.id == temporySelectedId ? .checkmark : .none
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        var view = tableView.dequeueReusableHeaderFooterView(withIdentifier: HotItemRightSlideTableViewHeaderView.key)
        
        if view == nil {
            view = HotItemRightSlideTableViewHeaderView.create()
        }
        
        (view as! HotItemRightSlideTableViewHeaderView).titleLabel.text = parentItem?.name ?? LanguageControl.shared.getLocalizeString(by: "category")
        (view as! HotItemRightSlideTableViewHeaderView).backButton.addTarget(self, action: #selector(onBackButtonTapped(_:)), for: .touchUpInside)
        
        return view!
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 44
    }
    
    @objc private func onBackButtonTapped (_ sender: UIButton) {
        delegate?.onBackCategoryHeaderTapped()
    }
}
