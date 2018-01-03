//
//  StoresViewController.swift
//  diyordernative
//
//  Created by Richard Lu on 2018-01-02.
//  Copyright © 2018 goopter. All rights reserved.
//

import UIKit

class StoresViewController: BaseViewController, UITableViewDataSource, UITableViewDelegate {
    
    var storyCategoryId: Int!
    
    var storeCategory: storeCategoryType { get { return storeCategoryType (rawValue: storyCategoryId)! }}
    
    var titleText: String?
    
    var storeFilterSorterControl: StoreFilterSorterControl!
    
    let heightOfStoreSubCategoryItems: CGFloat = 75
    
    @IBOutlet weak var contentTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.title = titleText
        
        contentTableView.register(StoreSubCategoryHeaderView.nib, forHeaderFooterViewReuseIdentifier: StoreSubCategoryHeaderView.key)
        
        contentTableView.dataSource = self
        contentTableView.delegate = self
        
        storeFilterSorterControl = StoreFilterSorterControl()
        
        loadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Implementation
    
    func setStoreCategory (_ storeCategory: StoreCategory) {
        titleText = storeCategory.name
        storyCategoryId = storeCategory.id
    }
    
    private func loadData () {
        let taskGroup = DispatchGroup ()
        DispatchQueue.global(qos: .userInitiated).async {
            taskGroup.enter()
            StoreFilterSorterManager.sharedOf(type: self.storeCategory).loadSubCategories(completion: {
                status, subcategories in
                
                self.storeFilterSorterControl.setSubcategories(subcategories)
                
                taskGroup.leave()
            })
        }
        
        DispatchQueue.global(qos: .userInitiated).async {
            taskGroup.enter()
            StoreFilterSorterManager.sharedOf(type: self.storeCategory).loadFilterSubCategoies(completion: {
                status, filterSubcategories in
                
                self.storeFilterSorterControl.setFilterSubcategories(filterSubcategories)
                
                taskGroup.leave()
            })
        }
        
        DispatchQueue.global(qos: .userInitiated).async {
            taskGroup.enter()
            StoreFilterSorterManager.sharedOf(type: self.storeCategory).loadSortItems(completion: {
                status, sorts in
                
                self.storeFilterSorterControl.setSorts(sorts)
                
                taskGroup.leave()
            })
        }
        
        DispatchQueue.global(qos: .userInitiated).async {
            taskGroup.enter()
            StoreFilterSorterManager.sharedOf(type: self.storeCategory).loadFilterItems(completion: {
                status, filters in
                
                self.storeFilterSorterControl.setFilters(filters)
                
                taskGroup.leave()
            })
        }
        
        taskGroup.notify(queue: DispatchQueue.main, execute: {
            self.refreshData()
        })
    }
    
    func refreshData () {
        contentTableView.reloadData()
        contentTableView.layoutIfNeeded()
    }
    
    // MARK: - UITableViewDataSource
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 0
        } else {
            return 5
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 {
            let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: StoreSubCategoryHeaderView.key) as! StoreSubCategoryHeaderView
            
            header.setSource(subcategories: storeFilterSorterControl.subcategories)
            
            return header
        } else {
            let header = UIView()
            
            return header
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return storeFilterSorterControl.subcategories == nil || storeFilterSorterControl.subcategories?.count == 0 ? 0 : heightOfStoreSubCategoryItems
        }
        
        return 60
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
