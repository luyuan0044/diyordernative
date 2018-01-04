//
//  HotItemViewController.swift
//  diyordernative
//
//  Created by Richard Lu on 2017-12-13.
//  Copyright © 2017 goopter. All rights reserved.
//

import UIKit

class HotItemViewController:BaseViewController,
                            UICollectionViewDataSource,
                            UICollectionViewDelegateFlowLayout,
                            UITableViewDelegate,
                            UITableViewDataSource,
                            UISearchBarDelegate,
                            UIViewControllerPreviewingDelegate,
                            UtilityButtonsHeaderViewDelegate,
                            HotItemCategoryHeaderViewDelegate,
                            RightSlideFilterViewControllerDelegate,
                            HotItemRightSlideTableViewDataSourceAndDelegateDelegate,
                            HotItemRightSlideTableViewMainDataSourceAndDelegateDelegate {
    
    // MARK: - Properties
    
    static let tabTitle = "hot"
    
    static let icon = #imageLiteral(resourceName: "icon_hot")
    
    @IBOutlet weak var hotItemCollectionView: UICollectionView!
    
    @IBOutlet weak var sortPopupPanelView: UIView!
    
    @IBOutlet weak var sortPopupTableView: UITableView!
    
    @IBOutlet weak var sortPopupTableViewHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var sortPopupPanelViewTopConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var hideSortPopupPanelViewButton: UIButton!
    
    @IBOutlet weak var toTopButton: UIButton!
    
    @IBOutlet weak var topTopButtonBottomConstraint: NSLayoutConstraint!
    
    var searhController: UISearchController!
    
    var currentHotItemCategoryIdOnTab: String? = nil
    
    var currentHotItemCategoryId: String? = nil
    
    // used for store hot item category id selected in right slide filter view controller
    // before confirm button tapped
    var temporyHotItemCategoryId: String? = nil
    
    var currentHotItemSortId: String? = nil
    
    var keyword: String? = nil
    
    var priceRange: (String?, String?)? = nil
    
    var hotItemCategories: [HotItemCategory]? = nil
    
    var hotItemSorts: [HotItemSort]? = nil
    
    var hotItemListingSorts: [HotItemSort]? {
        get {
            return hotItemSorts?.filter{$0.type == hotItemSortType.list.rawValue}
        }
    }
    
    var hotItemTabSort: HotItemSort? {
        get {
            return hotItemSorts?.filter{$0.type == hotItemSortType.tab.rawValue}[0]
        }
    }
    
    var hotItems: [HotItem]? = nil
    
    var colletionViewDisplayStyle: colletionViewDisplayStyle = .grid
    
    var colletionViewDisplayStyleIcon: UIImage { get { return colletionViewDisplayStyle == .grid ? #imageLiteral(resourceName: "icon_grid") : #imageLiteral(resourceName: "icon_list") } }
    
    let hotItemPadding: CGFloat = 5
    
    var numberOfItemPerLine: CGFloat { get { return colletionViewDisplayStyle == .grid ? 2 : 1 } }
    
    let heightOfHeader: CGFloat = 40
    
    let limit = 20
    
    var rightSlideFilterViewController: RightSlideFilterViewController? = nil
    
    var isRightSlideFilterViewControllerPresented = false
    
    var rightSlideMainDataSourceAndDelegate: HotItemRightSlideTableViewMainDataSourceAndDelegate? = nil
    
    var rightSlideDataSourceAndDelegateDict: [String: HotItemRightSlideTableViewDataSourceAndDelegate]? = nil
    
    var rightSlideDataSourceAdnDelegateStack: [HotItemRightSlideTableViewDataSourceAndDelegate] = []
    
    let keyOfRightSlideDataSourceAndDelegate = "base"
    
    let toTopButtonDisplacement: CGFloat = 61
    
    var isToTopButtonOnView = false
    
    var pagingControl: PagingControl!
    
    var isLoading: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        navigationController?.navigationBar.barTintColor = UIConstants.appThemeColor
        tabBarItem = UITabBarItem (title: HotItemViewController.tabTitle, image: HotItemViewController.icon, tag: 1)
        
        hotItemCollectionView.register(HotItemCategoryHeaderView.nib, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: HotItemCategoryHeaderView.key)
        hotItemCollectionView.register(UtilityButtonsHeaderView.nib, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: UtilityButtonsHeaderView.key)
        hotItemCollectionView.register(CollectionLoadingFooterView.nib, forSupplementaryViewOfKind: UICollectionElementKindSectionFooter, withReuseIdentifier: CollectionLoadingFooterView.key)
        hotItemCollectionView.register(GridProductCell.nib, forCellWithReuseIdentifier: GridProductCell.key)
        hotItemCollectionView.register(ListProductCell.nib, forCellWithReuseIdentifier: ListProductCell.key)
        
        hotItemCollectionView.dataSource = self
        hotItemCollectionView.delegate = self
        
        hotItemCollectionView.backgroundColor = UIColor.white
        // sticky header setup
        let layout = hotItemCollectionView.collectionViewLayout as? UICollectionViewFlowLayout
        layout?.sectionHeadersPinToVisibleBounds = true
        
        sortPopupPanelView.backgroundColor = UIConstants.transparentBlackColor
        sortPopupPanelView.isHidden = true
        
        sortPopupTableView.isHidden = true
        sortPopupTableView.delegate = self
        sortPopupTableView.dataSource = self
        sortPopupTableView.isScrollEnabled = false
        
        hideSortPopupPanelViewButton.backgroundColor = UIColor.clear
        hideSortPopupPanelViewButton.addTarget(self, action: #selector(handleOnHideSortPopupPanelViewButtonTapped(_:)), for: .touchUpInside)
        
        searhController = UISearchController (searchResultsController: nil)
        searhController!.hidesNavigationBarDuringPresentation = false
        searhController!.dimsBackgroundDuringPresentation = false
        searhController!.searchBar.tintColor = UIColor.white
        
        searhController!.searchBar.placeholder = LanguageControl.shared.getLocalizeString(by: "search hot items")
        searhController!.searchBar.delegate = self
        searhController!.searchBar.sizeToFit()
        searhController!.searchBar.searchTextPositionAdjustment = UIOffset (horizontal: 0.0, vertical: 0.0)
        
        navigationItem.titleView = self.searhController.searchBar
        definesPresentationContext = true
        
        toTopButton.backgroundColor = UIColor.white.withAlphaComponent(0.9)
        toTopButton.setImage(#imageLiteral(resourceName: "icon_top").withRenderingMode(.alwaysTemplate), for: .normal)
        toTopButton.tintColor = UIColor.darkGray
        toTopButton.layer.cornerRadius = toTopButton.frame.height / 2
        toTopButton.layer.borderColor = UIColor.lightGray.cgColor
        toTopButton.layer.borderWidth = 0.5
        toTopButton.contentEdgeInsets = UIEdgeInsets (top: 10, left: 10, bottom: 10, right: 10)
        toTopButton.addTarget(self, action: #selector(handleOnToTopButtonTapped(_:)), for: .touchUpInside)
        
        if traitCollection.forceTouchCapability == .available {
            registerForPreviewing(with: self, sourceView: hotItemCollectionView)
        }
        
        pagingControl = PagingControl (limit: limit)
        
        fetch()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Implementation
    
    /**
     Fetch data for view controller
     1. Hot items array
     2. Hot item categories array
     3. Hot itme sort array
     */
    func fetch () {
        //TODO: show loading box here
        
        let taskGroup = DispatchGroup ()
        taskGroup.enter()
        loadHotItemTask (completion: {
            taskGroup.leave()
        })
        
        taskGroup.enter()
        loadHotItemCategoryTask (completion: {
            taskGroup.leave()
        })
        
        taskGroup.enter()
        loadHotItemSortItemsTask (completion: {
            taskGroup.leave()
        })
        
        taskGroup.notify(queue: DispatchQueue.main, execute: {
            //TODO: hide loading box
        })
    }
    
    /**
     Load next page hot items from server
     */
    func loadMore () {
        if pagingControl.hasMore {
            loadHotItemTask ()
        }
    }
    
    /**
     Task of load hot item categories array
     
     - parameter completion: callback of the task completion, the default value will be nil
     */
    private func loadHotItemCategoryTask (completion: (() -> Void)? = nil) {
        DispatchQueue.global(qos: .userInitiated).async {
            HotItemLoader.startRequestHotItemCategory(completion: {
                _status, items in
                
                if _status == .success {
                    self.hotItemCategories = items
                }
                
                DispatchQueue.main.async {
                    self.refreshHotItemCollectionView()
                }
                
                completion?()
            })
        }
    }
    
    /**
     Task of load hot item sort array
     
     - parameter completion: callback of the task completion, the default value will be nil
     */
    private func loadHotItemSortItemsTask (completion: (() -> Void)? = nil) {
        DispatchQueue.global(qos: .userInitiated).async {
            HotItemLoader.startLoadHotItemSort(completion: {
                items in
                
                self.hotItemSorts = items
                self.currentHotItemSortId = self.hotItemSorts!.first!.id
                
                DispatchQueue.main.async {
                    self.refreshSortPopupTableView()
                }
                completion?()
            })
        }
    }
    
    /**
     Task of load hot item array
     
     - parameter completion: callback of the task completion, the default value will be nil
     */
    private func loadHotItemTask (completion: (() -> Void)? = nil) {
        isLoading = true
        DispatchQueue.global(qos: .userInitiated).async {
            let urlparams = self.getUrlParams()
            
            self.pagingControl.loadPagingData(urlparams: urlparams, completion: {
                _status, _items in
                
                if _status == .success {
                    if self.hotItems == nil {
                        self.hotItems = []
                    }
                    
                    self.hotItems!.append(contentsOf: _items!)
                }
                
                DispatchQueue.main.async {
                    self.isLoading = false
                    self.refreshHotItemSection()
                }
                
                completion?()
            }, task: HotItemLoader.startRequestHotItems)
        }
    }
    
    /**
     Reload data on hot item collection view and layout afterword
     */
    func refreshHotItemCollectionView () {
        hotItemCollectionView.reloadData()
        hotItemCollectionView.layoutIfNeeded()
    }
    
    /**
     Reload data on section #1 on hot item collection view and layout afterword
     */
    func refreshHotItemSection () {
        hotItemCollectionView.reloadSections(IndexSet (integer: 1))
        hotItemCollectionView.layoutIfNeeded()
    }
    
    /**
     Reload data on sort popup tableview and layout afterword
     */
    func refreshSortPopupTableView () {
        sortPopupTableView.reloadData()
        sortPopupPanelView.layoutIfNeeded()
    }
    
    /**
     Switch the display style of the hot item collection view
     If current style is ".list", then the stlye will change to ".grid"
     If current style is ".grid", then the stlye will change to ".list"
     Collection view will reload data after style setting changed
     */
    func switchCollectionViewDisplayStyle () {
        colletionViewDisplayStyle = colletionViewDisplayStyle == .grid ? .list : .grid
        refreshHotItemCollectionView()
    }
    
    /**
     Show RightSlideFilterViewController
     - RightSlideFilterViewController will be initialized if it is never initialized, otherwise will use the previous instance
     - HotItemRightSlideTableViewMainDataSourceAndDelegate will be initialized if it is never initilized
     - Setup instance of HotItemRightSlideTableViewMainDataSourceAndDelegate
     - Setup instance of HotItemRightSlideTableViewMainDataSourceAndDelegate as TableView's datasource and delegate
     - Present view controller
     */
    func showRightSlideFilterViewController () {
        // Initialize rightSlideFilterViewController if it is nil
        if rightSlideFilterViewController == nil {
            rightSlideFilterViewController = RightSlideFilterViewController()
            rightSlideFilterViewController!.delegate = self
            rightSlideFilterViewController!.modalPresentationStyle = .overFullScreen
            rightSlideFilterViewController!.modalTransitionStyle = .crossDissolve
        }
        
        // Initialize rightSlideMainDataSourceAndDelegate if it is nil
        if (rightSlideMainDataSourceAndDelegate == nil) {
            rightSlideMainDataSourceAndDelegate = HotItemRightSlideTableViewMainDataSourceAndDelegate()
            rightSlideMainDataSourceAndDelegate!.delegate = self
        }
        
        // Setup rightSlideMainDataSourceAndDelegate
        if currentHotItemCategoryId == nil {
            rightSlideMainDataSourceAndDelegate!.hasChildren = false
        } else {
            let selectedCategory = self.hotItemCategories!.filter{$0.id == currentHotItemCategoryIdOnTab!}.first!
            rightSlideMainDataSourceAndDelegate!.hasChildren = selectedCategory.hasChildren()
        }
        
        // Setup rightSlideMainDataSourceAndDelegate as TableView's datasource and delegate
        rightSlideFilterViewController!.setTableViewDataSourceAndDelegate(dataSource: rightSlideMainDataSourceAndDelegate!, delegate: rightSlideMainDataSourceAndDelegate!)
        
        // Preset the view controller
        present(rightSlideFilterViewController!, animated: true, completion: {
            self.isRightSlideFilterViewControllerPresented = true;
        })
    }
    
    /**
     Hide RightSlideFilterViewController
     */
    func hideRightSlideFilterViewContrller () {
        guard isRightSlideFilterViewControllerPresented || rightSlideFilterViewController != nil else {
            return
        }
        
        rightSlideFilterViewController?.dismiss(animated: true, completion: {
            self.isRightSlideFilterViewControllerPresented = false
            
            // Clear right slide cache stack
            self.rightSlideDataSourceAdnDelegateStack = []
        })
    }
    
    /**
     Show SortPopupView
     - Setup the top constraint of sort popup view to be the bottom of second header view
     */
    func showSortPopupView () {
        sortPopupPanelView.isHidden = false
        
        //setup the top constraint of popup panel view
        let header = hotItemCollectionView.supplementaryView(forElementKind: UICollectionElementKindSectionHeader, at: IndexPath (row: 0, section: 1))!
        let yPosition = header.frame.maxY
        sortPopupPanelViewTopConstraint.constant = yPosition
        view.layoutSubviews()
        
        //show the popup table
        sortPopupTableView.isHidden = false
        UIView.animate(withDuration: 0.2, animations: {
            self.sortPopupTableViewHeightConstraint.constant = self.sortPopupTableView.contentSize.height
            self.view.layoutSubviews()
        })
    }
    
    /**
     Hide SortPopupView
     */
    func hideSortPopupView () {
        UIView.animate(withDuration: 0.2, animations: {
            self.sortPopupTableViewHeightConstraint.constant = 0
            self.view.layoutSubviews()
        }, completion: {
            isFinished in
            
            if isFinished {
                self.sortPopupTableView.isHidden = true
                self.sortPopupPanelView.isHidden = true
            }
        })
    }
    
    /**
     Handle on hide button of sort popup panel view tapped
     */
    @objc private func handleOnHideSortPopupPanelViewButtonTapped (_ sender: AnyObject?) {
        hideSortPopupView()
    }
    
    /**
     Set the selected hot item category id displayed on first header view
     - parameter id: id of selected hot item category on first header view
     */
    func setHotItemCategoryIdOnTab (_ id: String?) {
        currentHotItemCategoryIdOnTab = id
    }
    
    /**
     Set the selected hot item category id which is a children of categories displayed on the first header view
     - parameter id: id of selected hot item category
     */
    func setHotItemCategoryId (_ id: String?) {
        currentHotItemCategoryId = id
    }
    
    /**
     Set the selected hot item sort id
     - parameter id: id of hot item sort
     */
    func setHotItemSortId (_ id: String?) {
        currentHotItemSortId = id
    }
    
    /**
     Set the search keyword
     */
    func setKeyword (_ keyword: String?) {
        self.keyword = keyword
    }
    
    func setPriceRangeUpperBound (_ upper: String?) {
        if priceRange == nil {
            priceRange = (nil, upper)
        } else {
            priceRange = (priceRange!.0, upper)
        }
    }
    
    func setPriceRangeLowerBound (_ lower: String?) {
        if priceRange == nil {
            priceRange = (lower, nil)
        } else {
            priceRange = (lower, priceRange!.1)
        }
    }
    
    func validatePriceRange () -> Bool {
        if priceRange == nil {
            return true
        }
        
        let lower = priceRange!.0
        let upper = priceRange!.1
        
        if lower != nil && Int(lower!) == nil {
            return false
        }
        
        if upper != nil && Int(upper!) == nil {
            return false
        }
        
        return true
    }
    
    /**
     Get url params of search settings in Dictionary
     
     - returns: search settings with coresponding key
     */
    func getUrlParams () -> [String: String]? {
        var result: [String: String]? = nil
        
        var categoryid: String? = nil
        if let filterid = currentHotItemCategoryId {
            categoryid = filterid
        } else if let filteridOnTab = currentHotItemCategoryIdOnTab {
            categoryid = filteridOnTab
        }
        
        if let filterid = categoryid {
            if result == nil {
                result = [:]
            }
            result!["tid"] = "\(filterid)"
        }
        
        if let sortid = currentHotItemSortId {
            if result == nil {
                result = [:]
            }
            result!["sort"] = sortid
        }
        
        if let keyword = keyword {
            if result == nil {
                result = [:]
            }
            result!["keywords"] = keyword
        }
        
        if let priceRange = self.priceRange {
            let lowerBound = priceRange.0
            let upperBound = priceRange.1
            
            if lowerBound != nil && upperBound != nil {
                if result == nil {
                    result = [:]
                }
                
                if lowerBound == nil {
                    result!["price"] = "-\(upperBound!)"
                } else if upperBound == nil {
                    result!["price"] = "\(lowerBound!)-"
                } else {
                    result!["price"] = "\(lowerBound!)-\(upperBound!)"
                }
            }
        }
        
        return result
    }
    
    /**
     Get tableview datasource and delegate by parent hot item category
     - If parent hot item category is nil, will create (if cannot find in cached dictionary) and return datasource and delegate of first level children, if it has children, otherwise will return nil
     - If parent hot item is not nil, will create (if cannot find in cached dictionary) and return datasource and delegate of its chidlren, if it has children, otherwise will return nil
     
     - parameter _hotItemCategory: parent hot item category
     
     - returns: search settings with coresponding key
     */
    func getDataSourceAndDelegateByParentCategory (_ _hotItemCategory: HotItemCategory?) -> HotItemRightSlideTableViewDataSourceAndDelegate? {
        if currentHotItemCategoryId == nil {
            return nil
        }
        
        var hotItemCategory = _hotItemCategory
        
        if hotItemCategory == nil {
            // Hot item category is nil, get the current selected hot item category on first header view
            hotItemCategory = self.hotItemCategories!.filter({$0.id == currentHotItemCategoryIdOnTab}).first!
            
            if (hotItemCategory!.hasChildren()) {
                // If hot item category has children check the cached dicationary
                // If cannot find datasource and delegate,  create and setup, then do the cache
                // Otherwise, return cached datasource and delegate
                if (rightSlideDataSourceAndDelegateDict == nil || !rightSlideDataSourceAndDelegateDict!.contains(where: {$0.key == hotItemCategory!.id!})) {
                    
                    rightSlideDataSourceAndDelegateDict = [:]
                    
                    let dataSourceAndDelegate = HotItemRightSlideTableViewDataSourceAndDelegate()
                    dataSourceAndDelegate.items = hotItemCategory!.children
                    dataSourceAndDelegate.delegate = self
                    rightSlideDataSourceAndDelegateDict![hotItemCategory!.id!] = dataSourceAndDelegate
                    
                    return dataSourceAndDelegate
                } else {
                    return rightSlideDataSourceAndDelegateDict![hotItemCategory!.id!]
                }
            } else {
                // Return nil if doesnt has children
                return nil
            }
        }
        
        if rightSlideDataSourceAndDelegateDict == nil {
            rightSlideDataSourceAndDelegateDict = [:]
        }
        
        if rightSlideDataSourceAndDelegateDict!.contains(where: {$0.key == hotItemCategory!.id}) {
            // Return existing datasource and delegate in cached dictionary
            return rightSlideDataSourceAndDelegateDict![hotItemCategory!.id!]
        } else {
            // Create a new one and do the setup, then cached it
            let dataSourceAndDelegate = HotItemRightSlideTableViewDataSourceAndDelegate()
            dataSourceAndDelegate.items = hotItemCategory!.children
            dataSourceAndDelegate.parentItem = hotItemCategory!
            dataSourceAndDelegate.delegate = self
            rightSlideDataSourceAndDelegateDict![hotItemCategory!.id!] = dataSourceAndDelegate
            
            return dataSourceAndDelegate
        }
    }
    
    /**
     Show to top button
     */
    func showToTopButton () {
        if isToTopButtonOnView {
            return
        }
        
        self.isToTopButtonOnView = true
        
        UIView.animate(withDuration: 0.2, animations: {
            self.topTopButtonBottomConstraint.constant += self.toTopButtonDisplacement
            self.view.layoutIfNeeded()
        })
    }
    
    /**
     Hide to top button
     */
    func hideToTopButton () {
        if !isToTopButtonOnView {
            return
        }
        
        self.isToTopButtonOnView = false
        
        UIView.animate(withDuration: 0.2, animations: {
            self.topTopButtonBottomConstraint.constant -= self.toTopButtonDisplacement
            self.view.layoutIfNeeded()
        })
    }
    
    @objc private func handleOnToTopButtonTapped (_ sender: AnyObject?) {
        hotItemCollectionView.setContentOffset(CGPoint.zero, animated: true)
    }
    
    // MARKL - UICollectionViewDataSource
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if hotItems != nil {
            let hotItem = hotItems![indexPath.row]
            
            if colletionViewDisplayStyle == .grid {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: GridProductCell.key, for: indexPath) as! GridProductCell
                
                cell.update(hotItem: hotItem)
                
                return cell
            } else {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ListProductCell.key, for: indexPath) as! ListProductCell
                
                cell.update(hotItem: hotItem)
                
                return cell
            }
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: GridProductCell.key, for: indexPath) as! GridProductCell
            
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            return 0
        } else {
            return hotItems == nil ? 1 : hotItems!.count
        }
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionElementKindSectionHeader {
            if indexPath.section == 0 {
                let view = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: HotItemCategoryHeaderView.key, for: indexPath) as! HotItemCategoryHeaderView
                
                view.update(hotItemCategories: self.hotItemCategories)
                view.delegate = self
                return view
            } else {
                let view = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: UtilityButtonsHeaderView.key, for: indexPath) as! UtilityButtonsHeaderView
                view.delegate = self
                
                var firstTitle: String? = nil
                if let sortId = currentHotItemSortId {
                    firstTitle = hotItemListingSorts!.filter{$0.id! == sortId}.first?.name
                    let sort = hotItemSorts!.filter{$0.id == currentHotItemSortId}.first!
                     view.updateSelectedSort(sortItem: sort)
                }
                
                if firstTitle == nil { firstTitle = hotItemListingSorts!.first!.name! }
                
                view.setup(firstButtonTitle: firstTitle!, secondButtonTitle: hotItemTabSort!.name!, squareIcon: colletionViewDisplayStyleIcon, rightButtonTitle: "filter")
                
                return view
            }
        } else {
            let view = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: CollectionLoadingFooterView.key, for: indexPath) as! CollectionLoadingFooterView
            
            view.backgroundColor = UIColor.groupTableViewBackground
            
            return view
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplaySupplementaryView view: UICollectionReusableView, forElementKind elementKind: String, at indexPath: IndexPath) {
        if elementKind == UICollectionElementKindSectionFooter && indexPath.section == 1 && !isLoading {
            loadMore()
        }
    }
    
    // MARK: - UICollectionViewDelegateFlowLayout
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let interItemSpace = (numberOfItemPerLine - 1) * hotItemPadding
        let itemWidth: CGFloat = (collectionView.frame.width - interItemSpace) / numberOfItemPerLine
        var itemHeight: CGFloat = itemWidth * 1.5
        if colletionViewDisplayStyle == .list {
            itemHeight = 140
        }
        return CGSize (width: itemWidth, height: itemHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return hotItemPadding
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        if section == 0 {
            return UIEdgeInsets (top: 0, left: 0, bottom: 0, right: 0)
        } else {
            return UIEdgeInsets (top: 0, left: 0, bottom: hotItemPadding, right: 0)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize (width: collectionView.frame.width, height: heightOfHeader)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        if section == 0 {
            return CGSize (width: collectionView.frame.width, height: 0)
        } else {
            return CGSize (width: collectionView.frame.width, height: heightOfHeader)
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        
        if offsetY > 50 {
            showToTopButton()
        } else {
            hideToTopButton()
        }
    }
    
    func scrollViewDidScrollToTop(_ scrollView: UIScrollView) {
        hideToTopButton()
    }
    
    // MARK: - UtilityButtonsHeaderViewDelegate
    
    func onFirstButtonTapped() {
        // Show or hide sort popup view
        if sortPopupTableView.isHidden {
            showSortPopupView()
        } else {
            hideSortPopupView()
        }
    }
    
    func onSecondButtonTapped() {
        // Apply sort by volume
        setHotItemSortId(hotItemTabSort?.id)
        refreshSortPopupTableView()
        pagingControl.reset()
        loadHotItemTask()
        
        // Hide sort popup view if needed
        if !sortPopupPanelView.isHidden {
            hideSortPopupView()
        }
    }
    
    func onSquareButtonTapped() {
        // Switch the display style of hot item collection view
        switchCollectionViewDisplayStyle()
        if let header = hotItemCollectionView.supplementaryView(forElementKind: UICollectionElementKindSectionHeader, at: IndexPath(row: 0, section: 1)) {
            (header as! UtilityButtonsHeaderView).updateSquareButtonIcon(iconImage: colletionViewDisplayStyleIcon)
        }
        
        // Hide sort popup view if needed
        if !sortPopupPanelView.isHidden {
            hideSortPopupView()
        }
    }
    
    func onRightButtonTapped() {
        // Show the right slide popup view
        showRightSlideFilterViewController()
        
        // Hide sort popup view if needed
        if !sortPopupPanelView.isHidden {
            hideSortPopupView()
        }
    }
    
    // MARK: - HotItemCategoryHeaderViewDelegate
    
    func onHotItemCategoryTapped(selectedHotItemCategory: HotItemCategory?) {
        setHotItemCategoryIdOnTab (selectedHotItemCategory?.id)
        setHotItemCategoryId (selectedHotItemCategory?.id)
        pagingControl.reset()
        loadHotItemTask ()
        
        // Hide sort popup view if needed
        if !sortPopupPanelView.isHidden {
            hideSortPopupView()
        }
    }
    
    // MARK: - RightSlideFilterViewControllerDelegate
    
    func onHideButtonTapped() {
        hideRightSlideFilterViewContrller()
    }
    
    func onResetButtonTapped() {
        temporyHotItemCategoryId = nil
        priceRange = (nil, nil)
        setHotItemCategoryId(nil)
        pagingControl.reset()
        loadHotItemTask()
        hideRightSlideFilterViewContrller()
    }
    
    func onConfirmButtonTapped() {
        if (validatePriceRange()) {
            setHotItemCategoryId(temporyHotItemCategoryId)
            pagingControl.reset()
            loadHotItemTask()
            hideRightSlideFilterViewContrller()
        } else {
            // Popup for invalid price range input
        }
    }
    
    // MARK: - UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return hotItemListingSorts == nil ? 0 : hotItemListingSorts!.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "SortPopupCell")
        
        let sortItem = hotItemListingSorts![indexPath.row]
        
        if cell == nil {
            cell = UITableViewCell (style: .default, reuseIdentifier: "SortPopupCell")
        }
        
        cell!.textLabel?.text = LanguageControl.shared.getLocalizeString(by: sortItem.name)
        cell!.textLabel?.font = UIFont.systemFont(ofSize: 14)
        cell!.textLabel?.textColor = UIColor.lightGray
        cell!.separatorInset = UIEdgeInsets (top: 0, left: 15, bottom: 0, right: 15)
        
        if sortItem.id == currentHotItemSortId {
            cell!.accessoryType = .checkmark
        } else {
            cell!.accessoryType = .none
        }
        
        return cell!
    }
    
    // MARK: - UITableViewDelegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let sortItem = hotItemListingSorts![indexPath.row]
        setHotItemSortId(sortItem.id)
        pagingControl.reset()
        loadHotItemTask()
        
        let header = hotItemCollectionView.supplementaryView(forElementKind: UICollectionElementKindSectionHeader, at: IndexPath(row: 0, section: 1)) as! UtilityButtonsHeaderView
        header.updateSelectedSort(sortItem: sortItem)
        
        hideSortPopupView()
        refreshSortPopupTableView()
    }
    
    // MARK: - HotItemRightSlideTableViewDataSourceAndDelegateDelegate
    
    func onHotItemCategoryCellTapped(hotItemCategory: HotItemCategory) {
        if hotItemCategory.hasChildren() {
            let dataSourceAndDelegate = getDataSourceAndDelegateByParentCategory(hotItemCategory)!
            rightSlideFilterViewController!.setTableViewDataSourceAndDelegate(dataSource: dataSourceAndDelegate, delegate: dataSourceAndDelegate)
            rightSlideDataSourceAdnDelegateStack.append(dataSourceAndDelegate)
        } else {
            // Set hot item category id as tempory
            temporyHotItemCategoryId = hotItemCategory.id
        }
    }
    
    func onBackCategoryHeaderTapped () {
        rightSlideDataSourceAdnDelegateStack.remove(at: rightSlideDataSourceAdnDelegateStack.count - 1)
        if rightSlideDataSourceAdnDelegateStack.count > 0 {
            let last = rightSlideDataSourceAdnDelegateStack.last!
            rightSlideFilterViewController!.setTableViewDataSourceAndDelegate(dataSource: last, delegate: last)
        } else {
            rightSlideFilterViewController!.setTableViewDataSourceAndDelegate(dataSource: rightSlideMainDataSourceAndDelegate!, delegate: rightSlideMainDataSourceAndDelegate!)
        }
    }
    
    func getCurrentSelectedCategoryId () -> String? {
        return currentHotItemCategoryId
    }
    
    func getTemporySelectedCategoryId () -> String? {
        return temporyHotItemCategoryId
    }
    
    // MARK: - HotItemRightSlideTableViewMainDataSourceAndDelegateDelegate
    
    func onCategoryCellTapped() {
        let dataSourceAndDelegate = getDataSourceAndDelegateByParentCategory(nil)!
        rightSlideFilterViewController!.setTableViewDataSourceAndDelegate(dataSource: dataSourceAndDelegate, delegate: dataSourceAndDelegate)
        rightSlideDataSourceAdnDelegateStack.append(dataSourceAndDelegate)
    }
    
    func onPriceRangeLowerBoundChanged (lower: String?) {
        setPriceRangeLowerBound (lower)
    }
    
    func onPriceRangeUpperBoundChanged (upper: String?) {
        setPriceRangeUpperBound (upper)
    }
    
    func getPriceRangeSetting () -> (String?, String?)? {
        return priceRange
    }
    
    // MARK: - UISearchBarDelegate
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        keyword = searchBar.text
        
        if keyword != nil && !keyword!.isEmpty {
            pagingControl.reset()
            loadHotItemTask()
        }
        
        searhController.dismiss(animated: true, completion: nil)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        keyword = nil
        
        pagingControl.reset()
        loadHotItemTask()
    }
    
    // MARK: - UIViewControllerPreviewingDelegate
    
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, viewControllerForLocation location: CGPoint) -> UIViewController? {
        guard let indexPath = hotItemCollectionView.indexPathForItem(at: location) else { return nil }
        guard let cell = hotItemCollectionView.cellForItem(at: indexPath) else { return nil }
        let item = hotItems![indexPath.row]
        let imageVC = ImageViewPeekViewController ()
        imageVC.update(imageURLStr: item.imageUrl)
        imageVC.preferredContentSize = CGSize (width: 50, height: 50)
        previewingContext.sourceRect = cell.frame
        return imageVC
    }
    
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, commit viewControllerToCommit: UIViewController) {
        show(viewControllerToCommit, sender: self)
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
