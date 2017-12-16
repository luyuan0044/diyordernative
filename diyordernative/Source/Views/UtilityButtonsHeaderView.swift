//
//  UtilityButtonsHeaderView.swift
//  diyordernative
//
//  Created by Richard Lu on 2017-12-15.
//  Copyright © 2017 goopter. All rights reserved.
//

import UIKit

class UtilityButtonsHeaderView: UICollectionReusableView {

    static let key = "UtilityButtonsHeaderView"
    
    static let nib = UINib (nibName: key, bundle: nil)
    
    @IBOutlet weak var firstButton: UIButton!
    
    @IBOutlet weak var secondButton: UIButton!
    
    @IBOutlet weak var squareButton: UIButton!
    
    @IBOutlet weak var rightButton: UIButton!
    
    var delegate: UtilityButtonsHeaderViewDelegate? = nil
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    func setup () {
        
    }
    
    @objc private func onFirstButtonTapped (_ sender: AnyObject?) {
        delegate?.onFirstButtonTapped()
    }
    
    @objc private func onSecondButtonTapped (_ sender: AnyObject?) {
        delegate?.onSecondButtonTapped()
    }
    
    @objc private func onSquareButtonTapped (_ sender: AnyObject?) {
        delegate?.onSquareButtonTapped()
    }
    
    @objc private func onRightButtonTapped (_ sender: AnyObject?) {
        delegate?.onRightButtonTapped()
    }
}
