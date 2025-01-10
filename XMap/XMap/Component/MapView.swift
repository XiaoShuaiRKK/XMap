//
//  MapView.swift
//  XMap
//
//  Created by Xiao Shuai on 2025/1/9.
//

import SwiftUI
import MapKit

struct MapView: UIViewRepresentable {
    @ObservedObject var locationManager: PathLocationManager
    @State private var userHasInteracted = false
        
    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView()
        mapView.delegate = context.coordinator
        mapView.showsUserLocation = true
        //手势识别器
        let panGesture = UIPanGestureRecognizer(target: context.coordinator, action: #selector(context.coordinator.userDidInteract))
        let pinchGesture = UIPinchGestureRecognizer(target: context.coordinator, action: #selector(context.coordinator.userDidInteract))
        mapView.addGestureRecognizer(panGesture)
        mapView.addGestureRecognizer(pinchGesture)
        return mapView
    }
    
    func updateUIView(_ uiView: MKMapView, context: Context) {
        let coordinates = locationManager.locations.map { $0.coordinate }
        let polyline = MKPolyline(coordinates: coordinates, count: coordinates.count)
        uiView.addOverlay(polyline)
        //调整地图显示区域
        if let lastLocation = locationManager.locations.last, !context.coordinator.userHasInteracted {
            let region = MKCoordinateRegion(center: lastLocation.coordinate, latitudinalMeters: 500, longitudinalMeters: 500)
            uiView.setRegion(region, animated: true)
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, MKMapViewDelegate {
        var userInteractionTimer: Timer?
        var userHasInteracted = false
        var parent: MapView
        
        init(_ parent: MapView) {
            self.parent = parent
        }
        
        func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
            if let polyline = overlay as? MKPolyline {
                let renderer = MKPolylineRenderer(polyline: polyline)
                renderer.strokeColor = .blue
                renderer.lineWidth = 5
                return renderer
            }
            return MKOverlayRenderer()
        }
        
        @objc func userDidInteract() {
            userHasInteracted = true
            resetTime()
        }
        
        private func resetTime() {
            userInteractionTimer?.invalidate()
            userInteractionTimer = Timer.scheduledTimer(withTimeInterval: 8.0, repeats: false) { [weak self] _ in
                self?.userHasInteracted = false
            }
        }
    }
}
