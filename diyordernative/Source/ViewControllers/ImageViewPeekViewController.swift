//
//  ImageViewPeekViewController.swift
//  diyordernative
//
//  Created by Yuan Lu on 2017-12-21.
//  Copyright © 2017 goopter. All rights reserved.
//

import UIKit
import SDWebImage

class ImageViewPeekViewController: UIViewController {

    @IBOutlet weak var targetImageView: UIImageView!
    
    var imageUrlString: String?
    
    let defaultImage = #imageLiteral(resourceName: "image_shopping_medium")
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        if let imageUrl = imageUrlString {
            let urlStr = ImageHelper.getFormattedImageUrl(imageId: imageUrl, size: targetImageView.frame.size)!
            if let url = URL (string: urlStr) {
                targetImageView.sd_setImage(with: url, placeholderImage: defaultImage)
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func update (imageURLStr: String?) {
        self.imageUrlString = imageURLStr
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
