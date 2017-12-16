//
//  HotItemCategoryHeaderView.swift
//  diyordernative
//
//  Created by Richard Lu on 2017-12-15.
//  Copyright © 2017 goopter. All rights reserved.
//

import UIKit

class HotItemCategoryHeaderView: UICollectionReusableView {
    
    // MARK: - Properties
    
    static let key = "HotItemCategoryHeaderView"
    
    static let nib = UINib (nibName: key, bundle: nil)
    
    @IBOutlet weak var hotItemCategoryScrollView: UIScrollView!
    
    var tabIndicatorView: UIView? = nil
    
    let heightOfTabIndicatorView: CGFloat = 3
    
    var categoryButtons: [UIButton]? = nil
    
    var currentSelectedButtonIndex: Int = 0
    
    let font = UIFont.systemFont(ofSize: 14)
    
    let highlightFont = UIFont.boldSystemFont(ofSize: 14)
    
    let categoryButtonPadding: CGFloat = 40
    
    let nonBorderButtonPositionPadding: CGFloat = 40
    
    let normalCategoryButtonTitleColor = UIColor.white.withAlphaComponent(0.5)
    
    let highlightCategoryButtonTitleColor = UIColor.white
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        hotItemCategoryScrollView.backgroundColor = UIConstants.appThemeColor
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        if categoryButtons != nil {
            for button in categoryButtons! {
                button.removeFromSuperview()
            }
        }
        
        tabIndicatorView?.removeFromSuperview()
    }
    
    func update (hotItemCategories: [HotItemCategory]?) {
        guard hotItemCategories != nil else {
            return
        }
        
        categoryButtons = []
        var offsetX: CGFloat = 0
        for hotItemCategory in hotItemCategories! {
            let name = hotItemCategory.name ?? ""
            let fontAttributes = NSAttributedStringKey.font
            let size = (name as NSString).size(withAttributes: [fontAttributes: font])
            let width = size.width + categoryButtonPadding
            
            let button = UIButton (frame: CGRect(x: offsetX, y: 0, width: width, height: hotItemCategoryScrollView.frame.height))
            button.setTitle(name, for: .normal)
            button.setTitleColor(normalCategoryButtonTitleColor, for: .normal)
            button.titleLabel?.font = font
            button.addTarget(self, action: #selector(handleOnCategoryButtonTapped(_:)), for: .touchUpInside)
            
            hotItemCategoryScrollView.addSubview(button)
            categoryButtons!.append(button)
            
            offsetX += width
        }
        hotItemCategoryScrollView.contentSize = CGSize (width: offsetX, height: hotItemCategoryScrollView.frame.height)
        
        let highlightButton = categoryButtons![currentSelectedButtonIndex]
        highlight (button: highlightButton)
        
        tabIndicatorView = UIView(frame: CGRect(x: highlightButton.frame.midX, y: hotItemCategoryScrollView.frame.height - heightOfTabIndicatorView, width: highlightButton.frame.width, height: heightOfTabIndicatorView))
        hotItemCategoryScrollView.addSubview(tabIndicatorView!)
    }
    
    private func highlight (button: UIButton) {
        button.setTitleColor(highlightCategoryButtonTitleColor, for: .normal)
        button.titleLabel?.font = highlightFont
    }
    
    private func dehighlight (button: UIButton) {
        button.setTitleColor(normalCategoryButtonTitleColor, for: .normal)
        button.titleLabel?.font = font
    }
    
    private func moveTabIndicatorViewTo (button: UIButton) {
        UIView.animate(withDuration: 0.1, animations: {
            self.tabIndicatorView!.frame = CGRect(x: button.frame.minX, y: 0, width: button.frame.width, height: self.hotItemCategoryScrollView.frame.height)
        })
    }
    
    @objc private func handleOnCategoryButtonTapped (_ sender: UIButton?) {
        guard sender != nil else {
            return
        }
        
        let indexOfTappedButton = categoryButtons!.index(of: sender!)!
        let previousSelectedButton = categoryButtons![currentSelectedButtonIndex]
        
        dehighlight (button: previousSelectedButton)
        
        highlight(button: previousSelectedButton)
        moveTabIndicatorViewTo(button: sender!)
        
        adjustScollViewOffset(index: indexOfTappedButton)
        currentSelectedButtonIndex = indexOfTappedButton
    }
    
    private func adjustScollViewOffset (index: Int) {
        let button = categoryButtons![index]
        let buttonX = button.frame.midX
        
        var scrollPosition: CGFloat = 0
        if (index != 0 && index != categoryButtons!.count - 1) {
            scrollPosition = nonBorderButtonPositionPadding
        }
        var scrollToOffsetX = buttonX - scrollPosition
        if (hotItemCategoryScrollView.contentSize.width - scrollToOffsetX <= hotItemCategoryScrollView.frame.width) {
            scrollToOffsetX = hotItemCategoryScrollView.contentSize.width - hotItemCategoryScrollView.frame.width
        }
        
        hotItemCategoryScrollView.setContentOffset(CGPoint (x: scrollToOffsetX, y: 0), animated: true)
    }
}
