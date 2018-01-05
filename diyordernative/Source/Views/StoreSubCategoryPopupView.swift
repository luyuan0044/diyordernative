//
//  StoreSubCategoryPopupView.swift
//  diyordernative
//
//  Created by Richard Lu on 2018-01-04.
//  Copyright © 2018 goopter. All rights reserved.
//

import UIKit

protocol StoreSubCategoryPopupViewDelegate {
    func handleOnDismissButtonTapped ()
}

class StoreSubCategoryPopupView: UIView, UITableViewDataSource, UITableViewDelegate {
    
    // MARK: - Properties
    
    static let key = "StoreSubCategoryPopupView"
    
    static let nib = UINib (nibName: key, bundle: nil)
    
    @IBOutlet var contentView: UIView!
    
    @IBOutlet weak var leftTableView: UITableView!
    
    @IBOutlet weak var rightTableView: UITableView!
    
    @IBOutlet weak var rightTableViewWidthConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var leftTableViewHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var dismissButton: UIButton!
    
    private var parentCategories: [StoreSubCategory]? = nil
    
    private var childCategories: [StoreSubCategory]? = nil
    
    var delegate: StoreSubCategoryPopupViewDelegate? = nil
    
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
    
    func setSubCategories (_ subcategories: [StoreSubCategory]) {
        parentCategories = subcategories
        refreshLeftTableView()
        self.layoutIfNeeded()
    }
    
    func animateLeftTableView (isShow: Bool, completion: (() -> Void)? = nil) {
        let targetHeight: CGFloat = isShow ? 300 : 0 //leftTableView.contentSize.height
        UIView.animate(withDuration: 0.3, animations: {
            self.leftTableViewHeightConstraint.constant = targetHeight
            self.layoutIfNeeded()
        }, completion: {
            isComplete in
            
            if isComplete && completion != nil {
                completion!()
            }
        })
    }
    
    func showRightTableView () {
        UIView.animate(withDuration: 0.2, animations: {
            self.rightTableViewWidthConstraint.constant = self.frame.width / 2
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
        
        dismissButton.addTarget(self, action: #selector(onDismissButtonTapped(_:)), for: .touchUpInside)
    }
    
    @objc private func onDismissButtonTapped (_ sender: AnyObject?) {
        delegate?.handleOnDismissButtonTapped()
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

