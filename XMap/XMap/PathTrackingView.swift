//
//  PathTrackingView.swift
//  XMap
//
//  Created by Xiao Shuai on 2025/1/9.
//

import SwiftUI
import MapKit

struct PathTrackingView: View {
    @StateObject private var pathLocationManager = PathLocationManager()
    var body: some View {
        MapView(locationManager: pathLocationManager)
    }
}

#Preview {
    PathTrackingView()
}
