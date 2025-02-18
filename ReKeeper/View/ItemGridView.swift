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
            LazyVGrid(columns: columns, spacing: 16) {
                ForEach(viewModel.places[placeIndex].categories[categoryIndex].items, id: \.self) { item in
                    NavigationLink(destination: ItemDetailView(item: item, placeIndex: placeIndex, categoryIndex: categoryIndex)) {
                        VStack {
                            // Image display logic
            //                if let imageData = item.imageData, let uiImage = UIImage(data: imageData) {
            //                    Image(uiImage: uiImage)
            //                        .resizable()
            //                        .scaledToFill()
            //                        .frame(width: 100, height: 100)
            //                        .clipShape(RoundedRectangle(cornerRadius: 10))
            //                } else {
            //                    Rectangle()
            //                        .fill(Color.gray.opacity(0.3))
            //                        .frame(width: 100, height: 100)
            //                        .cornerRadius(10)
            //                }
                            
                            Text(item.name)
                                .font(.caption)
                                .foregroundColor(.primary)
                                .lineLimit(1)
                        }
                        .frame(width: 140, height: 140)
                        .background(Color(.systemBackground))  // Separate background
                        .clipShape(RoundedRectangle(cornerRadius: 10))  // Separate corner radius
                    }
                }
            }

        }
        .padding()
        .navigationTitle(viewModel.places[placeIndex].categories[categoryIndex].name)
        
        Spacer()
        
        Button(action: {
            isAddPlaceSheetPresented.toggle()
        }) {
            ZStack {
                Circle()
                    .fill(
                        LinearGradient(gradient: Gradient(colors: [Color.pink, Color.purple]),
                                       startPoint: .topLeading,
                                       endPoint: .bottomTrailing)
                    )
                    .frame(width: 70, height: 70)
                    .shadow(color: Color.pink.opacity(0.5), radius: 10, x: 0, y: 5)
                
                Image(systemName: "camera.fill")
                    .foregroundColor(.white)
                    .font(.system(size: 30, weight: .bold))
            }
        }
        .sheet(isPresented: $isAddPlaceSheetPresented) {
            AddItemView(viewModel: viewModel, placeIndex: placeIndex, categoryIndex: categoryIndex)
                .cornerRadius(20)
        }

    }
}

