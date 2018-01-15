//
//  StoresMapViewController.swift
//  diyordernative
//
//  Created by Yuan Lu on 2018-01-11.
//  Copyright © 2018 goopter. All rights reserved.
//

import UIKit
import MapKit

class StoresMapViewController: BaseViewController, MKMapViewDelegate, UIScrollViewDelegate {
    
    // MARK: - Properties
    
    @IBOutlet weak var mapView: MKMapView!
    
    @IBOutlet weak var searchAreaButton: UIButton!
    
    @IBOutlet weak var moveToCurrentLocationButton: UIButton!
    
    @IBOutlet weak var storesScrollView: UIScrollView!
    
    @IBOutlet weak var dismissButton: UIButton!
    
    @IBOutlet weak var storesScrollViewBottomConstraint: NSLayoutConstraint!
    
    var navController: UINavigationController?
    
    var storeCategoryType: storeCategoryType!
    
    var isStoresScrollViewShowed = false
    
    var regionRadius: CLLocationDistance = 3 * 1000 // 3km
    
    var reloadDataDistanceTolerance: CLLocationDistance = 500 // 500m
    
    let testColor: [UIColor] = [UIColor.red, UIColor.blue, UIColor.green, UIColor.yellow, UIColor.gray, UIColor.black]
    
    let scrollViewShowHideDisplacement: CGFloat = 178
    
    var lastSearchCoordinate: CLLocationCoordinate2D?
    
    var stores: [Store]? = nil
    
    var scrollSubview: [StoresMapAnnotationView] = []
    
    let scrollSubViewPadding: CGFloat = 16
    
    let scrollSubviewPaddingY: CGFloat = 5
    
    var scrollSubviewWidth: CGFloat {
        get {
            return storesScrollView.frame.width - 2 * scrollSubViewPadding
        }
    }
    
    var scrollSubviewHeight: CGFloat {
        get {
            return storesScrollView.frame.height - 10
        }
    }
    
    var isRegionChangedBySelectAnnotation = false
    
    var isBySelectedAnnotation = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        if let currentLoaction = LocationHelper.shared.currentLocation {
            centerMapOnLocation (location: currentLoaction)
        }
        
        mapView.showsUserLocation = true
        mapView.delegate = self
        mapView.showsPointsOfInterest = false
        mapView.deselectAnnotation(mapView.selectedAnnotations.first, animated: false)
        
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
        
        storesScrollView.delegate = self
        storesScrollView.backgroundColor = UIColor.clear
        storesScrollView.isPagingEnabled = true
        storesScrollView.showsHorizontalScrollIndicator = false
        
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
    
    // MARK: - Implementation
    
    func setStoreCategoryType (_ storeCategoryType: storeCategoryType) {
        self.storeCategoryType = storeCategoryType
    }
    
    func setNavigationController (navigationController: UINavigationController) {
        self.navController = navigationController
    }
    
