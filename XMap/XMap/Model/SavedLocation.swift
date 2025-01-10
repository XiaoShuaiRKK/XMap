//
//  SavedLocation.swift
//  XMap
//
//  Created by Xiao Shuai on 2024/12/26.
//

import Foundation
import MapKit
import SwiftUI

struct SavedLocation: Hashable,Identifiable {
    let id = UUID()
    let coordinate: CLLocationCoordinate2D
    let name: String
    let icon: String
    let color: Color
    
    static func == (lhs: SavedLocation, rhs: SavedLocation) -> Bool {
        return lhs.coordinate.latitude == rhs.coordinate.latitude && lhs.coordinate.longitude == rhs.coordinate.longitude && lhs.name == rhs.name && lhs.icon == rhs.icon && lhs.color.description == rhs.color.description
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(coordinate.latitude)
        hasher.combine(coordinate.longitude)
        hasher.combine(name)
        hasher.combine(icon)
        hasher.combine(color.description)
    }
}
