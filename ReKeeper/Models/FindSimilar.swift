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
    @State private var isScanning = false
    @State private var similarItems: [Item] = []
    
    @Environment(\.dismiss) var dismiss

    var body: some View {
        NavigationStack {
            VStack {
                Button(action: {
                    isImagePickerPresented = true
                }) {
                    ZStack {
                        if let capturedImage = capturedImage {
                            Image(uiImage: capturedImage)
                                .resizable()
                                .scaledToFill()
                                .frame(width: 300, height: 300)
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
                        }
                    }
                }
                .padding()
                .sheet(isPresented: $isImagePickerPresented) {
                    ImagePicker(image: $capturedImage, useCamera: true)
                }

                if capturedImage != nil {
                    Button(action: {
                        isScanning = true
                        similarItems = []
                        
                        Task {
                            if let image = capturedImage {
                                self.similarItems = await viewModel.findSimilarItems(image: image)
                            }
                            isScanning = false
                        }
                    }) {
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
                    .padding(.top, 10)
                    
                    Button("Cancel") {
                        capturedImage = nil
                        similarItems = []
                    }
                    .foregroundColor(Color.red)
                    .padding(.top, 10)
                }
                
                if isScanning {
                    ProgressView("Scanning...")
                        .progressViewStyle(CircularProgressViewStyle(tint: .blue))
                        .scaleEffect(1.5)
                        .padding()
                }
                
                if !similarItems.isEmpty {
                    VStack {
                        Text("Found \(similarItems.count) similar items:")
                            .font(.headline)
                            .padding()
                        
                        ForEach(similarItems, id: \.id) { item in
                            Text("Item: \(item.name)")
                                .padding()
                        }
                    }
                } else if !isScanning && capturedImage != nil {
                    Text("Not Found")
                        .font(.headline)
                        .foregroundColor(.red)
                        .padding()
                }
                
                Spacer()
            }
            .navigationTitle("Find Similar")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") { dismiss() }
                        .foregroundColor(.red)
                }
            }
        }
    }
}

struct CameraView: UIViewControllerRepresentable {
    @Binding var image: UIImage?
    
    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        var parent: CameraView
        
        init(parent: CameraView) {
            self.parent = parent
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
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
        picker.sourceType = .camera
        picker.delegate = context.coordinator
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}
}
