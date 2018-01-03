//
//  IconLabelButtonView.swift
//  diyordernative
//
//  Created by Richard Lu on 2017-12-12.
//  Copyright © 2017 goopter. All rights reserved.
//

import UIKit
import SDWebImage

protocol IconLabelButtonViewItem {
    func getImageUrl () -> String?
    func getTitleText () -> String?
}

class IconLabelButtonView: UIView {
    
    static let key = "IconLabelButtonView"
    
    static let nib = UINib (nibName: key, bundle: nil)

    @IBOutlet var contentView: UIView!
    
    @IBOutlet weak var iconImageView: UIImageView!
    
    @IBOutlet weak var titleLabel: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        commonInit()
        
        viewSetup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        commonInit()
    }
    
    func commonInit ()
    {
        Bundle.main.loadNibNamed(IconLabelButtonView.key, owner: self, options: nil)
        addSubview(contentView)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        viewSetup()
    }
    
    func update (item: IconLabelButtonViewItem) {
        iconImageView.sd_setImage(with: URL(string: item.getImageUrl()!)!)
        
        titleLabel.text = item.getTitleText()
    }
    
    private func viewSetup () {
        iconImageView.contentMode = .scaleAspectFit
        iconImageView.clipsToBounds = true
        
        titleLabel.textColor = UIColor.darkGray
        
        contentView.bounds = self.bounds
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
