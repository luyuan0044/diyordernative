//
//  UtilityButtonsHeaderView.swift
//  diyordernative
//
//  Created by Richard Lu on 2017-12-15.
//  Copyright © 2017 goopter. All rights reserved.
//

import UIKit

protocol UtilityButtonsHeaderViewDelegate {
    func onFirstButtonTapped ()
    func onSecondButtonTapped ()
    func onSquareButtonTapped ()
    func onRightButtonTapped ()
}

class UtilityButtonsHeaderView: UICollectionReusableView {

    static let key = "UtilityButtonsHeaderView"
    
    static let nib = UINib (nibName: key, bundle: nil)
    
    @IBOutlet weak var firstButton: UIButton!
    
    @IBOutlet weak var secondButton: UIButton!
    
    @IBOutlet weak var squareButton: UIButton!
    
    @IBOutlet weak var rightButton: UIButton!
    
    let font = UIFont.systemFont(ofSize: 14)
    
    var delegate: UtilityButtonsHeaderViewDelegate? = nil
    
    let normalTitleColor = UIColor.gray
    
    let highlightTitleColor = UIConstants.appThemeColor
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        firstButton.setTitleColor(highlightTitleColor, for: .normal)
        firstButton.titleLabel?.font = font
        firstButton.addTarget(self, action: #selector(onFirstButtonTapped(_:)), for: .touchUpInside)
        
        secondButton.setTitleColor(normalTitleColor, for: .normal)
        secondButton.titleLabel?.font = font
        secondButton.addTarget(self, action: #selector(onSecondButtonTapped(_:)), for: .touchUpInside)
        
        squareButton.tintColor = normalTitleColor
        squareButton.imageEdgeInsets = UIEdgeInsets (top: 10, left: 10, bottom: 10, right: 10)
        squareButton.addTarget(self, action: #selector(onSquareButtonTapped(_:)), for: .touchUpInside)
        
        rightButton.setTitleColor(normalTitleColor, for: .normal)
        rightButton.titleLabel?.font = font
        rightButton.addTarget(self, action: #selector(onRightButtonTapped(_:)), for: .touchUpInside)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    func setup (firstButtonTitle: String, secondButtonTitle: String, squareIcon: UIImage, rightButtonTitle: String) {
        
        firstButton.setTitle(LanguageControl.shared.getLocalizeString(by: firstButtonTitle), for: .normal)
        
        secondButton.setTitle(LanguageControl.shared.getLocalizeString(by: secondButtonTitle), for: .normal)
        
        squareButton.setImage(squareIcon, for: .normal)
        
        rightButton.setTitle(LanguageControl.shared.getLocalizeString(by: rightButtonTitle), for: .normal)
    }
    
    @objc private func onFirstButtonTapped (_ sender: AnyObject?) {
        delegate?.onFirstButtonTapped()
    }
    
    @objc private func onSecondButtonTapped (_ sender: AnyObject?) {
        firstButton.setTitleColor(normalTitleColor, for: .normal)
        secondButton.setTitleColor(UIConstants.appThemeColor, for: .normal)
        delegate?.onSecondButtonTapped()
    }
    
    @objc private func onSquareButtonTapped (_ sender: AnyObject?) {
        delegate?.onSquareButtonTapped()
    }
    
    @objc private func onRightButtonTapped (_ sender: AnyObject?) {
        delegate?.onRightButtonTapped()
    }
    
    func updateSquareButtonIcon (iconImage: UIImage) {
        squareButton.setImage(iconImage, for: .normal)
    }
    
    func updateSelectedSort (sortItem: HotItemSort) {
        if sortItem.type == hotItemSortType.tab.rawValue {
            firstButton.setTitleColor(normalTitleColor, for: .normal)
            secondButton.setTitleColor(UIConstants.appThemeColor, for: .normal)
        } else {
            firstButton.titleLabel?.text = LanguageControl.shared.getLocalizeString(by: sortItem.name)
            firstButton.setTitleColor(UIConstants.appThemeColor, for: .normal)
            secondButton.setTitleColor(normalTitleColor, for: .normal)
        }
    }
}
