//
//  UtilsPopupItemView.swift
//  diyordernative
//
//  Created by Richard Lu on 2018-01-04.
//  Copyright © 2018 goopter. All rights reserved.
//

import UIKit

class UtilsPopupItem {
    var titleText: String
    var iconImage: UIImage
    
    init(titleText: String, iconImage: UIImage) {
        self.titleText = titleText
        self.iconImage = iconImage
    }
}

class UtilsPopupItemView: UIView {
    
    static let key = "UtilsPopupItemView"
    
    static let nib = UINib (nibName: key, bundle: nil)
    
    @IBOutlet weak var iconImageView: UIImageView!
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var seperatorView: UIView!
    
    @IBOutlet weak var contentView: UIView!
    
    var item: UtilsPopupItem!
    
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
    
    func setup (item: UtilsPopupItem) {
        self.item = item
        
        titleLabel.text = item.titleText
        iconImageView.image = item.iconImage.withRenderingMode(.alwaysTemplate)
    }
    
    private func viewSetup () {
        backgroundColor = UIColor.clear
        contentView.backgroundColor = UIColor.clear
        
        seperatorView.backgroundColor = UIConstants.generalBorderColor
        
        iconImageView.contentMode = .scaleAspectFit
        iconImageView.tintColor = UIColor.white
        
        titleLabel.textColor = UIColor.white
    }
}

private extension UtilsPopupItemView {
    private func xibSetup() {
        Bundle.main.loadNibNamed(UtilsPopupItemView.key, owner: self, options: nil)
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
