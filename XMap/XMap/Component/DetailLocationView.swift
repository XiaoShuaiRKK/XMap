//
//  DetailLocationView.swift
//  XMap
//
//  Created by Xiao Shuai on 2024/12/27.
//

import SwiftUI
import MapKit

struct DetailLocationView: View {
    @State var location: SavedLocation = SavedLocation(coordinate: CLLocationCoordinate2D(), name: "Location", icon: "star", color: .red)
    @State var isDelete = false
    @State private var images: [UIImage] = []
    @State private var showImagePicker = false
    @EnvironmentObject var locationStore: LocationManager
    
    var body: some View {
        VStack(spacing: 10){
            HStack{
                Text(location.name)
                    .font(.title)
                    .fontWeight(.bold)
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
            }
            .frame(maxWidth: .infinity,alignment: .leading)
            lookMapLocationView
            imageCarousel
            Spacer()
            Button{
                if !isDelete {
                    isDelete = true
                }else {
                    locationStore.deleteLocation(location: location)
                }
            } label: {
                Text("Delete")
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(isDelete ? .red : .gray)
            .foregroundColor(.white)
            .cornerRadius(20)
        }
        .padding()
        .frame(maxWidth: .infinity,maxHeight: .infinity)
        .shadow(radius: 10)
        .sheet(isPresented: $showImagePicker) {
            ImagePicker(images: $images)
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
                center: location.coordinate,
                span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
            )))
            .cornerRadius(20)
        }
        .frame(height: 200)
    }
    
    var imageCarousel: some View {
        VStack{
            Text("图片展示")
                .font(.title2)
                .fontWeight(.bold)
                .frame(maxWidth: .infinity, alignment: .leading)
            if images.isEmpty {
                Button {
                    showImagePicker = true
                } label: {
                    VStack{
                        Image(systemName: "plus")
                            .font(.largeTitle)
                            .foregroundColor(.gray)
                    }
                    .frame(width: 120,height: 80)
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(style: StrokeStyle(lineWidth: 2, dash: [10]))
                            .foregroundColor(.gray)
                    )
                }
            } else {
                TabView {
                    ForEach(images, id: \.self) { image in
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFit()
                            .cornerRadius(20)
                    }
                }
                .tabViewStyle(PageTabViewStyle())
                .frame(height: 200)
            }
        }
    }
}

#Preview {
    DetailLocationView()
}
