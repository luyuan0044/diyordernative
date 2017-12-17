//
//  CollectionLoadingFooterView.swift
//  diyordernative
//
//  Created by Richard Lu on 2017-12-15.
//  Copyright © 2017 goopter. All rights reserved.
//

import UIKit

class CollectionLoadingFooterView: UICollectionReusableView {

    static let key = "CollectionLoadingFooterView"
    
    static let nib = UINib (nibName: key, bundle: nil)
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var loadingActivityIndicator: UIActivityIndicatorView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        loadingActivityIndicator.startAnimating()
    }
    
    func update (hasMoreData: Bool) {
        if hasMoreData {
            loadingActivityIndicator.startAnimating()
            loadingActivityIndicator.isHidden = false
            titleLabel.text = "loading more data"
        } else {
            loadingActivityIndicator.isHidden = true
            titleLabel.text = "no more data"
        }
    }
}
