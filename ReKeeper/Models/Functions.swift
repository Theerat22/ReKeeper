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
        Place(name: "Living Room", icon: "house.fill", categories: [
            Category(name: "Shoes", icon: "shoe.fill", items: [
                Item(name: "Nike Sneakers", receivedDate: Date().addingTimeInterval(-86400), expiryDate: Date().addingTimeInterval(604800), imageData: nil),
                Item(name: "Adidas Running", receivedDate: Date().addingTimeInterval(-43200), expiryDate: Date().addingTimeInterval(1209600), imageData: nil),
                Item(name: "Puma Sandals", receivedDate: Date().addingTimeInterval(-259200), expiryDate: Date().addingTimeInterval(1728000), imageData: nil),
                Item(name: "Fatty Grace", receivedDate: Date().addingTimeInterval(-259200), expiryDate: Date().addingTimeInterval(1728000), imageData: nil),
                Item(name: "Fatty Grace", receivedDate: Date().addingTimeInterval(-259200), expiryDate: Date().addingTimeInterval(1728000), imageData: nil)
            ])
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
    
    func addItem(to categoryIndex: Int, in placeIndex: Int, name: String, receivedDate: Date, expiryDate: Date, imageData: Data?) {
        let newItem = Item(name: name, receivedDate: receivedDate, expiryDate: expiryDate, imageData: imageData)
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
    
    func findSimilarItem(image: UIImage) async -> Item? {
        guard let queryFeature = await extractFeature(from: image) else { return nil }
        
        var mostSimilarItem: Item?
        var highestSimilarity: Float = -1.0

        for place in places {
            for category in place.categories {
                for item in category.items {
                    if let imageData = item.imageData,
                       let storedImage = UIImage(data: imageData),
                       let itemFeature = await extractFeature(from: storedImage) {

                        let similarity = cosineSimilarity(feature1: queryFeature, feature2: itemFeature)
                        if similarity > highestSimilarity {
                            highestSimilarity = similarity
                            mostSimilarItem = item
                        }
                    }
                }
            }
        }
        
        return mostSimilarItem
    }

    private func extractFeature(from image: UIImage) async -> [Float]? {
        guard let model = try? VNCoreMLModel(for: MobileNetV2(configuration: MLModelConfiguration()).model),
              let cgImage = image.cgImage else {
            print("Failed to load MobileNetV2 model or image.")
            return nil
        }

        let request = VNCoreMLRequest(model: model) { request, error in
            if let error = error {
                print("Error performing feature extraction: \(error)")
            }
        }

        let handler = VNImageRequestHandler(cgImage: cgImage)

        return await withCheckedContinuation { continuation in
            DispatchQueue.global(qos: .userInitiated).async {
                do {
                    try handler.perform([request]) // Synchronously perform the request
                    if let result = request.results?.first as? VNFeaturePrintObservation {
                        continuation.resume(returning: result.featureDataToArray())
                    } else {
                        continuation.resume(returning: nil)
                    }
                } catch {
                    print("Error extracting features: \(error)")
                    continuation.resume(returning: nil)
                }
            }
        }
    }

    private func cosineSimilarity(feature1: [Float], feature2: [Float]) -> Float {
        guard feature1.count == feature2.count else { return -1 }

        let dotProduct = zip(feature1, feature2).reduce(0) { $0 + $1.0 * $1.1 }
        let magnitude1 = sqrt(feature1.reduce(0) { $0 + $1 * $1 })
        let magnitude2 = sqrt(feature2.reduce(0) { $0 + $1 * $1 })

        return dotProduct / (magnitude1 * magnitude2)
    }
}

extension VNFeaturePrintObservation {
    func featureDataToArray() -> [Float] {
        let count = self.data.count / MemoryLayout<Float>.stride
        return self.data.withUnsafeBytes { pointer in
            Array(pointer.bindMemory(to: Float.self).prefix(count))
        }
    }
}
