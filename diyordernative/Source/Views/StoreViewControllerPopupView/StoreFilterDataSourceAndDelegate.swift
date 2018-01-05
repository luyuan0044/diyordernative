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
    
    var filters: [StoreFilter]? = nil
    
    override init() {
        super.init()
    }
    
    func setSource (filters: [StoreFilter]?) {
        self.filters = filters
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filters == nil ? 0 : filters!.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
}
