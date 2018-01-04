//
//  LocationHelper.swift
//  diyordernative
//
//  Created by Yuan Lu on 2017-12-18.
//  Copyright © 2017 goopter. All rights reserved.
//

import Foundation
import CoreLocation

class LocationHelper: NSObject, CLLocationManagerDelegate {
    
    static let shared = LocationHelper ()
    
    private(set) var manager: CLLocationManager?
    
    private(set) var geocoder: CLGeocoder?
    
    private(set) var currentLocation: CLLocation?
    
    private(set) var placemark: CLPlacemark?
    
    private(set) var timer: Timer?
    
    let updateTimeInterval: Double = 30
    
    var isLocationAvaliable: Bool {
        get {
            return CLLocationManager.locationServicesEnabled() && (CLLocationManager.authorizationStatus() == .authorizedAlways || CLLocationManager.authorizationStatus() == .authorizedWhenInUse)
        }
    }
    
    func getDistanceToCurrentLocation (lat: Double, lon: Double) -> CLLocationDistance? {
        if currentLocation == nil {
            return nil
        }
        
        let target = CLLocation (latitude: lat, longitude: lon)
        return target.distance(from: currentLocation!)
    }
    
    /**
     Update location
     */
    func updateLocation () {
        if !CLLocationManager.locationServicesEnabled () {
            return
        }
        
        if manager == nil {
            manager = CLLocationManager()
            manager!.delegate = self
            manager!.desiredAccuracy = kCLLocationAccuracyBest
        }
        
        if geocoder == nil {
            geocoder = CLGeocoder()
        }
        
        if CLLocationManager.authorizationStatus() == .notDetermined {
            manager!.requestWhenInUseAuthorization()
        }
        
        if timer == nil {
            timer = Timer.scheduledTimer(withTimeInterval: updateTimeInterval, repeats: true, block: {
                tmr in
                
                self.updateLocation()
            })
        }
        
        manager!.startUpdatingLocation()
    }
    
    /**
     Get most updated current location, if there is no location detected will return nil
     */
    func getCurrentLocation () -> CLLocation? {
        return currentLocation
    }
    
    func getCurrentLatAndLon () -> CLLocationCoordinate2D? {
        guard currentLocation != nil else {
            return nil
        }
        
        return currentLocation!.coordinate
    }
    
    func getCurrentPlacemark () -> CLPlacemark? {
        return placemark
    }
    
    //MARK: - CLLocationManagerDelegate
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if locations.count > 0 {
            currentLocation = locations.first!
            
            geocoder!.reverseGeocodeLocation(currentLocation!, completionHandler: {
                placemarks, error in
                
                if error == nil && placemarks != nil && placemarks!.count > 0 {
                    self.placemark = placemarks!.last
                    print("Found placemarks \(self.placemark!)")
                } else {
                    if error == nil {
                        print("No placemarks found")
                    } else {
                        print("Found placemarks with error \(error!.localizedDescription)")
                    }
                }
            })
        }
        
        manager.stopUpdatingLocation()
    }
}
