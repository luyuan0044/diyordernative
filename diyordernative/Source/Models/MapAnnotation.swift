//
//  MapAnnotation.swift
//  diyordernative
//
//  Created by Yuan Lu on 2018-01-12.
//  Copyright © 2018 goopter. All rights reserved.
//

import Foundation
import MapKit

protocol IMapAnnotation {
    func getId () -> String
    func getName () -> String?
    func getImageUrl () -> String?
    func getLatitude () -> Double?
    func getLongitude () -> Double?
}

class MapAnnotation: NSObject, MKAnnotation {
    
    let model: IMapAnnotation
    
    let id: String
    
    let isValid: Bool
    
    let coordinate: CLLocationCoordinate2D
    
    let title: String?
    
    init(model: IMapAnnotation) {
        self.model = model
        self.id = model.getId()
        self.title = model.getName()
        self.coordinate = CLLocationCoordinate2D (latitude: model.getLatitude() ?? 0, longitude: model.getLongitude() ?? 0)
        self.isValid = model.getLatitude() != nil && model.getLongitude() != nil
        super.init()
    }
}
