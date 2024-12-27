//
//  XMapLookAroundSceneRequest.swift
//  XMap
//
//  Created by Xiao Shuai on 2024/12/26.
//

import SwiftUI
import MapKit

struct XMapLookAroundSceneRequest: UIViewRepresentable {
    typealias UIViewType = <#type#>
    
    let coordinate: CLLocationCoordinate2D
    
    func makeUIView(context: Context) async -> MKLookAroundViewController {
        let view = MKLookAroundViewController()
        let lookAroundSceneRequest = MKLookAroundSceneRequest(coordinate: coordinate)
        view.scene = await lookAroundSceneRequest.scene
        return view
    }
}
