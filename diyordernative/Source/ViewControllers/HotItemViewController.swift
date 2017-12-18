//
//  HotItemViewController.swift
//  diyordernative
//
//  Created by Richard Lu on 2017-12-13.
//  Copyright © 2017 goopter. All rights reserved.
//

import UIKit

class HotItemViewController: BaseViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UtilityButtonsHeaderViewDelegate, RightSlideFilterViewControllerDelegate {
    
    

    // MARK: - Properties
    
    static let title = "Hot"
    
    static let icon = #imageLiteral(resourceName: "icon_hot")
    
    @IBOutlet weak var hotItemCollectionView: UICollectionView!
    
    var hotItemCategories: [HotItemCategory]? = nil
    
    var hotItems: [HotItem]? = nil
    
    var colletionViewDisplayStyle: colletionViewDisplayStyle = .grid
    
    var colletionViewDisplayStyleIcon: UIImage { get { return colletionViewDisplayStyle == .grid ? #imageLiteral(resourceName: "icon_grid") : #imageLiteral(resourceName: "icon_list") } }
    
    let hotItemPadding: CGFloat = 5
    
    var numberOfItemPerLine: CGFloat { get { return colletionViewDisplayStyle == .grid ? 2 : 1 } }
    
    let heightOfHeader: CGFloat = 40
    
    var rightSlideFilterViewController: RightSlideFilterViewController? = nil
    
    var isRightSlideFilterViewControllerPresented = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        navigationController?.navigationBar.barTintColor = UIConstants.appThemeColor
        tabBarItem = UITabBarItem (title: HotItemViewController.title, image: HotItemViewController.icon, tag: 1)
        
        hotItemCollectionView.register(HotItemCategoryHeaderView.nib, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: HotItemCategoryHeaderView.key)
        hotItemCollectionView.register(UtilityButtonsHeaderView.nib, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: UtilityButtonsHeaderView.key)
        hotItemCollectionView.register(CollectionLoadingFooterView.nib, forSupplementaryViewOfKind: UICollectionElementKindSectionFooter, withReuseIdentifier: CollectionLoadingFooterView.key)
        hotItemCollectionView.register(GridProductCell.nib, forCellWithReuseIdentifier: GridProductCell.key)
        
        hotItemCollectionView.dataSource = self
        hotItemCollectionView.delegate = self
        // sticky header setup
        let layout = hotItemCollectionView.collectionViewLayout as? UICollectionViewFlowLayout
        layout?.sectionHeadersPinToVisibleBounds = true
        
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
    
    private func loadHotItemTask (completion: (() -> Void)?) {
        DispatchQueue.global(qos: .userInitiated).async {
            HotItemLoader.startRequestHotItems(urlparams: [:], completion: {
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
    
    func switchCollectionViewDisplayStyle () {
        colletionViewDisplayStyle = colletionViewDisplayStyle == .grid ? .list : .grid
        refreshHotItemCollectionView()
    }
    
    func showRightSlideFilterViewController () {
        if rightSlideFilterViewController == nil {
            rightSlideFilterViewController = RightSlideFilterViewController()
            rightSlideFilterViewController?.delegate = self
            rightSlideFilterViewController?.modalPresentationStyle = .overFullScreen
            rightSlideFilterViewController?.modalTransitionStyle = .crossDissolve
        }
        
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
    
    // MARKL - UICollectionViewDataSource
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if hotItems != nil {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: GridProductCell.key, for: indexPath) as! GridProductCell
            
            let hotItem = hotItems![indexPath.row]
            cell.update(hotItem: hotItem)
            
            return cell
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
                
                return view
            } else {
                let view = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: UtilityButtonsHeaderView.key, for: indexPath) as! UtilityButtonsHeaderView
                view.delegate = self
                view.setup(firstButtonTitle: "Relevance", secondButtonTitle: "Volume", squareIcon: colletionViewDisplayStyleIcon, rightButtonTitle: "Filter")
                
                return view
            }
        } else {
            let view = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: CollectionLoadingFooterView.key, for: indexPath)
            
            return view
        }
    }
    
    // MARK: - UICollectionViewDelegateFlowLayout
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let interItemSpace = (numberOfItemPerLine - 1) * hotItemPadding
        let itemWidth: CGFloat = (collectionView.frame.width - interItemSpace) / numberOfItemPerLine
        let itemHeight: CGFloat = itemWidth * 1.5
        return CGSize (width: itemWidth, height: itemHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return hotItemPadding
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return hotItemPadding / 2
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
        
    }
    
    func onSecondButtonTapped() {
        
    }
    
    func onSquareButtonTapped() {
        switchCollectionViewDisplayStyle()
        if let header = hotItemCollectionView.supplementaryView(forElementKind: UICollectionElementKindSectionHeader, at: IndexPath(row: 0, section: 1)) {
            (header as! UtilityButtonsHeaderView).updateSquareButtonIcon(iconImage: colletionViewDisplayStyleIcon)
        }
    }
    
    func onRightButtonTapped() {
        showRightSlideFilterViewController()
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
