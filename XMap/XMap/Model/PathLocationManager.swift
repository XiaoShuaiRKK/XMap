//
//  PathLocationManager.swift
//  XMap
//
//  Created by Xiao Shuai on 2025/1/9.
//

import Foundation
import CoreLocation

class PathLocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    private var locationManager = CLLocationManager()
    @Published var locations: [CLLocation] = []
    
    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        self.locations.append(contentsOf: locations)
    }
}
