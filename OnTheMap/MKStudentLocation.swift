//
//  MKStudentLocation.swift
//  OnTheMap
//
//  Created by Oleksandr Iaroshenko on 13.06.15.
//  Copyright (c) 2015 Oleksandr Iaroshenko. All rights reserved.
//

import Foundation
import MapKit

// Conforming StudentLocation to MKAnnotation protocol in order to add it directly to MKMapView
extension StudentLocation: MKAnnotation {

    var coordinate: CLLocationCoordinate2D {
        get {
            return CLLocationCoordinate2DMake(latitude, longitude)
        }
    }

    var title: String! {
        get {
            return firstName + " " + lastName
        }
    }

    var subtitle: String! {
        get {
            return mediaURL
        }
    }
}