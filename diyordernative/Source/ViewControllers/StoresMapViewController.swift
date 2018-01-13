//
//  StoresMapViewController.swift
//  diyordernative
//
//  Created by Yuan Lu on 2018-01-11.
//  Copyright © 2018 goopter. All rights reserved.
//

import UIKit
import MapKit

class StoresMapViewController: BaseViewController, MKMapViewDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    
    @IBOutlet weak var searchAreaButton: UIButton!
    
    @IBOutlet weak var moveToCurrentLocationButton: UIButton!
    
    @IBOutlet weak var storesScrollView: UIScrollView!
    
    @IBOutlet weak var dismissButton: UIButton!
    
    @IBOutlet weak var storesScrollViewBottomConstraint: NSLayoutConstraint!
    
    var storeCategoryType: storeCategoryType!
    
    var isStoresScrollViewShowed = false
    
    var regionRadius: CLLocationDistance = 3 * 1000 // 3km
    
    var reloadDataDistanceTolerance: CLLocationDistance = 500 // 500m
    
    let testColor: [UIColor] = [UIColor.red, UIColor.blue, UIColor.green, UIColor.yellow, UIColor.gray, UIColor.black]
    
    let scrollViewShowHideDisplacement: CGFloat = 158
    
    var lastSearchCoordinate: CLLocationCoordinate2D?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        if let currentLoaction = LocationHelper.shared.currentLocation {
            centerMapOnLocation (location: currentLoaction)
        }
        
        mapView.showsUserLocation = true
        mapView.delegate = self
        
        searchAreaButton.isHidden = true
        searchAreaButton.alpha = 0
        searchAreaButton.setTitle(LanguageControl.shared.getLocalizeString(by: "redo search in this area"), for: .normal)
        searchAreaButton.layer.cornerRadius = 3
        searchAreaButton.backgroundColor = UIColor.white
        searchAreaButton.contentEdgeInsets = UIEdgeInsetsMake (5, 15, 5, 15)
        searchAreaButton.layer.masksToBounds = false
        searchAreaButton.layer.shadowOffset = CGSize (width: 0, height: 0)
        searchAreaButton.layer.shadowRadius = 3
        searchAreaButton.layer.shadowOpacity = 0.5
        searchAreaButton.addTarget(self, action: #selector(handleSearchAreaButtonTapped(_:)), for: .touchUpInside)
        
        moveToCurrentLocationButton.isHidden = true
        moveToCurrentLocationButton.alpha = 0
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
            let colorView = UIView (frame: CGRect(x: offset, y: 5, width: width, height: storesScrollView.frame.height - 10))
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
        
        loadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setStoreCategoryType (_ storeCategoryType: storeCategoryType) {
        self.storeCategoryType = storeCategoryType
    }
    
    func centerMapOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate, regionRadius, regionRadius)
        mapView.setRegion(coordinateRegion, animated: true)
    }
    
    func loadData () {
        var _urlparams: [String: String] = [:]
        
        _urlparams["c_id"] = "\(self.storeCategoryType.rawValue)"
        if let latlonStr = UrlHelper.getFormattedUrlLatAndLon(coordinate: mapView.centerCoordinate) {
            lastSearchCoordinate = mapView.centerCoordinate
            _urlparams["latlon"] = latlonStr
        }
        
        DispatchQueue.global(qos: .userInitiated).async {
            StoreDataLoader.startRequestStores(urlparams: _urlparams, completion: {
                status, stores, _ in
                
                
            })
        }
    }
    
    func showScrollView (show: Bool) {
        if show {
            if isStoresScrollViewShowed {
                return
            }
            
            isStoresScrollViewShowed = true
            UIView.animate(withDuration: 0.2, animations: {
                self.storesScrollViewBottomConstraint.constant += self.scrollViewShowHideDisplacement
                self.view.layoutIfNeeded()
            })
        } else {
            if !isStoresScrollViewShowed {
                return
            }
            
            isStoresScrollViewShowed = false
            UIView.animate(withDuration: 0.2, animations: {
                self.storesScrollViewBottomConstraint.constant -= self.scrollViewShowHideDisplacement
                self.view.layoutIfNeeded()
            })
        }
    }
    
    func showMoveToCurrentLocationButton (show: Bool) {
        if show && moveToCurrentLocationButton.isHidden {
            moveToCurrentLocationButton.isHidden = false
            moveToCurrentLocationButton.alpha = 0
            UIView.animate(withDuration: 0.5, animations: {
                self.moveToCurrentLocationButton.alpha = 1
            })
        } else if !show && !moveToCurrentLocationButton.isHidden {
            self.moveToCurrentLocationButton.alpha = 1
            UIView.animate(withDuration: 0.5, animations: {
                self.moveToCurrentLocationButton.alpha = 0
            }, completion: {
                isComplete in
                if isComplete {
                    self.moveToCurrentLocationButton.isHidden = true
                }
            })
        }
    }
    
    func showSearchAreaButton (show: Bool) {
        if show && searchAreaButton.isHidden {
            searchAreaButton.isHidden = false
            searchAreaButton.alpha = 0
            UIView.animate(withDuration: 0.5, animations: {
                self.searchAreaButton.alpha = 1
            })
        } else if !show && !searchAreaButton.isHidden {
            self.searchAreaButton.alpha = 1
            UIView.animate(withDuration: 0.5, animations: {
                self.searchAreaButton.alpha = 0
            }, completion: {
                isComplete in
                if isComplete {
                    self.searchAreaButton.isHidden = true
                }
            })
        }
    }
    
    @objc private func handleSearchAreaButtonTapped (_ sender: AnyObject?) {
        showSearchAreaButton(show: false)
        loadData()
    }
    
    @objc private func handleMoveToCurrentLocationButtonTapped (_ sender: AnyObject?) {
        if let currentLoaction = LocationHelper.shared.currentLocation {
            centerMapOnLocation (location: currentLoaction)
        }
        
        showMoveToCurrentLocationButton (show: false)
    }
    
    @objc private func handleDismissButtonTapped (_ sender: AnyObject?) {
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: - MKMapViewDelegate
    
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        // show move to current location button if current location point is invisible on map
        if !mapView.isUserLocationVisible {
            showMoveToCurrentLocationButton (show: true)
        }
        
        // show search area button if distance between last search coordinate and current mapview center coordinate greater than tolerance
        if let lastSearchCoordinate = lastSearchCoordinate {
            let centerLocation = CLLocation(latitude:  mapView.centerCoordinate.latitude, longitude: mapView.centerCoordinate.longitude)
            let lastLocation = CLLocation(latitude: lastSearchCoordinate.latitude, longitude: lastSearchCoordinate.longitude)
            let distance = centerLocation.distance(from: lastLocation)
            print(distance)
            if reloadDataDistanceTolerance <= distance {
                showSearchAreaButton(show: true)
            }
        }
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
