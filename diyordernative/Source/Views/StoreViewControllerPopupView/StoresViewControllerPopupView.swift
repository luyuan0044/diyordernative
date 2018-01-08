//
//  StoreSubCategoryPopupView.swift
//  diyordernative
//
//  Created by Richard Lu on 2018-01-04.
//  Copyright © 2018 goopter. All rights reserved.
//

import UIKit

protocol StoresViewControllerPopupViewDelegate {
    func handleOnDismissButtonTapped ()
    func onSelectedSubcategory(_ subcategory: StoreSubCategory)
    func onSelectedSort (_ sort: Sort)
    func getSelectedSubcategory () -> StoreSubCategory?
    func onSwitchFilterSelected (id: Int)
    func onSelectionFitlerSelected (id: Int, optionId: Int)
    func isSwitchFilterSelected (id: Int) -> Bool
    func isSelectionFilterSelected (id: Int, optionId: Int) -> Bool
}

class StoresViewControllerPopupView: UIView, StoreSubCategoryDataSourceAndDelegateDelegate {

    // MARK: - Properties
    
    static let key = "StoresViewControllerPopupView"
    
    static let nib = UINib (nibName: key, bundle: nil)
    
    @IBOutlet var contentView: UIView!
    
    @IBOutlet weak var leftTableView: UITableView!
    
    @IBOutlet weak var rightTableView: UITableView!
    
    @IBOutlet weak var rightTableViewWidthConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var leftTableViewHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var dismissButton: UIButton!
    
    var delegate: StoresViewControllerPopupViewDelegate? = nil
    
    var rightTableViewSourceAndDelegate: StoreSubCategoryDataSourceAndDelegate? = nil
    
    var isRightTableViewShowed = false
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        xibSetup()
        viewSetup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        xibSetup()
        viewSetup()
    }
    
    // MARK: - Implementation
    
    func setSourceAndDelegate (sourceAndDelegate: StoresViewControllerPopupViewSourceAndDelegate) {
        sourceAndDelegate.delegate = self
        leftTableView.dataSource = sourceAndDelegate
        leftTableView.delegate = sourceAndDelegate
        
        refreshLeftTableView()
        layoutIfNeeded()
        
        refreshLeftTableView()
        layoutIfNeeded()
    }
    
    func animateLeftTableView (isShow: Bool, completion: (() -> Void)? = nil) {
        hideRightTableView()
        
        let targetHeight: CGFloat = isShow ? leftTableView.contentSize.height : 0
        UIView.animate(withDuration: 0.2, animations: {
            self.leftTableViewHeightConstraint.constant = targetHeight
            self.layoutIfNeeded()
        }, completion: {
            isComplete in
            
            if isComplete && completion != nil {
                completion!()
            }
        })
    }
    
    /**
     Show right table view with left slide animation
     */
    func showRightTableView () {
        if isRightTableViewShowed {
            return
        }
        
        isRightTableViewShowed = true
        UIView.animate(withDuration: 0.2, animations: {
            self.rightTableViewWidthConstraint.constant = self.frame.width / 2
            self.layoutIfNeeded()
        })
    }
    
    /**
     Hide right table view with right slide animation
     */
    func hideRightTableView () {
        if !isRightTableViewShowed {
            return
        }
        
        isRightTableViewShowed = false
        UIView.animate(withDuration: 0.2, animations: {
            self.rightTableViewWidthConstraint.constant = 0
            self.layoutIfNeeded()
        })
    }
    
    func refreshLeftTableView () {
        leftTableView.reloadData()
        leftTableView.layoutIfNeeded()
    }
    
    func refreshRigthtableView () {
        rightTableView.reloadData()
        rightTableView.layoutIfNeeded()
    }
    
    func viewSetup () {
        backgroundColor = UIColor.clear
        contentView.backgroundColor = UIColor.clear
        dismissButton.backgroundColor = UIConstants.transparentBlackColor
        
        leftTableView.isScrollEnabled = false
        leftTableView.separatorInset = UIEdgeInsets (top: 0, left: 15, bottom: 0, right: 15)
        leftTableView.register(StoreFilterCell.nib, forCellReuseIdentifier: StoreFilterCell.key)
        
        rightTableView.separatorInset = UIEdgeInsets (top: 0, left: 15, bottom: 0, right: 15)
        
        dismissButton.addTarget(self, action: #selector(onDismissButtonTapped(_:)), for: .touchUpInside)
    }
    
    @objc private func onDismissButtonTapped (_ sender: AnyObject?) {
        delegate?.handleOnDismissButtonTapped()
    }
    
    func updateSelectedCategoryOnRightTableViewSourceAndDelegate (selectedSubcategory: StoreSubCategory?) {
        if rightTableViewSourceAndDelegate == nil {
            createRightTableViewSourceAndDelegate()
        }
        rightTableViewSourceAndDelegate?.setSelectedSubCategory(selectedSubcategory: selectedSubcategory)
    }
    
    private func createRightTableViewSourceAndDelegate () {
        rightTableViewSourceAndDelegate = StoreSubCategoryDataSourceAndDelegate()
        rightTableView.dataSource = rightTableViewSourceAndDelegate
        rightTableView.delegate = rightTableViewSourceAndDelegate
        rightTableViewSourceAndDelegate!.delegate = self
    }
    
    // MARK: - StoreSubCategoryDataSourceAndDelegateDelegate
    
    func onSubCategoryCellTapped(subcategory: StoreSubCategory) {
        if subcategory.children != nil && subcategory.children!.count > 0 {
            if rightTableViewSourceAndDelegate == nil {
                createRightTableViewSourceAndDelegate()
            }
            
            let selectedSubcategory = delegate?.getSelectedSubcategory()
            rightTableViewSourceAndDelegate!.setSource(subcategories: subcategory.children!, selectedSubcategory: selectedSubcategory)
            refreshRigthtableView()
            
            showRightTableView()
        } else {
            hideRightTableView()
            delegate?.onSelectedSubcategory (subcategory)
        }
    }
    
    func onSortCelltapped(sort: Sort) {
        delegate?.onSelectedSort(sort)
    }
    
    func onSwitchFilterTapped(id: Int) {
        delegate?.onSwitchFilterSelected(id: id)
    }
    
    func onSelectionFilterOptionTapped(id: Int, optionId: Int) {
        delegate?.onSelectionFitlerSelected(id: id, optionId: optionId)
    }
    
    func isSwitchFilterSelected(id: Int) -> Bool {
        return delegate?.isSwitchFilterSelected(id: id) ?? false
    }
    
    func isSelectionFilterOptionSelected(id: Int, optionId: Int) -> Bool {
        return delegate?.isSelectionFilterSelected(id: id, optionId: optionId) ?? false
    }
}

private extension StoresViewControllerPopupView {
    private func xibSetup() {
        Bundle.main.loadNibNamed(StoresViewControllerPopupView.key, owner: self, options: nil)
        addSubview(contentView)
        
        contentView.translatesAutoresizingMaskIntoConstraints = false
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[childView]|",
                                                      options: [],
                                                      metrics: nil,
                                                      views: ["childView": contentView]))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[childView]|",
                                                      options: [],
                                                      metrics: nil,
                                                      views: ["childView": contentView]))
    }
}

