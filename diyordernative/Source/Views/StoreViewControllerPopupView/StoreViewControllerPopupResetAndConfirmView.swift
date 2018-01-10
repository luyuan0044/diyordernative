//
//  StoreViewControllerPopupResetAndConfirmView.swift
//  diyordernative
//
//  Created by Richard Lu on 2018-01-09.
//  Copyright © 2018 goopter. All rights reserved.
//

import UIKit

protocol StoreViewControllerPopupResetAndConfirmViewDelegate {
    func onResetButtonTapped ()
    func onConfirmButtonTapped ()
}

class StoreViewControllerPopupResetAndConfirmView: UITableViewHeaderFooterView {
    
    static let key = "StoreViewControllerPopupResetAndConfirmView"
    
    static let nib = UINib (nibName: key, bundle: nil)
    
    @IBOutlet weak var resetButton: UIButton!
    
    @IBOutlet weak var confirmButton: UIButton!
    
    var delegate: StoreViewControllerPopupResetAndConfirmViewDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        resetButton.backgroundColor = StoreCategoryControl.shared.themeColor.withAlphaComponent(0.4)
        resetButton.setTitle(LanguageControl.shared.getLocalizeString(by: "reset"), for: .normal)
        resetButton.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        resetButton.addTarget(self, action: #selector(onResetButtonTapped(_:)), for: .touchUpInside)
        
        confirmButton.backgroundColor = StoreCategoryControl.shared.themeColor
        confirmButton.setTitle(LanguageControl.shared.getLocalizeString(by: "confirm"), for: .normal)
        confirmButton.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        confirmButton.addTarget(self, action: #selector(onConfirmButtonTapped(_:)), for: .touchUpInside)
    }
    
    @objc private func onResetButtonTapped (_ sender: AnyObject?) {
        delegate?.onResetButtonTapped()
    }
    
    @objc private func onConfirmButtonTapped (_ sender: AnyObject?) {
        delegate?.onConfirmButtonTapped()
    }
}
