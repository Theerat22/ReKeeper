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
import UIKit
    
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
    
}

extension StorageViewModel {
    func findSimilarItem(image: UIImage) async -> Item? {
        guard let imageFeatureVector = await extractFeatureVector(from: image) else {
            print("Error extracting feature vector")
            return nil
        }

        var bestMatch: Item?
        var highestSimilarity: Float = -1

        for place in places {
            for category in place.categories {
                for item in category.items {
                    if let imageData = item.imageData,
                       let storedImage = UIImage(data: imageData),
                       let storedFeatureVector = await extractFeatureVector(from: storedImage) {

                        let similarity = cosineSimilarity(v1: imageFeatureVector, v2: storedFeatureVector)
                        
                        if similarity > highestSimilarity {
                            highestSimilarity = similarity
                            bestMatch = item
                        }
                    }
                }
            }
        }
        return bestMatch
    }

    private func extractFeatureVector(from image: UIImage) async -> [Float]? {
        guard let cgImage = image.cgImage else { return nil }
        let request = VNGenerateImageFeaturePrintRequest()

        let handler = VNImageRequestHandler(cgImage: cgImage, options: [:])
        do {
            try handler.perform([request])
            guard let result = request.results?.first as? VNFeaturePrintObservation else { return nil }

            let featureVector = try result.data.toArray()

            return featureVector
        } catch {
            print("Feature extraction error: \(error)")
            return nil
        }
    }

    private func cosineSimilarity(v1: [Float], v2: [Float]) -> Float {
        guard v1.count == v2.count else { return -1 }

        let dotProduct = zip(v1, v2).map(*).reduce(0, +)
        let magnitude1 = sqrt(v1.map { $0 * $0 }.reduce(0, +))
        let magnitude2 = sqrt(v2.map { $0 * $0 }.reduce(0, +))

        return dotProduct / (magnitude1 * magnitude2)
    }
}

extension Data {
    func toArray() throws -> [Float] {
        return try withUnsafeBytes { pointer -> [Float] in
            guard let base = pointer.baseAddress?.assumingMemoryBound(to: Float.self) else {
                throw NSError(domain: "DataConversionError", code: 0, userInfo: nil)
            }
            return Array(UnsafeBufferPointer(start: base, count: count / MemoryLayout<Float>.stride))
        }
    }
}
