//
//  OriginalMapView.swift
//  XMap
//
//  Created by Xiao Shuai on 2025/1/9.
//

import SwiftUI
import MapKit

struct OriginalMapView: View {
    @State private var position: MapCameraPosition = .userLocation(fallback: .automatic)
    //选择到的地点
    @State private var selectedLocation: CLLocationCoordinate2D = CLLocationCoordinate2D()
    //是否显示创建地点视图
    @State private var showLocationInfo = false
    //是否显示地点详细页
    @State private var showDetailLocationInfo = false
    @State private var showFilter = false
    //选中的SavedLocation
    @State private var selectedDetailLocation: SavedLocation = emptySavedLocation
    @State private var isShowDetail = false
    @State private var selectedIcon: String = ""
    @State private var selectedColor: Color = .clear
    @EnvironmentObject var locationStore: LocationManager
    var body: some View {
        HStack {
            ZStack{
                MapReader{ proxy in
                    Map(position: $position, interactionModes: .all){
                        UserAnnotation()
                        ForEach(locationStore.savedLocations, id: \.self) { location in
                            Annotation(coordinate: location.coordinate) {
                                Button{
                                    if isShowDetail {
                                        selectedDetailLocation = location
                                        print(selectedDetailLocation)
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
                                    .frame(width: 50, height: 50)
                                }
                                .contentShape(Rectangle())
                                
                            } label: {
                                Text(location.name)
                                    .font(.caption)
                                    .foregroundColor(.black)
                            }
                        }
                    }
                    .onTapGesture { location in
                        print("Click Map")
                        if showFilter {
                            withAnimation {
                                showFilter = false
                            }
                        }
                        else {
                            if !isShowDetail{
                                let coordinate = proxy.convert(location, from: .local)
                                selectedLocation = coordinate!
                                showLocationInfo = true
                            }
                        }
                    }
                    //禁止onTapGesture影响到按钮的点击
                    .gesture(DragGesture().onChanged({ _ in
                        
                    }))
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
                        VStack {
                            Button{
                                isShowDetail.toggle()
                                showLocationInfo = false
                                showDetailLocationInfo = false
                            }label: {
                                Image(systemName: isShowDetail ? "eye.fill" : "plus.circle.fill")
                                    .resizable()
                                    .frame(width: 20,height: 20)
                                    .foregroundColor(.white)
                                    .padding(15)
                                    .background(.blue)
                                    .cornerRadius(10)
                            }
                            
                            Button{
                                withAnimation {
                                    showFilter.toggle()
                                }
                            } label: {
                                Image(systemName: "slider.horizontal.3")
                                    .resizable()
                                    .frame(width: 20,height: 20)
                                    .foregroundColor(.white)
                                    .padding(15)
                                    .background(.blue)
                                    .cornerRadius(10)
                            }
                        }
                        .padding(.trailing, 10)
                        .padding(.top, 20)
                    }
                    .padding(.top, 100)
                    Spacer()
                }
                
                
            }
            .sheet(isPresented: $showLocationInfo, onDismiss: {
                showLocationInfo = false
            }) {
                AddPointView(selectedLocation: $selectedLocation, showLocationInfo: $showLocationInfo)
            }
            .sheet(isPresented: $showDetailLocationInfo, onDismiss: {
                showDetailLocationInfo = false
            }) {
                DetailLocationView(location: $selectedDetailLocation)
            }
            if showFilter {
                FilterView(selectedIcon: $selectedIcon, selectedColor: $selectedColor)
                    .frame(maxWidth: 200)
                    .background(Color(.systemBackground))
                    .transition(.move(edge: .trailing))
                    .animation(.easeInOut)
            }
        }
        
    }
}

#Preview {
    OriginalMapView()
}
