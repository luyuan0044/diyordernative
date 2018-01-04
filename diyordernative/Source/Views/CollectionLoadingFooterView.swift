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
    
    var titleLabel: UILabel {
        get {
            return headerFooterLoadingView.titleLabel
        }
    }
    
    var loadingActivityIndicator: UIActivityIndicatorView {
        get {
            return headerFooterLoadingView.loadingActivityIndicator
        }
    }
    
    @IBOutlet weak var headerFooterLoadingView: HeaderFooterLoadingView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func update (hasMoreData: Bool) {
        headerFooterLoadingView.update (hasMoreData: hasMoreData)
    }
}
