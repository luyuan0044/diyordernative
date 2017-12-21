//
//  HotItemRightSlideTableViewHeaderView.swift
//  diyordernative
//
//  Created by Richard Lu on 2017-12-20.
//  Copyright © 2017 goopter. All rights reserved.
//

import UIKit

class HotItemRightSlideTableViewHeaderView: UITableViewHeaderFooterView {

    static let key = "HotItemRightSlideTableViewHeaderView"
    
    static let nib = UINib (nibName: key, bundle: nil)
    
    static func create () -> HotItemRightSlideTableViewHeaderView {
        return nib.instantiate(withOwner: self, options: nil)[0] as! HotItemRightSlideTableViewHeaderView
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        backIndicatorImageView.image = #imageLiteral(resourceName: "icon_back").withRenderingMode(.alwaysTemplate)
        backIndicatorImageView.tintColor = UIColor.darkGray
        backIndicatorImageView.contentMode = .scaleAspectFit
        
        titleLabel.textColor = UIColor.darkGray
    }
    
    @IBOutlet weak var backIndicatorImageView: UIImageView!
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var backButton: UIButton!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
