//
//  AddItemView.swift
//  ReKeeper
//
//  Created by Theeratdolchat Chatchai on 18/2/2568 BE.
//

import SwiftUI
import PhotosUI

struct AddItemView: View {
    @StateObject var viewModel = StorageViewModel()
    var placeIndex: Int
    var categoryIndex: Int
    
    @State private var selectedImage: UIImage?
    @State private var isImagePickerPresented = false
    @State private var isConfirmationPresented = false
    @State private var inputName = ""
    @State private var receivedDate = Date()
    @State private var expiryDate = Date()
    
    @Environment(\.dismiss) var dismiss

    var body: some View {
        NavigationStack {
            VStack {
//                Spacer()
                Button(action: {
                    isImagePickerPresented.toggle()
                }) {
                    ZStack {
                        if let selectedImage = selectedImage {
                            Image(uiImage: selectedImage)
                                .resizable()
                                .scaledToFill()
                                .frame(width:300, height: 300)
                                .clipShape(Circle())
                                .clipped()
//                                .shadow(radius: 10)
                        } else {
                            Circle()
                                .fill(Color.gray.opacity(0.3))
                                .frame(width: 300,height:300)
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
                .sheet(isPresented: $isImagePickerPresented) {
                    ImagePicker(image: $selectedImage)
                }
                
                if selectedImage != nil {
                    Button(action: {
                        isConfirmationPresented = true
                    }) {
                        ZStack {
                            Circle()
                                .fill(
                                    LinearGradient(gradient: Gradient(colors: [Color.pink, Color.purple]),
                                                   startPoint: .topLeading,
                                                   endPoint: .bottomTrailing)
                                )
                                .frame(width: 70, height: 70)
//                                .shadow(color: Color.pink.opacity(0.5), radius: 10, x: 0, y: 5)
                            
                            Image(systemName: "checkmark")
                                .foregroundColor(.white)
                                .font(.system(size: 30, weight: .bold))
                        }
                    }
                    Button("Cancel") {
                        selectedImage = nil
                    }
                    .foregroundColor(Color.red)
                    .padding(.top,10)
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
}

struct ImagePicker: UIViewControllerRepresentable {
    @Binding var image: UIImage?
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        picker.sourceType = .photoLibrary
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}
    
    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        var parent: ImagePicker
        
        init(_ parent: ImagePicker) {
            self.parent = parent
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let uiImage = info[.originalImage] as? UIImage {
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
