//
//  ContentView.swift
//  XMap
//
//  Created by XiaoShuai on 2024/9/5.
//

import SwiftUI
import MapKit

struct ContentView: View {
    @EnvironmentObject var locationStore: LocationManager
    let healthManager = HealthManager()
    
    var body: some View {
        TabView {
            OriginalMapView()
                .tabItem {
                    Label("Locations", systemImage: "map")
                }
            PathTrackingView()
                .tabItem {
                    Label("Path Tracking", systemImage: "location.fill")
                }
        }
    }
}

#Preview {
    ContentView()
}
