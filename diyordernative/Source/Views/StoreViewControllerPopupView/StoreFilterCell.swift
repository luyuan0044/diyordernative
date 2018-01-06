//
//  StoreFilterCell.swift
//  diyordernative
//
//  Created by Richard Lu on 2018-01-05.
//  Copyright © 2018 goopter. All rights reserved.
//

import UIKit

class StoreFilterCell: UITableViewCell, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    // MARK: - Properties
    
    static let key = "StoreFilterCell"
    
    static let nib = UINib (nibName: key, bundle: nil)
    
    @IBOutlet weak var filterOptionCollectionView: UICollectionView!

    @IBOutlet weak var filterOptionCollectionViewHeightConstraint: NSLayoutConstraint!
    
    var selectionFilter: StoreFilter? = nil
    
    var switchFilters: [StoreFilter]? = nil
    
    private let itemWidth: CGFloat = 90
    
    private let itemHeight: CGFloat = 55
    
    private let itemPadding: CGFloat = 2
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        filterOptionCollectionView.register(StoreFilterOptionCell.nib, forCellWithReuseIdentifier: StoreFilterOptionCell.key)
        filterOptionCollectionView.dataSource = self
        filterOptionCollectionView.delegate = self
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    // MARK: - Implementation
    
    func setSwitchFilters (_ storeFilters: [StoreFilter]?) {
        switchFilters = storeFilters
        
        refreshData()
        
        filterOptionCollectionViewHeightConstraint.constant = filterOptionCollectionView.contentSize.height
        layoutIfNeeded()
    }
    
    func setSelectionFilter (_ storeFilter: StoreFilter) {
        selectionFilter = storeFilter
        
        refreshData()
        
        filterOptionCollectionViewHeightConstraint.constant = filterOptionCollectionView.contentSize.height
        layoutIfNeeded()
    }
    
    func refreshData () {
        filterOptionCollectionView.reloadData()
        filterOptionCollectionView.layoutIfNeeded()
    }
    
    // MARK: - UICollectionViewDataSource
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if switchFilters != nil {
            return switchFilters!.count
        } else if selectionFilter != nil && selectionFilter!.options != nil {
            return selectionFilter!.options!.count
        } else {
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: StoreFilterOptionCell.key, for: indexPath) as! StoreFilterOptionCell
        
        if switchFilters != nil {
            let switchFilter = switchFilters![indexPath.row]
            cell.update(title: switchFilter.name, isSelected: false)
        } else {
            let filterOption = selectionFilter!.options![indexPath.row]
            cell.update(title: filterOption.name, isSelected: false)
        }
        
        return cell
    }
    
    // MARK: - UICollectionViewDelegateFlowLayout
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize (width: itemWidth, height: itemHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return itemPadding
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return itemPadding
    }
    
    @available(iOS 11.0, *)
    func collectionView(_ collectionView: UICollectionView, shouldSpringLoadItemAt indexPath: IndexPath, with context: UISpringLoadedInteractionContext) -> Bool {
        return true
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets (top: itemPadding, left: itemPadding, bottom: itemPadding, right: itemPadding)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        var selectedFilter: StoreFilter!
        
        if switchFilters != nil && indexPath.section == 0 {
            selectedFilter = switchFilters![indexPath.row]
        } else {
//            selectionFilter!.options![indexPath.row]
        }
    }
}
