////
////  ItemGridView.swift
////  ReKeeper
////
////  Created by Theeratdolchat Chatchai on 16/2/2568 BE.
////

import SwiftUI
import PhotosUI

struct ItemGridView: View {
    var placeIndex: Int
    var categoryIndex: Int
        
    @State private var isShowingPhotoPicker = false
    @State private var isAddPlaceSheetPresented: Bool = false
    @State private var selectedItem: Item?
    @State private var isShowingDeleteAlert = false
    @State private var itemToDelete: Item?
        
    @State private var inputImage: UIImage?
    @State private var newItemName = ""
    
    @ObservedObject var viewModel: StorageViewModel

    var sortedItems: [Item] {
        viewModel.places[placeIndex].categories[categoryIndex].items.sorted {
            $0.receivedDate < $1.receivedDate
        }
    }

    let columns = [
        GridItem(.flexible(), spacing: 7),
        GridItem(.flexible(), spacing: 7),
        GridItem(.flexible(), spacing: 7)
    ]
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 16) {
                ForEach(sortedItems.indices, id: \.self) { index in
                    let item = sortedItems[index]
                    
                    VStack {
                        if let imageData = item.imageData, let uiImage = UIImage(data: imageData) {
                            Image(uiImage: uiImage)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 100, height: 100)
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                        } else {
                            Image(systemName: "photo")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 50, height: 50)
                                .foregroundColor(.gray)
                        }
                        Text(item.name)
                            .font(.caption)
                            .foregroundColor(.primary)
                    }
                    .frame(width: 130, height: 150)
                    .background(Color(.systemBackground))
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .onTapGesture {
                        selectedItem = item
                    }
                    .onLongPressGesture {
                        itemToDelete = item
                        isShowingDeleteAlert = true
                    }
                }
            }
            .padding()
            .sheet(isPresented: $isAddPlaceSheetPresented) {
                AddItemView(viewModel: viewModel, placeIndex: placeIndex, categoryIndex: categoryIndex)
                    .cornerRadius(20)
            }
            .sheet(item: $selectedItem) { item in
                ItemView(item: item, viewModel: viewModel, placeIndex: placeIndex, categoryIndex: categoryIndex)
                    .presentationDetents([.medium, .large])
                    .presentationDragIndicator(.visible)
            }
        }
        .navigationTitle(viewModel.places[placeIndex].categories[categoryIndex].name)
        .alert(isPresented: $isShowingDeleteAlert) {
            Alert(
                title: Text("Delete Item"),
                message: Text("Are you sure you want to delete \(itemToDelete?.name ?? "")?"),
                primaryButton: .destructive(Text("Delete")) {
                    if let itemToDelete = itemToDelete,
                       let itemIndex = viewModel.places[placeIndex].categories[categoryIndex].items.firstIndex(where: { $0.id == itemToDelete.id }) {
                        viewModel.places[placeIndex].categories[categoryIndex].items.remove(at: itemIndex)
                        viewModel.saveData()
                    }
                },
                secondaryButton: .cancel()
            )
        }
        
        Spacer()
        AddButton(isPresented: $isAddPlaceSheetPresented)
    }
}


struct ItemView: View {
    @State private var isEditing = false
    @State private var editedName: String
    
    var item: Item
    @ObservedObject var viewModel: StorageViewModel
    var placeIndex: Int
    var categoryIndex: Int
    
    @Environment(\.dismiss) var dismiss

    init(item: Item, viewModel: StorageViewModel, placeIndex: Int, categoryIndex: Int) {
        self.item = item
        self.viewModel = viewModel
        self.placeIndex = placeIndex
        self.categoryIndex = categoryIndex
        _editedName = State(initialValue: item.name)
    }
    
    var body: some View {
        VStack {
            HStack {
                Button(action: {
                    removeItem()
                }) {
                    Image(systemName: "trash")
                        .foregroundColor(.red)
//                        .padding()
                        .font(.system(size: 20))
                }
                Spacer()
                Button(action: {
                    if isEditing {
                        updateItemName()
                    }
                    isEditing.toggle()
                }) {
                    Image(systemName: isEditing ? "checkmark" : "square.and.pencil")
                        .foregroundColor(.blue)
//                        .padding()
                        .font(.system(size: 20))
                }
            }
            
            if let imageData = item.imageData, let uiImage = UIImage(data: imageData) {
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFit()
                    .frame(height: 200)
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                    .padding()
            } else {
                Image(systemName: "photo")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 100, height: 100)
                    .foregroundColor(.gray)
                    .padding()
            }
            
            if isEditing {
                TextField("Item Name", text: $editedName)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
            } else {
                Text(item.name)
                    .font(.title)
                    .padding()
            }
            
            Text("Received Date: \(item.receivedDate, formatter: itemFormatter)")
                .font(.body)
                .foregroundColor(.gray)
                .padding(.bottom)
        }
        .padding()
    }
    func updateItemName() {
        if let itemIndex = viewModel.places[placeIndex].categories[categoryIndex].items.firstIndex(where: { $0.id == item.id }) {
            viewModel.objectWillChange.send()
            viewModel.places[placeIndex].categories[categoryIndex].items[itemIndex].name = editedName
            viewModel.saveData()
        }
    }
    func removeItem() {
        if let itemIndex = viewModel.places[placeIndex].categories[categoryIndex].items.firstIndex(where: { $0.id == item.id }) {
            viewModel.objectWillChange.send()
            viewModel.places[placeIndex].categories[categoryIndex].items.remove(at: itemIndex)
            viewModel.saveData()
            dismiss()
        }
    }}

private let itemFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .medium
    return formatter
}()

struct AddButton: View {
    @Binding var isPresented: Bool
    
    var body: some View {
        Button(action: {
            isPresented.toggle()
        }) {
            ZStack {
                Circle()
                    .fill(
                        LinearGradient(gradient: Gradient(colors: [Color.pink, Color.purple]),
                                       startPoint: .topLeading,
                                       endPoint: .bottomTrailing)
                    )
                    .frame(width: 70, height: 70)
                
                Image(systemName: "camera.fill")
                    .foregroundColor(.white)
                    .font(.system(size: 30, weight: .bold))
            }
        }
    }
}
#Preview {
    ItemGridView(placeIndex: 0, categoryIndex: 0, viewModel: StorageViewModel())
}
