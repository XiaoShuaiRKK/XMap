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
    let id: String
    let coordinate: CLLocationCoordinate2D
    let name: String
    let icon: String
    let color: Color
    
    static func == (lhs: SavedLocation, rhs: SavedLocation) -> Bool {
        return lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

let emptySavedLocation = SavedLocation(id: "", coordinate: CLLocationCoordinate2D(), name: "", icon: "", color: .clear)
