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
}

class StoresViewControllerPopupView: UIView {
    
    // MARK: - Properties
    
    static let key = "StoresViewControllerPopupView"
    
    static let nib = UINib (nibName: key, bundle: nil)
    
    @IBOutlet var contentView: UIView!
    
    @IBOutlet weak var leftTableView: UITableView!
    
    @IBOutlet weak var rightTableView: UITableView!
    
    @IBOutlet weak var rightTableViewWidthConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var leftTableViewHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var dismissButton: UIButton!
    
    private var parentCategories: [StoreSubCategory]? = nil
    
    private var childCategories: [StoreSubCategory]? = nil
    
    var delegate: StoresViewControllerPopupViewDelegate? = nil
    
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
    
    func setSourceAndDelegate (source: UITableViewDataSource, delegate: UITableViewDelegate) {
        leftTableView.dataSource = source
        leftTableView.delegate = delegate
        
        refreshLeftTableView()
        layoutIfNeeded()
    }
    
    func animateLeftTableView (isShow: Bool, completion: (() -> Void)? = nil) {
        let targetHeight: CGFloat = isShow ? leftTableView.contentSize.height : 0
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
        
        leftTableView.separatorInset = UIEdgeInsets (top: 0, left: 15, bottom: 0, right: 15)
        rightTableView.separatorInset = UIEdgeInsets (top: 0, left: 15, bottom: 0, right: 15)
        
        dismissButton.addTarget(self, action: #selector(onDismissButtonTapped(_:)), for: .touchUpInside)
    }
    
    @objc private func onDismissButtonTapped (_ sender: AnyObject?) {
        delegate?.handleOnDismissButtonTapped()
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

class StoreSubCategoryDataSourceAndDelegate: NSObject, UITableViewDataSource, UITableViewDelegate {
    
    var subcategories: [StoreSubCategory]? = nil
    
    override init() {
        super.init()
    }
    
    func setSource (subcategories: [StoreSubCategory]?) {
        self.subcategories = subcategories
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return subcategories == nil ? 0 : subcategories!.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "SubCategoryCell")
        
        if cell == nil {
            cell = UITableViewCell(style: .default, reuseIdentifier: "SubCategoryCell")
        }
        
        let subcategory = subcategories![indexPath.row]
        
        cell!.textLabel?.text = subcategory.name
        cell!.textLabel?.textColor = UIColor.darkGray
        cell!.textLabel?.font = UIFont.systemFont(ofSize: 14)
        
        cell!.accessoryType = subcategory.children != nil && subcategory.children!.count > 0 ? .disclosureIndicator : .none
        
        return cell!
    }
}

class StoreSortDataSourceAndDelegate: NSObject, UITableViewDataSource, UITableViewDelegate {
    
    var sorts: [Sort]? = nil
    
    override init() {
        super.init()
    }
    
    func setSource (sorts: [Sort]?) {
        self.sorts = sorts
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sorts == nil ? 0 : sorts!.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "SortCell")
        
        if cell == nil {
            cell = UITableViewCell (style: .default, reuseIdentifier: "SortCell")
        }
        
        let sort = sorts![indexPath.row]
        
        cell!.textLabel?.text = sort.name
        cell!.textLabel?.textColor = UIColor.darkGray
        cell!.textLabel?.font = UIFont.systemFont(ofSize: 14)
        cell!.tintColor = StoreCategoryControl.shared.themeColor
        cell!.accessoryType = .checkmark
        
        return cell!
    }
}

class StoreFilterDataSourceAndDelegate: NSObject, UITableViewDataSource, UITableViewDelegate {
    
    var filters: [StoreFilter]? = nil
    
    override init() {
        super.init()
    }
    
    func setSource (filters: [StoreFilter]?) {
        self.filters = filters
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filters == nil ? 0 : filters!.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
}

