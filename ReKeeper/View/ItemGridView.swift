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
                                .frame(width: 70, height: 70)
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
                    .frame(width: 100, height: 70)
                    .background(Color(.systemBackground))
                    .clipShape(RoundedRectangle(cornerRadius: 10))
//                    .shadow(radius: 2)
                }
            }
            .padding()
            .sheet(isPresented: $isAddPlaceSheetPresented) {
                AddItemView(viewModel: viewModel, placeIndex: placeIndex, categoryIndex: categoryIndex)
                    .cornerRadius(20)
            }

        }
        .navigationTitle("Items in \(viewModel.places[placeIndex].categories[categoryIndex].name)")
        
        Spacer()
        AddButton(isPresented: $isAddPlaceSheetPresented)
    }

}

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
//                    .shadow(color: Color.pink.opacity(0.5), radius: 10, x: 0, y: 5)
                
                Image(systemName: "camera.fill")
                    .foregroundColor(.white)
                    .font(.system(size: 30, weight: .bold))
            }
        }
    }
}
