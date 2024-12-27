//
//  LocationsInformation.swift
//  XMap
//
//  Created by Xiao Shuai on 2024/12/26.
//

import Foundation
import MapKit
import SwiftUI

let colors: [Color] = [.red, .green, .blue, .orange, .purple]

class LocationManager: ObservableObject{
    @Published var savedLocations: [SavedLocation] = []
    static let shared = LocationManager()
    init() {
        loadSavedLocations()
    }
    private let key = "saveLocations"
    func saveLocation(location: CLLocationCoordinate2D,name: String,icon: String,colorIndex: Int){
        print(colorIndex)
        var savedLocations = UserDefaults.standard.array(forKey: key) as? [[String: Any]] ?? []
        let newLocation: [String: Any] = [
            "latitude": location.latitude,
            "longitude": location.longitude,
            "name": name,
            "icon": icon,
            "color": colorIndex
        ]
        savedLocations.append(newLocation)
        UserDefaults.standard.set(savedLocations, forKey: key)
        loadSavedLocations()
    }
    
    func loadSavedLocations(){
        let savedData = UserDefaults.standard.array(forKey: key) as? [[String: Any]] ?? []
        savedLocations = savedData.compactMap { dict in
            if let latitude = dict["latitude"] as? Double, let longitude = dict["longitude"] as? Double,
               let name = dict["name"] as? String, let icon = dict["icon"] as? String, let colorIndex = dict["color"] as? Int{
                return SavedLocation(coordinate: CLLocationCoordinate2D(latitude: latitude, longitude: longitude), name: name, icon: icon, color: colors[colorIndex])
            }
            return nil
        }
    }
    
    func deleteLocation(location: SavedLocation) {
        var savedLocations = UserDefaults.standard.array(forKey: key) as? [[String: Any]] ?? []
        if let index = savedLocations.firstIndex(where: { dict in
            if let latitude = dict["latitude"] as? Double, let longitude = dict["longitude"] as? Double {
                return latitude == location.coordinate.latitude && longitude == location.coordinate.longitude
            }
            return false
        }) {
            savedLocations.remove(at: index)
            UserDefaults.standard.set(savedLocations, forKey: key)
            loadSavedLocations()
        }
    }
}
