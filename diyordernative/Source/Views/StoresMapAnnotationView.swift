//
//  StoresMapAnnotationView.swift
//  diyordernative
//
//  Created by Yuan Lu on 2018-01-13.
//  Copyright © 2018 goopter. All rights reserved.
//

import UIKit

class StoresMapAnnotationView: UIView {
    
    @IBOutlet weak var iconImageView: UIImageView!
    
    @IBOutlet weak var nameLabel: UILabel!
    
    var defaultImage = StoreCategoryControl.shared.defaultStoreCategoryImageSmall
    
    var model: IMapAnnotation?
    
    static func create () -> StoresMapAnnotationView {
        return UINib (nibName: "StoresMapAnnotationView", bundle: nil).instantiate(withOwner: self, options: nil) [0] as! StoresMapAnnotationView
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        layer.cornerRadius = 3
        layer.shadowOffset = CGSize (width: 0, height: 0)
        layer.shadowRadius = 3
        layer.shadowOpacity = 0.5
        layer.masksToBounds = false
        
        iconImageView.contentMode = .scaleAspectFit
        iconImageView.clipsToBounds = true
        iconImageView.layer.cornerRadius = 5
        iconImageView.image = defaultImage
        
        nameLabel.textColor = UIColor.darkGray
    }
    
    func update (model: IMapAnnotation) {
        self.model = model
        
        if let imageUrl = model.getImageUrl() {
            let urlStr = ImageHelper.getFormattedImageUrl(imageId: imageUrl, size: iconImageView.frame.size)!
            if let url = URL (string: urlStr) {
                iconImageView.sd_setImage(with: url, placeholderImage: defaultImage)
            }
        }
        
        nameLabel.text = model.getName()
    }
}
