//
//  StoresMapViewController.swift
//  diyordernative
//
//  Created by Yuan Lu on 2018-01-11.
//  Copyright © 2018 goopter. All rights reserved.
//

import UIKit
import MapKit

class StoresMapViewController: BaseViewController {
    
    @IBOutlet weak var mapView: MKMapView!
    
    @IBOutlet weak var searchAreaButton: UIButton!
    
    @IBOutlet weak var moveToCurrentLocationButton: UIButton!
    
    @IBOutlet weak var storesScrollView: UIScrollView!
    
    @IBOutlet weak var dismissButton: UIButton!
    
    @IBOutlet weak var storesScrollViewBottomConstraint: NSLayoutConstraint!
    
    var isStoresScrollViewShowed = false
    
    var regionRadius: CLLocationDistance = 3 * 1000 // 5km
    
    let testColor: [UIColor] = [UIColor.red, UIColor.blue, UIColor.green, UIColor.yellow, UIColor.gray, UIColor.black]
    
    let scrollViewShowHideDisplacement: CGFloat = 158
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        if let currentLoaction = LocationHelper.shared.currentLocation {
            centerMapOnLocation (location: currentLoaction)
        }
        
        mapView.showsUserLocation = true
        
        searchAreaButton.setTitle(LanguageControl.shared.getLocalizeString(by: "redo search in this area"), for: .normal)
        searchAreaButton.layer.cornerRadius = 3
        searchAreaButton.backgroundColor = UIColor.white
        searchAreaButton.contentEdgeInsets = UIEdgeInsetsMake (5, 15, 5, 15)
        searchAreaButton.layer.masksToBounds = false
        searchAreaButton.layer.shadowOffset = CGSize (width: 0, height: 0)
        searchAreaButton.layer.shadowRadius = 3
        searchAreaButton.layer.shadowOpacity = 0.5
        searchAreaButton.addTarget(self, action: #selector(handleSearchAreaButtonTapped(_:)), for: .touchUpInside)
        
        moveToCurrentLocationButton.layer.cornerRadius = 3
        moveToCurrentLocationButton.setImage(#imageLiteral(resourceName: "icon_target").withRenderingMode(.alwaysTemplate), for: .normal)
        moveToCurrentLocationButton.contentMode = .scaleAspectFit
        moveToCurrentLocationButton.imageEdgeInsets = UIEdgeInsetsMake(5, 5, 5, 5)
        moveToCurrentLocationButton.backgroundColor = UIColor.white
        moveToCurrentLocationButton.layer.masksToBounds = false
        moveToCurrentLocationButton.layer.shadowOffset = CGSize (width: 0, height: 0)
        moveToCurrentLocationButton.layer.shadowRadius = 3
        moveToCurrentLocationButton.layer.shadowOpacity = 0.5
        moveToCurrentLocationButton.addTarget(self, action: #selector(handleMoveToCurrentLocationButtonTapped(_:)), for: .touchUpInside)
        
        storesScrollView.backgroundColor = UIColor.clear
        storesScrollView.isPagingEnabled = true
        storesScrollView.showsHorizontalScrollIndicator = false
        let padding: CGFloat = 16
        var offset: CGFloat = padding
        let width: CGFloat = storesScrollView.frame.width - 2 * padding
        for color in testColor {
            let colorView = UIView (frame: CGRect(x: offset, y: 0, width: width, height: storesScrollView.frame.height))
            colorView.layer.cornerRadius = 3
            colorView.layer.shadowOffset = CGSize (width: 0, height: 0)
            colorView.layer.shadowRadius = 3
            colorView.layer.shadowOpacity = 0.5
            colorView.layer.masksToBounds = false
            colorView.backgroundColor = color
            storesScrollView.addSubview(colorView)
            offset += width + 2 * padding
        }
        storesScrollView.contentSize = CGSize (width: offset - padding, height: storesScrollView.frame.height)
        
        dismissButton.setImage(#imageLiteral(resourceName: "icon_list").withRenderingMode(.alwaysTemplate), for: .normal)
        dismissButton.tintColor = UIColor.darkGray
        dismissButton.imageEdgeInsets = UIEdgeInsetsMake(10, 10, 10, 10)
        dismissButton.addTarget(self, action: #selector(handleDismissButtonTapped(_:)), for: .touchUpInside)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func centerMapOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate, regionRadius, regionRadius)
        mapView.setRegion(coordinateRegion, animated: true)
    }
    
    func showScrollView () {
        if isStoresScrollViewShowed {
            return
        }
        
        isStoresScrollViewShowed = true
        UIView.animate(withDuration: 0.2, animations: {
            self.storesScrollViewBottomConstraint.constant += self.scrollViewShowHideDisplacement
            self.view.layoutIfNeeded()
        })
    }
    
    func hideScrollView () {
        if !isStoresScrollViewShowed {
            return
        }
        
        isStoresScrollViewShowed = false
        UIView.animate(withDuration: 0.2, animations: {
            self.storesScrollViewBottomConstraint.constant -= self.scrollViewShowHideDisplacement
            self.view.layoutIfNeeded()
        })
    }
    
    @objc private func handleSearchAreaButtonTapped (_ sender: AnyObject?) {
        showScrollView()
    }
    
    @objc private func handleMoveToCurrentLocationButtonTapped (_ sender: AnyObject?) {
        hideScrollView()
    }
    
    @objc private func handleDismissButtonTapped (_ sender: AnyObject?) {
        dismiss(animated: true, completion: nil)
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
