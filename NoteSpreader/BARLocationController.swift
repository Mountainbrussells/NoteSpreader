//
//  BARLocationController.swift
//  NoteSpreader
//
//  Created by BenRussell on 8/24/17.
//  Copyright © 2017 BenRussell. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit

class BARLocationController: NSObject, CLLocationManagerDelegate {
    var locationManager: CLLocationManager = CLLocationManager()
    var location: CLLocation?
    
    override init() {
        super.init()
        self.locationManager.delegate = self
        self.locationManager.requestAlwaysAuthorization()
        self.locationManager.distanceFilter = 300
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.startUpdatingLocation()
    }
    
    // MARK - CLLocationMangerDelegate methods
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        location = locations.last!
    }
    
    func showLocation(_ location: Location) {
        let regionDistance:CLLocationDistance = 100
        let coordinates = CLLocationCoordinate2DMake(location.lattitude, location.longitude)
        let regionSpan = MKCoordinateRegionMakeWithDistance(coordinates, regionDistance, regionDistance)
        let options = [
            MKLaunchOptionsMapCenterKey: NSValue(mkCoordinate: regionSpan.center),
            MKLaunchOptionsMapSpanKey: NSValue(mkCoordinateSpan: regionSpan.span)
        ]
        let placemark = MKPlacemark(coordinate: coordinates, addressDictionary: nil)
        let mapItem = MKMapItem(placemark: placemark)
        mapItem.name = "Note Location"
        mapItem.openInMaps(launchOptions: options)
    }
    
}
