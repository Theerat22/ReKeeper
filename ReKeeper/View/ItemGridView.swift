////
////  ItemGridView.swift
////  ReKeeper
////
////  Created by Theeratdolchat Chatchai on 16/2/2568 BE.
////
//
import SwiftUI
import PhotosUI

struct ItemGridView: View {
    var placeIndex: Int
    var categoryIndex: Int
    @ObservedObject var viewModel: StorageViewModel
    @State private var isShowingPhotoPicker = false
    @State private var isAddPlaceSheetPresented: Bool = false
    
    @State private var inputImage: UIImage?
    @State private var newItemName = ""
    
    let columns = [
        GridItem(.flexible(), spacing: 7),
        GridItem(.flexible(), spacing: 7),
        GridItem(.flexible(), spacing: 7)
    ]
    
    var body: some View {
        ScrollView {
            VStack {
//                LazyVGrid(columns: columns, spacing: 16) {
//                    ForEach(viewModel.places[placeIndex].categories[categoryIndex].items, id: \.self) { item in
//                        NavigationLink(destination: ItemDetailView(item: item, placeIndex: placeIndex, categoryIndex: categoryIndex)) {
//                            ItemView(item: item)
//                        }
//                    }
//                }
                Text("hello")
                .padding()
                .navigationTitle(viewModel.places[placeIndex].categories[categoryIndex].name)
                
                Spacer()
                
                AddButton(isPresented: $isAddPlaceSheetPresented)
            }
        }
        .sheet(isPresented: $isAddPlaceSheetPresented) {
            AddItemView(viewModel: viewModel, placeIndex: placeIndex, categoryIndex: categoryIndex)
                .cornerRadius(20)
        }
    }
    
}

struct ItemView: View {
    var item: Item
    var body: some View {
        VStack {
            Text(item.name)
                .font(.caption)
                .foregroundColor(.primary)
                .lineLimit(1)
        }
        .frame(width: 140, height: 140)
        .background(Color(.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 10))
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

