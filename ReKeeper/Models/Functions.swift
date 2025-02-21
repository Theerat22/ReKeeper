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
    
    func findSimilarItem(image: UIImage) async -> Item? {
        guard let queryFeatures = await ImageClassifier.shared.extractFeatures(from: image) else {
            return nil
        }

        var bestMatch: (item: Item, similarity: Float)? = nil

        for place in self.places {
            for category in place.categories {
                for item in category.items {
                    if let imageData = item.imageData, let itemImage = UIImage(data: imageData) {
                        if let itemFeatures = await ImageClassifier.shared.extractFeatures(from: itemImage) {
                            let similarity = self.cosineSimilarity(queryFeatures, itemFeatures)

                            if bestMatch == nil || similarity > bestMatch!.similarity {
                                bestMatch = (item, similarity)
                            }
                        }
                    }
                }
            }
        }

        return bestMatch?.item
    }

    private func cosineSimilarity(_ a: [Float], _ b: [Float]) -> Float {
        let dotProduct = zip(a, b).map(*).reduce(0, +)
        let magnitudeA = sqrt(a.map { $0 * $0 }.reduce(0, +))
        let magnitudeB = sqrt(b.map { $0 * $0 }.reduce(0, +))
        return dotProduct / (magnitudeA * magnitudeB)
    }
}


class ImageClassifier {
    static let shared = ImageClassifier()
    
    func extractFeatures(from image: UIImage) async -> [Float]? {
        return await withCheckedContinuation { continuation in
            processImage(image) { features in
                continuation.resume(returning: features)
            }
        }
    }
    
    private func processImage(_ image: UIImage, completion: @escaping ([Float]?) -> Void) {
        guard let cgImage = image.cgImage else {
            completion(nil)
            return
        }

        // โหลดโมเดล MobileNetV2.mlmodel
        guard let modelURL = Bundle.main.url(forResource: "mobilenetv2", withExtension: "mlmodel"),
              let model = try? VNCoreMLModel(for: MLModel(contentsOf: modelURL)) else {
            completion(nil)
            return
        }
        
        let request = VNCoreMLRequest(model: model) { request, error in
            guard let results = request.results as? [VNCoreMLFeatureValueObservation] else {
                completion(nil)
                return
            }
            
            // แปลงผลลัพธ์เป็น array ของ float
            if let multiArray = results.first?.featureValue.multiArrayValue {
                var features: [Float] = []
                for i in 0..<multiArray.count {
                    features.append(Float(multiArray[i].floatValue))
                }
                completion(features)
            } else {
                completion(nil)
            }
        }

        let handler = VNImageRequestHandler(cgImage: cgImage, options: [:])
        try? handler.perform([request])
    }
}
