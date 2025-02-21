//
//  AddItemView.swift
//  ReKeeper
//
//  Created by Theeratdolchat Chatchai on 18/2/2568 BE.
//

import AVFoundation
import SwiftUI
import PhotosUI

struct AddItemView: View {
    @StateObject var viewModel = StorageViewModel()
    var placeIndex: Int
    var categoryIndex: Int
    
    @State private var selectedImage: UIImage?
    @State private var isImagePickerPresented = false
    @State private var isConfirmationPresented = false
    @State private var isShowingImageSourceOptions = false
    @State private var useCamera = false
    
    @State private var inputName = ""
    @State private var receivedDate = Date()
    @State private var expiryDate = Date()
    
    @Environment(\.dismiss) var dismiss

    var body: some View {
        NavigationStack {
            VStack {
                Button(action: {
                    isShowingImageSourceOptions = true
                }) {
                    ZStack {
                        if let selectedImage = selectedImage {
                            Image(uiImage: selectedImage)
                                .resizable()
                                .scaledToFill()
                                .frame(width: 300, height: 300)
                                .clipShape(Circle())
                                .clipped()
                        } else {
                            Circle()
                                .fill(Color.gray.opacity(0.3))
                                .frame(width: 300,height: 300)
                                .overlay(
                                    VStack {
                                        Image(systemName: "photo.on.rectangle")
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
                .confirmationDialog("Choose Image Source", isPresented: $isShowingImageSourceOptions, titleVisibility: .visible) {
                    Button("Take a Photo") {
                        requestCameraAccess()
                    }
                    Button("Choose from Library") {
                        requestPhotoLibraryAccess()
                    }
                    Button("Cancel", role: .cancel) {}
                }
                .sheet(isPresented: $isImagePickerPresented) {
                    ImagePicker(image: $selectedImage, useCamera: useCamera)
                }

                if selectedImage != nil {
                    Button(action: {
                        isConfirmationPresented = true
                    }) {
                            ZStack{
                                Circle()
                                    .fill(
                                        LinearGradient(gradient: Gradient(colors: [Color.pink, Color.purple]),
                                                       startPoint: .topLeading,
                                                       endPoint: .bottomTrailing)
                                    )
                                    .frame(width: 70, height: 70)
                                
                                Image(systemName: "checkmark")
                                    .foregroundColor(.white)
                                    .font(.system(size: 30, weight: .bold))
                            }
                    }
                }
                Spacer()
            }
            .navigationTitle("Add Item")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .foregroundColor(.red)
                }
            }
            .fullScreenCover(isPresented: $isConfirmationPresented) {
                ItemDetailView(viewModel: viewModel, placeIndex: placeIndex, categoryIndex: categoryIndex, selectedImage: selectedImage)
            }
        }
    }

    private func requestCameraAccess() {
        let status = AVCaptureDevice.authorizationStatus(for: .video)
        
        switch status {
        case .authorized:
            useCamera = true
            isImagePickerPresented = true
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { granted in
                DispatchQueue.main.async {
                    if granted {
                        useCamera = true
                        isImagePickerPresented = true
                    }
                }
            }
        case .denied, .restricted:
            showSettingsAlert()
        @unknown default:
            break
        }
    }
    
    private func requestPhotoLibraryAccess() {
        let status = PHPhotoLibrary.authorizationStatus()
        
        switch status {
        case .authorized, .limited:
            useCamera = false
            isImagePickerPresented = true
        case .notDetermined:
            PHPhotoLibrary.requestAuthorization { newStatus in
                DispatchQueue.main.async {
                    if newStatus == .authorized || newStatus == .limited {
                        useCamera = false
                        isImagePickerPresented = true
                    }
                }
            }
        case .denied, .restricted:
            showSettingsAlert()
        @unknown default:
            break
        }
    }
    
    private func showSettingsAlert() {
        let alert = UIAlertController(
            title: "Permission Required",
            message: "Please allow access in Settings to use this feature.",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "Open Settings", style: .default) { _ in
            if let settingsURL = URL(string: UIApplication.openSettingsURLString) {
                UIApplication.shared.open(settingsURL)
            }
        })
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
        DispatchQueue.main.async {
            if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
               let rootVC = windowScene.windows.first?.rootViewController {
                rootVC.present(alert, animated: true)
            }
        }
    }
}

struct ImagePicker: UIViewControllerRepresentable {
    @Binding var image: UIImage?
    var useCamera: Bool

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        picker.sourceType = useCamera ? .camera : .photoLibrary
        picker.allowsEditing = true
        return picker
    }

    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}

    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        var parent: ImagePicker

        init(_ parent: ImagePicker) {
            self.parent = parent
        }

        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let uiImage = info[.editedImage] as? UIImage ?? info[.originalImage] as? UIImage {
                parent.image = uiImage
            }
            picker.dismiss(animated: true)
        }
    }
}


struct ItemDetailView: View {
    @ObservedObject var viewModel: StorageViewModel
    var placeIndex: Int
    var categoryIndex: Int
    var selectedImage: UIImage?
    
    @State private var inputName = ""
    @State private var receivedDate = Date()
    @State private var expiryDate = Date()
    
    @Environment(\.dismiss) var dismiss

    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Item Name *")) {
                    TextField("Enter Item Name", text: $inputName)
                }
                
                Section(header: Text("Dates")) {
                    DatePicker("Received Date", selection: $receivedDate, displayedComponents: .date)
                    DatePicker("Expiry Date", selection: $expiryDate, displayedComponents: .date)
                }
                
                Section(header: Text("Preview")) {
                    if let selectedImage = selectedImage {
                        Image(uiImage: selectedImage)
                            .resizable()
                            .scaledToFit()
                            .frame(height: 200)
                    }
                }
            }
            .navigationTitle("Item Details")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Back") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Add") {
                        if !inputName.isEmpty {
                            let imageData = selectedImage?.jpegData(compressionQuality: 0.8)
                            
                            viewModel.addItem(
                                to: categoryIndex,
                                in: placeIndex,
                                name: inputName,
                                receivedDate: receivedDate,
                                expiryDate: expiryDate,
                                imageData: imageData
                            )
                            
                            dismiss()
                        }
                    }
                    .disabled(inputName.isEmpty)
                }
            }
        }
    }
}


//#Preview {
//    AddItemView()
//}
