//
//  HotItemViewController.swift
//  diyordernative
//
//  Created by Richard Lu on 2017-12-13.
//  Copyright © 2017 goopter. All rights reserved.
//

import UIKit

class HotItemViewController: BaseViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UITableViewDelegate, UITableViewDataSource, UtilityButtonsHeaderViewDelegate, HotItemCategoryHeaderViewDelegate, RightSlideFilterViewControllerDelegate, HotItemRightSlideTableViewDataSourceAndDelegateDelegate {
   
    // MARK: - Properties
    
    static let tabTitle = "hot"
    
    static let icon = #imageLiteral(resourceName: "icon_hot")
    
    @IBOutlet weak var hotItemCollectionView: UICollectionView!
    
    @IBOutlet weak var sortPopupPanelView: UIView!
    
    @IBOutlet weak var sortPopupTableView: UITableView!
    
    @IBOutlet weak var sortPopupTableViewHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var sortPopupPanelViewTopConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var hideSortPopupPanelViewButton: UIButton!
    
    var currentHotItemCategoryId: String? = nil
    
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
    
    var rightSlideFilterViewController: RightSlideFilterViewController? = nil
    
    var isRightSlideFilterViewControllerPresented = false
    
    var rightSlideDataSourceAndDelegateDict: [String: HotItemRightSlideTableViewDataSourceAndDelegate]? = nil
    
    let keyOfRightSlideDataSourceAndDelegate = "base"
    
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
        
        hotItemCollectionView.backgroundColor = UIColor.groupTableViewBackground
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
        
        fetch()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Implementation
    
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
    
    func loadMore () {
        loadHotItemTask (completion: nil)
    }
    
