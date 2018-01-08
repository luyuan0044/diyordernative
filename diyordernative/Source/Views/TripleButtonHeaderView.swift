//
//  TripleButtonHeaderView.swift
//  diyordernative
//
//  Created by Richard Lu on 2018-01-03.
//  Copyright © 2018 goopter. All rights reserved.
//

import UIKit

protocol TripleButtonHeaderViewDelegate {
    func handleOnLeftButtonTapped ()
    func handleOnMiddleButtonTapped ()
    func handleOnRightButtonTapped ()
}

class TripleButtonHeaderView: UITableViewHeaderFooterView {

    //MARK: - Properties
    
    static let key = "TripleButtonHeaderView"
    
    static let nib = UINib (nibName: key, bundle: nil)
    
    @IBOutlet weak var leftButton: UIButton!
    
    @IBOutlet weak var middleButton: UIButton!
    
    @IBOutlet weak var rightButton: UIButton!
    
    @IBOutlet weak var topBorder: UIView!
    
    @IBOutlet weak var leftBorder: UIView!
    
    @IBOutlet weak var rightBorder: UIView!
    
    @IBOutlet weak var bottomBorder: UIView!
    
    var delegate: TripleButtonHeaderViewDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        leftButton.setTitleColor(.darkGray, for: .normal)
        leftButton.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        leftButton.addTarget(self, action: #selector(onLeftButtonTapped(_:)), for: .touchUpInside)
        
        middleButton.setTitleColor(.darkGray, for: .normal)
        middleButton.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        middleButton.addTarget(self, action: #selector(onMiddleButtonTapped(_:)), for: .touchUpInside)
        
        rightButton.setTitleColor(.darkGray, for: .normal)
        rightButton.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        rightButton.addTarget(self, action: #selector(onRightButtonTapped(_:)), for: .touchUpInside)
        
        topBorder.backgroundColor = UIConstants.generalBorderColor
        leftBorder.backgroundColor = UIConstants.generalBorderColor
        rightBorder.backgroundColor = UIConstants.generalBorderColor
        bottomBorder.backgroundColor = UIConstants.generalBorderColor
    }
    
    @objc private func onLeftButtonTapped (_ sender: AnyObject?) {
        delegate?.handleOnLeftButtonTapped()
    }
    
    @objc private func onMiddleButtonTapped (_ sender: AnyObject?) {
        delegate?.handleOnMiddleButtonTapped()
    }
    
    @objc private func onRightButtonTapped (_ sender: AnyObject?) {
        delegate?.handleOnRightButtonTapped()
    }
    
    func updateLeftButton (title: String?, with color: UIColor) {
        leftButton.setTitle(title, for: .normal)
        leftButton.setTitleColor(color, for: .normal)
    }
    
    func updateMiddleButton (title: String?, with color: UIColor) {
        middleButton.setTitle(title, for: .normal)
        middleButton.setTitleColor(color, for: .normal)
    }
    
    func updateRightButton (title: String?, with color: UIColor) {
        rightButton.setTitle(title, for: .normal)
        rightButton.setTitleColor(color, for: .normal)
    }
    
    func update (selectedSubcategory: StoreSubCategory?, selectedSort: Sort?, hasFilterSelected: Bool) {
        if let subcategory = selectedSubcategory {
            leftButton.setTitle(subcategory.name, for: .normal)
            leftButton.setTitleColor(StoreCategoryControl.shared.themeColor, for: .normal)
        }
        
        if let sort = selectedSort {
            middleButton.setTitle(sort.name, for: .normal)
            middleButton.setTitleColor(StoreCategoryControl.shared.themeColor, for: .normal)
        }
        
        if hasFilterSelected {
            rightButton.setTitleColor(StoreCategoryControl.shared.themeColor, for: .normal)
        }
    }
}
