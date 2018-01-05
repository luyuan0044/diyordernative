//
//  StoreSubCategoryPopupView.swift
//  diyordernative
//
//  Created by Richard Lu on 2018-01-04.
//  Copyright © 2018 goopter. All rights reserved.
//

import UIKit

class StoreSubCategoryPopupView: UIView, UITableViewDataSource, UITableViewDelegate {
    
    // MARK: - Properties
    
    static let key = "StoreSubCategoryPopupView"
    
    static let nib = UINib (nibName: key, bundle: nil)
    
    @IBOutlet var contentView: UIView!
    
    @IBOutlet weak var leftTableView: UITableView!
    
    @IBOutlet weak var rightTableView: UITableView!
    
    @IBOutlet weak var rightTableViewWidthConstraint: NSLayoutConstraint!
    
    private var parentCategories: [StoreSubCategory]? = nil
    
    private var childCategories: [StoreSubCategory]? = nil
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        xibSetup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        xibSetup()
    }
    
    // MARK: - Implementation
    
    func setSubCategories (_ subcategories: [StoreSubCategory]) {
        parentCategories = subcategories
    }
    
    func showRightTableView () {
        UIView.animate(withDuration: 0.2, animations: {
            self.rightTableViewWidthConstraint.constant = frame.width / 2
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
    
    // MARK: - UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == leftTableView {
            return parentCategories != nil ? parentCategories!.count : 0
        } else {
            return childCategories != nil ? childCategories!.count : 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
    
    // MARK: - UITableViewDelegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == leftTableView {
            let selectedCategory = parentCategories![indexPath.row]
            if selectedCategory.children != nil && selectedCategory.children!.count > 0 {
                childCategories = selectedCategory.children
                refreshRigthtableView()
                showRightTableView()
            }
        } else {
            
        }
    }
}

private extension StoreSubCategoryPopupView {
    private func xibSetup() {
        Bundle.main.loadNibNamed(StoreSubCategoryPopupView.key, owner: self, options: nil)
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

