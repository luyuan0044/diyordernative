//
//  AccountHeaderCell.swift
//  diyordernative
//
//  Created by Richard Lu on 2017-12-21.
//  Copyright © 2017 goopter. All rights reserved.
//

import UIKit

class AccountHeaderCell: UITableViewCell {
    
    static let key = "AccountHeaderCell"
    
    static let nib = UINib (nibName: key, bundle: nil)

    @IBOutlet weak var avatarImageView: UIImageView!
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var descriptionLabel: UILabel!
    
    @IBOutlet weak var forwardIndicatorImageView: UIImageView!
    
    @IBOutlet weak var titleLabelCenterYConstraint: NSLayoutConstraint!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        contentView.backgroundColor = UIConstants.appThemeColor
        
        avatarImageView.image = #imageLiteral(resourceName: "image_avatar_placehoder").withRenderingMode(.alwaysTemplate)
        avatarImageView.tintColor = UIColor.white
        avatarImageView.contentMode = .scaleAspectFit
        avatarImageView.clipsToBounds = true
        
        titleLabel.textColor = UIColor.white
        titleLabel.text = "\(LanguageControl.shared.getLocalizeString(by: "log in")) / \(LanguageControl.shared.getLocalizeString(by: "sign up"))"
        
        descriptionLabel.textColor = UIColor.white
        descriptionLabel.text = LanguageControl.shared.getLocalizeString(by: "register as a memeber to receive reward points")
        
        forwardIndicatorImageView.image = #imageLiteral(resourceName: "icon_forward").withRenderingMode(.alwaysTemplate)
        forwardIndicatorImageView.tintColor = UIColor.white
        forwardIndicatorImageView.contentMode = .scaleAspectFit
        forwardIndicatorImageView.clipsToBounds = true
    }
    
    func update (isLogin: Bool) {
        descriptionLabel.isHidden = isLogin
        if isLogin {
            titleLabelCenterYConstraint.constant = 0
        }
    }
}
