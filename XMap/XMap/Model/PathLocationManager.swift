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
    @Published var locations: [CLLocation] = [] {
        didSet {
            DispatchQueue.main.async {
                self.objectWillChange.send()
            }
        }
    }
    
    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let lastLocation = self.locations.last else { //过滤低精度点
            self.locations.append(contentsOf: locations.filter { $0.horizontalAccuracy < 50 })
            return
        }
        
        for location in locations where location.horizontalAccuracy < 50 {
            let distance = location.distance(from: lastLocation)
            if distance > 10 { // 避免记录过近的点
                self.locations.append(location)
            }
        }
    }
}
