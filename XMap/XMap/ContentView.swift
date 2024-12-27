//
//  ContentView.swift
//  XMap
//
//  Created by XiaoShuai on 2024/9/5.
//

import SwiftUI
import MapKit

struct ContentView: View {
    @State private var position: MapCameraPosition = .userLocation(fallback: .automatic)
    //选择到的地点
    @State private var selectedLocation: CLLocationCoordinate2D = CLLocationCoordinate2D()
    //是否显示创建地点视图
    @State private var showLocationInfo = false
    //是否显示地点详细页
    @State private var showDetailLocationInfo = false
    //选中的SavedLocation
    @State private var selectedDetailLocation: SavedLocation = SavedLocation(coordinate: CLLocationCoordinate2D(), name: "", icon: "", color: .red)
    @State private var isShowDetail = false
    @EnvironmentObject var locationStore: LocationManager
    
    var body: some View {
        ZStack{
            MapReader{ proxy in
                Map(position: $position, interactionModes: .all){
                    UserAnnotation()
                    ForEach(locationStore.savedLocations, id: \.self) { location in
                        Annotation(coordinate: location.coordinate) {
                            Button{
                                if isShowDetail {
                                    selectedDetailLocation = location
                                    showDetailLocationInfo = true
                                }
                            } label: {
                                ZStack{
                                    Circle()
                                        .fill(.white)
                                        .frame(width: 30, height: 30)
                                    Circle()
                                        .fill(location.color)
                                        .frame(width: 25, height: 25)
                                    Image(systemName: location.icon)
                                        .resizable()
                                        .foregroundColor(.white)
                                        .font(.title)
                                        .frame(width: 15, height: 15)
                                }
                                .frame(width: 30, height: 30)
                            }
                            
                        } label: {
                            Text(location.name)
                                .font(.caption)
                                .foregroundColor(.black)
                        }
                    }
                }
                .onTapGesture { location in
                    if !isShowDetail{
                        let coordinate = proxy.convert(location, from: .local)
                        selectedLocation = coordinate!
                        showLocationInfo = true
                    }
                }
                .mapControls{
                    MapUserLocationButton()
                    MapPitchToggle()
                }
                .mapFeatureSelectionAccessory(.callout)
                .onAppear {
                    CLLocationManager().requestWhenInUseAuthorization()
                }
            }
            VStack{
                HStack{
                    Spacer()
                    Button{
                        isShowDetail.toggle()
                    }label: {
                        Text(isShowDetail ? "查看" : "创建")
                            .padding()
                            .background(.blue)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                    .padding()
                }
                .padding(.top, 100)
                Spacer()
            }
        }
        .sheet(isPresented: $showLocationInfo) {
            if selectedLocation.latitude != 0.0 {
                AddPointView(selectedLocation: $selectedLocation, showLocationInfo: $showLocationInfo)
            }
        }
        .sheet(isPresented: $showDetailLocationInfo) {
            DetailLocationView()
        }
}

//extension ContentView{
//    func searchPlaces() async {
//        let request = MKLocalSearch.Request()
//        request.naturalLanguageQuery = searchText
//        request.region = .userRegion
//        let results = try? await MKLocalSearch(request: request).start()
//        self.results = results?.mapItems ?? []
//    }
//}
//
//extension CLLocationCoordinate2D{
//    static var userLocation: CLLocationCoordinate2D{
//        return .init(latitude: 22.499157, longitude: 113.388548)
//    }
//}
//
//extension MKCoordinateRegion {
//    static var userRegion: MKCoordinateRegion{
//        return .init(center: .userLocation, latitudinalMeters: 10000, longitudinalMeters: 10000)
//    }
}

#Preview {
    ContentView()
}
