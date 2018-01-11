//
//  StoreFilterCell.swift
//  diyordernative
//
//  Created by Richard Lu on 2018-01-05.
//  Copyright © 2018 goopter. All rights reserved.
//

import UIKit

protocol StoreFilterCellDelegate {
    func onSwitchFilterTapped (id: Int)
    func onSelectionFilterOptionTapped (id: Int, optionId: Int)
    func isSwitchFilterSelected (id: Int) -> Bool
    func isSelectionFilterOptionSelected (id: Int, optionId: Int) -> Bool
}

class StoreFilterCell: UITableViewCell, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    // MARK: - Properties
    
    static let key = "StoreFilterCell"
    
    static let nib = UINib (nibName: key, bundle: nil)
    
    @IBOutlet weak var filterOptionCollectionView: UICollectionView!

    //@IBOutlet weak var filterOptionCollectionViewHeightConstraint: NSLayoutConstraint!
    
    var selectionFilters: [StoreFilter]? = nil
    
    var switchFilters: [StoreFilter]? = nil
    
    var sectionCount: Int = 0
    
    private let itemWidth: CGFloat = 90
    
    private let itemHeight: CGFloat = 40
    
    private let itemPadding: CGFloat = 2
    
    var delegate: StoreFilterCellDelegate? = nil
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
//        filterOptionCollectionView.isScrollEnabled = false
        filterOptionCollectionView.register(StoreFilterOptionCell.nib, forCellWithReuseIdentifier: StoreFilterOptionCell.key)
        filterOptionCollectionView.register(StoreFilterHeaderView.nib, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: StoreFilterHeaderView.key)
        filterOptionCollectionView.dataSource = self
        filterOptionCollectionView.delegate = self
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func systemLayoutSizeFitting(_ targetSize: CGSize, withHorizontalFittingPriority horizontalFittingPriority: UILayoutPriority, verticalFittingPriority: UILayoutPriority) -> CGSize {
        filterOptionCollectionView.frame = CGRect (x: 0, y: 0, width: targetSize.width, height: 1)
        filterOptionCollectionView.layoutIfNeeded()
        return filterOptionCollectionView.collectionViewLayout.collectionViewContentSize
    }
    
    // MARK: - Implementation
    
    func setFilterSource (switchFilters: [StoreFilter]?, selectionFilters: [StoreFilter]?) {
        sectionCount = 0
        
        self.switchFilters = switchFilters
        self.selectionFilters = selectionFilters
        
        if switchFilters != nil && switchFilters!.count > 0 {
            sectionCount += 1
        }
        if selectionFilters != nil && selectionFilters!.count > 0 {
            sectionCount += selectionFilters!.count
        }
        
        refreshData()
        contentView.layoutIfNeeded()
    }
    
    func refreshData () {
        filterOptionCollectionView.reloadData()
        filterOptionCollectionView.layoutIfNeeded()
    }
    
    // MARK: - UICollectionViewDataSource
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return sectionCount;
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if switchFilters != nil && section == 0 {
            return switchFilters!.count
        } else {
            let dataOffset = switchFilters != nil ? 1 : 0
            let idx = section - dataOffset
            return selectionFilters![idx].options!.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: StoreFilterOptionCell.key, for: indexPath) as! StoreFilterOptionCell
        
        if switchFilters != nil && indexPath.section == 0 {
            let switchFilter = switchFilters![indexPath.row]
            let isSelected = delegate?.isSwitchFilterSelected(id: switchFilter.id!) ?? false
            cell.update(title: switchFilter.name, isSelected: isSelected)
        } else {
            let dataOffset = switchFilters != nil ? 1 : 0
            let idx = indexPath.section - dataOffset
            let selectionFilter = selectionFilters![idx]
            let filterOption = selectionFilter.options![indexPath.row]
            let isSelected = delegate?.isSelectionFilterOptionSelected(id: selectionFilter.id!, optionId: filterOption.id!) ?? false
            cell.update(title: filterOption.name, isSelected: isSelected)
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
        if switchFilters != nil && indexPath.section == 0 {
            let selectedFilter = switchFilters![indexPath.row]
            delegate?.onSwitchFilterTapped(id: selectedFilter.id!)
        } else {
            let dataOffset = switchFilters != nil ? 1 : 0
            let idx = indexPath.section - dataOffset
            let selectionFilter = selectionFilters![idx]
            let filterOption = selectionFilter.options![indexPath.row]
            delegate?.onSelectionFilterOptionTapped(id: selectionFilter.id!, optionId: filterOption.id!)
        }
        refreshData()
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader, withReuseIdentifier: StoreFilterHeaderView.key, for: indexPath) as! StoreFilterHeaderView
        
        let dataOffset = switchFilters != nil ? 1 : 0
        let idx = indexPath.section - dataOffset
        let selectionFilter = selectionFilters![idx]
        
        let title = switchFilters != nil && indexPath.section == 0 ? nil : selectionFilter.name
        header.update(titleText: title)
        
        return header
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        if switchFilters != nil && section == 0 {
            return CGSize (width: 0, height: 0)
        }
        
        return CGSize (width: collectionView.frame.width, height: 25)
    }
}
