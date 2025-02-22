//
//  FindSimilar.swift
//  ReKeeper
//
//  Created by Theeratdolchat Chatchai on 20/2/2568 BE.
//

import AVFoundation
import SwiftUI
import PhotosUI
import Photos
import Vision

struct FindSimilar: View {
    @StateObject var viewModel = StorageViewModel()
    @State private var capturedImage: UIImage?
    @State private var isImagePickerPresented = false
    @State private var isShowingImageSourceOptions = false
    @State private var isScanning = false
    @State private var usedModel = false
    @State private var useCamera = false
    @State private var similarItems: [(item: Item, rank: Int)] = []

    @Environment(\.dismiss) var dismiss

    var filteredResults: [(item: Item, placeIndex: Int, categoryIndex: Int, itemIndex: Int, rank: Int)] {
        return viewModel.places.enumerated().flatMap { placeIndex, place in
            place.categories.enumerated().flatMap { categoryIndex, category in
                category.items.enumerated()
                    .compactMap { item in
                        if let matchedItem = similarItems.first(where: { $0.item.id == item.element.id }) {
                            return (item: item.element, placeIndex: placeIndex, categoryIndex: categoryIndex, itemIndex: item.offset, rank: matchedItem.rank)
                        }
                        return nil
                    }
            }
        }.sorted { $0.rank < $1.rank }
    }

    var body: some View {
        NavigationStack {
            VStack {
                Button(action: {
                    isShowingImageSourceOptions = true
                }) {
                    ZStack {
                        if let capturedImage = capturedImage {
                            Image(uiImage: capturedImage)
                                .resizable()
                                .scaledToFill()
                                .frame(width: 250, height: 250)
                                .clipShape(Circle())
                                .clipped()
                            
                        } else {
                            Circle()
                                .fill(Color.gray.opacity(0.3))
                                .frame(width: 300, height: 300)
                                .overlay(
                                    VStack {
                                        Image(systemName: "camera")
                                            .font(.largeTitle)
                                            .foregroundColor(.gray)
                                        Text("Select or Take a Photo")
                                            .foregroundColor(.gray)
                                    }
                                )
                            Spacer()
                        }
                    }
                }
                .padding()
                .confirmationDialog("Choose Image Source", isPresented: $isShowingImageSourceOptions, titleVisibility: .visible) {
                    Button("Take a Photo") {
                        useCamera = true
                        isImagePickerPresented = true
                    }
                    Button("Choose from Library") {
                        useCamera = false
                        isImagePickerPresented = true
                    }
                    Button("Cancel", role: .cancel) {}
                }
                .sheet(isPresented: $isImagePickerPresented) {
                    ImagePickerController(image: $capturedImage, useCamera: useCamera)
                }

                Button(action: {
                    isScanning = true
                    usedModel = true
                    similarItems = []

                    Task {
                        if let image = capturedImage {
                            self.similarItems = await viewModel.findSimilarItems(image: image)
                        }
                        isScanning = false
                    }
                }) {
                    if capturedImage == nil || isScanning || usedModel {
                        EmptyView()
                    } else {
                        ZStack {
                            Circle()
                                .fill(
                                    LinearGradient(gradient: Gradient(colors: [Color.pink, Color.purple]),
                                                   startPoint: .topLeading,
                                                   endPoint: .bottomTrailing)
                                )
                                .frame(width: 70, height: 70)

                            Image(systemName: "magnifyingglass.circle.fill")
                                .foregroundColor(.white)
                                .font(.system(size: 30, weight: .bold))
                        }
                    }
                }

                if isScanning {
                    ProgressView("Scanning...")
                        .progressViewStyle(CircularProgressViewStyle(tint: .blue))
                        .scaleEffect(1.5)
                        .padding()
                }

                if !filteredResults.isEmpty {
                    List(filteredResults, id: \.item.id) { result in
                        NavigationLink(
                            destination: ItemGridView(
                                placeIndex: result.placeIndex,
                                categoryIndex: result.categoryIndex,
                                viewModel: viewModel)
                        ) {
                            HStack {
                                Text("#\(result.rank)")
                                    .font(.headline)
                                    .foregroundColor(.blue)
                                
                                if let imageData = result.item.imageData, let uiImage = UIImage(data: imageData) {
                                    Image(uiImage: uiImage)
                                        .resizable()
                                        .frame(width: 40, height: 40)
                                        .clipShape(RoundedRectangle(cornerRadius: 8))
                                } else {
                                    Image(systemName: "photo")
                                        .frame(width: 40, height: 40)
                                }
                                
                                VStack(alignment: .leading) {
                                    Text(result.item.name)
                                        .font(.headline)
                                    Text("Stored in: \(viewModel.places[result.placeIndex].name)")
                                        .font(.subheadline)
                                        .foregroundColor(.pink)
                                    Text("Received: \(formattedDate(result.item.receivedDate))")
                                        .font(.subheadline)
                                        .foregroundColor(.gray)
                                }
                            }
                        }
                    }

                }
                else if capturedImage != nil {
                    Text("")
                }
                else if !isScanning && capturedImage != nil {
                    Text("Not Found")
                        .font(.headline)
                        .foregroundColor(.red)
                        .padding()
                }

            }
            Spacer()
            .navigationTitle("Find Similar")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") { dismiss() }
                        .foregroundColor(.red)
                }
            }
        }
    }

    private func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: date)
    }
}


struct ImagePickerController: UIViewControllerRepresentable {
    @Binding var image: UIImage?
    var useCamera: Bool

    class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        var parent: ImagePickerController
        
        init(parent: ImagePickerController) {
            self.parent = parent
        }

        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
            if let uiImage = info[.originalImage] as? UIImage {
                parent.image = uiImage
            }
            picker.dismiss(animated: true)
        }

        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            picker.dismiss(animated: true)
        }
    }

    func makeCoordinator() -> Coordinator {
        return Coordinator(parent: self)
    }

    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.sourceType = useCamera ? .camera : .photoLibrary
        picker.delegate = context.coordinator
        return picker
    }

    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}
}
