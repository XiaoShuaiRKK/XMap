//
//  XMapApp.swift
//  XMap
//
//  Created by XiaoShuai on 2024/9/5.
//

import SwiftUI

@main
struct XMapApp: App {
    @StateObject private var locationStore = LocationManager()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(locationStore)
        }
    }
}
