//
//  Functions.swift
//  ReKeeper
//
//  Created by Theeratdolchat Chatchai on 16/2/2568 BE.
//

import SwiftUI
import PhotosUI
import CoreML
import Vision

class StorageViewModel: ObservableObject {
    @Published var places: [Place] = [
        Place(name: "Living Room", icon:"house.fill",categories: [
            Category(name: "Shoes", items: [])
        ])
    ]
    
    func addPlace(name: String, icon: String) {
        let newPlace = Place(name: name, icon: icon, categories: [])
        places.append(newPlace)
    }
    
    func addCategory(to placeIndex: Int, name: String) {
        guard placeIndex < places.count else { return }
        let newCategory = Category(name: name, items: [])
        places[placeIndex].categories.append(newCategory)
    }
    
    func addItem(to categoryIndex: Int, in placeIndex: Int, name: String, image: UIImage) {
        let newItem = Item(name: name, image: image)
        places[placeIndex].categories[categoryIndex].items.append(newItem)
    }
    
    func findSimilarItem(image: UIImage) -> Item? {
            for place in places {
                for category in place.categories {
                    for item in category.items {
                        if compareImages(image1: image, image2: item.image) {
                            return item
                        }
                    }
                }
            }
            return nil
        }
        
    private func compareImages(image1: UIImage, image2: UIImage) -> Bool {
        guard let model = try? VNCoreMLModel(for: MobileNetV2(configuration: MLModelConfiguration()).model) else {
            print("Failed to load MobileNetV2 model")
            return false
        }
        
        let request = VNCoreMLRequest(model: model) { request, error in
            guard let results = request.results as? [VNClassificationObservation] else { return }
            print("Classification Results: \(results)")
        }
        
        guard let cgImage1 = image1.cgImage, let cgImage2 = image2.cgImage else { return false }
        
        let handler1 = VNImageRequestHandler(cgImage: cgImage1)
        let handler2 = VNImageRequestHandler(cgImage: cgImage2)
        
        do {
            try handler1.perform([request])
            try handler2.perform([request])
        } catch {
            print("Error performing image comparison: \(error)")
            return false
        }
        
        return true
    }

}