    func centerMapOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate, regionRadius, regionRadius)
        mapView.setRegion(coordinateRegion, animated: true)
    }
    
    func configScrollSubview (numberOfSubViews: Int) {
        if scrollSubview.count > 0 {
            for subview in scrollSubview {
                subview.removeFromSuperview()
            }
            
            scrollSubview = []
        }
        
        var offset: CGFloat = scrollSubViewPadding
        for _ in 1...numberOfSubViews {
            let view = StoresMapAnnotationView.create()
            view.frame = CGRect(x: offset, y: scrollSubviewPaddingY, width: scrollSubviewWidth, height: scrollSubviewHeight)
            view.layoutIfNeeded()
            storesScrollView.addSubview(view)
            scrollSubview.append(view)
            offset += scrollSubviewWidth + 2 * scrollSubViewPadding
        }
        storesScrollView.contentSize = CGSize (width: offset - scrollSubViewPadding, height: storesScrollView.frame.height)
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
                
                DispatchQueue.main.async {
                    //remove previous annotations
                    self.mapView.removeAnnotations(self.mapView.annotations)
                    
                    if status == .success && stores != nil && stores!.count > 0 {
                        self.stores = stores
                        for store in self.stores! {
                            let annotation = MapAnnotation (model: store)
                            self.mapView.addAnnotation(annotation)
                        }
                        
                        let numberOfScrollSubview = self.stores!.count > 1 ? 3 : 1
                        self.configScrollSubview (numberOfSubViews: numberOfScrollSubview)
                    }
                }
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
    
    func handleSelectedAnnotationChanged (annotation: MapAnnotation) {
        // If selected annotation changed is by selecting annotation on mapview
        // 1. get the selected model and update scroll view content
        // 2. scroll the scroll view
        if isBySelectedAnnotation {
            let idx = stores!.index(where: {$0.getId() == annotation.id})!
            loadScrollViewData(with: idx)
            scrollToCenterOfScrollSubviewIndex()
        }
        // If selected annotation changed is by scrolling the scrollview
        // select the annotation
        else {
            mapView.selectAnnotation(annotation, animated: true)
        }
        
        // Turn on switch of annotation is selected the annotation on map self
        isBySelectedAnnotation = true
    }
    
    private func getPreModelIdx (idx: Int) -> Int {
        return idx == 0 ? stores!.count - 1 : idx - 1
    }
    
    private func getNextModelIdx (idx: Int) -> Int {
        return idx == stores!.count - 1 ? 0 : idx + 1
    }
    
    func loadScrollViewData (with index: Int) {
        guard let stores = self.stores else {
            return
        }
        
        if stores.count > 1 {
            let store = stores[index]
            let preStore = stores[getPreModelIdx(idx: index)]
            let nextStore = stores[getNextModelIdx(idx: index)]
            
            scrollSubview[0].update(model: preStore)
            scrollSubview[1].update(model: store)
            scrollSubview[2].update(model: nextStore)
        } else {
            let store = stores[index]
            scrollSubview[0].update(model: store)
        }
    }
    
    func scrollToCenterOfScrollSubviewIndex (animation: Bool = true) {
        let idx = scrollSubview.count == 1 ? 0 : 1
        storesScrollView.setContentOffset(CGPoint(x: storesScrollView.frame.width * CGFloat(idx), y: 0)  , animated: animation)
    }
    
    // MARK: - MKMapViewDelegate
    
    func mapView(_ mapView: MKMapView, regionWillChangeAnimated animated: Bool) {
        // Hide bottom scroll view if map will moved
        showScrollView(show: false)
        
        // If there is at least one annotation selected on mapview and the region changed is not by selecting annotation
        // deselect the annotation
        if mapView.selectedAnnotations.count > 0 && !isRegionChangedBySelectAnnotation {
            mapView.deselectAnnotation(mapView.selectedAnnotations.first!, animated: true)
        }
    }
    
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        isRegionChangedBySelectAnnotation = false
        
        // show move to current location button if current location point is invisible on map
        if !mapView.isUserLocationVisible {
            showMoveToCurrentLocationButton (show: true)
        }
        
        // show search area button if distance between last search coordinate and current mapview center coordinate greater than tolerance
        if let lastSearchCoordinate = lastSearchCoordinate {
            let centerLocation = CLLocation(latitude:  mapView.centerCoordinate.latitude, longitude: mapView.centerCoordinate.longitude)
            let lastLocation = CLLocation(latitude: lastSearchCoordinate.latitude, longitude: lastSearchCoordinate.longitude)
            let distance = centerLocation.distance(from: lastLocation)
            if reloadDataDistanceTolerance <= distance {
                showSearchAreaButton(show: true)
            }
        }
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        // Check selected annotation view is not nil
        // also check annotation is MapAnnotation to avoid user current location annotation selected
        guard view.annotation != nil || !(view.annotation is MapAnnotation) else {
            return
        }
        
        // If the select annotation action is triggered by selecting annotation on mapview
        if isBySelectedAnnotation, let selectedAnnotation = view.annotation as? MapAnnotation {
            handleSelectedAnnotationChanged (annotation: selectedAnnotation)
        }
        // If the select annotation action is triggered by scrolling the scroll view
        else if !isBySelectedAnnotation, let selectedAnnotation = view.annotation as? MapAnnotation {
            // Turn on switch of region change by selecting annotation
            isRegionChangedBySelectAnnotation = true
            
            // Move the selected annotation to center of the mapview
            let coordinate = selectedAnnotation.coordinate
            mapView.setCenter(coordinate, animated: true)
        }
        
        showScrollView(show: true)
    }
    
    // MARK: - UIScrollViewDelegate
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        // Turn off switch of annotation is selected the annotation on map self
        isBySelectedAnnotation = false
        
        // Get selected annotation view on scroll view
        let viewIdx = Int(scrollView.contentOffset.x / scrollView.frame.width)
        let modelId = (scrollSubview[viewIdx] as StoresMapAnnotationView).model!.getId()
        if let annotation = mapView.annotations.filter({$0 is MapAnnotation && ($0 as! MapAnnotation).id == modelId}).first {
            handleSelectedAnnotationChanged (annotation: annotation as! MapAnnotation)
        }
        
        // Update scroll view's subviews and models
        
        // If selected subview index == 0
        if let modelIdx = stores!.index(where: {$0.id == modelId}), stores!.count > 1 {
            if viewIdx == 0 {
                let view = scrollSubview[2]
                scrollSubview.remove(at: 2)
                scrollSubview.insert(view, at: 0)
                
                let model = stores![getPreModelIdx(idx: modelIdx)]
                view.update(model: model)
            } else if viewIdx == 2 {
                let view = scrollSubview[0]
                scrollSubview.remove(at: 0)
                scrollSubview.append(view)
                
                let model = stores![getNextModelIdx(idx: modelIdx)]
                view.update(model: model)
            }
            
            var offset: CGFloat = scrollSubViewPadding
            for idx in 0...2 {
                scrollSubview[idx].frame = CGRect(x: offset, y: scrollSubviewPaddingY, width: scrollSubviewWidth, height: scrollSubviewHeight)
                offset += scrollSubviewWidth + 2 * scrollSubViewPadding
            }
            
            scrollToCenterOfScrollSubviewIndex (animation: false)
        }
        
