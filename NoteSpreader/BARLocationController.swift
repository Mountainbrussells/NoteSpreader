//
//  BARLocationController.swift
//  NoteSpreader
//
//  Created by BenRussell on 8/24/17.
//  Copyright © 2017 BenRussell. All rights reserved.
//

import UIKit
import CoreLocation

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
    
}
