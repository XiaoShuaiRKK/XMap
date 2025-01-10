//
//  DetailLocationView.swift
//  XMap
//
//  Created by Xiao Shuai on 2024/12/27.
//

import SwiftUI
import MapKit

struct DetailLocationView: View {
    @State var location: SavedLocation
    @State var isDelete = false
    @State private var images: [UIImage] = []
    @State private var showImagePicker = false
    @EnvironmentObject var locationStore: LocationManager
    
    var body: some View {
        ScrollView {
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
//                NowPlayingView()
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
                ImagePicker(images: $images, locationID: location.id)
            }
            .onAppear {
                loadImagesFromDisk()
            }
        }
        .scrollIndicators(.hidden)
    }
    
    var lookMapLocationView: some View {
        VStack(spacing: 10){
            Text("预览")
                .font(.title)
                .fontWeight(.bold)
                .frame(maxWidth: .infinity, alignment: .leading)
            //小地图
            //小地图
            Map(coordinateRegion: .constant(MKCoordinateRegion(
                center: location.coordinate,
                span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
            )),annotationItems: [IdentifiableLocation(coordinate: location.coordinate)]) {_ in
                MapAnnotation(coordinate: location.coordinate) {
                    VStack{
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
                        Text(location.name)
                            .font(.caption)
                            .foregroundColor(.black)
                    }
                    .frame(width: 40, height: 40)
                }
            }
            .cornerRadius(20)
        }
        .frame(height: 200)
    }
    
    var imageCarousel: some View {
        VStack{
            HStack{
                Text("图片展示")
                    .font(.title2)
                    .fontWeight(.bold)
                    .frame(maxWidth: .infinity, alignment: .leading)
                Spacer()
                Button {
                    showImagePicker = true
                } label: {
                    Image(systemName: "plus.circle.fill")
                        .font(.title)
                        .foregroundColor(.blue)
                }
            }
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
                ScrollView(.horizontal){
                    LazyHGrid(rows: [GridItem(.flexible()), GridItem(.flexible())]) {
                        ForEach(images, id: \.self) { image in
                            Image(uiImage: image)
                                .resizable()
                                .scaledToFit()
                                .frame(
                                    width: image.size.width / 15,  // 确保每张图片占据屏幕的一半宽度
                                    height: image.size.height / 15 // 高度保持与宽度等比
                                )
                                .clipped()  // 剪切超出部分
                        }
                    }
                }
                .scrollIndicators(.hidden)
            }
        }
    }
    
    
    
    // 从磁盘加载图片
    func loadImagesFromDisk() {
        let key = "\(location.id.uuidString)\(ImagePicker.IMAGE_KEY)"
        let filenames = UserDefaults.standard.stringArray(forKey: key) ?? []
        print(key)
        print("Loaded filenames: \(filenames)")
        for filename in filenames {
            let url = getDocumentsDirectory().appendingPathComponent(filename)
            if let data = try? Data(contentsOf: url), let image = UIImage(data: data) {
                images.append(image)
            } else {
                print("Failed to load image: \(filename)")
            }
        }
    }
    
    func getDocumentsDirectory() -> URL {
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    }
}

#Preview {
    DetailLocationView(location: SavedLocation(coordinate: CLLocationCoordinate2D(), name: "", icon: "", color: .red))
}
