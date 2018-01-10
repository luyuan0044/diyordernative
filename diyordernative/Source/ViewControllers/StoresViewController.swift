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
                            StoreSubCategoryHeaderViewDelegate,
                            StoresViewControllerPopupViewDelegate {

    @IBOutlet weak var contentTableView: UITableView!
    
    @IBOutlet weak var storeViewControllerPopupView: StoresViewControllerPopupView!
    
    @IBOutlet weak var storeSubCategoryPopupViewTopConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var storeSubCategoryPopupViewHeightConstraint: NSLayoutConstraint!
    
    var storyCategoryId: Int!
    
    var storeCategory: storeCategoryType { get { return storeCategoryType (rawValue: storyCategoryId)! }}
    
    var titleText: String?
    
    var storeListManager: StoreListManager!
    
    var storeFilterSorterManager: StoreFilterSorterManager!
    
    var storeFilterSorterControl: StoreFilterSorterControl!
    
    var storeSubcategoryDataSourceAndDelegate = StoreSubCategoryDataSourceAndDelegate()
    
    var storeSortDataSourceAndDelegate = StoreSortDataSourceAndDelegate()
    
    var storeFilterDataSourceAndDelegate = StoreFilterDataSourceAndDelegate()
    
    let heightOfStoreSubCategoryItems: CGFloat = 75
    
    let heightOfTripleButtonHeader: CGFloat = 44
    
    let heightOfLoadingFooter: CGFloat = 40
    
    var rightButtonItem: UIBarButtonItem!
    
    var stores: [Store]? = nil
    
    var isLoading = false
    
    enum tripleButton {
        case left
        case middle
        case right
    }
    
    var lastTappedButton: tripleButton? = nil
    
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
        
        storeFilterSorterControl = StoreFilterSorterControl()
        
        self.title = titleText
        
        navigationController?.navigationBar.tintColor = UIColor.white
        navigationController?.navigationBar.barTintColor = StoreCategoryControl.shared.themeColor
        navigationController?.navigationBar.backIndicatorImage = #imageLiteral(resourceName: "icon_back").withRenderingMode(.alwaysTemplate)
        navigationController?.navigationBar.backIndicatorTransitionMaskImage = #imageLiteral(resourceName: "icon_back").withRenderingMode(.alwaysTemplate)
        
        rightButtonItem = UIBarButtonItem (image: #imageLiteral(resourceName: "icon_dots"), style: .plain, target: self, action: #selector(onRightNavBarButtonItemTapped(_:)))
        navigationItem.rightBarButtonItem = rightButtonItem
        
        contentTableView.register(StoreSubCategoryHeaderView.nib, forHeaderFooterViewReuseIdentifier: StoreSubCategoryHeaderView.key)
        contentTableView.register(TripleButtonHeaderView.nib, forHeaderFooterViewReuseIdentifier: TripleButtonHeaderView.key)
        
        contentTableView.dataSource = self
        contentTableView.delegate = self
        contentTableView.tableFooterView = HeaderFooterLoadingView (frame: CGRect(x: 0, y: 0, width: contentTableView.frame.width, height: heightOfLoadingFooter))
        contentTableView.separatorInset = UIEdgeInsets (top: 0, left: 15, bottom: 0, right: 15)
        
        storeViewControllerPopupView.delegate = self
        
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
                
                DispatchQueue.main.async {
                    self.storeFilterSorterControl.setSubcategories(subcategories)
                }
                
                completion?()
            })
        }
    }
    
    func loadFilterSubCategories (completion: (() -> Void)?) {
        DispatchQueue.global(qos: .userInitiated).async {
            self.storeFilterSorterManager.loadFilterSubCategoies(completion: {
                status, filterSubcategories in
                
                self.storeFilterSorterControl.setFilterSubcategories(filterSubcategories)
                self.storeSubcategoryDataSourceAndDelegate.setSource(subcategories: filterSubcategories, selectedSubcategory: self.storeFilterSorterControl.selectedSubCategory)
                
                completion?()
            })
        }
    }
    
    func loadSorters (completion: (() -> Void)?) {
        DispatchQueue.global(qos: .userInitiated).async {
            self.storeFilterSorterManager.loadSortItems(completion: {
                status, sorts in
                
                self.storeFilterSorterControl.setSorts(sorts)
                
                DispatchQueue.main.async {
                    self.storeSortDataSourceAndDelegate.setSource(sorts: sorts, selectedSort: self.storeFilterSorterControl.selectedSort)
                }
                
                completion?()
            })
        }
    }
    
    func loadFilters (completion: (() -> Void)?) {
        DispatchQueue.global(qos: .userInitiated).async {
            self.storeFilterSorterManager.loadFilterItems(completion: {
                status, filters in
                
                self.storeFilterSorterControl.setFilters(filters)
                
                DispatchQueue.main.async {
                    self.storeFilterDataSourceAndDelegate.setSource(filters: filters)
                }
                
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
    
    private func getYPositionOfHeaderInFirstSection () -> CGFloat {
        let rect = contentTableView.rectForHeader(inSection: 1)
        let originalMaxY = rect.maxY
        let tableViewOffsetY = contentTableView.contentOffset.y
        return max(originalMaxY - tableViewOffsetY, heightOfTripleButtonHeader)
    }
    
    private func showStoreViewControllerPopupView (with sourceAndDelegate: StoresViewControllerPopupViewSourceAndDelegate) {
        storeViewControllerPopupView.setSourceAndDelegate(sourceAndDelegate: sourceAndDelegate)
        
        if storeViewControllerPopupView.isHidden {
            
            storeViewControllerPopupView.alpha = 1
            contentTableView.isScrollEnabled = false
            storeViewControllerPopupView.isHidden = false
            
            let y = getYPositionOfHeaderInFirstSection()
            let height = contentTableView.frame.height - y
            
            storeSubCategoryPopupViewTopConstraint.constant = y
            storeSubCategoryPopupViewHeightConstraint.constant = height
            
            view.layoutIfNeeded()
        }
        
        storeViewControllerPopupView.animateLeftTableView(isShow: true)
    }
    
    private func hideStoreViewControllerPopupView () {
        lastTappedButton = nil
        storeViewControllerPopupView.animateLeftTableView (isShow: false, completion: {
            self.contentTableView.isScrollEnabled = true
            UIView.animate(withDuration: 0.2, animations: {
                self.storeViewControllerPopupView.alpha = 0
            }, completion: {
                isComplete in
                self.storeViewControllerPopupView.isHidden = true
            })
        })
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
            header.update(selectedSubcategory: storeFilterSorterControl.selectedSubCategory, selectedSort: storeFilterSorterControl.selectedSort, hasFilterSelected: storeFilterSorterControl.hasFilterSelected())
            
            return header
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return storeFilterSorterControl.subcategories == nil || storeFilterSorterControl.subcategories?.count == 0 ? 0 : heightOfStoreSubCategoryItems
        }
        
        return heightOfTripleButtonHeader
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
        if storeViewControllerPopupView.isHidden || (lastTappedButton != nil && lastTappedButton != .left) {
            showStoreViewControllerPopupView(with: storeSubcategoryDataSourceAndDelegate)
        } else {
            hideStoreViewControllerPopupView()
        }
        lastTappedButton = tripleButton.left
    }
    
    func handleOnMiddleButtonTapped() {
        if storeViewControllerPopupView.isHidden || (lastTappedButton != nil && lastTappedButton != .middle) {
            showStoreViewControllerPopupView(with: storeSortDataSourceAndDelegate)
        } else {
            hideStoreViewControllerPopupView()
        }
        lastTappedButton = tripleButton.middle
    }
    
    func handleOnRightButtonTapped() {
        if storeViewControllerPopupView.isHidden || (lastTappedButton != nil && lastTappedButton != .right) {
            storeFilterDataSourceAndDelegate.setSelectedSwitchFilterIds(storeFilterSorterControl.selectedSwitchFilterId)
            storeFilterDataSourceAndDelegate.setSelectedSelectionFilterIds(storeFilterSorterControl.selectedSelectionFilter)
            showStoreViewControllerPopupView(with: storeFilterDataSourceAndDelegate)
        } else {
            hideStoreViewControllerPopupView()
        }
        lastTappedButton = tripleButton.right
    }
    
    // MARK: - StoreSubCategoryHeaderViewDelegate
    
    func onSelectedSubcategory(_ subcategory: StoreSubCategory) {
        if !storeViewControllerPopupView.isHidden {
            hideStoreViewControllerPopupView()
        }
        
        //update selected category in souce and delegate of popup view
        storeSubcategoryDataSourceAndDelegate.setSelectedSubCategory(selectedSubcategory: subcategory)
        storeViewControllerPopupView.updateSelectedCategoryOnRightTableViewSourceAndDelegate (selectedSubcategory: subcategory)
        
        storeFilterSorterControl.selectSubcateogry(subcategory)
        storeListManager.cleanCache()
        loadStores(force: true, completion: {
            DispatchQueue.main.async {
                self.refreshData()
            }
        })
        
        let header = contentTableView.headerView(forSection: 1) as! TripleButtonHeaderView
        header.updateLeftButton(title: subcategory.name, with: StoreCategoryControl.shared.themeColor)
    }
    
    // MARK: - StoresViewControllerPopupViewDelegate
    
    func onSelectedSort(_ sort: Sort) {
        if !storeViewControllerPopupView.isHidden {
            hideStoreViewControllerPopupView()
        }
        
        //update selected sort in souce and delegate of popup view
        storeSortDataSourceAndDelegate.setSelectedSort(selectedSort: sort)
        
        storeFilterSorterControl.selectSort(sort)
        storeListManager.cleanCache()
        loadStores(force: true, completion: {
            DispatchQueue.main.async {
                self.refreshData()
            }
        })
        
        let header = contentTableView.headerView(forSection: 1) as! TripleButtonHeaderView
        header.updateMiddleButton(title: sort.name, with: StoreCategoryControl.shared.themeColor)
    }
    
    func handleOnDismissButtonTapped() {
        hideStoreViewControllerPopupView()
    }
    
    func getSelectedSubcategory() -> StoreSubCategory? {
        return storeFilterSorterControl.selectedSubCategory
    }
    
    func onConfirmButtonTapped(switchFilterId: [Int]?, selectionFilterIds: [Int: [Int]]?) {
        storeFilterSorterControl.setSelectedFilters(switchFilterId: switchFilterId, selectionFilterIds: selectionFilterIds)
        storeListManager.cleanCache()
        loadStores(force: true, completion: {
            DispatchQueue.main.async {
                self.refreshData()
            }
        })
        if !storeViewControllerPopupView.isHidden {
            hideStoreViewControllerPopupView()
        }
    }
    
    func onResetButtonTapped() {
        storeFilterSorterControl.resetFilters()
        storeListManager.cleanCache()
        loadStores(force: true, completion: {
            DispatchQueue.main.async {
                self.refreshData()
            }
        })
        if !storeViewControllerPopupView.isHidden {
            hideStoreViewControllerPopupView()
        }
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
