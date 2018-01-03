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
    
    @IBOutlet weak var contentTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.title = titleText
        
        contentTableView.register(StoreSubCategoryHeaderView.nib, forHeaderFooterViewReuseIdentifier: StoreSubCategoryHeaderView.key)
        
        contentTableView.dataSource = self
        contentTableView.delegate = self
        
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
                
                taskGroup.leave()
            })
        }
        
        DispatchQueue.global(qos: .userInitiated).async {
            taskGroup.enter()
            StoreFilterSorterManager.sharedOf(type: self.storeCategory).loadFilterSubCategoies(completion: {
                status, filterSubcategories in
                
                taskGroup.leave()
            })
        }
        
        DispatchQueue.global(qos: .userInitiated).async {
            taskGroup.enter()
            StoreFilterSorterManager.sharedOf(type: self.storeCategory).loadSortItems(completion: {
                status, sorts in
                
                taskGroup.leave()
            })
        }
        
        DispatchQueue.global(qos: .userInitiated).async {
            taskGroup.enter()
            StoreFilterSorterManager.sharedOf(type: self.storeCategory).loadFilterItems(completion: {
                status, filters in
                
                taskGroup.leave()
            })
        }
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
            var header = tableView.dequeueReusableCell(withIdentifier: StoreSubCategoryHeaderView.key) as! StoreSubCategoryHeaderView
            
            return header
        } else {
            let header = UIView()
            
            return header
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
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
