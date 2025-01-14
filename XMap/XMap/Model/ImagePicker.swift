//
//  ImagePicker.swift
//  XMap
//
//  Created by Xiao Shuai on 2024/12/27.
//

import Foundation
import UIKit
import SwiftUI
import PhotosUI

struct ImagePicker: UIViewControllerRepresentable {
    @Binding var images: [UIImage]
    var locationID: String
    public static let IMAGE_KEY: String = "_SavedImageFilenames"
    
    class Coordinator: NSObject, PHPickerViewControllerDelegate {
        var parent: ImagePicker
        init(parent: ImagePicker) {
            self.parent = parent
        }
        
        func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
            for result in results {
                if result.itemProvider.canLoadObject(ofClass: UIImage.self){
                    result.itemProvider.loadObject(ofClass: UIImage.self) { [weak self] (image, error) in
                        if let image = image as? UIImage {
                            DispatchQueue.main.async {
                                self?.parent.images.append(image)
                                self?.parent.saveImageToDisk(image: image)
                            }
                        }
                    }
                }
            }
            parent.presentationMode.wrappedValue.dismiss()
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }
    
    @Environment(\.presentationMode) var presentationMode
    
    func makeUIViewController(context: Context) -> some UIViewController {
        var config = PHPickerConfiguration()
        config.selectionLimit = 0 //0 表示无限制
        config.filter = .images // 仅选择图片
        let picker = PHPickerViewController(configuration: config)
        picker.delegate = context.coordinator
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        
    }
    
    //保存图片到磁盘
    func saveImageToDisk(image: UIImage){
        guard let data = image.jpegData(compressionQuality: 1.0) else { return }
        let filename = UUID().uuidString + ".jpg"
        let url = getDocumentsDirectory().appendingPathComponent(filename)
        do {
            try? data.write(to: url)
            print("Image saved successfully: \(filename)")
            saveImageFilename(filename)
        } catch {
            print("Failed to save image: \(error)")
        }
    }
    
    //获得文档目录
    func getDocumentsDirectory() -> URL {
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    }
    
    //保存图片文件名到UserDefaults
    func saveImageFilename(_ filename: String){
        let key = "\(locationID)\(ImagePicker.IMAGE_KEY)"
        print(key)
        var imageFilenames = UserDefaults.standard.stringArray(forKey: key) ?? []
        imageFilenames.append(filename)
        UserDefaults.standard.set(imageFilenames, forKey: key)
    }
    
    
}
