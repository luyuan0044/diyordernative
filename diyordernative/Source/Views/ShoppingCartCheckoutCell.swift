//
//  ShoppingCartCheckoutCell.swift
//  diyordernative
//
//  Created by Richard Lu on 2017-12-21.
//  Copyright © 2017 goopter. All rights reserved.
//

import UIKit

protocol ShoppingCartCheckoutCellDelegate {
    func onCheckoutButtonTapped ()
}

class ShoppingCartCheckoutCell: UITableViewCell {
    
    static let key = "ShoppingCartCheckoutCell"
    
    static let nib = UINib (nibName: key, bundle: nil)
    
    @IBOutlet weak var orderTotalTitle: UILabel!
    
    @IBOutlet weak var orderTotalLabel: UILabel!
    
    @IBOutlet weak var checkoutButton: UIButton!
    
    var delegate: ShoppingCartCheckoutCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        orderTotalTitle.text = LanguageControl.shared.getLocalizeString(by: "sub total") + ":"
        orderTotalTitle.font = UIFont.systemFont(ofSize: 14)
        
        orderTotalLabel.textColor = UIConstants.appThemeColor
        orderTotalLabel.font = UIFont.systemFont(ofSize: 14)
        
        checkoutButton.backgroundColor = UIConstants.checkoutButtonColor
        checkoutButton.setTitle(LanguageControl.shared.getLocalizeString(by: "checkout"), for: .normal)
        checkoutButton.setTitleColor(UIColor.white, for: .normal)
        checkoutButton.titleLabel?.textColor = UIColor.white
        checkoutButton.addTarget(self, action: #selector(onCheckoutButtonTapped(_:)), for: .touchUpInside)
    }
    
    func update (subtotal: Float, contentColor: UIColor) {
        orderTotalTitle.textColor = contentColor
    }
    
    @objc private func onCheckoutButtonTapped (_ sender: AnyObject?) {
        delegate?.onCheckoutButtonTapped()
    }
}
