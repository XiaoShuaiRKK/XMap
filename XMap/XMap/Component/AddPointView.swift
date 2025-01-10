//
//  AddPointView.swift
//  XMap
//
//  Created by Xiao Shuai on 2024/12/26.
//

import SwiftUI
import MapKit


struct AddPointView: View {
    @Binding var selectedLocation: CLLocationCoordinate2D
    @Binding var showLocationInfo: Bool
    @State private var customText = "地点"
    @State private var selectedIcon: String = "mappin.and.ellipse"
    @State private var selectedColorIndex: Int = 0
    let icons = ["mappin.and.ellipse","star","heart","flag","leaf"]
    @EnvironmentObject var locationStore: LocationManager
    
    var body: some View {
        VStack(spacing: 20){
            TextField("自定义地点名称",text: $customText)
                .font(.title)
                .fontWeight(.bold)
                .frame(maxWidth: .infinity, alignment: .leading)
            VStack{
                Text("经度: \(selectedLocation.longitude)")
                    .font(.caption)
                Text("纬度: \(selectedLocation.latitude)")
                    .font(.caption)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            lookMapLocationView
            selectIconView
            selectIconColorView
            Spacer()
            Button{
                saveLocation()
                showLocationInfo = false
            }label: {
                Text("Create")
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(.blue)
            .foregroundColor(.white)
            .cornerRadius(20)
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .shadow(radius: 10)
    }
    
    var selectIconView: some View{
        VStack{
            Text("选择图标")
                .font(.headline)
                .padding(.top, 10)
            HStack{
                ForEach(icons, id: \.self){ icon in
                    Image(systemName: icon)
                        .font(.title)
                        .padding()
                        .background(selectedIcon == icon ? colors[selectedColorIndex] : Color.gray.opacity(0.2))
                        .foregroundColor(.white)
                        .cornerRadius(10)
                        .onTapGesture {
                            selectedIcon = icon
                        }
                }
            }
        }
    }
    
    var selectIconColorView: some View {
        VStack{
            Text("选择颜色")
                .font(.headline)
                .padding(.top, 10)
            HStack(spacing: 20){
                ForEach(colors.indices, id: \.self){ index in
                    Circle()
                        .fill(colors[index])
                        .frame(width: 40,height: 40)
                        .overlay(selectedColorIndex == index ? Circle().stroke(Color.white, lineWidth: 3) : nil)
                        .onTapGesture {
                            selectedColorIndex = index
                        }
                }
            }
            .padding(.vertical, 10)
        }
    }
    
    var lookMapLocationView: some View {
        VStack(spacing: 10){
            Text("预览")
                .font(.title)
                .fontWeight(.bold)
                .frame(maxWidth: .infinity, alignment: .leading)
            //小地图
            Map(coordinateRegion: .constant(MKCoordinateRegion(
                center: selectedLocation,
                span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
            )),annotationItems: [IdentifiableLocation(coordinate: selectedLocation)]) { location in
                MapAnnotation(coordinate: location.coordinate) {
                    ZStack{
                        Circle()
                            .fill(.white)
                            .frame(width: 30, height: 30)
                        Circle()
                            .fill(colors[selectedColorIndex])
                            .frame(width: 25, height: 25)
                        Image(systemName: selectedIcon)
                            .resizable()
                            .foregroundColor(.white)
                            .font(.title)
                            .frame(width: 15, height: 15)
                    }
                    .frame(width: 40, height: 40)
                }
            }
            .cornerRadius(20)
        }
        .frame(height: 200)
    }
    
    func saveLocation(){
        locationStore.saveLocation(location: selectedLocation, name: customText, icon: selectedIcon, colorIndex: selectedColorIndex)
    }
    
}

#Preview {
    @State var location: CLLocationCoordinate2D = CLLocationCoordinate2D()
    @State var show = true
    AddPointView(selectedLocation: $location, showLocationInfo: $show)
}
