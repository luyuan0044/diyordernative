//
//  StoresViewController.swift
//  diyordernative
//
//  Created by Richard Lu on 2018-01-02.
//  Copyright © 2018 goopter. All rights reserved.
//

import UIKit

class StoresViewController: BaseViewController,
                            UITableViewDataSource,
                            UITableViewDelegate,
                            TripleButtonHeaderViewDelegate,
                            StoreSubCategoryHeaderViewDelegate {
    
    var storyCategoryId: Int!
    
    var storeCategory: storeCategoryType { get { return storeCategoryType (rawValue: storyCategoryId)! }}
    
    var titleText: String?
    
    var storeListManager: StoreListManager!
    
    var storeFilterSorterManager: StoreFilterSorterManager!
    
    var storeFilterSorterControl: StoreFilterSorterControl!
    
    let heightOfStoreSubCategoryItems: CGFloat = 75
    
    let heightOfLoadingFooter: CGFloat = 40
    
    @IBOutlet weak var contentTableView: UITableView!
    
    var rightButtonItem: UIBarButtonItem!
    
    var stores: [Store]? = nil
    
    var isLoading = false
    
    override var utilsPopupViewItems: [UtilsPopupItem]? {
        get {
            return [UtilsPopupItem(titleText: LanguageControl.shared.getLocalizeString(by: "map"), iconImage: #imageLiteral(resourceName: "icon_map"), action: handleOnMapButtonTapped),
                    UtilsPopupItem(titleText: LanguageControl.shared.getLocalizeString(by: "near by"), iconImage: #imageLiteral(resourceName: "icon_location"), action: handleOnNearByButtonTapped),
                    UtilsPopupItem(titleText: LanguageControl.shared.getLocalizeString(by: "search"), iconImage: #imageLiteral(resourceName: "icon_search"), action: handleOnSearchButtonTapped)]
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.title = titleText
        
        navigationController?.navigationBar.tintColor = UIColor.white
        navigationController?.navigationBar.barTintColor = StoreCategoryControl.shared.themeColor
        navigationController?.navigationBar.backIndicatorImage = #imageLiteral(resourceName: "icon_back").withRenderingMode(.alwaysTemplate)
        navigationController?.navigationBar.backIndicatorTransitionMaskImage = #imageLiteral(resourceName: "icon_back").withRenderingMode(.alwaysTemplate)
        
        rightButtonItem = UIBarButtonItem (image: #imageLiteral(resourceName: "icon_dots"), style: .plain, target: self, action: #selector(onRightNavBarButtonItemTapped(_:)))
        navigationItem.rightBarButtonItem = rightButtonItem
        
        storeFilterSorterControl = StoreFilterSorterControl()
        
        contentTableView.register(StoreSubCategoryHeaderView.nib, forHeaderFooterViewReuseIdentifier: StoreSubCategoryHeaderView.key)
        contentTableView.register(TripleButtonHeaderView.nib, forHeaderFooterViewReuseIdentifier: TripleButtonHeaderView.key)
        
        contentTableView.dataSource = self
        contentTableView.delegate = self
        contentTableView.tableFooterView = HeaderFooterLoadingView (frame: CGRect(x: 0, y: 0, width: contentTableView.frame.width, height: heightOfLoadingFooter))
        contentTableView.separatorInset = UIEdgeInsets (top: 0, left: 15, bottom: 0, right: 15)
        
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
        
        StoreCategoryControl.shared.enterStoreCategory(self.storeCategory)
        storeListManager = StoreListManager.sharedOf(type: self.storeCategory)
        storeFilterSorterManager = StoreFilterSorterManager.sharedOf(type: self.storeCategory)
    }
    
    private func loadData () {
        let taskGroup = DispatchGroup ()
        taskGroup.enter()
        loadSubCategories(completion: {
            taskGroup.leave()
        })
        
        taskGroup.enter()
        loadFilterSubCategories (completion: {
            taskGroup.leave()
        })

        taskGroup.enter()
        loadSorters (completion: {
            taskGroup.leave()
        })

        taskGroup.enter()
        loadFilters (completion: {
            taskGroup.leave()
        })

        taskGroup.enter()
        loadStores (force: false, completion: {
            taskGroup.leave()
        })
        
        taskGroup.notify(queue: DispatchQueue.main, execute: {
            self.refreshData()
        })
    }
    
    func loadSubCategories (completion: (() -> Void)?) {
        DispatchQueue.global(qos: .userInitiated).async {
            self.storeFilterSorterManager.loadSubCategories(completion: {
                status, subcategories in
                
                self.storeFilterSorterControl.setSubcategories(subcategories)
                
                completion?()
            })
        }
    }
    
    func loadFilterSubCategories (completion: (() -> Void)?) {
        DispatchQueue.global(qos: .userInitiated).async {
            self.storeFilterSorterManager.loadFilterSubCategoies(completion: {
                status, filterSubcategories in
                
                self.storeFilterSorterControl.setFilterSubcategories(filterSubcategories)
                
                completion?()
            })
        }
    }
    
    func loadSorters (completion: (() -> Void)?) {
        DispatchQueue.global(qos: .userInitiated).async {
            self.storeFilterSorterManager.loadSortItems(completion: {
                status, sorts in
                
                self.storeFilterSorterControl.setSorts(sorts)
                
                completion?()
            })
        }
    }
    
    func loadFilters (completion: (() -> Void)?) {
        DispatchQueue.global(qos: .userInitiated).async {
            self.storeFilterSorterManager.loadFilterItems(completion: {
                status, filters in
                
                self.storeFilterSorterControl.setFilters(filters)
                
                completion?()
            })
        }
    }
    
    func loadStores (force: Bool, completion: (() -> Void)?) {
        isLoading = true
        DispatchQueue.global(qos: .userInitiated).async {
            let urlparams = self.storeFilterSorterControl.getUrlParams()
            self.storeListManager.loadStores(force: force, urlparams: urlparams, completion: {
                status, stores in
                
                if status == .success {
                    self.stores = stores
                    
                    DispatchQueue.main.async {
                        (self.contentTableView.tableFooterView as! HeaderFooterLoadingView).update(hasMoreData: self.storeListManager.pagingControl.hasMore)
                        self.isLoading = false
                    }
                }
                
                completion?()
            })
        }
    }
    
    func loadMore () {
        if storeListManager.pagingControl.hasMore {
            loadStores (force: true, completion: {
                DispatchQueue.main.async {
                    self.refreshData()
                }
            })
        }
    }
    
    func refreshData () {
        contentTableView.reloadData()
        contentTableView.layoutIfNeeded()
    }
    
    @objc private func onRightNavBarButtonItemTapped (_ sender: AnyObject?) {
        presentUtilsPopupViewController()
    }
    
    func handleOnMapButtonTapped () {
        dismissUtilsPopupViewController()
    }
    
    func handleOnNearByButtonTapped () {
        dismissUtilsPopupViewController()
    }
    
    func handleOnSearchButtonTapped () {
        dismissUtilsPopupViewController()
    }
    
    // MARK: - UITableViewDataSource
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 0
        } else {
            return self.stores != nil ? self.stores!.count : 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: StoreTableViewCell.key) as! StoreTableViewCell
        
        let store = self.stores![indexPath.row]
        cell.update(store: store)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 {
            let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: StoreSubCategoryHeaderView.key) as! StoreSubCategoryHeaderView
            
            header.delegate = self
            header.setSource(subcategories: storeFilterSorterControl.subcategories)
            
            return header
        } else {
            let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: TripleButtonHeaderView.key) as! TripleButtonHeaderView
            
            header.leftButton.setTitle(LanguageControl.shared.getLocalizeString(by: "category"), for: .normal)
            header.middleButton.setTitle(LanguageControl.shared.getLocalizeString(by: "sort"), for: .normal)
            header.rightButton.setTitle(LanguageControl.shared.getLocalizeString(by: "filter"), for: .normal)
            
            header.delegate = self
            header.update()
            
            return header
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return storeFilterSorterControl.subcategories == nil || storeFilterSorterControl.subcategories?.count == 0 ? 0 : heightOfStoreSubCategoryItems
        }
        
        return 44
    }
    
    // UITableViewDelegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        loadMore()
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.section == 1 && stores!.count - 1 == indexPath.row && !isLoading {
            loadMore()
        }
    }
    
    // MARK: - TripleButtonHeaderViewDelegate
    
    func handleOnLeftButtonTapped() {
        
    }
    
    func handleOnMiddleButtonTapped() {
        
    }
    
    func handleOnRightButtonTapped() {
        
    }
    
    // MARK: - StoreSubCategoryHeaderViewDelegate
    
    func onSelectedSubcategory(_ subcategory: StoreSubCategory) {
        storeFilterSorterControl.selectSubcateogry(subcategory)
        storeListManager.cleanCache()
        loadStores(force: true, completion: {
            DispatchQueue.main.async {
                self.refreshData()
            }
        })
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
