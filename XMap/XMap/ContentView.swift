//
//  ContentView.swift
//  XMap
//
//  Created by XiaoShuai on 2024/9/5.
//

import SwiftUI
import MapKit

struct ContentView: View {
    let park = CLLocationCoordinate2D(latitude: 22.497284, longitude: 113.388242)
        let treePark = CLLocationCoordinate2D(latitude: 22.503584, longitude: 113.391698)
        
        
        @State var region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 22.497242, longitude: 113.388339), span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05))
        @State var camera: MapCameraPosition = .automatic
        @State var cameraPosition: MapCameraPosition = .region(.userRegion)
        @State var searchText = ""
        @State var results = [MKMapItem]()
        
        var body: some View {
            
            Map(position: $cameraPosition){
                Marker("孙文公园",systemImage: "", coordinate: park)
                    .tint(.green)
                Marker("湿地公园",systemImage: "",coordinate: treePark)
                UserAnnotation()
                Annotation("My Location", coordinate: .userLocation) {
                    ZStack{
                        Circle()
                            .frame(width: 32,height: 32)
                            .foregroundStyle(.blue.opacity(0.25))
                        Circle()
                            .frame(width: 20,height: 20)
                            .foregroundColor(.white)
                        Circle()
                            .frame(width: 12,height: 12)
                            .foregroundColor(.blue)
                    }
                }
                ForEach(results, id: \.self){ item in
                    let placemark = item.placemark
                    Marker(placemark.name ?? "", coordinate: placemark.coordinate)
                }
            }
            .overlay(alignment: .top){
                TextField("Search for a location...", text: $searchText)
                    .foregroundColor(.black)
                    .font(.subheadline)
                    .padding(12)
                    .background(.white)
                    .cornerRadius(12)
                    .padding(.horizontal, 55)
                    .padding(.vertical, 10)
                    .shadow(radius: 12)
            }
            .onSubmit(of: /*@START_MENU_TOKEN@*/.text/*@END_MENU_TOKEN@*/) {
                Task{
                    await searchPlaces()
                }
            }
            .mapControls{
                MapCompass()
                MapPitchToggle()
                MapUserLocationButton()
            }
            .safeAreaInset(edge: .bottom) {
                HStack{
                    Spacer()
                    Button{
                        camera = .region(MKCoordinateRegion(
                            center: park,
                            latitudinalMeters: 300,
                            longitudinalMeters: 300))
                    }label: {
                        Text("PARK")
                    }
                    Button{
                        camera = .region(MKCoordinateRegion(
                            center: treePark,
                            latitudinalMeters: 300,
                            longitudinalMeters: 300))
                    }label: {
                        Text("Tree Park")
                    }
                    Spacer()
                }
                .padding(.top)
                .background(.thinMaterial)
            }
    //        .mapStyle(.imagery)
        }
}

extension ContentView{
    func searchPlaces() async {
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = searchText
        request.region = .userRegion
        let results = try? await MKLocalSearch(request: request).start()
        self.results = results?.mapItems ?? []
    }
}

extension CLLocationCoordinate2D{
    static var userLocation: CLLocationCoordinate2D{
        return .init(latitude: 22.499157, longitude: 113.388548)
    }
}

extension MKCoordinateRegion {
    static var userRegion: MKCoordinateRegion{
        return .init(center: .userLocation, latitudinalMeters: 10000, longitudinalMeters: 10000)
    }
}

#Preview {
    ContentView()
}
