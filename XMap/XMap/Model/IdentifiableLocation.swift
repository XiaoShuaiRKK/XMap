//
//  IdentifiableLocation.swift
//  XMap
//
//  Created by Xiao Shuai on 2025/1/8.
//

import Foundation
import MapKit

struct IdentifiableLocation: Identifiable {
    let id = UUID()
    let coordinate: CLLocationCoordinate2D
}
