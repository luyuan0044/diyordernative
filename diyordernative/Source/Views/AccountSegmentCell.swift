//
//  AccountSegmentCell.swift
//  diyordernative
//
//  Created by Richard Lu on 2017-12-21.
//  Copyright © 2017 goopter. All rights reserved.
//

import UIKit

protocol AccountSegmentCellDelegate {
    func handleOnOrderButtonTapped ()
    func handleOnPointsButtonTapped ()
    func handleOnBookmarkButtonTapped ()
}

class AccountSegmentCell: UITableViewCell {
    
    static let key = "AccountSegmentCell"
    
    static let nib = UINib (nibName: key, bundle: nil)
    
    @IBOutlet weak var orderButton: UIButton!
    
    @IBOutlet weak var bookmarkButton: UIButton!
    
    @IBOutlet weak var pointsButton: UIButton!
    
    let spacing: CGFloat = 5
    
    let buttonTitleFont = UIFont.systemFont(ofSize: 12)
    
    let buttonTitlePadding: CGFloat = 5
    
    var delegate: AccountSegmentCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        orderButton.setImage(#imageLiteral(resourceName: "icon_order").withRenderingMode(.alwaysTemplate), for: .normal)
        orderButton.setTitle(LanguageControl.shared.getLocalizeString(by: "order"), for: .normal)
        orderButton.titleLabel?.font = buttonTitleFont
        orderButton.centerVertically(padding: buttonTitlePadding)
        
        bookmarkButton.setImage(#imageLiteral(resourceName: "icon_star").withRenderingMode(.alwaysTemplate), for: .normal)
        bookmarkButton.setTitle(LanguageControl.shared.getLocalizeString(by: "bookmark"), for: .normal)
        bookmarkButton.titleLabel?.font = buttonTitleFont
        bookmarkButton.centerVertically(padding: buttonTitlePadding)

        pointsButton.setImage(#imageLiteral(resourceName: "icon_points").withRenderingMode(.alwaysTemplate), for: .normal)
        pointsButton.setTitle(LanguageControl.shared.getLocalizeString(by: "points"), for: .normal)
        pointsButton.titleLabel?.font = buttonTitleFont
        pointsButton.centerVertically(padding: buttonTitlePadding)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func update (contentColor: UIColor) {
        orderButton.tintColor = contentColor
        orderButton.setTitleColor(contentColor, for: .normal)
        
        bookmarkButton.tintColor = contentColor
        bookmarkButton.setTitleColor(contentColor, for: .normal)
        
        pointsButton.tintColor = contentColor
        pointsButton.setTitleColor(contentColor, for: .normal)
    }
    
    @objc private func onOrderButtonTapped (_ sender: AnyObject?) {
        delegate?.handleOnOrderButtonTapped()
    }
    
    @objc private func onPointsButtonTapped (_ sender: AnyObject?) {
        delegate?.handleOnPointsButtonTapped()
    }
    
    @objc private func onBookmarkButtonTapped (_ sender: AnyObject?) {
        delegate?.handleOnBookmarkButtonTapped()
    }
}
