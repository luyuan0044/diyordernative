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
    
    var manager: CLLocationManager?
    
    var geocoder: CLGeocoder?
    
    var currentLocation: CLLocation?
    
    var placemark: CLPlacemark?
    
    var timer: Timer?
    
    let updateTimeInterval: Double = 30
    
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

    func getCurrentLocation () -> CLLocation? {
        return currentLocation
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