//        if viewIdx == 0{
//            let view = scrollSubview[2]
//            scrollSubview.remove(at: 2)
//            scrollSubview.insert(view, at: 0)
//
//            var offset: CGFloat = scrollSubViewPadding
//            for idx in 0...2 {
//                scrollSubview[idx].frame = CGRect(x: offset, y: scrollSubviewPaddingY, width: scrollSubviewWidth, height: scrollSubviewHeight)
//                offset += scrollSubviewWidth + 2 * scrollSubViewPadding
//            }
//
//            let model = stores![getPreModelIdx(idx: modelIdx)]
//            view.update(model: model)
//
//            scrollToScrollSubviewIndex (1, animation: false)
//        } else if viewIdx == 2, let modelIdx = stores!.index(where: {$0.id == modelId}) {
//            let view = scrollSubview[0]
//            scrollSubview.remove(at: 0)
//            scrollSubview.append(view)
//
//            var offset: CGFloat = scrollSubViewPadding
//            for idx in 0...2 {
//                scrollSubview[idx].frame = CGRect(x: offset, y: scrollSubviewPaddingY, width: scrollSubviewWidth, height: scrollSubviewHeight)
//                offset += scrollSubviewWidth + 2 * scrollSubViewPadding
//            }
//
//            let model = stores![getNextModelIdx(idx: modelIdx)]
//            view.update(model: model)
//
//            scrollToScrollSubviewIndex (1, animation: false)
//        }
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
