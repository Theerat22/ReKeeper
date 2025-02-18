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
            Category(name: "Shoes",icon: "shoe.fill", items: [])
        ])
    ]
    
    private let storageKey = "places_storage"
    
    init() {
        loadData()
    }
    
    func saveData() {
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(places) {
            UserDefaults.standard.set(encoded, forKey: storageKey)
        }
    }
    func loadData() {
        if let savedData = UserDefaults.standard.data(forKey: storageKey) {
            let decoder = JSONDecoder()
            if let decodedPlaces = try? decoder.decode([Place].self, from: savedData) {
                places = decodedPlaces
            }
        }
    }
    
    
    func addPlace(name: String, icon: String) {
        let newPlace = Place(name: name, icon: icon, categories: [])
        places.append(newPlace)
        saveData()
    }
    
    func addCategory(to placeIndex: Int, name: String, icon: String) {
        guard placeIndex < places.count else { return }
        let newCategory = Category(name: name,icon: icon, items: [])
        places[placeIndex].categories.append(newCategory)
        saveData()
    }
    
    func addItem(to categoryIndex: Int, in placeIndex: Int, name: String) {
        let newItem = Item(name: name)
        places[placeIndex].categories[categoryIndex].items.append(newItem)
        saveData()
    }
    
    func removePlace(at index: Int) {
        guard index < places.count else { return }
        places.remove(at: index)
        saveData()
    }

    func removeCategory(from placeIndex: Int, at categoryIndex: Int) {
        guard placeIndex < places.count, categoryIndex < places[placeIndex].categories.count else { return }
        places[placeIndex].categories.remove(at: categoryIndex)
        saveData()
    }

    func removeItem(from categoryIndex: Int, in placeIndex: Int, at itemIndex: Int) {
        guard placeIndex < places.count, categoryIndex < places[placeIndex].categories.count, itemIndex < places[placeIndex].categories[categoryIndex].items.count else { return }
        places[placeIndex].categories[categoryIndex].items.remove(at: itemIndex)
        saveData()
    }

    
    
    
    
//    func findSimilarItem(image: UIImage) -> Item? {
//            for place in places {
//                for category in place.categories {
//                    for item in category.items {
//                        if compareImages(image1: image, image2: item.image) {
//                            return item
//                        }
//                    }
//                }
//            }
//            return nil
//        }
//        
//    private func compareImages(image1: UIImage, image2: UIImage) -> Bool {
//        guard let model = try? VNCoreMLModel(for: MobileNetV2(configuration: MLModelConfiguration()).model) else {
//            print("Failed to load MobileNetV2 model")
//            return false
//        }
//        
//        let request = VNCoreMLRequest(model: model) { request, error in
//            guard let results = request.results as? [VNClassificationObservation] else { return }
//            print("Classification Results: \(results)")
//        }
//        
//        guard let cgImage1 = image1.cgImage, let cgImage2 = image2.cgImage else { return false }
//        
//        let handler1 = VNImageRequestHandler(cgImage: cgImage1)
//        let handler2 = VNImageRequestHandler(cgImage: cgImage2)
//        
//        do {
//            try handler1.perform([request])
//            try handler2.perform([request])
//        } catch {
//            print("Error performing image comparison: \(error)")
//            return false
//        }
//        
//        return true
//    }

}