    private func loadHotItemCategoryTask (completion: (() -> Void)?) {
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
    
    private func loadHotItemSortItemsTask (completion: (() -> Void)?) {
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
    
    private func loadHotItemTask (completion: (() -> Void)?) {
        DispatchQueue.global(qos: .userInitiated).async {
            let urlparams = self.getUrlParams()
            HotItemLoader.startRequestHotItems(_urlparams: urlparams, completion: {
                _status, items in
                
                if _status == .success {
                    self.hotItems = items
                }
                
                DispatchQueue.main.async {
                    self.refreshHotItemSection()
                }
                
                completion?()
            })
        }
    }
    
    func refreshHotItemCollectionView () {
        hotItemCollectionView.reloadData()
        hotItemCollectionView.layoutIfNeeded()
    }
    
    func refreshHotItemSection () {
        hotItemCollectionView.reloadSections(IndexSet (integer: 1))
        hotItemCollectionView.layoutIfNeeded()
    }
    
    func refreshSortPopupTableView () {
        sortPopupTableView.reloadData()
        sortPopupPanelView.layoutIfNeeded()
    }
    
    func switchCollectionViewDisplayStyle () {
        colletionViewDisplayStyle = colletionViewDisplayStyle == .grid ? .list : .grid
        refreshHotItemCollectionView()
    }
    
    func showRightSlideFilterViewController () {
        if rightSlideFilterViewController == nil {
            rightSlideFilterViewController = RightSlideFilterViewController()
            rightSlideFilterViewController!.delegate = self
            rightSlideFilterViewController!.modalPresentationStyle = .overFullScreen
            rightSlideFilterViewController!.modalTransitionStyle = .crossDissolve
        }
        
        let dataSourceAndDelegate = getDataSourceAndDelegateByParentCategory(nil)!
        rightSlideFilterViewController!.setTableViewDataSourceAndDelegate(dataSource: dataSourceAndDelegate, delegate: dataSourceAndDelegate)
        
        present(rightSlideFilterViewController!, animated: true, completion: {
            self.isRightSlideFilterViewControllerPresented = true;
        })
    }
    
    func hideRightSlideFilterViewContrller () {
        guard isRightSlideFilterViewControllerPresented || rightSlideFilterViewController != nil else {
            return
        }
        
        rightSlideFilterViewController?.dismiss(animated: true, completion: {
            self.isRightSlideFilterViewControllerPresented = false
        })
    }
    
    func showSortPopupView () {
        sortPopupPanelView.isHidden = false
        let header = hotItemCollectionView.supplementaryView(forElementKind: UICollectionElementKindSectionHeader, at: IndexPath (row: 0, section: 1))!
        let yPosition = header.frame.maxY
        sortPopupPanelViewTopConstraint.constant = yPosition
        view.layoutSubviews()
        sortPopupTableView.isHidden = false
        UIView.animate(withDuration: 0.2, animations: {
            self.sortPopupTableViewHeightConstraint.constant = self.sortPopupTableView.contentSize.height
            self.view.layoutSubviews()
        })
    }
    
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
    
    @objc private func handleOnHideSortPopupPanelViewButtonTapped (_ sender: AnyObject?) {
        hideSortPopupView()
    }
    
    func setHotItemCategoryId (_ id: String?) {
        currentHotItemCategoryId = id
    }
    
    func setHotItemSortId (_ id: String?) {
        currentHotItemSortId = id
    }
    
    func setKeyword (_ keyword: String?) {
        self.keyword = keyword
    }
    
    func getUrlParams () -> [String: String]? {
        var result: [String: String]? = nil
        
        if let filterid = currentHotItemCategoryId {
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
        
        return result
    }
    
    func getDataSourceAndDelegateByParentCategory (_ hotItemCategory: HotItemCategory?) -> HotItemRightSlideTableViewDataSourceAndDelegate? {
        
        if hotItemCategory == nil {
            if (rightSlideDataSourceAndDelegateDict == nil || !rightSlideDataSourceAndDelegateDict!.contains(where: {$0.key == keyOfRightSlideDataSourceAndDelegate})) {
                rightSlideDataSourceAndDelegateDict = [:]
                
                let dataSourceAndDelegate = HotItemRightSlideTableViewDataSourceAndDelegate()
                dataSourceAndDelegate.items = self.hotItemCategories
                dataSourceAndDelegate.delegate = self
                rightSlideDataSourceAndDelegateDict![keyOfRightSlideDataSourceAndDelegate] = dataSourceAndDelegate
                
                return dataSourceAndDelegate
            } else {
                return rightSlideDataSourceAndDelegateDict![keyOfRightSlideDataSourceAndDelegate]
            }
        }
        
        if rightSlideDataSourceAndDelegateDict == nil {
            rightSlideDataSourceAndDelegateDict = [:]
        }
        
        if rightSlideDataSourceAndDelegateDict!.contains(where: {$0.key == hotItemCategory!.id}) {
            return rightSlideDataSourceAndDelegateDict![hotItemCategory!.id!]
        } else {
            let dataSourceAndDelegate = HotItemRightSlideTableViewDataSourceAndDelegate()
            dataSourceAndDelegate.items = hotItemCategory!.children
            dataSourceAndDelegate.delegate = self
            rightSlideDataSourceAndDelegateDict![hotItemCategory!.id!] = dataSourceAndDelegate
            
            return dataSourceAndDelegate
        }
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
    
    // MARK: - UtilityButtonsHeaderViewDelegate
    
    func onFirstButtonTapped() {
        if sortPopupTableView.isHidden {
            showSortPopupView()
        } else {
            hideSortPopupView()
        }
    }
    
    func onSecondButtonTapped() {
        setHotItemSortId(hotItemTabSort?.id)
        refreshSortPopupTableView()
        loadHotItemTask(completion: nil)
    }
    
    func onSquareButtonTapped() {
        switchCollectionViewDisplayStyle()
        if let header = hotItemCollectionView.supplementaryView(forElementKind: UICollectionElementKindSectionHeader, at: IndexPath(row: 0, section: 1)) {
            (header as! UtilityButtonsHeaderView).updateSquareButtonIcon(iconImage: colletionViewDisplayStyleIcon)
        }
    }
    
    func onRightButtonTapped() {
        showRightSlideFilterViewController()
        
        if !sortPopupPanelView.isHidden {
            hideSortPopupView()
        }
    }
    
    // MARK: - HotItemCategoryHeaderViewDelegate
    
    func onHotItemCategoryTapped(selectedHotItemCategory: HotItemCategory?) {
        setHotItemCategoryId (selectedHotItemCategory?.id)
        loadHotItemTask (completion: nil)
        
        if !sortPopupPanelView.isHidden {
            hideSortPopupView()
        }
    }
    
    // MARK: - RightSlideFilterViewControllerDelegate
    
    func onHideButtonTapped() {
        hideRightSlideFilterViewContrller()
    }
    
    func onResetButtonTapped() {
        hideRightSlideFilterViewContrller()
    }
    
    func onConfirmButtonTapped() {
        hideRightSlideFilterViewContrller()
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
        loadHotItemTask(completion: nil)
        
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
        } else {
            setHotItemCategoryId(hotItemCategory.id)
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
