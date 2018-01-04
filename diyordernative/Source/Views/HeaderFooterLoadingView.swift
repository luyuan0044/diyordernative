//
//  HeaderFooterLoadingView.swift
//  diyordernative
//
//  Created by Yuan Lu on 2018-01-03.
//  Copyright © 2018 goopter. All rights reserved.
//

import UIKit

class HeaderFooterLoadingView: UIView {
    
    static let key = "HeaderFooterLoadingView"
    
    static let nib = UINib (nibName: key, bundle: nil)

    @IBOutlet var contentView: UIView!
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var loadingActivityIndicator: UIActivityIndicatorView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        commonInit()
        
        viewSetup()
        loadingActivityIndicator.startAnimating()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        commonInit()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        viewSetup()
        loadingActivityIndicator.startAnimating()
    }
    
    func commonInit ()
    {
        Bundle.main.loadNibNamed(HeaderFooterLoadingView.key, owner: self, options: nil)
        addSubview(contentView)
    }
    
    private func viewSetup () {
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
    
    func update (hasMoreData: Bool) {
        if hasMoreData {
            loadingActivityIndicator.startAnimating()
            loadingActivityIndicator.isHidden = false
            titleLabel.text = LanguageControl.shared.getLocalizeString(by: "loading more data")
        } else {
            loadingActivityIndicator.isHidden = true
            titleLabel.text = LanguageControl.shared.getLocalizeString(by: "no more data")
        }
    }
}
