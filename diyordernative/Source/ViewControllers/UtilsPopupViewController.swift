//
//  UtilsPopupViewController.swift
//  diyordernative
//
//  Created by Richard Lu on 2018-01-04.
//  Copyright © 2018 goopter. All rights reserved.
//

import UIKit

class UtilsPopupViewController: UIViewController {
    
    // MARK: - Properties
    
    let heightOfItem: CGFloat = 40
    
    let backgroundColor = UIColor.darkGray
    
    var viewItems: [UtilsPopupItem]!
    
    @IBOutlet weak var contentPanelView: UIView!
    
    @IBOutlet weak var navBar: UINavigationBar!
    
    @IBOutlet weak var dismissButton: UIButton!
    
    @IBOutlet weak var contentPanelViewHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var triangleView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        view.backgroundColor = UIColor.clear
        
        navBar.setBackgroundImage(UIImage(), for: .default)
        navBar.shadowImage = UIImage()
        navBar.isTranslucent = true
        
        contentPanelView.layer.cornerRadius = 5
        contentPanelView.clipsToBounds = true
        
        dismissButton.addTarget(self, action: #selector(handleOnDismissButtonTapped(_:)), for: .touchUpInside)
        dismissButton.backgroundColor = UIColor.clear
        
        triangleView.backgroundColor = UIColor.clear
        
        setupItemViews()
        drawTrianle()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - Implementation
    
    @objc private func handleOnDismissButtonTapped (_ sender: AnyObject?) {
        dismiss(animated: true, completion: nil)
    }
    
    func setViewItems (items: [UtilsPopupItem]) {
        viewItems = items
    }
    
    private func setupItemViews () {
        var offsetY: CGFloat = 0
        for item in viewItems! {
            let view = UtilsPopupItemView (frame: CGRect (x: 0, y: offsetY, width: contentPanelView.frame.width, height: heightOfItem))
            view.backgroundColor = backgroundColor
            view.setup(item: item)
            view.layoutSubviews()
            contentPanelView.addSubview(view)
            offsetY += heightOfItem
        }
        contentPanelViewHeightConstraint.constant = offsetY
    }
    
    private func drawTrianle () {
        var point = CGPoint (x: 10, y: 0)
        let path = UIBezierPath ()
        path.move(to: point)
        point = CGPoint (x: 20, y: 10)
        path.addLine(to: point)
        point = CGPoint (x: 0, y: 10)
        path.addLine(to: point)
        path.close()
        
        let layer = CAShapeLayer ()
        layer.path = path.cgPath
        layer.frame = CGRect (x: 0, y: 0, width: 20, height: 10)
        layer.fillColor = backgroundColor.cgColor
        
        triangleView.layer.addSublayer(layer)
    }
}
