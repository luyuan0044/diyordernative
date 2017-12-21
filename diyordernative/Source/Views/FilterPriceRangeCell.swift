//
//  FilterPriceRangeCell.swift
//  diyordernative
//
//  Created by Yuan Lu on 2017-12-20.
//  Copyright © 2017 goopter. All rights reserved.
//

import UIKit

class FilterPriceRangeCell: UITableViewCell, UITextFieldDelegate {

    static let key = "FilterPriceRangeCell"
    
    static let nib = UINib (nibName: key, bundle: nil)
    
    static func create () -> FilterPriceRangeCell {
        return nib.instantiate(withOwner: self, options: nil)[0] as! FilterPriceRangeCell
    }
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var lowerBoundTextField: UITextField!
    
    @IBOutlet weak var upperBoundTextField: UITextField!
    
    var delegate: FilterPriceRangeCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        selectionStyle = .none
        
        titleLabel.textColor = UIColor.darkGray
        titleLabel.text = LanguageControl.shared.getLocalizeString(by: "price")
        
        lowerBoundTextField.font = UIFont.systemFont(ofSize: 12)
        lowerBoundTextField.textAlignment = .center
        lowerBoundTextField.placeholder = LanguageControl.shared.getLocalizeString(by: "min price")
        lowerBoundTextField.addTarget(self, action: #selector(handleLowerBoundEditingChanged(_:)), for: .editingChanged)
        lowerBoundTextField.backgroundColor = UIColor.white
        
        upperBoundTextField.font = UIFont.systemFont(ofSize: 12)
        upperBoundTextField.textAlignment = .center
        upperBoundTextField.placeholder = LanguageControl.shared.getLocalizeString(by: "max price")
        upperBoundTextField.addTarget(self, action: #selector(handleUpperBoundEditingChanged(_:)), for: .editingChanged)
        upperBoundTextField.backgroundColor = UIColor.white
    }
    
    func update (priceRange: (String?, String?)?) {
        if let pRange = priceRange {
            lowerBoundTextField.text = pRange.0
            upperBoundTextField.text = pRange.1
        }
    }
    
    @objc private func handleLowerBoundEditingChanged (_ sender: AnyObject?) {
        let lowerBound = (sender as! UITextField).text
        delegate?.onPriceRangeLowerBoundChanged(lower: lowerBound)
    }
    
    @objc private func handleUpperBoundEditingChanged (_ sender: AnyObject?) {
        let upperBound = (sender as! UITextField).text
        delegate?.onPriceRangeUpperBoundChanged(upper: upperBound)
    }
}

protocol FilterPriceRangeCellDelegate {
    func onPriceRangeLowerBoundChanged (lower: String?)
    func onPriceRangeUpperBoundChanged (upper: String?)
}
